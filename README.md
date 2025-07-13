# RFM Customer Segmentation using SQL (E-Commerce Dataset)

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

## 📈 Tools Used
- ✅ **MySQL Workbench**
- 🗃️ CSV Import & Table Creation
- 🔍 SQL Views & Case Logic
- 📦 Exported final table for Power BI dashboard

---

## 🧠 Key Skills Demonstrated
- Data Cleaning (NULLs, Duplicates, Returns)
- SQL Feature Engineering
- Customer Segmentation via RFM
- Business Logic Implementation
- Preparation for Power BI Visualization

---

## 📤 Next Steps
This dataset is now ready for:
- 🎨 Power BI dashboard visualizing RFM segments
- 📈 Targeted marketing strategy simulation
