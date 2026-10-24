# Portfolio 4: NoSQL and Advanced Data Models - Suitability Explanation
Student: Asogwa Brendan 30161991
Case Study: Clinic Management System

This portfolio implements the same Clinic Management case study from P1-P3 using NoSQL models to show polyglot persistence - using the right database for the right job.

## 1. Document Model - MongoDB (ClinicEvents)

**Implementation:** `db.clinicEvents` collection with documents like:
{ patientId: "P001", event: "VISITED", doctor: "Dr. Smith", notes: "Flu symptoms, prescribed rest", date: "2025-10-22" }

**Why Suitable:**
Clinic events are semi-structured and variable. One visit may have lab results, another may have referral notes, another may have just a prescription. A relational table would need many nullable columns or ALTER TABLE for every new field.
Document model allows flexible JSON - we can add `symptoms`, `prescription`, `labResult` fields anytime without schema migration. Perfect for clinic notes which are different per patient. Also easy to query by patientId and good for storing event history.

Screenshot: `Asogwa_Brendan_30161991_P4_ClinicEvents.png`

## 2. Key-Value Model - Redis (Patient Session Cache)

**Implementation:**
SET patient:P001 "John Doe | Dr. Smith | 2025-10-22"
GET patient:P001

**Why Suitable:**
When a patient checks in at reception, the system needs their name and last doctor in <10ms. Relational DB is slower for this frequent lookup. Key-Value gives O(1) fast access by key.
Suitable for caching frequent data, session management, and reducing load on main database. For example, if 100 patients visit daily, Redis serves the recent 20 from memory instantly. It is not suitable as primary storage because it lacks complex queries, but perfect as a cache layer for the clinic.

Screenshot: `Asogwa_Brendan_30161991_P4_KeyValue.png`

## 3. Column Model - Cassandra (Patient Records)

**Implementation:**
CREATE TABLE clinic.patients (id text PRIMARY KEY, name text, doctor text, clinic_id text, last_visit date);
Designed to partition by clinic_id.

**Why Suitable:**
A clinic system grows to many clinics and millions of patient records. It needs high availability, write-heavy performance, and horizontal scaling.
Column-family (wide-column) allows partitioning by `clinic_id` - all patients of Abuja clinic on one node set, Lagos on another. Writes are fast, and we can add columns like `blood_type` or `insurance` without affecting old rows.
Unlike MongoDB which is better for one server, Cassandra is suitable when the clinic expands to multiple locations and needs 99.9% uptime - if one node fails, others still serve.

Screenshot: `Asogwa_Brendan_30161991_P4_Column.png`

## 4. Graph Model - Neo4j (Visits and Referrals)

**Implementation:**
```cypher
CREATE (p1:Patient {id: 'P001', name: 'John Doe'})
CREATE (d1:Doctor {id: 'D01', name: 'Dr. Smith'})
CREATE (p1)-[:VISITED {date: '2025-10-22'}]->(d1)
MATCH (p:Patient)-[:VISITED]->(d:Doctor {name: 'Dr. Smith'}) RETURN p