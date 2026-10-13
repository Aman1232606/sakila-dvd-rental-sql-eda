# sakila-dvd-rental-sql-eda
Exploratory Data Analysis of Sakila DVD Rental database using MySQL with documented insights.

# Sakila DVD Rental Store – SQL Exploratory Data Analysis

##  Project Overview
This project performs Exploratory Data Analysis (EDA) on the Sakila DVD Rental database using MySQL.  
The goal is to analyze customer behavior, film popularity, rental trends, and revenue generation to support business decision-making.

##  Tools & Technologies
- MySQL
- MySQL Workbench
- Sakila Sample Database

##  Dataset
- Database: Sakila DVD Rental Database
- Tables used: film, category, customer, rental, payment, inventory, staff, store

##  Analysis Performed
- Film popularity and most rented categories
- Customer behavior analysis and segmentation using CASE statements
- Rental trends by month and weekday
- Revenue analysis by category, store, and staff
- Late return analysis and estimation of potential late fee revenue loss

##  Key Insights
- Sports, Sci-Fi, and Animation are the top revenue-generating categories
- July 2005 is the peak rental month
- High-value customers contribute significantly to total revenue
- Approximately 45% of rentals are returned late, with an estimated late fee loss of $58,640

##  Files in this Repository
- `01skila.sql` – Contains all SQL queries with section-wise comments and insights
- `README.md` – Project description and summary

##  How to Run
1. Load the Sakila schema and data into MySQL
2. Open `01skila.sql` in MySQL Workbench
3. Run queries section by section


