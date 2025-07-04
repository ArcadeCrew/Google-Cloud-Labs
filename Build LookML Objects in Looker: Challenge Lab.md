<h1 align="center">
✨  Build LookML Objects in Looker: Challenge Lab || GSP361 ✨
</h1>

<div align="center">
  <a href="https://www.cloudskillsboost.google/focuses/25703?parent=catalog" target="_blank" rel="noopener noreferrer">
    <img src="https://img.shields.io/badge/Open_Lab-Cloud_Skills_Boost-4285F4?style=for-the-badge&logo=google&logoColor=white&labelColor=34A853" alt="Open Lab Badge">
  </a>
</div>

---

## ⚠️ Disclaimer ⚠️

<blockquote style="background-color: #fffbea; border-left: 6px solid #f7c948; padding: 1em; font-size: 15px; line-height: 1.5;">
  <strong>Educational Purpose Only:</strong> This script and guide are intended <em>solely for educational purposes</em> to help you understand Google Cloud monitoring services and advance your cloud skills. Before using, please review it carefully to become familiar with the services involved.
  <br><br>
  <strong>Terms Compliance:</strong> Always ensure compliance with Qwiklabs' terms of service and YouTube's community guidelines. The aim is to enhance your learning experience—<em>not</em> to circumvent it.
</blockquote>

---

## ⚙️ **Lab Environment Configuration**

> 💡 **Tip:** *Ensure you watch the complete video guide to achieve full scores on the "Check My Progress" steps.*

1.  **Define the `order_items_challenge` View:**
  *   Initiate a new LookML view file and name it `order_items_challenge`.
  *   Populate this file with the following LookML code:

  ```lookml
  view: order_items_challenge {
    sql_table_name: `cloud-training-demos.looker_ecomm.order_items`  ;;
    drill_fields: [order_item_id]
    dimension: order_item_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    }

    dimension: is_search_source {
    type: yesno
    sql: ${users.traffic_source} = "Search" ;;
    }


    measure: sales_from_complete_search_users {
    type: sum
    sql: ${TABLE}.sale_price ;;
    filters: [is_search_source: "Yes", order_items.status: "Complete"]
    }


    measure: total_gross_margin {
    type: sum
    sql: ${TABLE}.sale_price - ${inventory_items.cost} ;;
    }


    dimension: return_days {
    type: number
    sql: DATE_DIFF(${order_items.delivered_date}, ${order_items.returned_date}, DAY);;
    }
    dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
    }

  }
  ```

2.  **Establish the `user_details` View:**
  *   Create a second LookML view file, naming it `user_details`.
  *   Insert the LookML code provided below into this new file:

  ```lookml
  # If necessary, uncomment the line below to include explore_source.
  # include: "training_ecommerce.model.lkml"

  view: user_details {
    derived_table: {
    explore_source: order_items {
      column: order_id {}
      column: user_id {}
      column: total_revenue {}
      column: age { field: users.age }
      column: city { field: users.city }
      column: state { field: users.state }
    }
    }
    dimension: order_id {
    description: ""
    type: number
    }
    dimension: user_id {
    description: ""
    type: number
    }
    dimension: total_revenue {
    description: ""
    value_format: "$#,##0.00"
    type: number
    }
    dimension: age {
    description: ""
    type: number
    }
    dimension: city {
    description: ""
    }
    dimension: state {
    description: ""
    }
  }
  ```

3.  **Configure the `training_ecommerce` Model (Filters & Joins):**
  *   Open the `training_ecommerce.model.lkml` model file for editing.
  *   Add the following LookML block to the model definition.
  *   Within this added code, locate the `sql_always_where` parameter and substitute `VALUE_1` with the price specified in `Filter #1`.
  *   Next, find the `sql_always_having` parameter and replace `VALUE_2` with the price indicated in `Filter #3`.

  ```lookml
  connection: "bigquery_public_data_looker"

  # include all the views
  include: "/views/*.view"
  include: "/z_tests/*.lkml"
  include: "/**/*.dashboard"

  datagroup: training_ecommerce_default_datagroup {
    # sql_trigger: SELECT MAX(id) FROM etl_log;;
    max_cache_age: "1 hour"
  }

  persist_with: training_ecommerce_default_datagroup

  label: "E-Commerce Training"

  explore: order_items {



    sql_always_where: ${sale_price} >= VALUE_1 ;;


    conditionally_filter: {

    filters: [order_items.shipped_date: "2018"]

    unless: [order_items.status, order_items.delivered_date]

    }


    sql_always_having: ${average_sale_price} > VALUE_2 ;;

    always_filter: {
    filters: [order_items.status: "Shipped", users.state: "California", users.traffic_source:
      "Search"]
    }



    join: user_details {

    type: left_outer

    sql_on: ${order_items.user_id} = ${user_details.user_id} ;;

    relationship: many_to_one

    }


    join: order_items_challenge {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_items_challenge.order_id} ;;
    relationship: many_to_one
    }

    join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    }



    join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    }

    join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
    }

    join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
    }
  }

  explore: events {
    join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
    }
    join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
    }
    join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
    }
  }
  ```

4.  **Configure the `training_ecommerce` Model (Datagroup):**
  *   Continue editing the `training_ecommerce.model.lkml` file.
  *   Incorporate the LookML code block shown below into the model.
  *   Inside the `datagroup: order_items_challenge_datagroup` definition within this block, find the `max_cache_age` parameter.
  *   Replace the placeholder `NUM` with the numerical hour value specified in the instructions for `TASK 4`.

  ```lookml
  connection: "bigquery_public_data_looker"

  # include all the views
  include: "/views/*.view"
  include: "/z_tests/*.lkml"
  include: "/**/*.dashboard"

  datagroup: order_items_challenge_datagroup {
    sql_trigger: SELECT MAX(order_item_id) from order_items ;;
    max_cache_age: "NUM hours"
  }


  persist_with: order_items_challenge_datagroup


  label: "E-Commerce Training"

  explore: order_items {
    join: user_details {

    type: left_outer

    sql_on: ${order_items.user_id} = ${user_details.user_id} ;;

    relationship: many_to_one

    }


    join: order_items_challenge {
    type: left_outer
    sql_on: ${order_items.order_id} = ${order_items_challenge.order_id} ;;
    relationship: many_to_one
    }

    join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
    }



    join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
    }

    join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
    }

    join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
    }
  }

  explore: events {
    join: event_session_facts {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
    relationship: many_to_one
    }
    join: event_session_funnel {
    type: left_outer
    sql_on: ${events.session_id} = ${event_session_funnel.session_id} ;;
    relationship: many_to_one
    }
    join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
    }
  }
  ```

> ⏳ **Important:** After completing the steps for `TASK 4`, wait for `4 to 5 minutes` to get score.

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
    <em>Last updated: April 2025</em>
  </p>
</div>
