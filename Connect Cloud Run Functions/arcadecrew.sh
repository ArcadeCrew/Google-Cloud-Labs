#!/bin/bash

# Define color variables
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

# Welcome message
echo "${BLUE_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}         INITIATING EXECUTION...  ${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}Enter ZONE:${RESET_FORMAT}"
read -p "Zone: " ZONE
echo "${CYAN_TEXT}${BOLD_TEXT}You have selected: $ZONE${RESET_FORMAT}"

PROJECT_ID=$(gcloud config get-value project)
REGION=${ZONE%-*}

echo "${GREEN_TEXT}${BOLD_TEXT}Enabling required GCP services...${RESET_FORMAT}"
echo "${YELLOW_TEXT}This may take a few minutes. Please be patient.${RESET_FORMAT}"

gcloud services enable \
  artifactregistry.googleapis.com \
  cloudfunctions.googleapis.com \
  cloudbuild.googleapis.com \
  eventarc.googleapis.com \
  run.googleapis.com \
  logging.googleapis.com \
  pubsub.googleapis.com \
  redis.googleapis.com \
  vpcaccess.googleapis.com

echo "${GREEN_TEXT}${BOLD_TEXT}Creating Redis instance for customer database...${RESET_FORMAT}"

REDIS_INSTANCE=customerdb

gcloud redis instances create $REDIS_INSTANCE \
 --size=2 --region=$REGION \
 --redis-version=redis_6_x

gcloud redis instances describe $REDIS_INSTANCE --region=$REGION

REDIS_IP=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(host)"); echo $REDIS_IP

REDIS_PORT=$(gcloud redis instances describe $REDIS_INSTANCE --region=$REGION --format="value(port)"); echo $REDIS_PORT

echo "${CYAN_TEXT}${BOLD_TEXT}Setting up VPC access connector for private connectivity...${RESET_FORMAT}"

gcloud compute networks vpc-access connectors create test-connector \
    --region $REGION \
    --range 10.8.0.0/28

TOPIC=add_redis

echo "${YELLOW_TEXT}${BOLD_TEXT}Creating Pub/Sub topic for Redis data ingestion...${RESET_FORMAT}"

gcloud pubsub topics create $TOPIC

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating first Cloud Function (Pub/Sub triggered) to add data to Redis...${RESET_FORMAT}"

mkdir ~/redis-pubsub && cd $_
touch main.py && touch requirements.txt

cat > main.py <<EOF_END
import os
import base64
import json
import redis
import functions_framework

redis_host = os.environ.get('REDISHOST', 'localhost')
redis_port = int(os.environ.get('REDISPORT', 6379))
redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

# Triggered from a message on a Pub/Sub topic.
@functions_framework.cloud_event
def addToRedis(cloud_event):
    # The Pub/Sub message data is stored as a base64-encoded string in the cloud_event.data property
    # The expected value should be a JSON string.
    json_data_str = base64.b64decode(cloud_event.data["message"]["data"]).decode()
    json_payload = json.loads(json_data_str)
    response_data = ""
    if json_payload and 'id' in json_payload:
        id = json_payload['id']
        data = redis_client.set(id, json_data_str)
        response_data = redis_client.get(id)
        print(f"Added data to Redis: {response_data}")
    else:
        print("Message is invalid, or missing an 'id' attribute")
EOF_END

cat > requirements.txt <<EOF_END
functions-framework==3.2.0
redis==4.3.4
EOF_END

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

echo "${BLUE_TEXT}${BOLD_TEXT}Deploying Pub/Sub Cloud Function with VPC connector...${RESET_FORMAT}"
echo "${YELLOW_TEXT}This function will listen to Pub/Sub messages and store data in Redis${RESET_FORMAT}"

# Your existing deployment command
deploy_function() {
gcloud functions deploy python-pubsub-function \
 --runtime=python310 \
 --region=$REGION \
 --source=. \
 --entry-point=addToRedis \
 --trigger-topic=$TOPIC \
 --vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector \
 --set-env-vars REDISHOST=$REDIS_IP,REDISPORT=$REDIS_PORT

}

# Variables
SERVICE_NAME="python-pubsub-function"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "${GREEN_TEXT}${BOLD_TEXT}Cloud Function is deployed. Exiting the loop.${RESET_FORMAT}"
    break
  else
    echo "${YELLOW_TEXT}${BOLD_TEXT}Waiting for Cloud Function to be deployed...${RESET_FORMAT}"
    echo
    echo "${RED_TEXT}${BOLD_TEXT}Till then, consider Subscribing to my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
    echo
    sleep 10
  fi
done

echo "${CYAN_TEXT}${BOLD_TEXT}Testing the Pub/Sub function by publishing a test message...${RESET_FORMAT}"

gcloud pubsub topics publish $TOPIC --message='{"id": 1234, "firstName": "Lucas" ,"lastName": "Sherman", "Phone": "555-555-5555"}'

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating second Cloud Function (HTTP triggered) to retrieve data from Redis...${RESET_FORMAT}"

mkdir ~/redis-http && cd $_
touch main.py && touch requirements.txt

cat > main.py <<EOF_END
import os
import redis
from flask import request
import functions_framework

redis_host = os.environ.get('REDISHOST', 'localhost')
redis_port = int(os.environ.get('REDISPORT', 6379))
redis_client = redis.StrictRedis(host=redis_host, port=redis_port)

@functions_framework.http
def getFromRedis(request):
    response_data = ""
    if request.method == 'GET':
        id = request.args.get('id')
        try:
            response_data = redis_client.get(id)
        except RuntimeError:
            response_data = ""
        if response_data is None:
            response_data = ""
    return response_data
EOF_END

cat > requirements.txt <<EOF_END
functions-framework==3.2.0
redis==4.3.4
EOF_END

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

echo "${BLUE_TEXT}${BOLD_TEXT}Deploying HTTP Cloud Function (2nd gen) with VPC connector...${RESET_FORMAT}"
echo "${YELLOW_TEXT}This function will retrieve data from Redis using HTTP requests${RESET_FORMAT}"

# Your existing deployment command
deploy_function() {
gcloud functions deploy http-get-redis \
--gen2 \
--runtime python310 \
--entry-point getFromRedis \
--source . \
--region $REGION \
--trigger-http \
--timeout 600s \
--max-instances 1 \
--vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector \
--set-env-vars REDISHOST=$REDIS_IP,REDISPORT=$REDIS_PORT \
--no-allow-unauthenticated
}

# Variables
SERVICE_NAME="http-get-redis"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "${GREEN_TEXT}${BOLD_TEXT}Cloud Function is deployed. Exiting the loop.${RESET_FORMAT}"
    break
  else
    echo "${YELLOW_TEXT}${BOLD_TEXT}Waiting for Cloud Function to be deployed...${RESET_FORMAT}"
    echo
    echo "${RED_TEXT}${BOLD_TEXT}Till then, consider Subscribing to my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
    echo
    sleep 10
  fi
done

sleep 20

FUNCTION_URI=$(gcloud functions describe http-get-redis --gen2 --region $REGION --format "value(serviceConfig.uri)"); echo $FUNCTION_URI

echo "${CYAN_TEXT}${BOLD_TEXT}Testing the HTTP function by retrieving our test data...${RESET_FORMAT}"

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?id=1234"

echo "${MAGENTA_TEXT}${BOLD_TEXT}Setting up a VM instance with a web server...${RESET_FORMAT}"

gcloud storage cp gs://cloud-training/CBL492/startup.sh .

gcloud compute instances create webserver-vm \
--image-project=debian-cloud \
--image-family=debian-11 \
--metadata-from-file=startup-script=./startup.sh \
--machine-type e2-standard-2 \
--tags=http-server \
--scopes=https://www.googleapis.com/auth/cloud-platform \
--zone $ZONE

echo "${BLUE_TEXT}${BOLD_TEXT}Creating firewall rule to allow HTTP traffic to the web server...${RESET_FORMAT}"

gcloud compute --project=$PROJECT_ID \
 firewall-rules create default-allow-http \
 --direction=INGRESS \
 --priority=1000 \
 --network=default \
 --action=ALLOW \
 --rules=tcp:80 \
 --source-ranges=0.0.0.0/0 \
 --target-tags=http-server

 sleep 20

 VM_INT_IP=$(gcloud compute instances describe webserver-vm --format='get(networkInterfaces[0].networkIP)' --zone $ZONE); echo $VM_INT_IP

 VM_EXT_IP=$(gcloud compute instances describe webserver-vm --format='get(networkInterfaces[0].accessConfigs[0].natIP)' --zone $ZONE); echo $VM_EXT_IP

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating third Cloud Function to connect to the VM web server...${RESET_FORMAT}"

 mkdir ~/vm-http && cd $_
touch main.py && touch requirements.txt

cat > main.py <<EOF_END
import functions_framework
import requests

@functions_framework.http
def connectVM(request):
    resp_text = ""
    if request.method == 'GET':
        ip = request.args.get('ip')
        try:
            response_data = requests.get(f"http://{ip}")
            resp_text = response_data.text
        except RuntimeError:
            print ("Error while connecting to VM")
    return resp_text
EOF_END

cat > requirements.txt <<EOF_END
functions-framework==3.2.0
Werkzeug==2.3.7
flask==2.1.3
requests==2.28.1
EOF_END

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

echo "${BLUE_TEXT}${BOLD_TEXT}Deploying VM connector Cloud Function...${RESET_FORMAT}"
echo "${YELLOW_TEXT}This function will connect to the VM's web server via HTTP${RESET_FORMAT}"

# Your existing deployment command
deploy_function() {
gcloud functions deploy vm-connector \
 --runtime python310 \
 --entry-point connectVM \
 --source . \
 --region $REGION \
 --trigger-http \
 --timeout 10s \
 --max-instances 1 \
 --no-allow-unauthenticated
}

# Variables
SERVICE_NAME="vm-connector"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "${GREEN_TEXT}${BOLD_TEXT}Cloud Function is deployed. Exiting the loop.${RESET_FORMAT}"
    break
  else
    echo "${YELLOW_TEXT}${BOLD_TEXT}Waiting for Cloud Function to be deployed...${RESET_FORMAT}"
    echo
    echo "${RED_TEXT}${BOLD_TEXT}Till then, consider Subscribing to my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
    echo
    sleep 10
  fi
done

FUNCTION_URI=$(gcloud functions describe vm-connector --region $REGION --format='value(httpsTrigger.url)'); echo $FUNCTION_URI

echo "${CYAN_TEXT}${BOLD_TEXT}Testing VM connection with external IP (public network)...${RESET_FORMAT}"

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_EXT_IP"

echo "${CYAN_TEXT}${BOLD_TEXT}Testing VM connection with internal IP (should fail without VPC connector)...${RESET_FORMAT}"

curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_INT_IP"

echo "${RED_TEXT}${BOLD_TEXT}Temporarily disabling and re-enabling Cloud Functions API...${RESET_FORMAT}"
echo "${YELLOW_TEXT}This is sometimes needed to clear service caches${RESET_FORMAT}"

gcloud services disable cloudfunctions.googleapis.com

gcloud services enable cloudfunctions.googleapis.com

sleep 60

PROJECT_NUMBER=$(gcloud projects describe $DEVSHELL_PROJECT_ID --format='value(projectNumber)')

echo "${BLUE_TEXT}${BOLD_TEXT}Redeploying VM connector with VPC connector to enable private network access...${RESET_FORMAT}"

# Your existing deployment command
deploy_function() {
gcloud functions deploy vm-connector \
 --runtime python310 \
 --entry-point connectVM \
 --source . \
 --region $REGION \
 --trigger-http \
 --timeout 10s \
 --max-instances 1 \
 --no-allow-unauthenticated \
 --vpc-connector projects/$PROJECT_ID/locations/$REGION/connectors/test-connector
}

# Variables
SERVICE_NAME="vm-connector"

# Loop until the Cloud Function is deployed
while true; do
  # Run the deployment command
  deploy_function

  # Check if Cloud Function is deployed
  if gcloud functions describe $SERVICE_NAME --region $REGION &> /dev/null; then
    echo "${GREEN_TEXT}${BOLD_TEXT}Cloud Function is deployed. Exiting the loop.${RESET_FORMAT}"
    break
  else
    echo "${YELLOW_TEXT}${BOLD_TEXT}Waiting for Cloud Function to be deployed...${RESET_FORMAT}"
    echo
    echo "${RED_TEXT}${BOLD_TEXT}Till then, consider Subscribing to my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
    echo
    sleep 10
  fi
done

echo "${CYAN_TEXT}${BOLD_TEXT}Testing VM connection with internal IP (should now work with VPC connector)...${RESET_FORMAT}"

 curl -H "Authorization: bearer $(gcloud auth print-identity-token)" "${FUNCTION_URI}?ip=$VM_INT_IP"

# Completion Message
echo
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}              LAB COMPLETED SUCCESSFULLY!              ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo ""
echo -e "${RED_TEXT}${BOLD_TEXT}Subscribe my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
echo