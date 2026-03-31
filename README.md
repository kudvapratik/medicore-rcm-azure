# MediCore RCM — Azure Data Warehousing Project

A cloud-based end-to-end data engineering project built on Microsoft Azure, implementing a **Medallion Architecture** for Healthcare Revenue Cycle Management (RCM) data.

---

## Architecture Overview

```
Data Sources → Landing → Bronze → Silver → Gold
```

| Layer    | Format        | Description                                      |
|----------|---------------|--------------------------------------------------|
| Landing  | CSV / JSON    | Raw drop zone for flat files                     |
| Bronze   | Parquet       | Raw ingested copies of all sources               |
| Silver   | Delta Tables  | Cleaned, deduplicated, conformed data            |
| Gold     | Delta Tables  | Star-schema aggregated tables for RCM reporting  |

---

## Tech Stack

| Tool                          | Purpose                            |
|-------------------------------|------------------------------------|
| Azure Data Lake Storage Gen2  | Storage for all layers             |
| Azure Data Factory (V2)       | Pipeline orchestration             |
| Azure Databricks              | Spark-based data transformation    |
| Azure SQL Database            | Source EMR systems (Hospital data) |
| Azure Key Vault               | Secrets management                 |
| Delta Lake                    | ACID transactions on data lake     |
| Apache Parquet                | Columnar storage format            |

---

## Data Sources

| Source                  | Type             | Description                                          |
|-------------------------|------------------|------------------------------------------------------|
| medicore-hospital-east  | Azure SQL DB     | EMR: patients, providers, departments, transactions, encounters |
| medicore-hospital-west  | Azure SQL DB     | Second hospital EMR with same schema                 |
| Payor / Claims Files    | CSV Flat Files   | Monthly insurance claims (landing zone)              |
| ICD Codes API           | Public REST API  | Standardised diagnosis codes (ICD-10)                |
| NPI API                 | Public REST API  | National Provider Identifier directory               |

---

## Azure Resources

| Resource Name           | Type                     | Region     |
|-------------------------|--------------------------|------------|
| medicore-rcm-rg         | Resource Group           | East US    |
| medicoreadlsdev         | Storage Account (ADLS Gen2) | East US |
| medicore-sql-dev        | SQL Server               | West US 2  |
| medicore-hospital-east  | SQL Database             | West US 2  |
| medicore-hospital-west  | SQL Database             | West US 2  |
| medicore-kv-dev         | Key Vault                | East US    |
| medicore-adf-dev        | Data Factory V2          | East US    |
| medicore-dbx-dev        | Databricks Workspace     | East US    |

---

## Repository Structure

```
medicore-rcm-azure/
├── adf/                        # Azure Data Factory ARM exports
│   ├── pipelines/              # Pipeline JSON definitions
│   ├── linkedServices/         # Linked service JSON definitions
│   ├── datasets/               # Dataset JSON definitions
│   └── triggers/               # Trigger JSON definitions
├── databricks/
│   └── notebooks/              # PySpark transformation notebooks
├── sql/
│   ├── emr_ddl_hospital_east.sql
│   └── emr_ddl_hospital_west.sql
├── config/
│   └── table_config.json       # Table mapping for ADF ForEach loops
├── docs/
│   └── project_plan.docx       # Full implementation guide
└── README.md
```

---

## ADLS Container Structure

```
medicoreadlsdev (Storage Account)
└── medicore-rcm (Container)
    ├── landing/
    │   └── claims/             # Payor CSV files drop here
    ├── bronze/
    │   ├── hospital_east/      # EMR A tables as Parquet
    │   ├── hospital_west/      # EMR B tables as Parquet
    │   ├── claims/             # Claims Parquet
    │   └── icd_codes/          # ICD API data as Parquet
    ├── silver/                 # Delta Tables (cleaned)
    ├── gold/                   # Delta Tables (aggregated)
    └── configs/                # Audit Delta table
```

## Setup Instructions

### Prerequisites
- Azure subscription (free tier works)
- Azure CLI or access to Azure Portal
- Databricks workspace with cluster
- GitHub account


*Built as a portfolio project to demonstrate Azure Data Engineering skills.*
