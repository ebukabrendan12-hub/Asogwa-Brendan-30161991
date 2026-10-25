# Individual Reflection - Database Systems
Student: Asogwa Brendan 30161991

## What I Learned

Across Portfolio 1 to 5, I learned how a database moves from design to cloud.

**P1 - Database Design:** I learned ER modelling and normalization. I designed Patient, Doctor, Appointment, Prescription tables and created schema with primary/foreign keys. Challenge was avoiding many-to-many issues.

**P2 - Query Optimisation:** I learned that without indexes, queries do Seq Scan and are slow (2.185ms). After creating indexes on patient_id and doctor_id, it used Bitmap Index Scan and became much faster. I also learned ACID, COMMIT, ROLLBACK, and isolation levels (Read Committed vs Repeatable Read) to handle concurrent bookings.

**P3 - Transactions & Concurrency:** I learned about concurrency issues like lost updates when two receptionists book same doctor time. Using locking and serializable isolation fixed it.

**P4 - NoSQL:** This was new. I learned polyglot persistence:
- MongoDB Document for flexible clinic notes
- Redis Key-Value for fast cache
- Cassandra Column for scalable records across clinics
- Neo4j Graph for Patient VISITED Doctor relationships
I struggled with Neo4j port 7474 timeout in Codespaces (fluffy-space-parakeet), but learned to use localhost:7474 inside Simple Browser and AuraDB alternative.

**P5 - Distributed & Cloud:** I learned about replication, sharding, and CAP theorem. Cloud deployment shows high availability.

## Challenges
- Git add/commit/push errors when folder name incomplete (portfolio-)
- Docker containers timing out in Opera browser - fixed with Simple Browser
- Missing README files - now fixed for all portfolios

## Skills Gained
- SQL, indexing, EXPLAIN ANALYSE, transaction control
- Docker for MongoDB, Redis, Cassandra, Neo4j
- GitHub Codespaces workflow
- Choosing the right database model based on data shape and query pattern

## Conclusion
I now understand there is no one best database. Relational for ACID appointments, Document for flexible notes, Key-Value for cache, Column for scale, Graph for relationships. This polyglot approach is what a real clinic system needs.

## MY AI USE

Tools: ChatGPT (OpenAI), Google Gemini, Meta AI (on WhatsApp), GitHub Copilot

Help received: 
- ChatGPT: Helped draft SQL queries for Appointments/Prescriptions, explained EXPLAIN ANALYSE difference (Seq Scan vs Index Scan), and helped structure P2 Comparison and P5 Discussion
- Gemini: Explained NoSQL suitability for clinic case study, gave ideas for P4_Explanation.md (why MongoDB for flexible notes, Redis for cache, Cassandra for scale, Neo4j for relationships)
- Meta AI: Helped fix git errors (git add portfolio-), guided on missing README files (P2 and P4), helped write Individual Reflection outline, and debug Neo4j port 7474 timeout in Codespaces
- GitHub Copilot: Auto-completed SQL syntax for CREATE INDEX and CREATE TABLE statements

My verification:
- I personally ran all PostgreSQL queries, transactions, COMMIT/ROLLBACK, and isolation levels in my GitHub Codespace and took all screenshots (P2_AFTER_BitmapIndex, P2_BEFORE_SeqScan, P2_Index_List, P2_Isolation_1/2/3, P2_Rollback)
- I personally ran Docker containers for MongoDB, Redis, Cassandra, Neo4j and captured all P4 evidence (P4_ClinicEvents.png, P4_KeyValue.png, P4_Column.png, P4_Graph.png)
- I personally reviewed, edited, and corrected all README and Explanation files to match my own clinic case study and actual file names in repo
- I personally executed all git add / commit / push commands and verified on GitHub: github.com/ebukaBrendan1-hub/Asogwa-Brendan-30161991
- All screenshots, code, and final wording are my own work - AI only helped with explanations and structuring.