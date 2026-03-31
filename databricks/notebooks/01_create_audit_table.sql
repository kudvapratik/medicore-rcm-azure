# Databricks notebook source
# MAGIC %md
# MAGIC # 01 - Create Audit / Load Log Table
# MAGIC Creates the audit schema and load_logs Delta table.
# MAGIC This table tracks every ADF pipeline run.
# MAGIC Run ONCE during initial setup.

# COMMAND ----------

# MAGIC %sql
CREATE SCHEMA IF NOT EXISTS audit;

# COMMAND ----------

# MAGIC %sql
CREATE TABLE IF NOT EXISTS audit.load_logs (
    id                  BIGINT GENERATED ALWAYS AS IDENTITY,
    data_source         STRING,
    tablename           STRING,
    numberofrowscopied  INT,
    watermarkcolumnname STRING,
    loaddate            TIMESTAMP
)
USING DELTA
LOCATION '/mnt/medicore/configs/audit_load_logs';

# COMMAND ----------

# MAGIC %sql
-- Verify table was created
DESCRIBE TABLE audit.load_logs;

# COMMAND ----------

# MAGIC %sql
-- Check it is empty and ready
SELECT * FROM audit.load_logs;
