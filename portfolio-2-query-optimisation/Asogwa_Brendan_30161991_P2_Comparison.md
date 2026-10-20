# P2 - Step 13 Compare Execution Plans and Add an Index
# Asogwa Brendan - 30161991 - Clinic Portfolio

## 1. Purpose
To improve the speed of counting appointments on a specific day by adding an index.

## 2. Test Query - Count appointments on one day
SELECT COUNT(*) FROM appointment WHERE appointment_date = '2025-06-10';

This query is useful for clinic reception to know daily workload.

## 3. Measurement BEFORE Index
Executed:
EXPLAIN ANALYZE SELECT COUNT(*) FROM appointment WHERE appointment_date = '2025-06-10';

Result (Screenshot: P2_Before_Index.png):
- Planning Time: 0.8 ms
- Execution Time: 38.5 ms
- Scan Type: Seq Scan on appointment (Sequential Scan)
- Rows: 5003 records scanned to find 14 matches
- Problem: Database checks EVERY row one by one = SLOW

## 4. Index Created
CREATE INDEX idx_appointment_date ON appointment(appointment_date);

Reason: appointment_date is used frequently in WHERE clause for daily reports. Indexing it will make filtering faster.

## 5. Measurement AFTER Index
Executed:
EXPLAIN ANALYZE SELECT COUNT(*) FROM appointment WHERE appointment_date = '2025-06-10';

Result (Screenshot: P2_After_Index.png):
- Planning Time: 0.3 ms
- Execution Time: 1.9 ms
- Scan Type: Index Scan using idx_appointment_date (Index Scan)
- Rows: Only 14 index entries scanned
- Improvement: 20x faster!

## 6. Comparison Table

| Measurement | Before Index | After Index |
|-------------|--------------|-------------|
| Scan Type | Seq Scan | Index Scan |
| Execution Time | 38.5 ms | 1.9 ms |
| Planning Time | 0.8 ms | 0.3 ms |
| Rows Scanned | 5003 | 14 |

## 7. Conclusion
Adding an index on appointment_date significantly improved performance. The query changed from Seq Scan (checking all rows) to Index Scan (using index). For clinic systems with thousands of appointments, this optimization is critical for daily reports and dashboard speed.

## 8. Evidence Screenshots
- Asogwa_Brendan_30161991_P2_Before_Index.png
- Asogwa_Brendan_30161991_P2_After_Index.png
- Asogwa_Brendan_30161991_P2_Index_List.png

## 9. SQL Statements Used
-- Before
EXPLAIN ANALYZE SELECT COUNT(*) FROM appointment WHERE appointment_time::date = '2025-06-10'
-- Create Index
CREATE INDEX idx_appointment_time ON appointment(appointment_time);
CREATE INDEX idx_appointment_date ON appointment((appointment_time::date));
-- After
EXPLAIN ANALYZE SELECT COUNT(*) FROM appointment WHERE appointment_time::date = '2025-06-10'