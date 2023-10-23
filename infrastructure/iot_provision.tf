# To use JITP
# --- first we will register CA but provision previously the iot thing
#resource "null_resource" "aws_iot_provisioning_template" {
#
#  triggers = {
#    template_body = jsonencode(
#      {
#        "Parameters": {
#          "AWS::IoT::Certificate::CommonName": {
#            "Type": "String"
#          },
#          "AWS::IoT::Certificate::Id": {
#            "Type": "String"
#          }
#        },
#        "Resources": {
#          "policy": {
#            "Type": "AWS::IoT::Policy",
#            "Properties": {
#              "PolicyName": aws_iot_policy.device_policy.name
#            }
#          },
#          "certificate": {
#            "Type": "AWS::IoT::Certificate",
#            "Properties": {
#              "CertificateId": {
#                "Ref": "AWS::IoT::Certificate::Id"
#              },
#              "Status": "Active"
#            }
#          },
#          "thing": {
#            "Type": "AWS::IoT::Thing",
#            "OverrideSettings": {
#              "AttributePayload": "MERGE",
#              "ThingGroups": "DO_NOTHING",
#              "ThingTypeName": "REPLACE"
#            },
#            "Properties": {
#              "AttributePayload": {},
#              "ThingGroups": [],
#              "ThingName": {
#                "Ref": "AWS::IoT::Certificate::CommonName"
#              }
#            }
#          }
#        }
#      }
#    )
#  }
#
#  provisioner "local-exec" {
#    command = <<EOF
#      echo '${self.triggers.template_body}' > template.json
#      aws iot create-provisioning-template --template-name FleetTemplate \
#                                            --template-body file://template.json \
#                                            --enabled \
#                                            --provisioning-role-arn ${aws_iam_role.iot_fleet_provisioning.arn} \
#                                            --type JITP
#    EOF
#  }
#
#  provisioner "local-exec" {
#    when    = destroy
#    command = <<EOF
#      aws iot delete-provisioning-template --template-name FleetTemplate
#    EOF
#  }
#}

data "local_file" "ca_input" {
  filename = var.iot_custom_ca
}

resource "null_resource" "aws_iot_ca" {
  triggers = {
    iot_custom_ca: var.iot_custom_ca
  }

#  depends_on = [
#    null_resource.aws_iot_provisioning_template
#  ]
#
#  provisioner "local-exec" {
#    command = <<EOF
#      aws iot register-ca-certificate --ca-certificate "${self.triggers.iot_custom_ca}" --registration-config templateName=FleetTemplate --certificate-mode SNI_ONLY --set-as-active --allow-auto-registration --query certificateId
#    EOF
#  }
  provisioner "local-exec" {
        command = <<EOF
          aws iot register-ca-certificate --ca-certificate "file://${self.triggers.iot_custom_ca}" --certificate-mode SNI_ONLY --set-as-active
        EOF
      }
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      CA_LIST=$(aws iot list-ca-certificates --query certificates[*].certificateId  | jq '.[]' | tr -d '"')
      for i in $CA_LIST
      do
          aws iot update-ca-certificate --certificate-id $i --new-status INACTIVE
          aws iot delete-ca-certificate --certificate-id $i
      done
    EOF
  }
#  provisioner "local-exec" {
#    when    = destroy
#    command = <<EOF
#      CA_LIST=$(aws iot list-ca-certificates --template-name FleetTemplate --query certificates[*].certificateId  | jq '.[]' | tr -d '"')
#      for i in $CA_LIST
#      do
#          aws iot update-ca-certificate --certificate-id $i --new-status INACTIVE
#          aws iot delete-ca-certificate --certificate-id $i
#      done
#    EOF
#  }
}