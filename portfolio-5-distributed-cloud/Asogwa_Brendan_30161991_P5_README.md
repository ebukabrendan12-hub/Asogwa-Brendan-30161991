# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup

According to the repository documentation, the system currently runs a single-node PostgreSQL relational database alongside a local, standalone MongoDB document store for patient events. The underlying multi-node infrastructure, network topology, and distributed failover verifications are not verified or implemented within the current workspace.

## Proposed replication

To provide high availability for the MongoDB document collection handling patient check-in events, a three-node replica set is proposed where all members hold data and participate in automated elections.

| Member | Starting role | Location |
| --- | --- | --- |
| `mongo-node1` | Primary [cite: ] | Availability Zone A |
| `mongo-node2` | Secondary [cite: ] | Availability Zone B |
| `mongo-node3` | Secondary [cite: ] | Availability Zone C |

## Failure and consistency

If the primary member experiences an outage, the remaining nodes initiate an election to elect a new primary, causing a short pause in event logging [cite: ]. Should the cluster lose its reachable majority, it cannot elect a primary and will decline new write operations [cite: ]. Configuring a majority write concern ensures changes are committed across more than half of the replica set members prior to client confirmation, though brief secondary replication lag can happen [cite: ]. Authoritative transaction management remains handled by the primary database, and MongoDB replication does not replicate or synchronize the separate PostgreSQL relational database.

## Sharding and cloud deployment

Sharding partitions unique data subsets across distinct servers, whereas replication maintains identical dataset copies across nodes. The clinic's current data volume does not justify sharding. Moving to a cloud environment requires strict security measures such as authentication, encryption at rest and in transit, and restricted firewall access, alongside routine backup and restore capabilities. Key disadvantages involve higher cloud hosting expenses and increased management overhead.

## References

* MongoDB Manual. *Replication* [cite: ]. [https://www.mongodb.com/docs/manual/replication/](https://www.mongodb.com/docs/manual/replication/)
* MongoDB Manual. *Replica Set Elections* [cite: ]. [https://www.mongodb.com/docs/v8.0/core/replica-set-elections/](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
* MongoDB Manual. *Write Concern* [cite: ]. [https://www.mongodb.com/docs/v8.0/reference/write-concern/](https://www.mongodb.com/docs/v8.0/reference/write-concern/)
* MongoDB Manual. *Sharding* [cite: ]. [https://www.mongodb.com/docs/manual/sharding/](https://www.mongodb.com/docs/manual/sharding/)
* MongoDB Atlas. *Backup and Restore a Cluster* [cite: ]. [https://www.mongodb.com/docs/atlas/backup-restore-cluster/](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)