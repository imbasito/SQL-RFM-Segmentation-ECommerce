##  Project Overview
This project applies **Recency, Frequency, and Monetary (RFM)** analysis to segment customers based on their purchasing behavior using SQL.

It was performed on a real-world **UK-based e-commerce transactions dataset**, imported into MySQL and cleaned to prepare for analysis.

---

## 📊 Business Objective
To segment customers for **targeted marketing** by identifying:
- 💎 **Champions**
- 🔁 **Loyal Customers**
- 🚨 **At Risk / Lost Customers**
- ✨ **New Customers**
- 💰 **Big Spenders at Risk**

---

## 🧱 Dataset Summary
- **Source**: Kaggle E-Commerce UK Dataset
- **Link** : https://www.kaggle.com/datasets/carrie1/ecommerce-data/data
- **Records**: 500K+ transactions
- **Fields**: InvoiceNo, Product Description, Quantity, UnitPrice, CustomerID, Country, InvoiceDate

---

## 🔧 Process Summary

### 🧹 1. Data Cleaning
- Removed null and blank descriptions & customer IDs
- Removed duplicates using composite key
- Handled returns based on `InvoiceNo LIKE 'C%'`

### 🏗️ 2. Feature Engineering
- Created `edata_clean`, `edata_cancelled`, `edata_customer_type`
- Calculated RFM metrics:
  - **Recency**: Days since last purchase
  - **Frequency**: Count of unique invoices
  - **Monetary**: Total spend per customer

### 🧮 3. RFM Scoring
- Scores (1–4) assigned for each metric based on thresholds
- Joined into final table `edata_rfm_segmented`

### 🔖 4. Customer Segmentation
Applied conditional logic to tag each customer into:

| Segment             | Criteria (R, F, M)         |
|---------------------|----------------------------|
| Champions           | 4-4-4                      |
| Loyal Customers     | R≥4, F≥3, M≥3              |
| At Risk Big Spenders| R≤2, F≤2, M≥3              |
| New Customers       | R=4, F=1, M=1              |
| Lost                | 1-1-1                      |
| Others              | Everything else            |

---

## 📌 Sample Output

| CustomerID | Recency | Frequency | Monetary | Segment           |
|------------|---------|-----------|----------|--------------------|
| 12748.0    | 3       | 107       | 11773.76 | Champions          |
| 14911.0    | 1       | 80        | 49217.04 | Champions          |
| 16013.0    | 16      | 25        | 15321.32 | Loyal Customers    |
| 17850.0    | 216     | 34        | 5391.21  | Big Spenders Risk  |

---

📊 Power BI Dashboard Overview

The cleaned SQL output was imported into Power BI to create an **interactive business dashboard**.

### 📌 Page 1 – Customer Overview

- 📌 KPIs: Total Revenue, Total Customers, New vs Returning %
- 🧭 Monthly Revenue Trends
- 📊 Pie Chart: Customer Type Distribution
- 🔎 Filter by Customer Type

### 📌 Page 2 – RFM Segmentation Dashboard

- 🧮 KPI Cards: Recency, Frequency, Monetary
- 📊 Bar Chart: Segment Count
- 📈 Line Chart: Revenue per Segment by Month
- 📋 Table: Customers per Segment with drillthrough

### 📌 Page 3 – Customer Drillthrough View

- 👤 Customer Details by RFM Segment
- 📌 Cross-filtering using drillthrough
- 📊 Dynamic visuals updated based on the selected customer

---
## 📌 Sample Output

![Ecommerce_Transactions_UK_Dashboard - Light_page-0001](https://github.com/user-attachments/assets/e2dc4dce-abd9-434c-a205-8e2c41abdf4d)

---

## 📈 Tools Used
- ✅ **MySQL Workbench**
- 🗃️ CSV Import & Table Creation
- 🔍 SQL Views & Case Logic
- 📦 Exported final table for Power BI dashboard

---

## 🧠 SQL - Key Skills Demonstrated
- Data Cleaning (NULLs, Duplicates, Returns)
- SQL Feature Engineering
- Customer Segmentation via RFM
- Business Logic Implementation
- Preparation for Power BI Visualization

---
## 🧠 Power BI - Key Skills Demonstrated
- DAX Measures for KPIs
- Drillthrough & Cross-filtering
- Page navigation & conditional formatting
- Data storytelling with business context


## 🗂️ Project Structure
  📦 rfm-customer-segmentation/
├── 📂 dashboard/
├── 📂 sample data/
├── 📂 sql/
├── 📄 LICENSE
├── 📊 Lab5_Behavioral_Segmentation(RFM Analysis).csv
├── 📄 README.md
├── 📊 edata_cleaned.csv
