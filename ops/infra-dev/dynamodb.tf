resource "aws_dynamodb_table" "enterprise_order" {
    name                        = "enterprise_order"
    # UUID
    hash_key                    = "user_id"
    # ULID(For Timestamp sorting func using SK)
    range_key                   = "order_id"
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = true
    point_in_time_recovery {
        enabled = true
    }
    attribute {
        name = "user_id"
        type = "S"
    }
    attribute {
        name = "order_id"
        type = "S"
    }
    # Enabling streaming for processing orders async via DynamoDB Stream and EDA(Event Drivern Arch.) with Lambda
    stream_enabled   = true
    stream_view_type = "NEW_IMAGES"
    # If additional GSI needed for specific feature development
    # attribute {
    #     name = "qty"
    #     type = "N"
    # }
    # attribute {
    #     name = "product_id"
    #     type = "S"
    # }
    # global_secondary_index {
    #     hash_key        = "order_id"
    #     name            = "order_id-qty-index"
    #     projection_type = "ALL" # Could be specific attr as well
    #     range_key       = "qty"
    # }
    # global_secondary_index {
    #     hash_key        = "user_id"
    #     name            = "user_id-product_id-index"
    #     projection_type = "ALL"
    #     range_key       = "product_id"
    # }
}


resource "aws_dynamodb_table" "enterprise_product" {
    name                        = "enterprise_product"
    # UUID
    hash_key                    = "product_id"
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = true
    point_in_time_recovery {
        enabled = true
    }
    attribute {
        name = "product_id"
        type = "S"
    }
}

resource "aws_dynamodb_table" "enterprise_user" {
    name                        = "enterprise_user"
    # UUID
    hash_key                    = "user_id"
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = true
    point_in_time_recovery {
        enabled = true
    }
    attribute {
        name = "user_id"
        type = "S"
    }
}

resource "aws_dynamodb_table" "enterprise_inventory" {
    name                        = "enterprise_inventory"
    # UUID
    hash_key                    = "product_id"
    billing_mode                = "PAY_PER_REQUEST"
    deletion_protection_enabled = true
    point_in_time_recovery {
        enabled = true
    }
    attribute {
        name = "product_id"
        type = "S"
    }
}