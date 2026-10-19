-- ConstraintTests.sql: Tests schema constraints using deliberately invalid statements.
-- Run each statement individually (outside a transaction block) so that a failure 
-- in one test does not prevent subsequent tests from executing.

-- Test 1: Required field violation (full_name is NOT NULL in patient table)
-- Expected error: null value in column "full_name" of relation "patient" violates not-null constraint
INSERT INTO public.patient (full_name, phone) 
VALUES (NULL, '555-9999');

-- Test 2: Unique value violation (phone must be UNIQUE in patient table)
-- Expected error: duplicate key value violates unique constraint "patient_phone_key"
INSERT INTO public.patient (full_name, phone) 
VALUES ('David Evans', '555-0100');

-- Test 3: Foreign key violation (patient_id 99999 does not exist)
-- Expected error: insert or update on table "appointment" violates foreign key constraint
INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
VALUES (99999, 1, '2026-12-01 10:00:00', '2026-10-20 10:00:00', 'scheduled');

-- Test 4: Check constraint violation (appointment_time must be later than created_at)
-- Expected error: new row for relation "appointment" violates check constraint "chk_appointment_time"
INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
SELECT p.patient_id, d.staff_id, '2026-10-20 08:00:00', '2026-10-20 10:00:00', 'scheduled'
FROM public.patient p, public.doctor d
WHERE p.phone = '555-0200' AND d.full_name = 'Dr. Sarah Vance';

-- Test 5: Partial unique index violation (conflicting appointment time for active doctor)
-- Expected error: duplicate key value violates unique constraint "uq_appointment_doctor_time"
INSERT INTO public.appointment (patient_id, staff_id, appointment_time, created_at, status) 
SELECT p.patient_id, d.staff_id, '2026-11-01 10:00:00', '2026-10-20 10:00:00', 'scheduled'
FROM public.patient p, public.doctor d
WHERE p.phone = '555-0200' AND d.full_name = 'Dr. John Adams';

-- Final Row Count Verification
-- Expected counts after valid data insertion (all invalid tests fail and add 0 rows):
-- patient: 3, doctor: 2, appointment: 3, consultation: 1, prescription: 1
SELECT 
    (SELECT COUNT(*) FROM public.patient) AS patient_count,
    (SELECT COUNT(*) FROM public.doctor) AS doctor_count,
    (SELECT COUNT(*) FROM public.appointment) AS appointment_count,
    (SELECT COUNT(*) FROM public.consultation) AS consultation_count,
    (SELECT COUNT(*) FROM public.prescription) AS prescription_count;