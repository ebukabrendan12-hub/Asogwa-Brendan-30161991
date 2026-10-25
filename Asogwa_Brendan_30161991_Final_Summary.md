# MIT 8103 Advanced Database Systems: Portfolio Summary

**Name:** Asogwa Brendan

**Student ID:** 30161991

**Repository:** [github.com/ebukaBrendan1-hub/Asogwa-Brendan-30161991](https://www.google.com/search?q=https://github.com/ebukaBrendan1-hub/Asogwa-Brendan-30161991)

## Case study

The core case study implemented across all five portfolios is the **Clinic Management System** (`clinic_portfolio`), designed to manage operational clinic workflows including patients, doctors, appointments, consultations, and prescriptions.

## Portfolio 1: Database Design and Modelling

This portfolio established the relational foundation for the clinic system within PostgreSQL in GitHub Codespaces. Five normalized tables were created (`patient`, `doctor`, `appointment`, `consultation`, and `prescription`) linked via foreign keys. Data integrity was enforced using `NOT NULL` rules, unique constraints on patient phone numbers and doctor email addresses, a check constraint (`chk_appointment_time`) to filter invalid times, and a unique index (`uq_appointment_doctor_time`) on staff ID and appointment time to prevent double-booking.

* **Verified Result:** Five deliberate invalid test cases were executed and successfully rejected by the database constraints (missing full name, duplicate phone number, non-existent foreign key reference, invalid time format, and duplicate doctor time slot). Final record counts verified a clean state of 3 patients, 2 doctors, 3 appointments, 1 consultation, and 1 prescription with zero corrupt rows added.
* **Meaning:** Demonstrates that robust upfront relational schema design and integrity constraints prevent invalid operational states before any application logic executes.

## Portfolio 2: Query Processing and Optimisation

This portfolio evaluated performance tuning for frequent database lookups and appointment filtering queries using PostgreSQL execution plans (`EXPLAIN ANALYZE`).

* **Measured Performance Comparison:**

| Metric / Phase | Before Indexing (Sequential Scan) | After Indexing (Bitmap/Index Scan) |
| --- | --- | --- |
| Scan Type | Sequential Scan | Bitmap Heap Scan / Index Scan |
| Execution Time | 2.185 ms | 0.067 ms |
| Shared Buffer Hits | 18 blocks | 9 blocks |

* **Measurement Limits:** Execution times and buffer metrics reflect local GitHub Codespace container runs on a small sample dataset. While sequential scans evaluate all table blocks linearly, indexing targets specific leaf pages directly, significantly reducing I/O overhead.
* **Meaning:** Proves that indexing high-selectivity foreign keys and timestamps reduces database load, though indexes require careful maintenance to balance read performance against write overhead.

## Portfolio 3: Transactions and Concurrency

This portfolio demonstrated ACID transaction compliance, focusing on concurrency control and isolation under multi-user workflows. The core business rule tested was preventing a doctor double-booking anomaly.

* **Verified Result:** Two concurrent `psql` sessions were simulated. Session A began a transaction and inserted an appointment while holding a row-level lock (`BEGIN` without `COMMIT`). Session B attempted a concurrent insert for the same doctor at the same time and hung, proving row-level isolation. Once Session A committed, Session B immediately failed with a duplicate key error (`ERROR: duplicate key value violates unique constraint "uq_appointment_doctor_time"`). Explicit `ROLLBACK` commands successfully cleared aborted transaction blocks, and final verification confirmed exactly 1 valid booking persisted.
* **Meaning:** Shows that combination of unique constraints, row-level locking, and transaction control blocks race conditions and preserves data consistency under concurrent user loads.

## Portfolio 4: NoSQL and Advanced Data Models

This portfolio explored polyglot persistence by implementing the clinic case study across four non-relational database models using Docker containers in Codespaces:

* **Document Model (MongoDB):** Utilized the `clinicEvents` collection (`Asogwa_Brendan_30161991_P4_ClinicEvents.png`) to store flexible, semi-structured visit notes and check-in logs.
* **Key-Value Model (Redis):** Deployed a fast in-memory cache (`Asogwa_Brendan_30161991_P4_KeyValue.png`) for rapid patient token and availability lookups.
* **Column Model (Cassandra):** Configured wide-column storage (`Asogwa_Brendan_30161991_P4_Column.png`) for scalable patient vital records.
* **Graph Model (Neo4j):** Modeled relationships (`Asogwa_Brendan_30161991_P4_Graph.png`) using nodes and edges (`Patient -[:VISITED]-> Doctor`).
* **Meaning:** Highlights that modern system architectures benefit from matching specific data shapes and query patterns to specialized database paradigms rather than forcing all data into a single relational structure.

## Portfolio 5: Distributed and Cloud Database Exercise

This portfolio analyzed high availability, replication, sharding, and cloud deployment principles.

* **Current Setup:** The repository currently runs a single-node PostgreSQL relational database alongside a local, standalone MongoDB document store. Multi-node cluster failover testing was not physically executed in the workspace.
* **Proposed Replication:** To guarantee high availability for event logs, a three-member MongoDB replica set is proposed across separate availability zones (`mongo-node1` as Primary in Zone A; `mongo-node2` and `mongo-node3` as Secondaries in Zones B and C).
* **Failure and Consistency:** In a primary outage, surviving nodes trigger an automated election, causing a brief write interruption. Losing a reachable majority halts new write acceptance. Utilizing majority write concern ensures durability across nodes, though secondary replication lag may occur. MongoDB replication does not replicate or synchronize the separate PostgreSQL instance.
* **Sharding and Cloud:** Distinguished record partitioning from replication, noting the clinic's small data volume does not require sharding. Cloud deployment mandates security controls (authentication, encryption in transit and at rest, IP restrictions), automated backups, and accounts for increased hosting expenses and operational complexity.

## Evidence

All project files, scripts, and evidence are stored in the repository:

* Portfolio 1: `Asogwa_Brendan_30161991_P1_Schema.sql`, `Asogwa_Brendan_30161991_P1_ConstraintTests.sql`, and Design documentation.
* Portfolio 2: `Asogwa_Brendan_30161991_P2_README.md`, `IndexBenchmark.sql`, and performance screenshots (`Asogwa_Brendan_30161991_P2_BEFORE_SeqScan_2.185ms.png`).
* Portfolio 3: `Asogwa_Brendan_30161991_P3_README.md`, and transaction validation screenshots (`P3_COMMIT_3.png`, `P2_Isolation_1.png`, `P2_Isolation_2.png`, `P2_Isolation_3.png`).
* Portfolio 4: `Asogwa_Brendan_30161991_P4_Setup.md`, `Asogwa_Brendan_30161991_P4_Explanation.md`, and model screenshots (`P4_ClinicEvents.png`, `P4_KeyValue.png`, `P4_Column.png`, `P4_Graph.png`).
* Portfolio 5: `Asogwa_Brendan_30161991_P5_README.md`.

## Individual reflection

Across Portfolios 1 through 5, I gained a comprehensive understanding of how database systems transition from foundational relational design to distributed cloud deployment.

In Portfolio 1 and 2, implementing entity relationships, constraints, and optimization via indexes (`EXPLAIN ANALYZE`) demonstrated how structural and performance tuning directly impacts query efficiency. Portfolio 3 deepened my practical knowledge of transaction safety, concurrency anomalies, and row-level locking mechanisms. Portfolio 4 introduced polyglot persistence, expanding my perspective beyond relational boundaries to document, key-value, column, and graph paradigms. Finally, Portfolio 5 contextualized cloud architecture, highlighting trade-offs in replication topologies, consistency models, and operational overhead.

Encountering technical challenges—such as Docker port timeouts (e.g., Neo4j port 7474 in Codespaces) and git directory synchronization errors—strengthened my troubleshooting skills, resolved by using alternative local browser views and correcting command prefixes. Ultimately, I learned that no single database model is universally optimal; choosing the right storage model depends entirely on data shape, access patterns, and ACID requirements.

## References

* PostgreSQL Global Development Group. (2024). *PostgreSQL 16 Documentation*. [https://www.postgresql.org/docs/16/](https://www.postgresql.org/docs/16/)
* MongoDB Manual. *Replication*. [https://www.mongodb.com/docs/manual/replication/](https://www.mongodb.com/docs/manual/replication/)
* MongoDB Manual. *Replica Set Elections*. [https://www.mongodb.com/docs/v8.0/core/replica-set-elections/](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
* MongoDB Manual. *Write Concern*. [https://www.mongodb.com/docs/v8.0/reference/write-concern/](https://www.mongodb.com/docs/v8.0/reference/write-concern/)
* MongoDB Manual. *Sharding*. [https://www.mongodb.com/docs/manual/sharding/](https://www.mongodb.com/docs/manual/sharding/)
* MongoDB Atlas. *Backup and Restore a Cluster*. [https://www.mongodb.com/docs/atlas/backup-restore-cluster/](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)

## AI-use declaration

* **Tools Used:** ChatGPT (OpenAI), Google Gemini, Meta AI, and GitHub Copilot.
* **Help Received:** AI assistants helped draft and format SQL syntax for constraints and indexes, clarify the operational difference between sequential scans and bitmap index scans, structure explanations for NoSQL model suitability, troubleshoot Git command syntax, and outline individual reflection sections.
* **Personal Verification:** I personally executed all PostgreSQL queries, transactions, concurrency tests, and NoSQL Docker containers within my GitHub Codespace environment. I captured all evidence screenshots, personally reviewed and edited all README files and explanations to reflect my specific clinic case study, and executed all final Git commits and pushes to verify repository integrity on GitHub (`[github.com/ebukaBrendan1-hub/Asogwa-Brendan-30161991](https://github.com/ebukaBrendan1-hub/Asogwa-Brendan-30161991)`).