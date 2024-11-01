# Define color codes for output formatting
YELLOW_COLOR=$'\033[0;33m'
NO_COLOR=$'\033[0m'
BACKGROUND_RED=`tput setab 1`
GREEN_TEXT=`tput setab 2`
RED_TEXT=`tput setaf 1`

BOLD_TEXT=`tput bold`
RESET_FORMAT=`tput sgr0`

echo "${BACKGROUND_RED}${BOLD_TEXT}Initiating Execution...${RESET_FORMAT}"

# Prompt user for their username
read -p "${YELLOW_COLOR}Enter USERNAME 2: ${NO_COLOR}" USERNAME_2

# Set the storage bucket and enable uniform bucket-level access
gsutil mb -l us -b on gs://$DEVSHELL_PROJECT_ID

# Create a sample file and write content to it
echo "Subscribe to Arcade Crew" > sample.txt

# Upload the sample file to the specified bucket
gsutil cp sample.txt gs://$DEVSHELL_PROJECT_ID

# Remove IAM policy binding for the specified user
gcloud projects remove-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/viewer

# Add IAM policy binding for storage object viewer role
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID \
  --member=user:$USERNAME_2 \
  --role=roles/storage.objectViewer


# Completion message
echo -e "${RED_TEXT}${BOLD_TEXT}Lab Completed Successfully!${RESET_FORMAT}"
echo -e "${GREEN_TEXT}${BOLD_TEXT}Check out our Channel: \e]8;;https://www.youtube.com/@Arcade61432\e\\https://www.youtube.com/@Arcade61432\e]8;;\e\\${RESET_FORMAT}"