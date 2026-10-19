-- SampleData.sql: Inserts a small valid dataset into the Clinic Management System schema.
-- Wrapped in a transaction to ensure all-or-nothing data integrity.

BEGIN;

-- Insert valid patient records
INSERT INTO public.patient (full_name, phone, date_of_birth, address) VALUES 
('Alice Brown', '555-0100', '1985-04-12', '123 Maple Street'),
('Bob Chen', '555-0200', '1990-09-23', '456 Oak Avenue'),
('Carol Davis', '555-0300', '1975-12-05', '789 Pine Road');

-- Insert valid doctor records
INSERT INTO public.doctor (full_name, department, is_active) VALUES 
('Dr. John Adams', 'Cardiology', TRUE),
('Dr. Sarah Vance', 'Pediatrics', TRUE);

-- Insert appointments (covering completed, scheduled, and cancelled states)
-- Using subqueries on unique fields to look up generated IDs safely.
INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
SELECT p.patient_id, d.staff_id, '2026-11-01 10:00:00', '2026-10-20 09:00:00', 'completed'
FROM public.patient p, public.doctor d
WHERE p.phone = '555-0100' AND d.full_name = 'Dr. John Adams';

INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
SELECT p.patient_id, d.staff_id, '2026-11-02 11:00:00', '2026-10-20 09:30:00', 'scheduled'
FROM public.patient p, public.doctor d
WHERE p.phone = '555-0200' AND d.full_name = 'Dr. Sarah Vance';

-- Cancelled appointment history record
INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
SELECT p.patient_id, d.staff_id, '2026-11-03 14:00:00', '2026-10-20 10:00:00', 'cancelled'
FROM public.patient p, public.doctor d
WHERE p.phone = '555-0300' AND d.full_name = 'Dr. John Adams';

-- Insert consultation record for the completed appointment
INSERT INTO public.consultation (appointment_id, diagnosis, medical_notes)
SELECT a.appointment_id, 'Mild Hypertension', 'Patient advised to monitor blood pressure weekly.'
FROM public.appointment a
JOIN public.patient p ON a.patient_id = p.patient_id
WHERE p.phone = '555-0100' AND a.status = 'completed';

-- Insert prescription record linked to the consultation
INSERT INTO public.prescription (consultation_id, medication_name, dosage, frequency, duration)
SELECT c.consultation_id, 'Lisinopril', '10mg', 'Once daily', '30 days'
FROM public.consultation c
JOIN public.appointment a ON c.appointment_id = a.appointment_id
JOIN public.patient p ON a.patient_id = p.patient_id
WHERE p.phone = '555-0100';

COMMIT;