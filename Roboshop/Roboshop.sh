#!/bin/bash

REGION="us-east-1"
AMI_ID="ami-0220d79f3f480ecf5"     # Amazon Linux 2
INSTANCE_TYPE="t3.micro"
SECURITY_GROUP_ID="sg-0d6a680fc44091364"
SUBNET_ID="subnet-0a79d446f5450259c"
HOSTED_ZONE_ID="Z019184425TWL87B91K51"


for instance in $@

do 
INSTANCE_ID=$(aws ec2 run-instances \
    --region $REGION \
    --image-id $AMI_ID \
    --instance-type $INSTANCE_TYPE \
    --security-group-ids $SECURITY_GROUP_ID \
    --subnet-id $SUBNET_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query "Instances[0].InstanceId" \
    --output text)


# Launch the EC2 instance

echo "EC2 Instance launched with ID: $INSTANCE_ID"

# Optional: wait until instance is running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID --region $REGION
echo "EC2 Instance $INSTANCE_ID is now running."


if [ $instance = "frontend" ] ; then 

#printing IP address 


PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)
  echo " this is $instance   $PUBLIC_IP"


  #updating the DNS records 

  RECORD_NAME="sndp.online"

else 

PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids "$INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].PrivateIpAddress' \
  --output text)
  echo " this is $instance   $PUBLIC_IP"

  RECORD_NAME="$instance.sndp.online"

fi

#updating the route 53 records 

aws route53 change-resource-record-sets \
  --hosted-zone-id "$HOSTED_ZONE_ID" \
  --change-batch '{
    "Comment": "Update A record",
    "Changes": [
      {
        "Action": "UPSERT",
        "ResourceRecordSet": {
          "Name": "'$RECORD_NAME'",
          "Type": "A",
          "TTL": 300,
          "ResourceRecords": [
            { "Value": "'$PUBLIC_IP'" }
          ]
        }
      }
    ]
  }'

  echo "record updated for $instance"

done




