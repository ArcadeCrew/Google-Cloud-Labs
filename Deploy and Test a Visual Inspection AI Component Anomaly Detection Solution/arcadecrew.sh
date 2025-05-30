#!/bin/bash
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

echo
echo "${CYAN_TEXT}${BOLD_TEXT}===================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}🚀     INITIATING EXECUTION     🚀${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}===================================${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}📝 Creating deployment script for Visual Inspection AI solution...${RESET_FORMAT}"
echo

cat > prepare_disk.sh <<'EOF_END'
export DOCKER_TAG=gcr.io/ql-shared-resources-test/resistance_solution@sha256:d9095cbd6f7ca69b1a30c58c4272b68062d2004ed259ff0dcb9af0ceb92b393b

export VISERVING_CPU_DOCKER_WITH_MODEL=${DOCKER_TAG}
export HTTP_PORT=8602
export LOCAL_METRIC_PORT=8603

docker pull ${VISERVING_CPU_DOCKER_WITH_MODEL}

docker run -v /secrets:/secrets --rm -d --name "test_cpu" \
--network="host" \
-p ${HTTP_PORT}:8602 \
-p ${LOCAL_METRIC_PORT}:8603 \
-t ${VISERVING_CPU_DOCKER_WITH_MODEL} \
--metric_project_id="${PROJECT_ID}" \
--use_default_credentials=false \
--service_account_credentials_json=/secrets/assembly-usage-reporter.json

docker container ls 

gsutil cp gs://cloud-training/gsp895/prediction_script.py .

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil mb gs://${PROJECT_ID}
gsutil -m cp gs://cloud-training/gsp895/pcb_images/*.png \
gs://${PROJECT_ID}/demo_pcb_images/
gsutil cp gs://${PROJECT_ID}/demo_pcb_images/image_275_cx98_cy16_r-5.png .

sudo apt install python3 -y
sudo apt install python3-pip -y
sudo apt install python3.11-venv -y 
python3 -m venv create myvenv
source myvenv/bin/activate
pip install absl-py  
pip install numpy 
pip install requests

python3 ./prediction_script.py --input_image_file=./image_275_cx98_cy16_r-5.png  --port=8602 --output_result_file=def_prediction_result.json

python3 ./prediction_script.py --input_image_file=./image_275_cx98_cy16_r-5.png  --port=8602 --num_of_requests=10 --output_result_file=def_latency_result.json

export PROJECT_ID=$(gcloud config get-value core/project)
gsutil cp gs://${PROJECT_ID}/demo_pcb_images/image_439_cx31_cy-35_r-4.png .

python3 ./prediction_script.py --input_image_file=./image_439_cx31_cy-35_r-4.png  --port=8602 --output_result_file=non_def_prediction_result.json

python3 ./prediction_script.py --input_image_file=./image_275_cx98_cy16_r-5.png  --port=8602 --num_of_requests=10 --output_result_file=non_def_latency_result.json
EOF_END

echo "${GREEN_TEXT}${BOLD_TEXT}✅ Deployment script created successfully!${RESET_FORMAT}"
echo

echo "${BLUE_TEXT}${BOLD_TEXT}🔍 Detecting target VM zone configuration...${RESET_FORMAT}"
echo

export ZONE=$(gcloud compute instances list lab-vm --format 'csv[no-heading](zone)')

echo "${MAGENTA_TEXT}${BOLD_TEXT}📤 Transferring deployment script to remote VM...${RESET_FORMAT}"
echo

gcloud compute scp prepare_disk.sh lab-vm:/tmp --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet

echo "${CYAN_TEXT}${BOLD_TEXT}🎯 Executing Visual Inspection AI deployment on remote VM...${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}⏳ This process may take several minutes to complete...${RESET_FORMAT}"
echo

gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet --command="bash /tmp/prepare_disk.sh"

echo
echo "${WHITE_TEXT}${BOLD_TEXT}🔬 Anomaly detection solution is now ready for testing${RESET_FORMAT}"
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}💖 IF YOU FOUND THIS HELPFUL, SUBSCRIBE ARCADE CREW! 👇${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
echo
