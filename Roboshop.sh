#!/bin/bash

REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"     # Amazon Linux 2
INSTANCE_TYPE="t3.micro"
SECURITY_GROUP_ID="sg-0d6a680fc44091364"
SUBNET_ID="subnet-0a79d446f5450259c"
TAG_NAME="ShellCreatedEC2"

# Launch the EC2 instance
INSTANCE_ID=$(aws ec2 run-instances \
    --region $REGION \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --security-group-ids $SECURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$TAG_NAME}]" \
    --query "Instances[0].InstanceId" \
    --output text)

echo "EC2 Instance launched with ID: $INSTANCE_ID"

# Optional: wait until instance is running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION
echo "EC2 Instance $INSTANCE_ID is now running."

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "$PUBLIC_IP"
