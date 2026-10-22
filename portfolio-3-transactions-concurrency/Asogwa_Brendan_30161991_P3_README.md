# Portfolio 3 - Transaction Management, Concurrency Control and Isolation
**Student:** Asogwa Brendan - 30161991
**Database:** clinic_portfolio
**DBMS:** PostgreSQL 14+ (Codespace)

## 1. Overview
This portfolio demonstrates ACID transaction properties for a clinic appointment system. The core business rule is: **A doctor (staff_id) cannot have two appointments at the same appointment_time (double-booking must be prevented).**

### Concurrency Issue Identified
**Issue:** Lost Update / Double-booking anomaly.
If two patients (Session A and Session B) concurrently book the same doctor at the same time '2026-10-25 10:00:00', without control, both INSERTs would succeed, creating duplicate bookings and inconsistent state.

### Control Mechanism Implemented
**Mechanism:** UNIQUE constraint on (staff_id, appointment_time)

```sql
CREATE UNIQUE INDEX uq_appointment_doctor_time 
ON appointment(staff_id, appointment_time);
This enforces at database level that combination of doctor + time must be unique. Screenshot `P3_Concurrency_Control.png` shows `\d appointment` with the constraint.

This mechanism provides:
- *Consistency:* Prevents invalid duplicate data
- *Concurrency Control:* Acts as pessimistic lock + unique check
- *Isolation Support:* Works with row-level locking

## 2. Transaction Setup
DROP TABLE IF EXISTS appointment CASCADE;

CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    staff_id INT NOT NULL,
    appointment_time TIMESTAMP NOT NULL,
    status VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE UNIQUE INDEX uq_appointment_doctor_time 
ON appointment(staff_id, appointment_time);
## 3. COMMIT Demonstration
COMMIT makes transaction changes permanent and visible to other sessions.

*SQL:*
BEGIN;
INSERT INTO appointment (patient_id, staff_id, appointment_time, status, created_at) 
VALUES (1, 1, '2026-10-25 10:00:00', 'scheduled', NOW());
COMMIT;

SELECT patient_id, staff_id, appointment_time, status FROM appointment 
WHERE appointment_time = '2026-10-25 10:00:00';
-- Result: (1 row) 1 | 1 | 2026-10-25 10:00:00 | scheduled
*Evidence:* `P3_COMMIT_3.png` shows 1 row after COMMIT. Data persists after transaction ends, proving durability.

*Screenshot:* `P2_Isolation_3.png` also shows committed row still exists in final SELECT.

## 4. ROLLBACK Demonstration
ROLLBACK undoes all changes in current transaction, returning database to state before BEGIN. Also required to clear aborted transaction after error.

*SQL - Clean ROLLBACK:*
BEGIN;
INSERT INTO appointment (patient_id, staff_id, appointment_time, status, created_at) 
VALUES (1, 1, '2026-10-27 11:00:00', 'scheduled', NOW());
SELECT * FROM appointment WHERE appointment_time = '2026-10-27 11:00:00'; -- Shows 1 row inside tx
ROLLBACK;
SELECT * FROM appointment WHERE appointment_time = '2026-10-27 11:00:00'; -- Shows 0 rows
-- Result: (0 rows) proves rollback removed uncommitted data
*SQL - ROLLBACK after aborted transaction:*
-- After duplicate key error, prompt becomes clinic_portfolio=!#
-- ERROR: current transaction is aborted, commands ignored until end of transaction block
clinic_portfolio=!# ROLLBACK;
-- Result: ROLLBACK
-- Prompt returns to clinic_portfolio=# - transaction cleared
*Evidence:* Screenshots `P3_Rollback_1.png` to `P3_Rollback_4.png` show row exists inside transaction but disappears after ROLLBACK. Also screenshots `P2_Isolation_1.png` and `P2_Isolation_2.png` show `ROLLBACK;` used to clear aborted state.

## 5. ISOLATION Demonstration (Two Concurrent Sessions)
Isolation tested with two psql sessions running concurrently in same database.

*Session A (Left Terminal):*
BEGIN;
INSERT INTO appointment (patient_id, staff_id, appointment_time, status, created_at) 
VALUES (1, 1, '2026-10-25 10:00:00', 'scheduled', NOW());
-- Holds lock on (staff_id=1, appointment_time=2026-10-25 10:00:00), does NOT commit yet
*Session B (Right Terminal - Concurrent):*
BEGIN;
INSERT INTO appointment (patient_id, staff_id, appointment_time, status, created_at) 
VALUES (2, 1, '2026-10-25 10:00:00', 'scheduled', NOW());
-- This session HANGS / blocks - blinking cursor, no INSERT 0 1
-- Proves PostgreSQL row-level locking: Session B cannot proceed until Session A releases lock
-- This is isolation in action
*Evidence:* `P2_Isolation_1.png` - Session B hangs.

*Session A Commits:*
COMMIT;
*Session B then fails:*
ERROR: duplicate key value violates unique constraint "uq_appointment_doctor_time"
DETAIL: Key (staff_id, appointment_time)=(1, 2026-10-25 10:00:00) already exists.
*Evidence:* `P2_Isolation_2.png` shows duplicate key error - proves control mechanism blocked second booking.

*Required cleanup:*
ROLLBACK; -- Clears aborted transaction
## 6. Final Consistent State
After both sessions, check final state:
SET search_path TO p2_benchmark;
SELECT patient_id, staff_id, appointment_time, status FROM appointment 
WHERE appointment_time = '2026-10-25 10:00:00';

-- Result:
-- patient_id | staff_id | appointment_time  | status
-- 1          | 1        | 2026-10-25 10:00:00 | scheduled
-- (1 row)
*Proves:*
- Only 1 booking exists, no duplicate
- COMMIT from Session A persisted
- Session B's attempted duplicate was prevented
- Database remains consistent despite concurrent conflict
- No lost update, no double-booking anomaly

*Evidence:* `P2_Isolation_3.png` shows (1 row)

## 7. Screenshots List
File | Description | Requirement
P3_Concurrency_Control.png | `\d appointment` showing uq_appointment_doctor_time | Control Mechanism
P3_COMMIT_3.png | SELECT after COMMIT showing 1 row | COMMIT
P3_Rollback_4.png | SELECT after ROLLBACK showing 0 rows | ROLLBACK
P2_Isolation_1.png | Session B hangs on concurrent INSERT | Isolation
P2_Isolation_2.png | duplicate key violates unique constraint error | Concurrency Issue + Control
P2_Isolation_3.png | Final SELECT (1 row) - no duplicate | Final Consistency
## 8. Conclusion
- COMMIT successfully saves appointment permanently
- ROLLBACK successfully undoes uncommitted changes and clears aborted transactions
- Isolation prevents concurrent sessions from seeing uncommitted data and uses row-level locking
- Concurrency issue (double-booking) is prevented by UNIQUE constraint uq_appointment_doctor_time
- Control mechanism enforced consistency with only 1 row in final state, preventing anomaly