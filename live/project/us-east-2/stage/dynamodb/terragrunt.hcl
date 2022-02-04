locals {
    attributes = [
        {
            name = "first"
            type = "S"
        },
        {
            name = "second"
            type = "S"
        },
        {
            name = "three"
            type = "N"
        },
        {
            name = "four"
            type = "S"
        }
    ]
}

include "root" {
    path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
    source = "git@github.com:josephthompson532/terra-modules.git//modules/data-storage/dynamodb?ref=v0.0.3"
}

inputs = {
    name = "gibs-table"
    hash_key = "id"
    attributes = local.attributes
    env = "dev"
}