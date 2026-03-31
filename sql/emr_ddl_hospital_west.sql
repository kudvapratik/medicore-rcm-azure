-- ============================================================
-- MediCore RCM - EMR DDL Script
-- Database: medicore-hospital-west
-- Run this script in Azure SQL Query Editor or SSMS
-- Identical schema to hospital-east (two separate hospital systems)
-- ============================================================

-- Patients table
CREATE TABLE dbo.patients (
    patient_id        VARCHAR(50)  NOT NULL PRIMARY KEY,
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    dob               DATE,
    gender            VARCHAR(10),
    address           VARCHAR(255),
    city              VARCHAR(100),
    state             VARCHAR(50),
    zip_code          VARCHAR(20),
    phone             VARCHAR(20),
    email             VARCHAR(150),
    insurance_type    VARCHAR(50),
    insurance_id      VARCHAR(100),
    created_date      DATETIME     DEFAULT GETDATE(),
    modified_date     DATETIME     DEFAULT GETDATE()
);

-- Providers table
CREATE TABLE dbo.providers (
    provider_id       VARCHAR(50)  NOT NULL PRIMARY KEY,
    npi               VARCHAR(20),
    first_name        VARCHAR(100),
    last_name         VARCHAR(100),
    specialty         VARCHAR(100),
    department_id     VARCHAR(50),
    phone             VARCHAR(20),
    email             VARCHAR(150),
    created_date      DATETIME     DEFAULT GETDATE(),
    modified_date     DATETIME     DEFAULT GETDATE()
);

-- Departments table
CREATE TABLE dbo.departments (
    department_id     VARCHAR(50)  NOT NULL PRIMARY KEY,
    department_name   VARCHAR(100),
    department_code   VARCHAR(20),
    location          VARCHAR(100),
    created_date      DATETIME     DEFAULT GETDATE(),
    modified_date     DATETIME     DEFAULT GETDATE()
);

-- Encounters table
CREATE TABLE dbo.encounter (
    encounter_id      VARCHAR(50)  NOT NULL PRIMARY KEY,
    patient_id        VARCHAR(50),
    provider_id       VARCHAR(50),
    department_id     VARCHAR(50),
    encounter_date    DATE,
    encounter_type    VARCHAR(50),
    admission_date    DATE,
    discharge_date    DATE,
    icd_code          VARCHAR(20),
    diagnosis         VARCHAR(255),
    created_date      DATETIME     DEFAULT GETDATE(),
    modified_date     DATETIME     DEFAULT GETDATE(),
    FOREIGN KEY (patient_id)    REFERENCES dbo.patients(patient_id),
    FOREIGN KEY (provider_id)   REFERENCES dbo.providers(provider_id),
    FOREIGN KEY (department_id) REFERENCES dbo.departments(department_id)
);

-- Transactions table
CREATE TABLE dbo.transactions (
    transaction_id    VARCHAR(50)  NOT NULL PRIMARY KEY,
    encounter_id      VARCHAR(50),
    patient_id        VARCHAR(50),
    transaction_date  DATE,
    transaction_type  VARCHAR(50),
    amount            DECIMAL(10,2),
    payment_method    VARCHAR(50),
    status            VARCHAR(30),
    payor_id          VARCHAR(50),
    created_date      DATETIME     DEFAULT GETDATE(),
    modified_date     DATETIME     DEFAULT GETDATE(),
    FOREIGN KEY (encounter_id) REFERENCES dbo.encounter(encounter_id),
    FOREIGN KEY (patient_id)   REFERENCES dbo.patients(patient_id)
);

-- ============================================================
-- Verify tables were created
-- ============================================================
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
