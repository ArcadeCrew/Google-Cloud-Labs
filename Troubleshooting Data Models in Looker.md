<h1 align="center">
✨  Troubleshooting Data Models in Looker || GSP1019 ✨
</h1>

<div align="center">
  <a href="https://www.cloudskillsboost.google/focuses/33371?parent=catalog" target="_blank" rel="noopener noreferrer">
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

## ⚙️ <ins>Lab Environment Setup</ins>

* Remember to Turn ON Developer Mode.

> ✅ **NOTE:** *Watch Full Video to get Full Scores on Check My Progress.*

### 1. Create View Named **`user_order_lifetime`** and add the following LookML code:

```lookml
view: user_order_lifetime {
  derived_table: {
    sql: SELECT
        order_items.user_id as user_id
         ,COUNT(*) as lifetime_orders
         ,SUM(order_items.sale_price) as lifetime_sales
      FROM cloud-training-demos.looker_ecomm.order_items
      GROUP BY user_id

      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: lifetime_sales {
    type: number
    sql: ${TABLE}.lifetime_sales ;;
  }

  set: detail {
    fields: [user_id, lifetime_orders, lifetime_sales]
  }
}
```

### 2. Update **`users.view`**
```lookml
view: users {
  sql_table_name: `cloud-training-demos.looker_ecomm.users`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: average_sales {
    type: number
    sql: ${user_order_lifetime.lifetime_sales} / ${user_order_lifetime.lifetime_orders} ;;
    value_format_name: usd
  }
  
  dimension: average_order_price  {
    type: number
    sql: ${user_order_lifetime.lifetime_sales} / ${user_order_lifetime.lifetime_orders} ;;
    value_format_name: usd
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }
}
```

### 3. Update **`training_ecommerce.model`**
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
  
  query: LOL {
    dimensions: [users.age, users.average_sales, users.country, users.id, users.state]
  }
  join: user_order_lifetime {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_lifetime.user_id} ;;
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
  join: order_items {
    type: left_outer
    sql_on: ${events.user_id} = ${order_items.user_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  
  join: user_order_lifetime {
    type: left_outer
    sql_on: ${order_items.user_id} = ${user_order_lifetime.user_id} ;;
    relationship: many_to_one
  }
  
}
```
* Save **Task 3** Look as **`Top 10 Users With Highest Average Sales`**
```
Top 10 Users With Highest Average Sales
```

## NOW FOLLOW VIDEO STEPS

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
    <em>Last updated: May 2025</em>
  </p>
</div>
