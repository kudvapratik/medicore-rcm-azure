# Databricks notebook source
# MAGIC %md
# MAGIC # 00 - Mount ADLS Gen2 to Databricks
# MAGIC Mounts the medicore-rcm container from ADLS Gen2 to /mnt/medicore
# MAGIC Run this notebook ONCE before any other notebook.

# COMMAND ----------

# Check if already mounted - unmount first if re-running
existing_mounts = [m.mountPoint for m in dbutils.fs.mounts()]
if "/mnt/medicore" in existing_mounts:
    dbutils.fs.unmount("/mnt/medicore")
    print("Unmounted existing /mnt/medicore")

# COMMAND ----------

# Retrieve storage account key from Key Vault via secret scope
storage_account_key = dbutils.secrets.get(
    scope="medicore-kv-scope",
    key="adls-storage-account-key"
)

configs = {
    "fs.azure.account.key.medicoreadlsdev.dfs.core.windows.net": storage_account_key
}

# Mount the container
dbutils.fs.mount(
    source="abfss://medicore-rcm@medicoreadlsdev.dfs.core.windows.net/",
    mount_point="/mnt/medicore",
    extra_configs=configs
)

print("Mount successful!")

# COMMAND ----------

# Verify mount - list all top-level folders
print("Folders in /mnt/medicore:")
display(dbutils.fs.ls("/mnt/medicore"))
