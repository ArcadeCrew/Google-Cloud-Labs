#!/bin/bash

# Define color variables
YELLOW_TEXT=$'\033[0;33m'
MAGENTA_TEXT=$'\033[0;35m'
NO_COLOR=$'\033[0m'
GREEN_TEXT=$'\033[0;32m'
RED_TEXT=$'\033[0;31m'
CYAN_TEXT=$'\033[0;36m'
BOLD_TEXT=$'\033[1m'
RESET_FORMAT=$'\033[0m'
BLUE_TEXT=$'\033[0;34m'

# Start of the script
echo
echo "${CYAN_TEXT}${BOLD_TEXT}Starting the process...${RESET_FORMAT}"
echo

# Prompt user to input the region
echo "${YELLOW_TEXT}${BOLD_TEXT}Step 1: Set the region for your Google Cloud resources.${RESET_FORMAT}"
echo "${MAGENTA_TEXT}${BOLD_TEXT}Please Enter REGION:${RESET_FORMAT}"
read -p "Region: " REGION
export REGION

# Set the region in gcloud config
echo
echo "${GREEN_TEXT}${BOLD_TEXT}Step 2: Setting the region in gcloud config...${RESET_FORMAT}"
gcloud config set compute/region $REGION

# Create a directory for the Cloud Function
echo
echo "${BLUE_TEXT}${BOLD_TEXT}Step 3: Creating a directory for the Cloud Function...${RESET_FORMAT}"
mkdir gcf_hello_world && cd $_

# Create the index.js file
echo
echo "${CYAN_TEXT}${BOLD_TEXT}Step 4: Creating the index.js file for the Cloud Function...${RESET_FORMAT}"
cat > index.js <<'EOF_END'
const functions = require('@google-cloud/functions-framework');

// Register a CloudEvent callback with the Functions Framework that will
// be executed when the Pub/Sub trigger topic receives a message.
functions.cloudEvent('helloPubSub', cloudEvent => {
  // The Pub/Sub message is passed as the CloudEvent's data payload.
  const base64name = cloudEvent.data.message.data;

  const name = base64name
    ? Buffer.from(base64name, 'base64').toString()
    : 'World';

  console.log(`Hello, ${name}!`);
});
EOF_END

# Create the package.json file
echo
echo "${GREEN_TEXT}${BOLD_TEXT}Step 5: Creating the package.json file for the Cloud Function...${RESET_FORMAT}"
cat > package.json <<'EOF_END'
{
  "name": "gcf_hello_world",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "dependencies": {
    "@google-cloud/functions-framework": "^3.0.0"
  }
}
EOF_END

# Install dependencies
echo
echo "${YELLOW_TEXT}${BOLD_TEXT}Step 6: Installing dependencies using npm...${RESET_FORMAT}"
npm install

# Disable and re-enable Cloud Functions API
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}Step 7: Disabling and re-enabling the Cloud Functions API...${RESET_FORMAT}"
gcloud services disable cloudfunctions.googleapis.com
gcloud services enable cloudfunctions.googleapis.com

# Wait for the API to be fully enabled
echo
echo "${BLUE_TEXT}${BOLD_TEXT}Step 8: Waiting for the Cloud Functions API to be fully enabled...${RESET_FORMAT}"
sleep 15

# Deploy the Cloud Function
echo
echo "${CYAN_TEXT}${BOLD_TEXT}Step 9: Deploying the Cloud Function...${RESET_FORMAT}"
gcloud functions deploy nodejs-pubsub-function \
  --gen2 \
  --runtime=nodejs20 \
  --region=$REGION \
  --source=. \
  --entry-point=helloPubSub \
  --trigger-topic cf-demo \
  --stage-bucket $DEVSHELL_PROJECT_ID-bucket \
  --service-account cloudfunctionsa@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com \
  --allow-unauthenticated \
  --quiet

# Describe the deployed Cloud Function
echo
echo "${GREEN_TEXT}${BOLD_TEXT}Step 10: Describing the deployed Cloud Function...${RESET_FORMAT}"
gcloud functions describe nodejs-pubsub-function \
  --region=$REGION

echo


# Safely delete the script if it exists
SCRIPT_NAME="arcadecrew.sh"
if [ -f "$SCRIPT_NAME" ]; then
    echo -e "${BOLD_TEXT}${RED_TEXT}Deleting the script ($SCRIPT_NAME) for safety purposes...${RESET_FORMAT}${NO_COLOR}"
    rm -- "$SCRIPT_NAME"
fi

echo
# Completion message
echo -e "${MAGENTA_TEXT}${BOLD_TEXT}Lab Completed Successfully!${RESET_FORMAT}"
echo -e "${GREEN_TEXT}${BOLD_TEXT}Subscribe our Channel:${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
echo