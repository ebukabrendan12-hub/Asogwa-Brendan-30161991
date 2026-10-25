# Portfolio 2: Query Optimisation and Transaction Management
Student: Asogwa Brendan (30161991)
Case Study: Clinic Management System

## Objective
This project focuses on improving the performance of clinic-related database queries by using indexes and explaining transaction isolation levels.

## 1. Query Optimisation

### Queries Tested
Q1: Appointments per patient
Q2: Count per doctor
Q3: Prescription lookup
Q4: Doctor search

### Before Indexing (Sequential Scan)
The initial query execution plan showed a Sequential Scan, which indicated that the database was scanning large amounts of data without efficient access paths. This resulted in a relatively high execution cost of approximately 2.185 ms.

### Screenshot: Asogwa_Brendan_30161991_P2_BEFORE_SeqScan_2.185ms.png

### After Indexing (Bitmap Index Scan)
To improve query performance, indexes were created on the most frequently queried columns. These indexes reduce the amount of data that needs to be scanned and speed up retrieval.

```sql
CREATE INDEX idx_appointment_patient ON Appointments(patient_id);
CREATE INDEX idx_appointment_doctor ON Appointments(doctor_id);
CREATE INDEX idx_prescription_patient ON Prescriptions(patient_id);