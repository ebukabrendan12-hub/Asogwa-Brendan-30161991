// Clinic Graph Model - Patient Doctor Relationships
CREATE (p1:Patient {id: 'P001', name: 'John Doe'})
CREATE (p2:Patient {id: 'P002', name: 'Mary Jane'})
CREATE (d1:Doctor {id: 'D01', name: 'Dr. Smith', specialty: 'Cardiology'})
CREATE (dept:Department {name: 'Cardiology'})

CREATE (p1)-[:VISITED {date: '2025-10-22'}]->(d1)
CREATE (p2)-[:VISITED {date: '2025-10-22'}]->(d1)
CREATE (d1)-[:WORKS_IN]->(dept)
CREATE (p1)-[:REFERRED {reason: 'Family'}]->(p2)

// Query: Who visited Dr. Smith?
MATCH (p:Patient)-[:VISITED]->(d:Doctor {id: 'D01'}) RETURN p.name, d.name

// Query: Referral chain
MATCH (p1:Patient)-[:REFERRED]->(p2:Patient) RETURN p1.name, p2.name