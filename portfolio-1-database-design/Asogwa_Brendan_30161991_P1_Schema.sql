-- Clinic Management System Database Schema (PostgreSQL 16)
-- MIT 8103 Portfolio 1

BEGIN;

-- 1. Patient Table
-- Stores patient identification, required contact details, and optional personal information.
CREATE TABLE public.patient (
    patient_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE,
    address TEXT
);

-- 2. Doctor Table
-- Stores doctor profiles, department details, and active status.
CREATE TABLE public.doctor (
    staff_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    department VARCHAR(80) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

-- 3. Appointment Table
-- Tracks scheduled visits linking patients and doctors with time and status constraints.
-- Note: Checking that a doctor is active (is_active = TRUE) when scheduling requires trigger/transaction logic.
CREATE TABLE public.appointment (
    appointment_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES public.patient(patient_id),
    staff_id INTEGER NOT NULL REFERENCES public.doctor(staff_id),
    appointment_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    
    -- Rule 4: One appointment per doctor at a given date and time
    CONSTRAINT uq_appointment_doctor_time UNIQUE (staff_id, appointment_time),
    
    -- Rule 5: Patient appointments at different times
    CONSTRAINT uq_appointment_patient_time UNIQUE (patient_id, appointment_time),
    
    -- Rule 6: Appointment time must be later than creation time
    CONSTRAINT chk_appointment_time CHECK (appointment_time > created_at)
);

-- 4. Consultation Table
-- Stores diagnosis and notes from completed appointments.
-- Note: Enforcing that the linked appointment status is explicitly 'completed' requires trigger/transaction logic.
CREATE TABLE public.consultation (
    consultation_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    appointment_id INTEGER NOT NULL UNIQUE REFERENCES public.appointment(appointment_id),
    diagnosis TEXT NOT NULL,
    medical_notes TEXT
);

-- 5. Prescription Table
-- Records medications prescribed during consultations.
CREATE TABLE public.prescription (
    prescription_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    consultation_id INTEGER NOT NULL REFERENCES public.consultation(consultation_id),
    medication_name VARCHAR(100) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    frequency VARCHAR(100) NOT NULL,
    duration VARCHAR(100) NOT NULL
);

COMMIT;