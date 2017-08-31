variable "region" {}

variable "azs" {
  type = "map"
  default = {
      us-east-1 = "us-east-1a,us-east-1c"
      us-west-1 = "us-west-1a,us-west-1b"
      us-west-2 = "us-west-2a,us-west-2b"
      eu-west-1 = "eu-west-1a,eu-west-1b"
      eu-central-1 = "eu-central-1a,eu-central-1b"
      ap-northeast-1 = "ap-northeast-1a,ap-northeast-1c"
      ap-northeast-2 = "ap-northeast-2a,ap-northeast-2c"
      ap-southeast-1 = "ap-southeast-1a,ap-southeast-1b"
      ap-southeast-2 = "ap-southeast-2a,ap-southeast-2b"
      sa-east-1 = "sa-east-1a,sa-east-1c"
    }
}
