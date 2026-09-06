# 📊 Telecel Customer Database & SQL Analytics


> **A relational telecommunications database designed and implemented in MySQL to manage customer information, mobile subscriptions, service plans, usage activity, billing, and customer support operations.**

---

## 📌 Table of Contents

* [Project Overview](#-project-overview)
* [Business Problem](#-business-problem)
* [Project Objectives](#-project-objectives)
* [Database Architecture](#️-database-architecture)
* [Entity Relationship Diagram](#-entity-relationship-diagram)
* [Database Schema](#-database-schema)
* [Key Relationships](#-key-relationships)
* [SQL Features & Techniques](#-sql-features--techniques)
* [Data Analysis](#-data-analysis)
* [Business Use Cases](#-business-use-cases)
* [Technologies Used](#️-technologies-used)
* [Project Structure](#-project-structure)
* [How to Run the Project](#-how-to-run-the-project)
* [Skills Demonstrated](#-skills-demonstrated)
* [Future Improvements](#-future-improvements)
* [Author](#-author)

---

## 📌 Project Overview

This project involves the design and implementation of a **relational telecommunications database for Telecel** using MySQL.

The database brings together customer, subscription, plan, telecommunications usage, billing, and customer support information within a structured relational model.

The project demonstrates the complete process of developing a relational database, from **schema and table creation to data population and SQL-based analysis**.

The database contains **8 interconnected tables** designed to represent key telecommunications business processes.

---

## 💼 Business Problem

Telecommunications companies manage large volumes of customer and service data across different operational areas.

Without a structured relational database, information such as customer subscriptions, mobile usage, billing records, and support interactions can become difficult to manage and analyse.

This project addresses this challenge by creating a centralized relational database that allows different areas of customer activity to be connected through well-defined relationships.

The database provides a foundation for analysing:

* Customer information
* Mobile subscriptions
* Service plans
* Call activity
* SMS activity
* Mobile data usage
* Billing information
* Customer support interactions

---

## 🎯 Project Objectives

The project was developed to:

* Design a structured relational database for a telecommunications company.
* Create a dedicated `Telecel` database schema.
* Establish relationships between business entities.
* Implement primary and foreign keys.
* Maintain referential integrity using constraints.
* Populate the database with sample data.
* Perform SQL-based data analysis.
* Create reusable database objects including a view and stored procedure.
* Demonstrate practical SQL and relational database design skills.

---

# 🏗️ Database Architecture

The `Telecel` database consists of **8 relational tables**:

| Table             | Purpose                                         |
| ----------------- | ----------------------------------------------- |
| `Customer`        | Stores customer information and contact details |
| `Plans`           | Stores available telecommunications plans       |
| `Subscription`    | Links customers to their selected plans         |
| `CallRecord`      | Stores customer call activity                   |
| `SMSRecord`       | Stores SMS activity                             |
| `DataUsage`       | Tracks mobile data consumption                  |
| `Bill`            | Stores subscription billing information         |
| `CustomerSupport` | Records customer complaints and support tickets |

### High-Level Data Model

```text
                         ┌──────────────┐
                         │   Customer   │
                         └──────┬───────┘
                                │
                                │
                         ┌──────▼───────┐
                         │ Subscription │
                         └──────┬───────┘
                                │
              ┌─────────────────┼──────────────────┐
              │                 │                  │
              ▼                 ▼                  ▼
       ┌────────────┐    ┌────────────┐    ┌────────────┐
       │ CallRecord │    │ SMSRecord  │    │ DataUsage  │
       └────────────┘    └────────────┘    └────────────┘
                               
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
              ┌────────────┐        ┌────────────────┐
              │    Bill    │        │CustomerSupport │
              └────────────┘        └────────────────┘

                         ┌──────────────┐
                         │    Plans     │
                         └──────┬───────┘
                                │
                                ▼
                         ┌──────────────┐
                         │ Subscription │
                         └──────────────┘
```

---

# 🔗 Entity Relationship Diagram

The database can be visualized using an **EER (Enhanced Entity-Relationship) Diagram** in MySQL Workbench.

### ERD

> 📌 **Add your exported ERD image here.**

For example:

```markdown
![Telecel ERD](images/telecel-erd.png)
```

The ERD visually represents the relationships between customers, subscriptions, plans, usage records, bills, and customer support tickets.

---

# 🗃️ Database Schema

## 1. Customer

The `Customer` table stores customer identification and contact information.

**Key fields:**

* `Customer_id` — Primary Key
* `first_name`
* `last_name`
* `address`
* `city`
* `email`

The email field is uniquely constrained to prevent duplicate customer email addresses.

---

## 2. Plans

The `Plans` table stores the telecommunications plans available to customers.

**Key fields:**

* `plan_id` — Primary Key
* `plan_name`
* `data_limit`
* `sms_limit`
* `call_minutes`
* `price`

This table provides the available service options that customers can subscribe to.

---

## 3. Subscription

The `Subscription` table connects customers with their selected telecommunications plans.

**Key fields:**

* `subscription_id` — Primary Key
* `customer_id` — Foreign Key
* `phone_number`
* `plan_id` — Foreign Key
* `activation_date`
* `end_date`

The `phone_number` field is uniquely constrained.

---

## 4. CallRecord

The `CallRecord` table stores individual call activity associated with subscriptions.

**Key fields:**

* `call_id` — Primary Key
* `subscription_id` — Foreign Key
* `call_time`
* `duration`
* `destination_number`

---

## 5. SMSRecord

The `SMSRecord` table records SMS activity.

**Key fields:**

* `sms_id` — Primary Key
* `subscription_id` — Foreign Key
* `sms_time`
* `recipient_number`

---

## 6. DataUsage

The `DataUsage` table tracks mobile data consumption.

**Key fields:**

* `session_id` — Primary Key
* `subscription_id` — Foreign Key
* `session_start`
* `session_end`
* `MB_used`

---

## 7. Bill

The `Bill` table manages billing information associated with subscriptions.

**Key fields:**

* `bill_id` — Primary Key
* `subscription_id` — Foreign Key
* `billing_period`
* `amount_due`
* `bill_status`
* `issue_date`
* `due_date`

The `bill_status` field uses controlled values:

* `Paid`
* `Unpaid`

---

## 8. CustomerSupport

The `CustomerSupport` table records customer service interactions.

**Key fields:**

* `ticket_id` — Primary Key
* `subscription_id` — Foreign Key
* `customer_id` — Foreign Key
* `ticket_date`
* `complaint_type`
* `complaint_description`
* `complaint_status`
* `resolution_date`

### Complaint Types

* Billing
* Plan Change
* Network Problem

### Complaint Statuses

* Open
* In Progress
* Resolved

---

# 🔗 Key Relationships

The database uses foreign keys to connect related entities.

### Customer → Subscription

A customer can have multiple subscriptions.

```text
Customer
   1
   │
   │
   │
   N
Subscription
```

### Plans → Subscription

A telecommunications plan can be associated with multiple subscriptions.

```text
Plans
  1
  │
  │
  N
Subscription
```

### Subscription → Usage

Each subscription can have multiple:

* Call records
* SMS records
* Data usage sessions
* Bills
* Customer support tickets

```text
                 ┌── CallRecord
                 │
                 ├── SMSRecord
Subscription ────┼── DataUsage
                 │
                 ├── Bill
                 │
                 └── CustomerSupport
```

---

# 🧠 SQL Features & Techniques

This project demonstrates a range of practical SQL and database development techniques.

### Database Creation

```sql
CREATE SCHEMA IF NOT EXISTS Telecel;
USE Telecel;
```

### Primary Keys

Each major entity has a unique identifier implemented using a primary key.

### Foreign Keys

Foreign keys establish relationships between tables and maintain referential integrity.

### Constraints

The database uses:

* `PRIMARY KEY`
* `FOREIGN KEY`
* `UNIQUE`
* `NOT NULL`
* `AUTO_INCREMENT`
* `ENUM`

### Referential Actions

Foreign-key relationships use actions including:

* `CASCADE`
* `NO ACTION`

These help control how related records behave when referenced records are updated or deleted.

### Data Manipulation

The project includes data insertion and SQL queries for working with the database.

### SQL Analysis

The project also demonstrates analytical querying using techniques such as:

* `SELECT`
* Filtering
* Sorting
* Aggregation
* `GROUP BY`
* Joins
* Conditional logic
* Date-based analysis
* Subqueries

### Database View

A database **view** is included to provide reusable access to queried data.

### Stored Procedure

A **stored procedure** is also implemented, demonstrating the ability to create reusable SQL logic within the database.

---

# 📊 Data Analysis

The SQL project includes analytical queries designed to extract information from the telecommunications database.

Because the tables are connected through relational keys, information from different business areas can be analysed together.

For example, subscription information can be combined with:

* Customer details
* Plan information
* Call activity
* SMS activity
* Data usage
* Billing records
* Customer support tickets

This allows the database to serve as a foundation for operational reporting and business intelligence.

---

# 💡 Business Use Cases

The database can support several telecommunications business functions.

### 👥 Customer Management

Centralize customer information and connect customers to their subscriptions and service interactions.

### 📱 Subscription Management

Track active subscriptions, selected plans, phone numbers, and activation information.

### 📞 Call Usage Monitoring

Analyse call activity and duration at subscription level.

### 💬 SMS Monitoring

Track SMS activity and recipient information.

### 📶 Data Consumption

Monitor mobile data usage across customer subscriptions.

### 💳 Billing Management

Track:

* Amounts due
* Billing periods
* Payment status
* Issue dates
* Due dates

### 🎧 Customer Support

Monitor customer complaints, complaint types, ticket status, and resolution information.

---

# 📈 Potential Business Questions

The database structure makes it possible to investigate questions such as:

1. Which telecommunications plans have the highest number of subscriptions?
2. How much mobile data is being consumed?
3. Which subscriptions generate the most call activity?
4. Which customers have unpaid bills?
5. What are the most common customer complaint types?
6. How many customer support tickets are open or unresolved?
7. How does customer usage vary between different plans?
8. What billing patterns can be identified from subscription data?

These types of questions demonstrate how a relational database can support **data-driven decision-making**.

---

# 🛠️ Technologies Used

| Technology          | Purpose                                         |
| ------------------- | ----------------------------------------------- |
| **MySQL**           | Database development and SQL analysis           |
| **MySQL Workbench** | Database management and EER modelling           |
| **SQL**             | Data definition, manipulation and analysis      |
| **EER Diagram**     | Visual representation of database relationships |

---

# 📁 Project Structure

```text
Telecel/
│
├── Telecel.sql
├── README.md
│
└── images/
    └── telecel-erd.png
```

### `Telecel.sql`

Contains the complete SQL implementation, including:

* Schema creation
* Table creation
* Primary keys
* Foreign keys
* Constraints
* Sample data
* Analytical queries
* View
* Stored procedure

### `telecel-erd.png`

Visual representation of the database architecture generated using MySQL Workbench.

---

# 🚀 How to Run the Project

## Step 1 — Install MySQL

Install **MySQL Server** and **MySQL Workbench**.

## Step 2 — Clone the Repository

```bash
git clone https://github.com/yourusername/telecel-database.git
```

## Step 3 — Open the SQL File

Open:

```text
Telecel.sql
```

in MySQL Workbench.

## Step 4 — Execute the Script

Run the complete SQL script.

The script will create the:

```text
Telecel
```

schema and populate the database.

## Step 5 — Verify the Tables

Refresh the schemas panel in MySQL Workbench and locate:

```text
Telecel
│
└── Tables
    ├── Customer
    ├── Plans
    ├── Subscription
    ├── CallRecord
    ├── SMSRecord
    ├── DataUsage
    ├── Bill
    └── CustomerSupport
```

## Step 6 — Explore the Database

The SQL queries included in the project can then be executed to explore and analyse the data.

---

# 🧠 Skills Demonstrated

### Database & SQL

* SQL
* MySQL
* Relational Database Design
* Database Schema Design
* Database Normalization
* Primary & Foreign Keys
* Referential Integrity
* SQL Constraints
* Views
* Stored Procedures

### Data Analytics

* Data Exploration
* Data Aggregation
* SQL Joins
* Business Question Development
* Analytical Query Development
* Customer Data Analysis

### Data Modelling

* Entity Relationship Modelling
* EER Diagrams
* Relational Data Modelling
* One-to-Many Relationships

### Business Understanding

* Customer Management
* Subscription Management
* Telecommunications Usage
* Billing
* Customer Support

---

# 🔮 Future Improvements

The database could be expanded into a more comprehensive telecommunications analytics platform.

Potential improvements include:

* Adding payment transaction records.
* Adding customer churn analysis.
* Developing customer segmentation.
* Adding network/location information.
* Adding mobile device information.
* Creating automated billing workflows.
* Developing customer lifetime value analysis.
* Connecting the database to **Power BI or Tableau**.
* Connecting the database to **Python** for advanced analytics and predictive modelling.
* Building an interactive telecommunications business intelligence dashboard.

---

# ⭐ Project Highlights

| Category          | Details                                                   |
| ----------------- | --------------------------------------------------------- |
| **Industry**      | Telecommunications                                        |
| **Database**      | MySQL                                                     |
| **Schema**        | Telecel                                                   |
| **Tables**        | 8                                                         |
| **Primary Focus** | Relational Database Design & SQL Analytics                |
| **Data Areas**    | Customers, Plans, Subscriptions, Usage, Billing & Support |
| **Modelling**     | EER / Relational Data Model                               |
| **Advanced SQL**  | Views & Stored Procedures                                 |

---

# 👩🏽‍💻 Author

## Maame Birago Aninkorah

**MSc Data Analytics | Data Analytics & Business Intelligence**

This project demonstrates practical application of SQL, relational database design, data modelling, and business-focused data analysis within a telecommunications environment.

---

⭐ **If you found this project useful, feel free to explore the SQL implementation and database structure in the repository.**
