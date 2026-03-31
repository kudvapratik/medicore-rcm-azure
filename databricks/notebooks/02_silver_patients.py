# Databricks notebook source
# MAGIC %md
# MAGIC # 02 - Silver: Patients
# MAGIC Reads Bronze Parquet from both hospitals, deduplicates,
# MAGIC standardises, and writes a unified Silver Delta table.

# COMMAND ----------

from pyspark.sql.functions import (
    col, to_date, current_timestamp, lit, sha2, concat_ws, coalesce
)
from delta.tables import DeltaTable

BRONZE_EAST = "/mnt/medicore/bronze/hospital_east/patients/"
BRONZE_WEST = "/mnt/medicore/bronze/hospital_west/patients/"
SILVER_PATH = "/mnt/medicore/silver/patients/"

# COMMAND ----------

# Read from both bronze sources
df_east = spark.read.parquet(BRONZE_EAST).withColumn("source_system", lit("hospital_east"))
df_west = spark.read.parquet(BRONZE_WEST).withColumn("source_system", lit("hospital_west"))

# Union both hospitals
df_all = df_east.unionByName(df_west, allowMissingColumns=True)

# COMMAND ----------

# Standardise and clean
df_clean = (
    df_all
    .withColumn("dob", to_date(col("dob"), "yyyy-MM-dd"))
    .withColumn("ingestion_date", current_timestamp())
    .withColumn("record_hash", sha2(concat_ws("|", col("patient_id"), col("dob"), col("gender")), 256))
    .dropDuplicates(["patient_id"])
    .filter(col("patient_id").isNotNull())
)

print(f"Total silver patients: {df_clean.count()}")

# COMMAND ----------

# Write as Delta (MERGE on re-runs to avoid duplicates)
if DeltaTable.isDeltaTable(spark, SILVER_PATH):
    delta_table = DeltaTable.forPath(spark, SILVER_PATH)
    delta_table.alias("target").merge(
        df_clean.alias("source"),
        "target.patient_id = source.patient_id"
    ).whenMatchedUpdateAll() \
     .whenNotMatchedInsertAll() \
     .execute()
    print("MERGE complete")
else:
    df_clean.write.format("delta").mode("overwrite").save(SILVER_PATH)
    print("Initial write complete")

# COMMAND ----------

# Verify
display(spark.read.format("delta").load(SILVER_PATH).limit(10))
