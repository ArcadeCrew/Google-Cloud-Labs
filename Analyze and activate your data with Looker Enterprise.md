# 🚀 **Analyze and activate your data with Looker Enterprise**  
[![Open Lab](https://img.shields.io/badge/Open-Lab-brown?style=for-the-badge&logo=google-cloud&logoColor=blue)](https://www.cloudskillsboost.google/focuses/88314?parent=catalog) 
---

## ⚠️ **Important Notice**  
This guide is designed to enhance your learning experience during this lab. Please review each step carefully to fully understand the concepts. Ensure you adhere to **Qwiklabs** and **YouTube** policies while following this guide.  

---
### **Open fintech.model file**
```
explore: +loan_details {
    query: Task2_ArcadeCrew{
      measures: [loan.outstanding_loans_amount]
    }
}


explore: +loan_details {
    query: Task3_ArcadeCrew {
      dimensions: [loan.loan_status]
      measures: [loan.outstanding_loans_amount]
    }
}


explore: +loan_details {
    query: Task4_ArcadeCrew {
      dimensions: [loan.state]
      measures: [loan.outstanding_count]
    }
}


explore: +loan_details {
    query: Task5_ArcadeCrew {
      dimensions: [
        customer.address_state,
        customer.annual_income,
        customer.customer_id,
        customer.home_ownership,
        loan.interest_rate,
        loan.loan_status
      ]
    }
}

```  
---

### Task 2: Total Outstanding Loans Visualization
#### Steps:
1. **Explore Data:**
   - Click `Loan Details` in Looker.
   - Review dimensions and measures under `All Fields`.
   - Check `loan.view` in LookML to understand available data.

2. **Select Data:**
   - Use `Outstanding Loans Amount` measure.

3. **Create Visualization:**
   - Select `Single Value Visualization`.
   - Apply conditional formatting to highlight values above $`3000000000` in red.
   - Dashboard Name: `Loan Insights`
   - Title: `Total Amount of Outstanding Loans`.

4. **Save to Dashboard:**
   - Click `Save` to update the dashboard.

---

### Task 3: Percentage of Outstanding Loans by Status

#### Steps:
1. **Select Data:**
   - Use `Loan Status` as the dimension.
   - Use `Count` as the measure.

2. **Create Visualization:**
   - Choose `Pie Chart` for part-to-whole analysis.
   - Title: `Percentage of Outstanding Loans`.

3. **Save to Dashboard:**
   - Click `Save` to update the dashboard.

---

### Task 4: Total Count of Outstanding Loans by State

#### Steps:
1. **Select Data:**
   - Use `State` as the dimension.
   - Use `Outstanding Count` as the measure.

2. **Create Visualization:**
   - Choose a `Bar Chart`.
   - Row Limit **10**.
   - Title: `Total Count of Outstanding Loans`.

3. **Save to Dashboard:**
   - Click `Save` to update the dashboard.

---

### Task 5: Top 10 Customers by Highest Income

#### Steps:
1. **Select Data:**
   - Dimensions: `Customer ID`, `Annual Income`, `State`, `Loan Interest Rate`.
   - Apply filter: `Owns Home Outright = True` and `Loan Status = Current`.

2. **Create Visualization:**
   - Use a `Table` visualization for easy sorting.
   - Row Limit **10**
   - Annual Income type: **Descending**
   - Title: `Top 10 Customers by Highest Income`.

3. **Save to Dashboard:**
   - Click `Save` to update the dashboard.

---

### Task 6: Enhance Dashboard Functionality

#### Steps:
1. **Enable Cross-Filtering:**
   - Edit dashboard > Click `Filters`.
   - Enable `Cross-Filtering`.

2. **Set Refresh Rates:**
   - `Total Amount of Outstanding Loans`: Refresh **hourly**.
   - `Top 10 Customers by Highest Income`: Refresh **daily**.
   - `Percentage of Outstanding Loans`: Refresh **daily**.

3. **Save Changes:**
   - Click `Save` to apply updates.

---

## 🎉 **Congratulations! Lab Completed Successfully!** 🏆  

---

## 🤝 **Join the Arcade Crew Community!**  

- **WhatsApp Group:** [Join Here](https://chat.whatsapp.com/KkNEauOhBQXHdVcmqIlv9F)  
- **YouTube Channel:** [![Subscribe to Arcade Crew](https://img.shields.io/badge/Youtube-Arcade%20Crew-red?style=for-the-badge&logo=google-cloud&logoColor=white)](https://www.youtube.com/@Arcade61432?sub_confirmation=1)  
