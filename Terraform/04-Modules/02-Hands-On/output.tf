output "PUBLIC_IP_FOR_EC2"{
    value=module.ec2_instance.public-ip-address
}
