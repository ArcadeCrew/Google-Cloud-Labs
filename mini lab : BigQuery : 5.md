# ✨ mini lab : BigQuery : 5

[![Lab Link](https://img.shields.io/badge/Open_Lab-Cloud_Skills_Boost-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://www.youtube.com/@Arcade61432?sub_confirmation=1)

---

## ⚠️ Disclaimer

<div style="padding: 15px; margin-bottom: 20px;">
<p><strong>Educational Purpose Only:</strong> This script and guide are intended solely for educational purposes to help you understand Google Cloud monitoring services and advance your cloud skills. Before using, please review it carefully to become familiar with the services involved.</p>

<p><strong>Terms Compliance:</strong> Always ensure compliance with Qwiklabs' terms of service and YouTube's community guidelines. The aim is to enhance your learning experience—not to circumvent it.</p>
</div>

---

## ⚙️ Lab Environment Setup

<div style="padding: 15px; margin: 10px 0;">
<p><strong>☁️ Run in Terminal:</strong></p>

```bash
PROJECT_ID=$(gcloud config get-value project)

bq load --autodetect --source_format=CSV customer_details.customers customers.csv

bq query --use_legacy_sql=false 'CREATE OR REPLACE TABLE customer_details.male_customers AS SELECT CustomerID, Gender FROM customer_details.customers WHERE Gender = "Male"'

bq extract --destination_format=CSV customer_details.male_customers gs://${PROJECT_ID}-bucket/exported_male_customers.csv
```
</div>
---

## 🎉 **Congratulations! Lab Completed Successfully!** 🏆  

<div align="center" style="padding: 5px;">
  <h3>📱 Join the Arcade Crew Community</h3>
  
  <a href="https://t.me/arcadecrewupdates">
    <img src="https://img.shields.io/badge/Join-Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram">
  </a>
  &nbsp;
  <a href="https://www.instagram.com/arcade_crew/">
    <img src="https://img.shields.io/badge/Follow-Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram">
  </a>
  &nbsp;
  <a href="https://www.youtube.com/@arcade_creww?sub_confirmation=1">
    <img src="https://img.shields.io/badge/Subscribe-Arcade%20Crew-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube Channel">
  </a>
  &nbsp;
  <a href="https://www.linkedin.com/in/arcadecrew/">
    <img src="https://img.shields.io/badge/LINKEDIN-Arcade%20Crew-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
</div>

---

<div align="center">
  <p style="font-size: 12px; color: #586069;">
    <em>This guide is provided for educational purposes. Always follow Qwiklabs terms of service and YouTube's community guidelines.</em>
  </p>
  <p style="font-size: 12px; color: #586069;">
    <em>Last updated: March 2025</em>
  </p>
</div>
