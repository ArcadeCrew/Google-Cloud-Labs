# Define color codes for output formatting
YELLOW_COLOR=$'\033[0;33m'
NO_COLOR=$'\033[0m'
BACKGROUND_RED=`tput setab 1`
GREEN_TEXT=`tput setab 2`
RED_TEXT=`tput setaf 1`

BOLD_TEXT=`tput bold`
RESET_FORMAT=`tput sgr0`

echo "${BACKGROUND_RED}${BOLD_TEXT}Initiating Execution...${RESET_FORMAT}"

gcloud alpha services api-keys create --display-name="arcadecrew" 

KEY_NAME=$(gcloud alpha services api-keys list --format="value(name)" --filter "displayName=arcadecrew")

export API_KEY=$(gcloud alpha services api-keys get-key-string $KEY_NAME --format="value(keyString)")

export PROJECT_ID=$(gcloud config list --format 'value(core.project)')

gsutil mb gs://$PROJECT_ID

curl -LO raw.githubusercontent.com/ArcadeCrew/Google-Cloud-Labs/refs/heads/main/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/city.png

curl -LO raw.githubusercontent.com/ArcadeCrew/Google-Cloud-Labs/refs/heads/main/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/donuts.png

curl -LO raw.githubusercontent.com/ArcadeCrew/Google-Cloud-Labs/refs/heads/main/Detect%20Labels%2C%20Faces%2C%20and%20Landmarks%20in%20Images%20with%20the%20Cloud%20Vision%20API/selfie.png

gsutil cp donuts.png gs://$PROJECT_ID

gsutil cp selfie.png gs://$PROJECT_ID

gsutil cp city.png gs://$PROJECT_ID

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/donuts.png

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/selfie.png

gsutil acl ch -u AllUsers:R gs://$PROJECT_ID/city.png

# Completion message
echo -e "${RED_TEXT}${BOLD_TEXT}Lab Completed Successfully!${RESET_FORMAT}"
echo -e "${GREEN_TEXT}${BOLD_TEXT}Check out our Channel: \e]8;;https://www.youtube.com/@Arcade61432\e\\https://www.youtube.com/@Arcade61432\e]8;;\e\\${RESET_FORMAT}"