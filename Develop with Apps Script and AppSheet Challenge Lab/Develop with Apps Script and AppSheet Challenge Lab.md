# ✨ Develop with Apps Script and AppSheet: Challenge Lab || ARC126 ✨
<div align="center">
<a href="https://www.cloudskillsboost.google/focuses/66584?parent=catalog" target="_blank" rel="noopener noreferrer" style="text-decoration: none;">
    <img src="https://img.shields.io/badge/Open_Lab-Cloud_Skills_Boost-4285F4?style=for-the-badge&logo=google&logoColor=white&labelColor=34A853" alt="Open Lab Badge" style="height: 35px; border-radius: 5px; transition: transform 0.2s ease-in-out;" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
  </a>
</div>

---

## ⚠️ Disclaimer ⚠️

> **Educational Purpose Only:** This script and guide are intended *solely for educational purposes* to help you understand Google Cloud monitoring services and advance your cloud skills. Before using, please review it carefully to become familiar with the services involved.
>
> **Terms Compliance:** Always ensure compliance with Qwiklabs' terms of service and YouTube's community guidelines. The aim is to enhance your learning experience—*not* to circumvent it.

---

## <ins>📝 Task 1: Create and customize an AppSheet app</ins>

1.  **Login** to **AppSheet**.
2.  Access the **[ATM Maintenance App](https://www.appsheet.com/template/AppDef?appName=ATMMaintenance-925818016)** in **Incognito Mode**.
3.  Use the left menu to select **Copy app**.
4.  In the **Copy app** form, set the **App name** as:
    ```plaintext
    ATM Maintenance Tracker
    ```
    *Leave other settings as they are.*
5.  Click **Copy app** to proceed.

---

## <ins>⚙️ Task 2: Add an automation to an AppSheet app</ins>

1.  Open **My Drive** from **[this link](https://drive.google.com/drive/my-drive)**.
2.  Download the required file **[here 📥](https://gourav8959-my.sharepoint.com/:f:/g/personal/gourav8959_gourav8959_onmicrosoft_com/Ejr59_zDiNRGko-iuLIritwBBmt-46CjuTLVqWpfzy9QeA?e=icLCtw)**.

---

## <ins>🤖 Task 3: Creating and Publishing a Google Chat Bot with Apps Script</ins>

1.  Start a new **Apps Script Chat App** project from **[this link](https://script.google.com/home/projects/create?template=hangoutsChat)**.

    <table style="width:100%; border: 1px solid #dfe2e5; border-collapse: collapse; text-align: center; font-family: sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
      <thead style="background-color: #0366d6; color: #ffffff;">
        <tr>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Property</th>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Value</th>
        </tr>
      </thead>
      <tbody>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Project name</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5; font-family: monospace; background-color: #eff2f5;">Helper Bot</td>
        </tr>
      </tbody>
    </table>
    <br/>

2.  Replace the content in `Code.gs` with the following script:

   ```javascript
   /**
    * Responds to a MESSAGE event in Google Chat.
    *
    * @param {Object} event the event object from Google Chat
    */
   function onMessage(event) {
     var name = "";

     if (event.space.type == "DM") {
       name = "You";
     } else {
       name = event.user.displayName;
     }
     var message = name + " said \"" + event.message.text + "\"";

     return { "text": message };
   }

   /**
    * Responds to an ADDED_TO_SPACE event in Google Chat.
    *
    * @param {Object} event the event object from Google Chat
    */
   function onAddToSpace(event) {
     var message = "";

     if (event.space.singleUserBotDm) {
       message = "Thank you for adding me to a DM, " + event.user.displayName + "!";
     } else {
       message = "Thank you for adding me to " +
           (event.space.displayName ? event.space.displayName : "this chat");
     }

     if (event.message) {
       message = message + " and you said: \"" + event.message.text + "\"";
     }
     console.log('Helper Bot added in ', event.space.name);
     return { "text": message };
   }

   /**
    * Responds to a REMOVED_FROM_SPACE event in Google Chat.
    *
    * @param {Object} event the event object from Google Chat
    */
   function onRemoveFromSpace(event) {
     console.info("Bot removed from ",
         (event.space.name ? event.space.name : "this chat"));
   }
   ```

---

## <ins>🔧 Configuring OAuth Consent Screen</ins>

1.  Navigate to the **OAuth consent screen** using **[this link](https://console.cloud.google.com/apis/credentials/consent)**.
2.  Configure the settings as follows:

    <table style="width:100%; border: 1px solid #dfe2e5; border-collapse: collapse; text-align: left; font-family: sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
      <thead style="background-color: #0366d6; color: #ffffff;">
        <tr>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Field</th>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Value</th>
        </tr>
      </thead>
      <tbody>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">App name</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5; font-family: monospace; background-color: #eff2f5;">Helper Bot</td>
        </tr>
        <tr style="background-color: #ffffff; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">User support email</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">*Your selected email*</td>
        </tr>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Developer contact</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">*Your email address*</td>
        </tr>
      </tbody>
    </table>

---

## <ins>🛠️ Setting Up Google Chat API</ins>

1.  Visit the **Google Chat API Configuration** page **[here](https://console.cloud.google.com/apis/api/chat.googleapis.com/hangouts-chat)**.
2.  Apply the following configuration:

    <table style="width:100%; border: 1px solid #dfe2e5; border-collapse: collapse; text-align: left; font-family: sans-serif; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
      <thead style="background-color: #0366d6; color: #ffffff;">
        <tr>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Field</th>
          <th style="padding: 10px 15px; border: 1px solid #dfe2e5;">Value</th>
        </tr>
      </thead>
      <tbody>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">App name</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5; font-family: monospace; background-color: #eff2f5;">Helper Bot</td>
        </tr>
        <tr style="background-color: #ffffff; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Avatar URL</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5; font-family: monospace; background-color: #eff2f5;">https://goo.gl/kv2ENA</td>
        </tr>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Description</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Helper chat bot</td>
        </tr>
        <tr style="background-color: #ffffff; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Functionality</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">✅ Receive 1:1 messages and join spaces/group conversations</td>
        </tr>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Connection settings</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">✅ Check <b>Apps Script project</b> and add <b>Head Deployment ID</b></td>
        </tr>
        <tr style="background-color: #ffffff; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">Visibility</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">✅ Specific people and groups: *Your email address*</td>
        </tr>
        <tr style="background-color: #f6f8fa; border-top: 1px solid #dfe2e5;">
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">App Status</td>
          <td style="padding: 10px 15px; border: 1px solid #dfe2e5;">🟢 LIVE – Available to users</td>
        </tr>
      </tbody>
    </table>

---

## <ins>🧪 Testing Your Helper Bot</ins>

You can test your newly created bot directly in Google Chat **[here](https://mail.google.com/chat/u/0/#chat/home)**.

---

## 🎉 **Congratulations! Lab Completed Successfully!** 🏆  

<div align="center" style="padding: 5px;">
  <h3>📱 Join the Arcade Crew Community</h3>
  
  <a href="https://chat.whatsapp.com/KkNEauOhBQXHdVcmqIlv9F">
    <img src="https://img.shields.io/badge/Join_WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white" alt="Join WhatsApp">
  </a>
  &nbsp;
  <a href="https://www.youtube.com/@Arcade61432?sub_confirmation=1">
    <img src="https://img.shields.io/badge/Subscribe-Arcade%20Crew-FF0000?style=for-the-badge&logo=youtube&logoColor=white" alt="YouTube Channel">
  </a>
  &nbsp;
  <a href="https://www.linkedin.com/in/gourav61432/">
    <img src="https://img.shields.io/badge/LINKEDIN-Gourav%20Sen-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
</a>


</div>

---

<div align="center">
  <p style="font-size: 12px; color: #586069;">
    <em>This guide is provided for educational purposes. Always follow Qwiklabs terms of service and YouTube's community guidelines.</em>
  </p>
  <p style="font-size: 12px; color: #586069;">
    <em>Last updated: April 2025</em>
  </p>
</div>
