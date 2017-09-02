#!/usr/bin/env python
import boto3
import os
import jinja2
import json


class Inventory(object):

    ec2_client = boto3.client('ec2')
    cluster_name = os.environ['TF_VAR_cluster_name']

    def get_instances_description(self, key, value):
        response = self.ec2_client.describe_instances(
            Filters=[
                {
                    'Name': key,
                    'Values': [
                        value,
                    ]
                },
                {
                    'Name': 'tag:cluster_name',
                    'Values': [
                        self.cluster_name,
                    ]
                }
            ]
        )
        return response['Reservations']

    def get_instances_public_ips_by_role(self, role):
        ip_list = []
        instances_info = self.get_instances_description('tag:role', role)
        for host in instances_info:
            ip_list.append(host['Instances'][0]['PublicIpAddress'])
        return ip_list

    def describe_instance_by_ip(self, public_ip):
        instance_description = self.get_instances_description('ip-address', public_ip)[0]['Instances'][0]
        instance_info = {}
        instance_info['AvailabilityZone'] = instance_description['Placement']['AvailabilityZone'][-1]
        instance_info['Region'] = instance_description['Placement']['AvailabilityZone'][0:-1]
        for i in ['InstanceType', 'VpcId', 'PublicIpAddress', 'PublicIpAddress', 'PrivateIpAddress']:
            instance_info[i] = instance_description[i]
        return instance_info

    def generate_template(self):
        template_loader = jinja2.FileSystemLoader(searchpath="./")
        template_env = jinja2.Environment(loader=template_loader)
        temolate_file = "inventory.j2"
        template = template_env.get_template(temolate_file)

        master_ip = self.get_instances_public_ips_by_role('master')
        minions_ips = self.get_instances_public_ips_by_role('minion')
        all_ips = master_ip + minions_ips
        hostvars = {}
        for ip in all_ips:
            hostvars[ip] = self.describe_instance_by_ip(ip)

        context = {'master_ip': master_ip, 'minions_ips': minions_ips, 'hostvars': hostvars}
        output_text = template.render(context)
        output_text = output_text.replace("'", '"')
        output_text = json.loads(output_text)
        output_text = json.dumps(output_text, sort_keys=True, indent=4)


        return output_text


if __name__ == '__main__':
    # Run the script
    a = Inventory()
    print a.generate_template()


