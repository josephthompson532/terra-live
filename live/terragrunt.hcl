locals {
    aws_region = read_terragrunt_config(find_in_parent_folder("region.hcl"))
    aws_account_region = local.aws_account.locals.aws_account_region
}

generate "provider" {
    path        = "provider.tf"
    if_exists   = "overwrite_terragrunt"
    contents = <<-EOF
        provider "aws" {
            region = "${local.aws_account_region}"
            allowed_account_ids = ["${aws_account_id}"]
        }
    EOF
}

remote_state {
    backend = "s3"

    generate {
        path = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        bucket          = "joseph-thompson-bucket-delete-this-one"
        key             = "${path_relative_to_include()}/terraform.tfstate"
        region          = "${local.aws_account_region}"

        dynamodb_table  = "lock-dynamo-table-joseph-delete"
        encrypt         = true
    }
}