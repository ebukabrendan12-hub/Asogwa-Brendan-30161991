# Asogwa Brendan 30161991 - Portfolio 4 Setup - NoSQL Models

This portfolio uses Docker in GitHub Codespaces (Ubuntu) for all NoSQL models.

## 1. Document Model - MongoDB (ClinicEvents)
For unstructured clinic visit notes.

**Start:**
```bash
docker run --name mongodb-clinic -d -p 27017:27017 mongo:latest
mongosh "mongodb://127.0.0.1:27017"Setup:jsuse clinicDB
db.clinicEvents.insertOne({ patientId: "P001", event: "VISITED", doctor: "Dr. Smith", notes: "Flu check", date: "2025-10-22" })
db.clinicEvents.find()Screenshot: screenshots/Asogwa_Brendan_30161991_P4_MongoDBConnection.png
2. Key-Value Model - Redis (Patient Cache)
For fast patient lookup.
Start:bashdocker run --name redis-clinic -d -p 6379:6379 redis:latest
docker exec -it redis-clinic redis-cliSetup:javascriptSET patient:P001 "John Doe | Dr. Smith | 2025-10-22"
GET patient:P001Screenshot: screenshots/Asogwa_Brendan_30161991_P4_KeyValue.png
3. Column Model - Cassandra (Patients)
For large-scale distributed patient records.
Start:bashdocker run --name cassandra-clinic -d -p 9042:9042 cassandra:latest
docker exec -it cassandra-clinic cqlshSetup:sqlCREATE KEYSPACE clinic WITH replication = {'class':'SimpleStrategy','replication_factor':1};
CREATE TABLE clinic.patients (id text PRIMARY KEY, name text, doctor text);
INSERT INTO clinic.patients (id, name, doctor) VALUES ('P001', 'John Doe', 'Dr. Smith');
SELECT * FROM clinic.patients;Screenshot: screenshots/Asogwa_Brendan_30161991_P4_Column.png
4. Graph Model - Neo4j (Visits/Referrals)
For relationships: Patient VISITED Doctor.
Start:bashdocker run --name neo4j-clinic -d -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH=neo4j/password neo4j:latestOpen port 7474 in browser -> localhost:7474 -> Login neo4j / password
Setup (Cypher):cypherCREATE (p1:Patient {id: 'P001', name: 'John Doe'})
CREATE (d1:Doctor {id: 'D01', name: 'Dr. Smith'})
CREATE (p1)-[:VISITED {date: '2025-10-22'}]->(d1)Screenshot: screenshots/Asogwa_Brendan_30161991_P4_Graph.png
All containers verified with docker ps.