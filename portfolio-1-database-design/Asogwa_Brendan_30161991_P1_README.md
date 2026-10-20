# Asogwa Brendan 30161991 - Portfolio 1: Clinic Management System

## Design and implementation files

| File | Contents |
| --- | --- |
| Asogwa_Brendan_30161991_P1_Design.md | Entities, attributes, keys and relationships for clinic |
| Asogwa_Brendan_30161991_P1_ERDiagram.md | Five tables and relationships: patient, doctor, appointment, consultation, prescription |
| Asogwa_Brendan_30161991_P1_Schema.sql | Table definitions, keys and constraints |
| Asogwa_Brendan_30161991_P1_SampleData.sql | Fictional data: 3 patients, 2 doctors, 3 appointments, 1 consultation, 1 prescription |
| Asogwa_Brendan_30161991_P1_ConstraintTests.sql | Invalid inserts and final count query |
| Screenshots PNGs | Evidence_count_before, Evidence_count_after_valid, Evidence_constraint_tests |

## Implementation

The database runs on PostgreSQL in GitHub Codespaces. Its name is clinic_portfolio. It contains patient, doctor, appointment, consultation and prescription.

Patient phones and doctor emails are unique. NOT NULL ensures full_name. Foreign keys link appointment to patient/doctor, consultation to appointment, prescription to consultation. Check constraint chk_appointment_time rejects invalid times. Unique index uq_appointment_doctor_time on (staff_id, appointment_time) prevents double-booking a doctor.

## Test results

Five invalid inserts were rejected: missing full_name, repeated phone 555-0100, nonexistent patient link 99999, invalid appointment time, duplicate doctor booking 1 at 2026-11-01 10:00:00.

Final counts are 3 patients, 2 doctors, 3 appointments, 1 consultation and 1 prescription. Failed inserts added 0 rows. Verified by count query.

Workflow logic needs transaction testing in Portfolio 2 and 3.