# 🚦 Traffic Management System (SQL Project)

## 📌 Overview

This project is a Traffic Management Database System built using SQL. It is designed to store, manage, and analyze data related to vehicles, drivers, violations, and fines. The system helps authorities monitor traffic violations, identify repeat offenders, and improve overall road safety.

---

## 🎯 Objectives

* Maintain structured records of vehicles and drivers
* Track traffic violations and fines
* Analyze data to identify patterns and trends
* Support decision-making for traffic police and government

---

## 🗂️ Database Structure

### 🔹 Tables Included

* vehicle – Stores vehicle details
* driver – Stores driver information
* violation – Records violations linked to drivers
* (Add more if present in your SQL file)

---

## 🧱 Database Schema

The database follows a relational model with proper primary and foreign key relationships.

* Each driver is uniquely identified by `license_no`
* Violations are linked to drivers using `license_no`
* Vehicles are identified by `reg_no`

---

## ⚙️ Technologies Used

* SQL (MySQL / PostgreSQL compatible)
* Database design using ER diagrams
* CSV (optional for data import)

---

## 📊 Key Features

* Retrieve total fines per driver
* Rank drivers based on violations
* Identify top offenders
* Analyze unpaid fines and compliance levels
* Generate reports for authorities

---

## 📈 Sample Query

```sql
SELECT d.driver_name,
       SUM(v.fine_amount) AS total_fine,
       RANK() OVER (ORDER BY SUM(v.fine_amount) DESC) AS rank_no
FROM driver d
JOIN violation v
ON d.license_no = v.license_no
GROUP BY d.driver_name;
```

👉 This query identifies top offenders based on total fines collected.

---

## 💡 Insights (Example)

* Some drivers consistently appear at the top → repeat offenders
* High number of unpaid fines → poor compliance
* Certain areas or vehicle types may show higher violation rates

---

## 🏗️ Setup Instructions

1. Clone the repository

```bash
git clone https://github.com/your-username/traffic-management-db.git
```

2. Open your SQL environment (MySQL Workbench / pgAdmin)

3. Run the SQL script:

```sql
SOURCE traffic_management_db.sql;
```

4. Start executing queries and analysis

---

## 📎 ER Diagram

(Attach your ER diagram image here if exporting from .mwb file)

---

## 🚀 Future Improvements

* Integrate with real-time traffic data
* Add dashboard using Power BI / Tableau
* Build API layer for application use
* Predict accident-prone zones using ML

---

## 👥 Target Users

* Traffic Police
* Government Authorities
* Data Analysts

---

## 📢 Recommendations

* Enforce stricter fine collection mechanisms
* Monitor repeat offenders closely
* Increase awareness for traffic compliance
* Use data-driven policies for road safety

---

## 📜 License

This project is for educational purposes.

---

## ✍️ Author

Shravani Kulkarni

