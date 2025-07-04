# ✨ Using the Machine Learning Accelerator in Looker to Create BigQuery ML Models
[![Lab Link](https://img.shields.io/badge/Open_Lab-Cloud_Skills_Boost-4285F4?style=for-the-badge&logo=google&logoColor=white)](https://www.youtube.com/@Arcade61432?sub_confirmation=1)

---

### ⚠️ Disclaimer  
- **This script and guide are intended solely for educational purposes to help you better understand lab services and advance your career. Before using the script, please review it carefully to become familiar with Google Cloud services. Always ensure compliance with Qwiklabs’ terms of service and YouTube’s community guidelines. The aim is to enhance your learning experience—not to circumvent it.**

---

## ⚙️ Lab Environment Setup

### ⚡ Task 1 Shortcuts: Explore Customer Churn Data
1. After opening **Looker → Explore → Telco Customer Churn**, select **Churn Rate**, hit **Run**.
   - **Answer:** 14.1%.
2. Select **Service Calls Group** dimension → Click **Run**.
   - **Answer:** 85.7%.
3. **Click Check My Progress NOW** → ✅ Task 1 done.

---

### ⚡ Task 2 Shortcut: Create Classification Model
#### 2.1 Go to Machine Learning Accelerator:
- Browse → **Applications → ML Accelerator**.
- Click **Create New Model**.

#### 2.2 Objective:
- **Select Classification** → Click **Continue**.

#### 2.3 Source:
- Select **Telco Customer Churn Explore**.
- Apply filter: **Dataframe → train**.
- Select **Customer ID**, **Churn**, and all features below.

| **Dimensions**                  | **Measures**               |
|----------------------------------|----------------------------|
| **Account Duration Months**      | **Total Day Calls**        |
| **International Plan** (Yes/No)  | **Total Day Charge**       |
| **State**                        | **Total Day Minutes**      |
| **Voice Mail Plan** (Yes/No)     | **Total Eve Calls**        |
|                                  | **Total Eve Charge**       |
|                                  | **Total Eve Minutes**      |
|                                  | **Total Intl Calls**       |
|                                  | **Total Intl Charge**      |
|                                  | **Total Intl Minutes**     |
|                                  | **Total Night Calls**      |
|                                  | **Total Night Charge**     |
|                                  | **Total Night Minutes**    |
|                                  | **Total Service Calls**    |
|                                  | **Total Vmail Messages**   |


- Click **Run** → Wait for results → Click **Continue**.

#### 2.4 Model Options:
- Model Name = Your **Project ID** with `_` instead of `-`.
- Target Field = **Customer Churn (Yes/No)**.
- Click **Generate Summary** → Wait for results.

#### ⚙️ Quick Advanced Settings:
- Click **Settings** → Set:
   - **Data split method**: RANDOM
   - **Fraction size**: 0.25
- Click **Save**.
- Click **Create Model** → Starts training (30–35 min).

---

## 🎉 **Congratulations! Lab Completed Successfully!** 🏆  

---

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

<br>

> *Note: This guide is provided for educational purposes. Always follow Qwiklabs terms of service and YouTube's community guidelines.*

---
