#!/bin/bash

# Define color variables
YELLOW_COLOR=$'\033[0;33m'
MAGENTA_COLOR="\e[35m"
NO_COLOR=$'\033[0m'
BACKGROUND_RED=`tput setab 1`
GREEN_TEXT=$'\033[0;32m'
RED_TEXT=`tput setaf 1`
BOLD_TEXT=`tput bold`
RESET_FORMAT=`tput sgr0`
BLUE_TEXT=`tput setaf 4`

echo
echo

# Display initiation message
echo "${GREEN_TEXT}${BOLD_TEXT}Initiating Execution...${RESET_FORMAT}"

echo

# Step 1: Create job-configuration.json file
echo -e "${MAGENTA_COLOR}${BOLD_TEXT}Step 1: Creating job-configuration.json file...${RESET_FORMAT}"
cat > job-configuration.json << EOM
{
  "triggerId": "dlp_job",
  "jobTrigger": {
    "triggers": [
      {
        "schedule": {
          "recurrencePeriodDuration": "604800s"
        }
      }
    ],
    "inspectJob": {
      "actions": [
        {
          "deidentify": {
            "fileTypesToTransform": [
              "TEXT_FILE",
              "IMAGE",
              "CSV",
              "TSV"
            ],
            "transformationDetailsStorageConfig": {},
            "transformationConfig": {
              "deidentifyTemplate": "projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates/unstructured_data_template",
              "structuredDeidentifyTemplate": "projects/$DEVSHELL_PROJECT_ID/locations/global/deidentifyTemplates/structured_data_template"
            },
            "cloudStorageOutput": "gs://$DEVSHELL_PROJECT_ID-output"
          }
        }
      ],
      "inspectConfig": {
        "infoTypes": [
          {
            "name": "ADVERTISING_ID"
          },
          {
            "name": "AGE"
          },
          {
            "name": "ARGENTINA_DNI_NUMBER"
          },
          {
            "name": "AUSTRALIA_TAX_FILE_NUMBER"
          },
          {
            "name": "BELGIUM_NATIONAL_ID_CARD_NUMBER"
          },
          {
            "name": "BRAZIL_CPF_NUMBER"
          },
          {
            "name": "CANADA_SOCIAL_INSURANCE_NUMBER"
          },
          {
            "name": "CHILE_CDI_NUMBER"
          },
          {
            "name": "CHINA_RESIDENT_ID_NUMBER"
          },
          {
            "name": "COLOMBIA_CDC_NUMBER"
          },
          {
            "name": "CREDIT_CARD_NUMBER"
          },
          {
            "name": "CREDIT_CARD_TRACK_NUMBER"
          },
          {
            "name": "DATE_OF_BIRTH"
          },
          {
            "name": "DENMARK_CPR_NUMBER"
          },
          {
            "name": "EMAIL_ADDRESS"
          },
          {
            "name": "ETHNIC_GROUP"
          },
          {
            "name": "FDA_CODE"
          },
          {
            "name": "FINLAND_NATIONAL_ID_NUMBER"
          },
          {
            "name": "FRANCE_CNI"
          },
          {
            "name": "FRANCE_NIR"
          },
          {
            "name": "FRANCE_TAX_IDENTIFICATION_NUMBER"
          },
          {
            "name": "GENDER"
          },
          {
            "name": "GERMANY_IDENTITY_CARD_NUMBER"
          },
          {
            "name": "GERMANY_TAXPAYER_IDENTIFICATION_NUMBER"
          },
          {
            "name": "HONG_KONG_ID_NUMBER"
          },
          {
            "name": "IBAN_CODE"
          },
          {
            "name": "IMEI_HARDWARE_ID"
          },
          {
            "name": "INDIA_AADHAAR_INDIVIDUAL"
          },
          {
            "name": "INDIA_GST_INDIVIDUAL"
          },
          {
            "name": "INDIA_PAN_INDIVIDUAL"
          },
          {
            "name": "INDONESIA_NIK_NUMBER"
          },
          {
            "name": "IRELAND_PPSN"
          },
          {
            "name": "ISRAEL_IDENTITY_CARD_NUMBER"
          },
          {
            "name": "JAPAN_INDIVIDUAL_NUMBER"
          },
          {
            "name": "KOREA_RRN"
          },
          {
            "name": "MAC_ADDRESS"
          },
          {
            "name": "MEXICO_CURP_NUMBER"
          },
          {
            "name": "NETHERLANDS_BSN_NUMBER"
          },
          {
            "name": "NORWAY_NI_NUMBER"
          },
          {
            "name": "PARAGUAY_CIC_NUMBER"
          },
          {
            "name": "PASSPORT"
          },
          {
            "name": "PERSON_NAME"
          },
          {
            "name": "PERU_DNI_NUMBER"
          },
          {
            "name": "PHONE_NUMBER"
          },
          {
            "name": "POLAND_NATIONAL_ID_NUMBER"
          },
          {
            "name": "PORTUGAL_CDC_NUMBER"
          },
          {
            "name": "SCOTLAND_COMMUNITY_HEALTH_INDEX_NUMBER"
          },
          {
            "name": "SINGAPORE_NATIONAL_REGISTRATION_ID_NUMBER"
          },
          {
            "name": "SPAIN_CIF_NUMBER"
          },
          {
            "name": "SPAIN_DNI_NUMBER"
          },
          {
            "name": "SPAIN_NIE_NUMBER"
          },
          {
            "name": "SPAIN_NIF_NUMBER"
          },
          {
            "name": "SPAIN_SOCIAL_SECURITY_NUMBER"
          },
          {
            "name": "STORAGE_SIGNED_URL"
          },
          {
            "name": "STREET_ADDRESS"
          },
          {
            "name": "SWEDEN_NATIONAL_ID_NUMBER"
          },
          {
            "name": "SWIFT_CODE"
          },
          {
            "name": "THAILAND_NATIONAL_ID_NUMBER"
          },
          {
            "name": "TURKEY_ID_NUMBER"
          },
          {
            "name": "UK_NATIONAL_HEALTH_SERVICE_NUMBER"
          },
          {
            "name": "UK_NATIONAL_INSURANCE_NUMBER"
          },
          {
            "name": "UK_TAXPAYER_REFERENCE"
          },
          {
            "name": "URUGUAY_CDI_NUMBER"
          },
          {
            "name": "US_BANK_ROUTING_MICR"
          },
          {
            "name": "US_EMPLOYER_IDENTIFICATION_NUMBER"
          },
          {
            "name": "US_HEALTHCARE_NPI"
          },
          {
            "name": "US_INDIVIDUAL_TAXPAYER_IDENTIFICATION_NUMBER"
          },
          {
            "name": "US_SOCIAL_SECURITY_NUMBER"
          },
          {
            "name": "VEHICLE_IDENTIFICATION_NUMBER"
          },
          {
            "name": "VENEZUELA_CDI_NUMBER"
          },
          {
            "name": "WEAK_PASSWORD_HASH"
          },
          {
            "name": "AUTH_TOKEN"
          },
          {
            "name": "AWS_CREDENTIALS"
          },
          {
            "name": "AZURE_AUTH_TOKEN"
          },
          {
            "name": "BASIC_AUTH_HEADER"
          },
          {
            "name": "ENCRYPTION_KEY"
          },
          {
            "name": "GCP_API_KEY"
          },
          {
            "name": "GCP_CREDENTIALS"
          },
          {
            "name": "JSON_WEB_TOKEN"
          },
          {
            "name": "HTTP_COOKIE"
          },
          {
            "name": "XSRF_TOKEN"
          }
        ],
        "minLikelihood": "POSSIBLE"
      },
      "storageConfig": {
        "cloudStorageOptions": {
          "filesLimitPercent": 100,
          "fileTypes": [
            "TEXT_FILE",
            "IMAGE",
            "WORD",
            "PDF",
            "AVRO",
            "CSV",
            "TSV",
            "EXCEL",
            "POWERPOINT"
          ],
          "fileSet": {
            "regexFileSet": {
              "bucketName": "$DEVSHELL_PROJECT_ID-input",
              "includeRegex": [],
              "excludeRegex": []
            }
          }
        }
      }
    },
    "status": "HEALTHY"
  }
}
EOM

# Step 2: Send job configuration to DLP API
echo -e "${YELLOW_COLOR}${BOLD_TEXT}Step 2: Sending job configuration to DLP API...${RESET_FORMAT}"
curl -s \
-H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
-H "Content-Type: application/json" \
https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/locations/global/jobTriggers \
-d @job-configuration.json

# Step 3: Wait for job trigger activation
echo -e "${BLUE_TEXT}${BOLD_TEXT}Step 3: Waiting 15 seconds before activating the job trigger...${RESET_FORMAT}"
sleep 15

# Step 4: Activate the job trigger
echo -e "${GREEN_TEXT}${BOLD_TEXT}Step 4: Activating the job trigger...${RESET_FORMAT}"
curl --request POST \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -H "X-Goog-User-Project: $DEVSHELL_PROJECT_ID" \
  "https://dlp.googleapis.com/v2/projects/$DEVSHELL_PROJECT_ID/locations/global/jobTriggers/dlp_job:activate"

# Safely delete the script if it exists
SCRIPT_NAME="arcadecrew.sh"
if [ -f "$SCRIPT_NAME" ]; then
    echo -e "${BOLD_TEXT}${RED_TEXT}Deleting the script ($SCRIPT_NAME) for safety purposes...${RESET_FORMAT}${NO_COLOR}"
    rm -- "$SCRIPT_NAME"
fi

echo
echo
# Completion message
echo -e "${MAGENTA_COLOR}${BOLD_TEXT}Lab Completed Successfully!${RESET_FORMAT}"
echo -e "${GREEN_TEXT}${BOLD_TEXT}Subscribe our Channel:${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
echo