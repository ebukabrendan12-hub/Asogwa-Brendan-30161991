# Portfolio 1 Database Design and Modelling

## Case Study
A clinic management system stores patient details, medical staff records, appointment schedules, and consultation history. Receptionists register patients and schedule visits, while doctors conduct consultations and record medical notes. The database maintains accurate tracking of patient interactions and clinical outcomes.

## Users
- **Patients:** Attend appointments and receive care.
- **Receptionists:** Register patients and schedule visits.
- **Doctors:** Manage diagnoses, consultation notes, and prescriptions.

## Main Operations
- Register a patient.
- Add a doctor profile.
- Schedule an appointment.
- Record a consultation.
- Issue a prescription.
- View a patient's medical history and doctor availability.

## Business Rules
1. Each patient has a unique patient ID and phone number.
2. Each doctor has a unique staff ID and belongs to one department.
3. Each appointment refers to one existing patient and one active doctor.
4. A doctor can have at most one appointment at a given date and time.
5. A patient can have multiple appointments, provided they are scheduled at different times.
6. The appointment time must be later than the creation time.
7. A consultation record is linked to exactly one completed appointment.
8. A prescription must reference a valid consultation and include specific medication details.

## Scope
One clinic branch, fictional patient records, and outpatient appointments. Inpatient stays, emergency services, insurance processing, billing, and pharmacy inventory are outside this example.