# Superstore Sales Intelligence Analysis

Python · PostgreSQL · SQL · Tableau · Scikit-learn

This project analyzes the Superstore retail dataset to understand what drives revenue, profit, and product returns. The goal was to turn a flat sales file into something more structured and useful for business analysis, then use that structure to identify trends in performance, margins, customer segments, and return risk.

The project includes:
- ETL in Python to normalize the raw Excel data into relational tables
- SQL analysis for revenue, profit, geography, customer segments, and returns
- Python-based exploratory analysis and visualizations
- A return prediction model using Random Forest and SMOTE
- A Tableau dashboard for interactive viewing

[View Interactive Dashboard](https://public.tableau.com/app/profile/rowan.eissa/viz/Book2_17810475894640/Dashboard1)

---

## Project Overview

The Superstore dataset contains four years of retail order data. I used it to answer a few practical business questions:

- Which product categories generate the most revenue and profit?
- Is the business growing year over year?
- Which customer segment is the most valuable?
- Which products or categories have the highest return rates?
- What factors are most associated with returned orders?

I approached the project as a junior data analyst would: clean the data, organize it into usable tables, analyze the business questions, and summarize the findings in a way that can support decision-making.

---

## Business Problem

Retail businesses often focus on sales volume without paying enough attention to profitability and returns. In this dataset, some categories generate strong revenue but weak profit margins, and some orders are more likely to be returned than others.

The main business challenge was to identify where revenue is strong, where profit is being lost, and where the business should pay closer attention to discounts, product mix, and return patterns.

---

## Project Objectives

- Organize the raw Superstore data into a relational structure
- Explore sales, profit, and return patterns
- Identify the strongest and weakest product categories
- Compare performance across customer segments
- Review year-over-year business trends
- Build a simple model to estimate return risk
- Present the findings in a clear, recruiter-friendly format

---

## Dataset Description

This project uses the **Sample Superstore** dataset, which includes:

- Orders
- Returns
- People

Key fields used in the analysis include:

- Order ID
- Order Date
- Ship Date
- Ship Mode
- Customer ID
- Customer Name
- Segment
- Country
- City
- State
- Region
- Postal Code
- Product ID
- Category
- Sub-Category
- Product Name
- Sales
- Quantity
- Discount
- Profit

The raw dataset is flattened, so I normalized it into separate tables during ETL to make the analysis easier to manage.

---

## Tools & Technologies Used

- **Python**
- **Pandas**
- **Matplotlib**
- **Seaborn**
- **PostgreSQL**
- **SQL**
- **SQLAlchemy**
- **Scikit-learn**
- **imbalanced-learn**
- **Tableau**

---

## ETL Process

I used Python to read the Superstore Excel workbook, normalize the raw data into relational tables, and load the results into PostgreSQL.

To make the project portable and GitHub-friendly, the ETL script uses:

* **Relative file paths** with `pathlib` instead of machine-specific paths
* **Environment variables** for the database connection instead of hardcoded credentials
* A `.env` file for local configuration and a `.env.example` template for other users

### Tables created

* `products`
* `customers`
* `geography`
* `orders`
* `order_items`
* `returns`
* `people`

### What the ETL did

* Loaded the raw Excel workbook from the `data/raw` directory
* Selected the relevant columns
* Removed duplicate records where needed
* Split the dataset into relational tables
* Loaded the tables into PostgreSQL using SQLAlchemy

This approach keeps the project portable across different machines and avoids exposing sensitive database credentials in the source code.


---

## Analysis Process

The analysis was done in Python and SQL.

### Python notebook
In `analysis.ipynb`, I:
- Loaded the dataset
- Built summary tables
- Created charts for category performance, yearly trends, segment analysis, returns, and top products
- Built a return prediction model

### SQL file
In `superstore_analysis.sql`, I wrote queries to examine:
- Sales by category and sub-category
- Profit by category
- Top products by revenue
- Geographic performance
- Year-over-year trends
- Revenue by customer segment
- Return rates by category

---

## Dashboard / Visualization Highlights

The Tableau dashboard was used to present the analysis visually and make the results easier to review.

Key visual themes included:
- Sales and profit by category
- Year-over-year growth
- Revenue by segment
- Return rate by category
- Top products by revenue

[Open the Tableau Dashboard](https://public.tableau.com/app/profile/rowan.eissa/viz/Book2_17810475894640/Dashboard1)

---

## Key Insights

- **Technology** generated the highest revenue and was also the most profitable category.
- **Furniture** had strong revenue but very weak profit, which suggests margin pressure.
- **Consumer** was the largest customer segment by revenue.
- **Office Supplies** had the highest return rate by category.
- Revenue increased over the four-year period, but profit grew more slowly.
- Sales, profit, and discount were the strongest signals in the return prediction model.

---

## Business Recommendations

- Review discounting in **Furniture**, especially where high revenue is not translating into meaningful profit.
- Investigate **Office Supplies** return patterns to see whether product quality, expectations, or descriptions are contributing.
- Prioritize **Consumer** as the main revenue-driving segment, while still testing growth opportunities in the smaller segments.
- Flag orders with **high discounts and low profit margins** for additional review before shipping.
- Focus on improving profit margin, not just sales growth.

---
## Setup

### Database Configuration

This project uses environment variables for the PostgreSQL connection.

Create a `.env` file in the project root:

```env
DB_URL=postgresql://username:password@localhost:5432/superstore
```

An example template is provided in `.env.example`.

### Install Dependencies

```bash
pip install -r requirements.txt
```

### Run the ETL Pipeline

```bash
python scripts/etl.py
```

The ETL script automatically loads the Excel file from the `data/raw` directory using relative paths, making the project portable across different environments.


## Repository Structure

```text
superstore-sales-intelligence/
├── data/
│   ├── raw/
│   └── processed/
├── notebooks/
│   └── analysis.ipynb
├── scripts/
│   └── etl.py
├── sql/
│   └── superstore_analysis.sql
├── visuals/
│   ├── dashboard/
│   └── charts/
├── README.md
├── requirements.txt
└── .gitignore
