resource "aws_cognito_user_pool" "enterpise_user_pool" {
    name             = "Enterprise-User-Pool"
    username_attributes = ["email"]
    mfa_configuration = "OPTIONAL"
    software_token_mfa_configuration {
        enabled = true
    }
    account_recovery_setting {
        recovery_mechanism {
        name     = "verified_email"
        priority = 1
        }
    }
    schema {
        attribute_data_type      = "String"
        name                     = "given_name"
        required                 = true
        developer_only_attribute = false
        mutable                  = true
    }
    schema {
        attribute_data_type      = "String"
        name                     = "family_name"
        required                 = true
        developer_only_attribute = false
        mutable                  = true
    }
    schema {
        attribute_data_type      = "String"
        name                     = "email"
        required                 = true
        developer_only_attribute = false
        mutable                  = true
    }
    email_configuration {
        email_sending_account = "COGNITO_DEFAULT"
        source_arn            = "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/noreply@verification.com"
    }
    verification_message_template {
        default_email_option = "CONFIRM_WITH_LINK"
        email_subject        = "Enterprise App: Your verification Link"
    }
    admin_create_user_config {
        allow_admin_create_user_only = false
        invite_message_template {
        email_subject = "Enterprise App: Your temporary password"
        email_message = "Your Enterprise App username is {username} and temporary password is {####}."
        sms_message   = "Your Enterprise App username is {username} and temporary password is {####}."
        }
    }
    deletion_protection        = "ACTIVE"

    user_pool_add_ons {
        advanced_security_mode = "AUDIT"
    }

    # Example for Lambda Pre Trigger Config
    # lambda_config {
    #     custom_message = "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:CognitoCustomMessage"
    #     pre_sign_up    = "arn:aws:lambda:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:function:CognitoPreSignUp"
    # }

    lifecycle {
        # Terraform doesn't handle updates to the schema block well and schema can't be modified in-place, so we ignore changes to it
        ignore_changes = [schema]
    }
}

output "cognito_user_pool_arn" {
  description = "Cognito userpool arn"
  value       = aws_cognito_user_pool.enterpise_user_pool.arn
}


resource "aws_cognito_user_pool_client" "enterpise_client" {
    name                          = "enterpise_client"
    user_pool_id                  = aws_cognito_user_pool.enterpise_user_pool.id
    auth_session_validity         = 10
    refresh_token_validity        = 1
    access_token_validity         = 30
    id_token_validity             = 30
    prevent_user_existence_errors = "ENABLED"
    explicit_auth_flows = [
        "ALLOW_CUSTOM_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_USER_SRP_AUTH"
    ]
    token_validity_units {
        refresh_token = "days"
        access_token  = "minutes"
        id_token      = "minutes"
    }
}

# To create identity pull with SAML and SSO integration
# resource "aws_cognito_identity_pool" "enterpise_idp" {
#     identity_pool_name               = "Enterprise-Identity-Pool"
#     allow_unauthenticated_identities = false
#     allow_classic_flow               = true

#     cognito_identity_providers {
#         client_id               = aws_cognito_user_pool_client.enterpise_client.id
#         provider_name           = aws_cognito_user_pool.enterpise_user_pool.arn
#         server_side_token_check = false
#     }
# }