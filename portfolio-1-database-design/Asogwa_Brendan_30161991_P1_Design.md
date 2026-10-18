# Clinic Management System Database Design

## 1. Entities — What the Database Keeps Records Of

The database contains five entities (tables):

1. **Patient:** Stores patient identification and contact details.
2. **Doctor:** Stores doctor details, staff identification, and department.
3. **Appointment:** Records scheduled visits, including the patient, doctor, date, time, and status.
4. **Consultation:** Stores medical notes and diagnoses from completed appointments.
5. **Prescription:** Records medications prescribed during consultations, including dosage and duration.

These five entities support patient registration, doctor profiles, appointment scheduling, consultation records, prescriptions, and medical history.

## 2. Attributes and Keys

PK means Primary Key, a unique identifier for each record. FK means Foreign Key, which links a record to another table. `NOT NULL` means a value is required, while `UNIQUE` prevents duplicate values.

| Entity | Attributes and PostgreSQL Types |
|---|---|
| **Patient** | `patient_id` — INTEGER, PK, required; `full_name` — VARCHAR(100), required; `phone` — VARCHAR(20), UNIQUE, required; `date_of_birth` — DATE, optional; `address` — TEXT, optional. |
| **Doctor** | `staff_id` — INTEGER, PK, required; `full_name` — VARCHAR(100), required; `department` — VARCHAR(80), required; `is_active` — BOOLEAN, required, default TRUE. |
| **Appointment** | `appointment_id` — INTEGER, PK, required; `patient_id` — INTEGER, FK to Patient, required; `staff_id` — INTEGER, FK to Doctor, required; `appointment_time` — TIMESTAMP, required; `created_at` — TIMESTAMP, required; `status` — VARCHAR(20), required. |
| **Consultation** | `consultation_id` — INTEGER, PK, required; `appointment_id` — INTEGER, UNIQUE FK to Appointment, required; `diagnosis` — TEXT, required; `medical_notes` — TEXT, optional. |
| **Prescription** | `prescription_id` — INTEGER, PK, required; `consultation_id` — INTEGER, FK to Consultation, required; `medication_name` — VARCHAR(100), required; `dosage` — VARCHAR(100), required; `frequency` — VARCHAR(100), required; `duration` — VARCHAR(100), required. |

Phone numbers use `VARCHAR` because they may contain leading zeros or country codes. Appointment status uses values such as scheduled, completed, or cancelled.

## 3. Relationships — How the Tables Connect

- **Patient to Appointment:** One patient can have zero or many appointments. Each appointment belongs to exactly one patient.
- **Doctor to Appointment:** One doctor can have zero or many appointments. Each appointment belongs to exactly one doctor.
- **Appointment to Consultation:** An appointment can have zero or one consultation. Each consultation belongs to exactly one appointment.
- **Consultation to Prescription:** One consultation can have zero or many prescriptions. Each prescription belongs to exactly one consultation.

No linking table is required because these relationships do not require many-to-many connections.

**Example:** Patient P001 can have appointments with doctor D001 on different dates. After an appointment is completed, it can have a consultation containing a diagnosis and medical notes, followed by one or more prescriptions.

## 4. Business Rules and Constraints

1. **Unique patient ID and phone number:** The patient primary key and `UNIQUE` phone constraint prevent duplicate identifiers and phone numbers.
2. **Unique staff ID and one department per doctor:** The staff primary key ensures unique staff IDs. A required `department` field records one department per doctor.
3. **Appointment requires an existing patient and active doctor:** Foreign keys ensure the patient and doctor exist. A database operation or trigger checks that the doctor is active when scheduling.
4. **One appointment per doctor at a given date and time:** A `UNIQUE` constraint on `staff_id` and `appointment_time` prevents conflicting appointments.
5. **Patient appointments at different times:** A `UNIQUE` constraint on `patient_id` and `appointment_time` prevents duplicate appointment times for the same patient.
6. **Appointment time must be later than creation time:** A `CHECK` constraint requires `appointment_time > created_at`.
7. **Consultation requires one completed appointment:** A unique foreign key links each consultation to one appointment. A trigger or controlled database operation checks that the appointment status is completed before recording the consultation.
8. **Prescription requires a valid consultation and medication details:** A foreign key identifies the consultation, while required fields ensure the medication name, dosage, frequency, and duration are provided.

## 5. Design Assumptions

1. Each doctor belongs to one department, stored as text because department management is outside the scope.
2. Cancelled appointments remain in the database for accurate history. The scheduling rules apply to appointments at the same date and time.
3. Prescription records represent individual medications, allowing one consultation to produce multiple prescriptions.