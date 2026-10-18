Clinic Management System Database Design Normalisation

Normalisation separates information into related tables to reduce repeated details and avoid inconsistent updates. Two fictional patients are used below to illustrate the process. Names, phone numbers, and medical details are fictional. Dates and times are shortened for readability.

Starting unnormalised list
A single unnormalised table tracks clinic visits, combining patient details, doctor details, and multiple prescriptions inside a single cell.

| patient_id | full_name | phone | staff_id | doctor_name | department | consultation_id | diagnosis | prescriptions |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Alice Brown | 555-0100 | 10 | Dr. Adams | Cardiology | 501 | Hypertension | Amoxicillin 500mg daily 7 days; Lisinopril 10mg daily 30 days |
| 2 | Bob Chen | 555-0200 | 12 | Dr. Vance | Pediatrics | 502 | Bronchitis | Azithromycin 250mg daily 5 days |

The first row contains multiple prescriptions in one cell. Finding a specific medication, updating a patient phone number, or recording returns is awkward and risks data errors.

1NF: One value per cell
First Normal Form (1NF) requires that every table cell contains a single, atomic value (no lists or repeating groups). Each prescription gets its own row, removing the repeated list.

| patient_id | full_name | phone | staff_id | doctor_name | department | consultation_id | diagnosis | medication_name | dosage | frequency | duration |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Alice Brown | 555-0100 | 10 | Dr. Adams | Cardiology | 501 | Hypertension | Amoxicillin | 500mg | daily | 7 days |
| 1 | Alice Brown | 555-0100 | 10 | Dr. Adams | Cardiology | 501 | Hypertension | Lisinopril | 10mg | daily | 30 days |
| 2 | Bob Chen | 555-0200 | 12 | Dr. Vance | Pediatrics | 502 | Bronchitis | Azithromycin | 250mg | daily | 5 days |

For this unnormalised stage, a combined key of `(consultation_id, medication_name)` identifies each row. 

The rows are now in 1NF, but patient details (`full_name`, `phone`) and doctor details (`doctor_name`, `department`) repeat across multiple rows. If Alice changes her phone number, it must be updated in multiple places.

2NF: Details depend on the whole key
Second Normal Form (2NF) includes 1NF and requires that all non-key fields depend on the *entire* primary key, not just part of it (partial dependency). 

In the 1NF table, assuming the combined key is `(consultation_id, medication_name)`:
- `full_name` and `phone` depend only on `patient_id`, which is only part of the key.
- `doctor_name` and `department` depend only on `staff_id`, which is also only part of the key.

To remove partial dependencies, patient details and doctor details move into separate tables where their respective IDs serve as the primary keys.

Patient table
Key: `patient_id`.

| patient_id | full_name | phone |
| --- | --- | --- |
| 1 | Alice Brown | 555-0100 |
| 2 | Bob Chen | 555-0200 |

Doctor table
Key: `staff_id`.

| staff_id | full_name | department |
| --- | --- | --- |
| 10 | Dr. Adams | Cardiology |
| 12 | Dr. Vance | Pediatrics |

Consultation and prescription details
Key: `(consultation_id, medication_name)`. `patient_id` and `staff_id` now act as foreign keys linking back to the Patient and Doctor tables.

| consultation_id | patient_id | staff_id | diagnosis | medication_name | dosage | frequency | duration |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 501 | 1 | 10 | Hypertension | Amoxicillin | 500mg | daily | 7 days |
| 501 | 1 | 10 | Hypertension | Lisinopril | 10mg | daily | 30 days |
| 502 | 2 | 12 | Bronchitis | Azithromycin | 250mg | daily | 5 days |

Patient and doctor details no longer repeat for every prescription row. However, consultation diagnosis still repeats for multiple prescriptions under the same consultation ID.

3NF: Keep details with the thing they describe
Third Normal Form (3NF) includes 2NF and removes transitive dependencies, where a non-key field depends on another non-key field rather than directly on the key. 

In the previous table, `diagnosis` describes the consultation (`consultation_id`), not the specific medication line item. Separating consultation records from prescription records ensures consultation details are stored once.

Patient
Key: `patient_id`.

| patient_id | full_name | phone |
| --- | --- | --- |
| 1 | Alice Brown | 555-0100 |
| 2 | Bob Chen | 555-0200 |

Doctor
Key: `staff_id`.

| staff_id | full_name | department |
| --- | --- | --- |
| 10 | Dr. Adams | Cardiology |
| 12 | Dr. Vance | Pediatrics |

Consultation
Key: `consultation_id`. Links to Appointment via foreign key.

| consultation_id | appointment_id | diagnosis |
| --- | --- | --- |
| 501 | 301 | Hypertension |
| 502 | 302 | Bronchitis |

Prescription
Key: `prescription_id`. `consultation_id` is a foreign key to Consultation. Adding an auto-generated ID (`prescription_id`) replaces the combined key `(consultation_id, medication_name)`.

| prescription_id | consultation_id | medication_name | dosage | frequency | duration |
| --- | --- | --- | --- | --- | --- |
| 901 | 501 | Amoxicillin | 500mg | daily | 7 days |
| 902 | 501 | Lisinopril | 10mg | daily | 30 days |
| 903 | 502 | Azithromycin | 250mg | daily | 5 days |

Summary of Final Structure
The final design uses surrogate primary keys (such as `patient_id`, `staff_id`, `consultation_id`, and `prescription_id`) to uniquely identify records and maintain relationships through foreign keys. 

Fields left out of these simplified example tables for readability include `date_of_birth` and `address` in `Patient`, `is_active` in `Doctor`, `appointment_time`, `created_at`, and `status` in `Appointment`, and `medical_notes` in `Consultation`. 

Normalisation removes redundant data and update anomalies, but structural keys alone do not enforce all business rules. Unique constraints, date checks, active doctor checks, and completed appointment status logic remain necessary alongside the normalised tables.