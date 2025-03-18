# 🎙️ Cloud Speech API: Hands-On Challenge Lab
[![Lab Link](https://img.shields.io/badge/Open_Lab-Cloud_Skills_Boost-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://www.cloudskillsboost.google/focuses/67215?parent=catalog)

---

### ⚠️ Disclaimer  
- **This script and guide are intended solely for educational purposes to help you better understand lab services and advance your career. Before using the script, please review it carefully to become familiar with Google Cloud services. Always ensure compliance with Qwiklabs’ terms of service and YouTube’s community guidelines. The aim is to enhance your learning experience—not to circumvent it.**

---

## ⚙️ Lab Environment Setup

Connect to your lab VM by running the following commands in Cloud Shell:

```bash
# Get the zone of your lab VM
export ZONE=$(gcloud compute instances list lab-vm --format 'csv[no-heading](zone)')

# SSH into the lab VM
gcloud compute ssh lab-vm --project=$DEVSHELL_PROJECT_ID --zone=$ZONE --quiet
```

Once connected to the lab VM, download and run the setup script:

```bash
# Download the setup script
curl -LO raw.githubusercontent.com/ArcadeCrew/Google-Cloud-Labs/refs/heads/main/Cloud%20Speech%20API%203%20Ways%20Challenge%20Lab/arcadecrew.sh

# Make the script executable
sudo chmod +x arcadecrew.sh

# Run the script to set up your environment
./arcadecrew.sh
```

---

## 🎉 **Congratulations! Lab Completed Successfully!** 🏆  

---

<div align="center">
  <p><strong>Visit Arcade Crew Community for more learning resources!</strong></p>
  
  <a href="https://chat.whatsapp.com/KkNEauOhBQXHdVcmqIlv9F">
    <img src="https://img.shields.io/badge/Join_WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" alt="Join WhatsApp">
  </a>
  &nbsp;
  <a href="https://www.youtube.com/@Arcade61432?sub_confirmation=1">
    <img src="https://img.shields.io/badge/Subscribe-Arcade%20%Crew-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube Channel">
  </a>
</div>

<br>

> *Note: This guide is provided for educational purposes. Always follow Qwiklabs terms of service and YouTube's community guidelines.*

---
