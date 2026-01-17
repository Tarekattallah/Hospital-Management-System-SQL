-- hospital management system database
--
-- this file contains basic sql queries for managing hospital operations
-- each query shows common tasks like finding appointments, checking rooms,
-- and viewing patient records
--
-- participants:
-- 	Mohamed Hany
--	Hussein Saleh 
--	Altarek Attallah
--	Elsayed Elsayed
--	Amr Gamal
--	Ali Saeed


CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

-- Drop tables if they exist
DROP TABLE IF EXISTS InvoiceDetails;
DROP TABLE IF EXISTS Invoice;
DROP TABLE IF EXISTS LabTests;
DROP TABLE IF EXISTS Prescription;
DROP TABLE IF EXISTS Medicine;
DROP TABLE IF EXISTS MedicalRecord;
DROP TABLE IF EXISTS Admission;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Patient;
DROP TABLE IF EXISTS Doctor;
DROP TABLE IF EXISTS Department;

-- create tables
CREATE TABLE Doctor (
    DoctorId INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL, 
    LastName VARCHAR(100),
    Speciality VARCHAR(100) NOT NULL,
    DepartmentId INT,
    Position ENUM('Intern','Consultant','DepartmentHead'),
    PhoneNumber VARCHAR(11),
    Address TEXT,
    Email VARCHAR(100) UNIQUE,
    HireDate DATE NOT NULL
);

CREATE TABLE Patient (
    PatientId INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100),
    Gender ENUM('Male','Female') NOT NULL,
    DateOfBirth DATE,
    PhoneNumber VARCHAR(11),
    Address TEXT,
    DateCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    BloodType ENUM('A+','A-','B+','B-','AB+','AB-','O+','O-'),
    DateLeave DATETIME DEFAULT CURRENT_TIMESTAMP,
    EmergencyContactName VARCHAR(100),
    EmergencyContactPhone VARCHAR(11)
);

CREATE TABLE Department (
    DepartmentId INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Head INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    Location VARCHAR(100) NOT NULL
);

CREATE TABLE Room (
    RoomId INT PRIMARY KEY AUTO_INCREMENT,
    Location VARCHAR(100) NOT NULL,
    RoomNumber VARCHAR(20) UNIQUE NOT NULL,
    RoomType ENUM('General','Private','Intensive Care Unit','Emergency') NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE
);

CREATE TABLE Appointment (
    AppointmentId INT PRIMARY KEY AUTO_INCREMENT,
    CreatedAT DATE NOT NULL,
    AppointmentDate DATE NOT NULL,
    DoctorId INT,
    PatientId INT,
    DurationMinutes INT,
    AppointmentStatus ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled' NOT NULL,
    Notes VARCHAR(100)
);

CREATE TABLE Admission (
    AdmissionId INT PRIMARY KEY AUTO_INCREMENT,
    RoomId INT,
    PatientId INT,
    AdmissionDate DATETIME NOT NULL,
    DischargeDate DATE NOT NULL,
    Diagnosis TEXT
);

CREATE TABLE MedicalRecord (
    RecordId INT PRIMARY KEY AUTO_INCREMENT,
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    VisitDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Diagnosis TEXT NOT NULL,  -- Fixed spelling
    Treatment TEXT,
    Notes TEXT,
    FollowUpDate DATE
);

CREATE TABLE Prescription (
    PrescriptionId INT PRIMARY KEY AUTO_INCREMENT,
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    TakenDate DATETIME NOT NULL,
    Dose VARCHAR(50) NOT NULL,
    MedicineId INT NOT NULL,
    Instructions TEXT
);

CREATE TABLE Medicine (
    MedicineId INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    UnitPrice DECIMAL(10,2) NOT NULL
);

CREATE TABLE LabTests (
    TestID INT PRIMARY KEY AUTO_INCREMENT,
    TestName VARCHAR(100) NOT NULL,
    TestDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    TestDetails TEXT,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    ResultDate DATETIME,
    Results TEXT, 
    Status ENUM('Pending', 'In Progress', 'Completed', 'Cancelled') DEFAULT 'Pending',
    Notes TEXT
);

CREATE TABLE Invoice (
    InvoiceId INT PRIMARY KEY AUTO_INCREMENT,
    InvoiceDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PatientId INT NOT NULL,
    AdmissionId INT NOT NULL,
    Total DECIMAL(10,2),
    Status ENUM('Unpaid','Paid','Cancelled')
);

CREATE TABLE InvoiceDetails (
    InvoiceDetailsId INT PRIMARY KEY AUTO_INCREMENT,
    InvoiceId INT,
    Description TEXT,
    Amount DECIMAL(10,2) NOT NULL
);


-- add foreign keys
ALTER TABLE Appointment ADD FOREIGN KEY (PatientId) REFERENCES Patient(PatientId);
ALTER TABLE Admission ADD FOREIGN KEY (PatientId) REFERENCES Patient(PatientId);
ALTER TABLE Admission ADD FOREIGN KEY (RoomId) REFERENCES Room(RoomId);
ALTER TABLE MedicalRecord ADD FOREIGN KEY (PatientId) REFERENCES Patient(PatientId);
ALTER TABLE Prescription ADD FOREIGN KEY (PatientId) REFERENCES Patient(PatientId);
ALTER TABLE LabTests ADD FOREIGN KEY (PatientID) REFERENCES Patient(PatientId);
ALTER TABLE Invoice ADD FOREIGN KEY (PatientId) REFERENCES Patient(PatientId);
ALTER TABLE InvoiceDetails ADD FOREIGN KEY (InvoiceId) REFERENCES Invoice(InvoiceId);
ALTER TABLE Prescription ADD FOREIGN KEY (MedicineId) REFERENCES Medicine(MedicineId);
ALTER TABLE Doctor ADD FOREIGN KEY (DepartmentId) REFERENCES Department(DepartmentId);
ALTER TABLE Appointment ADD FOREIGN KEY (DoctorId) REFERENCES Doctor(DoctorId);
ALTER TABLE MedicalRecord ADD FOREIGN KEY (DoctorId) REFERENCES Doctor(DoctorId);
ALTER TABLE Prescription ADD FOREIGN KEY (DoctorId) REFERENCES Doctor(DoctorId);
ALTER TABLE LabTests ADD FOREIGN KEY (DoctorID) REFERENCES Doctor(DoctorId);
ALTER TABLE Invoice ADD FOREIGN KEY (AdmissionId) REFERENCES Admission(AdmissionId);


-- insert data
INSERT INTO Doctor (FirstName, LastName, Speciality, DepartmentId, Position, PhoneNumber, Address, Email, HireDate) VALUES
('John', 'Smith', 'Cardiologist', NULL, 'DepartmentHead', '5550101234', '123 Main St, Boston', 'john.smith@hospital.com', '2020-05-15'),
('Sarah', 'Johnson', 'Neurologist', NULL, 'DepartmentHead', '5550101235', '456 Oak Ave, Boston', 'sarah.j@hospital.com', '2019-08-20'),
('Michael', 'Brown', 'Orthopedic Surgeon', NULL, 'Consultant', '5550101236', '789 Pine Rd, Boston', 'm.brown@hospital.com', '2021-03-10'),
('Emily', 'Davis', 'Pediatrician', NULL, 'DepartmentHead', '5550101237', '321 Elm St, Boston', 'emily.davis@hospital.com', '2018-11-05'),
('Robert', 'Wilson', 'Oncologist', NULL, 'Consultant', '5550101238', '654 Maple Dr, Boston', 'r.wilson@hospital.com', '2022-01-30'),
('Jennifer', 'Miller', 'Cardiologist', NULL, 'Consultant', '5550101239', '987 Cedar Ln, Boston', 'j.miller@hospital.com', '2021-07-15'),
('David', 'Taylor', 'Neurologist', NULL, 'Intern', '5550101240', '147 Birch St, Boston', 'd.taylor@hospital.com', '2023-06-01');


INSERT INTO Department (Name, Head, Location, CreatedAt) VALUES
('Cardiology', 1, 'Floor 3, Wing A', '2023-01-15 08:00:00'),
('Neurology', 2, 'Floor 2, Wing B', '2023-02-10 09:00:00'),
('Orthopedics', 3, 'Floor 1, Wing C', '2023-03-05 10:00:00'),
('Pediatrics', 4, 'Floor 4, Wing A', '2023-01-20 08:30:00'),
('Oncology', 5, 'Floor 5, Wing B', '2023-02-25 09:30:00');


UPDATE Doctor SET DepartmentId = 1 WHERE DoctorId IN (1, 6); -- Cardiology
UPDATE Doctor SET DepartmentId = 2 WHERE DoctorId IN (2, 7); -- Neurology
UPDATE Doctor SET DepartmentId = 3 WHERE DoctorId = 3; -- Orthopedics
UPDATE Doctor SET DepartmentId = 4 WHERE DoctorId = 4; -- Pediatrics
UPDATE Doctor SET DepartmentId = 5 WHERE DoctorId = 5; -- Oncology


INSERT INTO Patient (FirstName, LastName, Gender, DateOfBirth, PhoneNumber, Address, BloodType, EmergencyContactName, EmergencyContactPhone) VALUES
('James', 'Anderson', 'Male', '1985-04-12', '5550201001', '111 Park Ave, Boston', 'A+', 'Mary Anderson', '5550201002'),
('Patricia', 'Clark', 'Female', '1978-09-25', '5550201003', '222 Garden St, Boston', 'B-', 'Thomas Clark', '5550201004'),
('William', 'Moore', 'Male', '1992-12-03', '5550201005', '333 River Rd, Boston', 'O+', 'Linda Moore', '5550201006'),
('Jennifer', 'Harris', 'Female', '1988-07-19', '5550201007', '444 Hill St, Boston', 'AB+', 'David Harris', '5550201008'),
('Richard', 'Martin', 'Male', '1975-02-28', '5550201009', '555 Lake Dr, Boston', 'A-', 'Susan Martin', '5550201010'),
('Jessica', 'Thompson', 'Female', '1995-11-14', '5550201011', '666 Forest Ave, Boston', 'B+', 'Kevin Thompson', '5550201012');


INSERT INTO Room (Location, RoomNumber, RoomType, IsAvailable) VALUES
('Floor 3, Cardiology Wing', '301A', 'Private', TRUE),
('Floor 3, Cardiology Wing', '301B', 'Private', FALSE),
('Floor 2, Neurology Wing', '202A', 'General', TRUE),
('Floor 2, Neurology Wing', '202B', 'General', TRUE),
('Floor 1, Orthopedics Wing', '101A', 'Intensive Care Unit', FALSE),
('Floor 4, Pediatrics Wing', '401A', 'Private', TRUE),
('Floor 5, Oncology Wing', '501A', 'Emergency', TRUE),
('Floor 5, Oncology Wing', '501B', 'Private', FALSE);


INSERT INTO Appointment (CreatedAT, AppointmentDate, DoctorId, PatientId, DurationMinutes, AppointmentStatus, Notes) VALUES
('2024-01-10', '2024-01-15', 1, 1, 30, 'Completed', 'Regular checkup'),
('2024-01-11', '2024-01-16', 2, 2, 45, 'Completed', 'Neurological consultation'),
('2024-01-12', '2024-01-17', 3, 3, 60, 'Cancelled', 'Patient rescheduled'),
('2024-01-13', '2024-01-18', 4, 4, 30, 'Scheduled', 'Pediatric follow-up'),
('2024-01-14', '2024-01-19', 5, 5, 90, 'Scheduled', 'Oncology treatment planning'),
('2024-01-15', '2024-01-20', 1, 6, 30, 'Scheduled', 'Cardiology review');


INSERT INTO Admission (RoomId, PatientId, AdmissionDate, DischargeDate, Diagnosis) VALUES
(2, 2, '2024-01-10 14:30:00', '2024-01-20', 'Severe migraine with complications'),
(5, 3, '2024-01-11 10:15:00', '2024-01-25', 'Fractured femur requiring surgery'),
(8, 5, '2024-01-12 09:00:00', '2024-02-10', 'Cancer treatment and monitoring'),
(2, 1, '2024-01-13 16:45:00', '2024-01-18', 'Cardiac arrhythmia observation'),
(6, 4, '2024-01-14 11:30:00', '2024-01-17', 'Pediatric asthma management');


INSERT INTO Medicine (Name, Description, UnitPrice) VALUES
('Lisinopril', 'Blood pressure medication', 25.50),
('Sumatriptan', 'Migraine medication', 45.75),
('Ibuprofen', 'Pain reliever and anti-inflammatory', 8.99),
('Albuterol', 'Asthma inhaler', 32.25),
('Paclitaxel', 'Chemotherapy drug', 1250.00),
('Atorvastatin', 'Cholesterol lowering drug', 35.60),
('Metformin', 'Diabetes medication', 12.80);


INSERT INTO MedicalRecord (PatientId, DoctorId, VisitDate, Diagnosis, Treatment, Notes, FollowUpDate) VALUES
(1, 1, '2024-01-15 09:00:00', 'Hypertension Stage 1', 'Prescribed medication and lifestyle changes', 'Monitor BP weekly', '2024-02-15'),
(2, 2, '2024-01-16 10:30:00', 'Chronic Migraine', 'Prescribed preventive medication', 'Avoid triggers, maintain sleep schedule', '2024-02-16'),
(3, 3, '2024-01-17 14:00:00', 'Fractured Right Femur', 'Surgery performed, cast applied', 'Physical therapy recommended', '2024-03-17'),
(4, 4, '2024-01-18 11:00:00', 'Acute Asthma', 'Inhaler prescribed and breathing exercises', 'Follow up in 2 weeks', '2024-02-01'),
(5, 5, '2024-01-19 13:30:00', 'Stage 2 Lung Cancer', 'Chemotherapy started', 'Regular blood tests required', '2024-02-05'),
(6, 1, '2024-01-20 15:00:00', 'High Cholesterol', 'Diet and exercise plan', 'Check cholesterol levels monthly', '2024-02-20');


INSERT INTO Prescription (PatientId, DoctorId, TakenDate, Dose, MedicineId, Instructions) VALUES
(1, 1, '2024-01-15 09:30:00', '10mg daily', 1, 'Take in morning with food'),
(2, 2, '2024-01-16 11:00:00', '50mg as needed', 2, 'Take at onset of migraine'),
(3, 3, '2024-01-17 14:30:00', '400mg every 6 hours', 3, 'Take with food, not more than 1200mg daily'),
(4, 4, '2024-01-18 11:30:00', '2 puffs every 4 hours', 4, 'Use before exercise'),
(5, 5, '2024-01-19 14:00:00', '175mg/m² every 3 weeks', 5, 'Administered by medical professional only'),
(1, 1, '2024-01-15 09:35:00', '20mg daily', 6, 'Take at bedtime');


INSERT INTO LabTests (TestName, PatientID, DoctorID, TestDetails, ResultDate, Results, Status, Notes) VALUES
('Complete Blood Count', 1, 1, 'Full blood panel analysis', '2024-01-16 14:00:00', 'Normal ranges, slightly elevated WBC', 'Completed', 'Follow up in 1 month'),
('MRI Brain', 2, 2, 'Magnetic resonance imaging of brain', '2024-01-17 16:30:00', 'No abnormalities detected', 'Completed', 'Continue current treatment'),
('X-Ray Right Leg', 3, 3, 'X-ray of fractured femur', '2024-01-18 11:45:00', 'Clean fracture, alignment good', 'Completed', 'Monitor healing progress'),
('Pulmonary Function Test', 4, 4, 'Lung capacity and function', NULL, NULL, 'In Progress', 'Awaiting results'),
('Biopsy Analysis', 5, 5, 'Tissue sample examination', '2024-01-20 10:15:00', 'Malignant cells detected, Stage 2', 'Completed', 'Begin treatment immediately'),
('Lipid Panel', 6, 1, 'Cholesterol and triglyceride levels', NULL, NULL, 'Pending', 'Scheduled for next week');


INSERT INTO Invoice (PatientId, AdmissionId, InvoiceDate, Total, Status) VALUES
(2, 1, '2024-01-21 10:00:00', 12500.75, 'Paid'),
(3, 2, '2024-01-26 14:30:00', 18750.00, 'Unpaid'),
(5, 3, '2024-02-11 09:15:00', 32500.50, 'Unpaid'),
(1, 4, '2024-01-19 11:45:00', 5600.25, 'Paid'),
(4, 5, '2024-01-18 16:20:00', 4200.80, 'Paid');


INSERT INTO InvoiceDetails (InvoiceId, Description, Amount) VALUES
(1, 'Room charges (10 days)', 5000.00),
(1, 'Doctor consultations', 3000.00),
(1, 'Lab tests and imaging', 2500.75),
(1, 'Medications', 2000.00),
(2, 'Room charges (14 days)', 7000.00),
(2, 'Surgical procedure', 8500.00),
(2, 'Physical therapy sessions', 2250.00),
(2, 'Medications', 1000.00),
(3, 'Room charges (30 days)', 15000.00),
(3, 'Chemotherapy treatments', 12500.50),
(3, 'Lab tests and monitoring', 5000.00),
(4, 'Room charges (5 days)', 2500.00),
(4, 'Cardiac monitoring', 2000.25),
(4, 'Consultations', 1100.00),
(5, 'Room charges (3 days)', 1500.00),
(5, 'Pediatric care', 2000.80),
(5, 'Medications and inhalers', 700.00);

-- 1. GET APPOINTMENTS FOR JANUARY 15TH
SELECT 
    A.APPOINTMENTID,
    A.APPOINTMENTDATE,
    P.FIRSTNAME,
    P.LASTNAME,
    D.FIRSTNAME,
    D.LASTNAME,
    A.APPOINTMENTSTATUS
FROM APPOINTMENT A
JOIN PATIENT P ON A.PATIENTID = P.PATIENTID
JOIN DOCTOR D ON A.DOCTORID = D.DOCTORID
WHERE A.APPOINTMENTDATE = '2024-01-15'
ORDER BY A.APPOINTMENTDATE;

-- 2. FIND PATIENTS ADMITTED THIS YEAR
SELECT 
    ADM.ADMISSIONID,
    P.FIRSTNAME,
    P.LASTNAME,
    D.FIRSTNAME,
    R.ROOMNUMBER,
    ADM.ADMISSIONDATE,
    ADM.DIAGNOSIS
FROM ADMISSION ADM
JOIN PATIENT P ON ADM.PATIENTID = P.PATIENTID
JOIN DOCTOR D ON D.DOCTORID IN (SELECT DOCTORID FROM APPOINTMENT WHERE PATIENTID = P.PATIENTID)
JOIN ROOM R ON ADM.ROOMID = R.ROOMID
WHERE ADM.ADMISSIONDATE >= '2024-01-01'
ORDER BY ADM.ADMISSIONDATE;

-- 3. FIND PATIENTS WITH NO APPOINTMENTS
SELECT 
    P.PATIENTID,
    P.FIRSTNAME,
    P.LASTNAME,
    P.PHONENUMBER
FROM PATIENT P
LEFT JOIN APPOINTMENT A ON P.PATIENTID = A.PATIENTID
WHERE A.APPOINTMENTID IS NULL
ORDER BY P.LASTNAME;

-- 4. SHOW DOCTORS WHO HAVE APPOINTMENTS
SELECT 
    D.DOCTORID,
    D.FIRSTNAME,
    D.LASTNAME
FROM DOCTOR D
JOIN APPOINTMENT A ON D.DOCTORID = A.DOCTORID
GROUP BY D.DOCTORID, D.FIRSTNAME, D.LASTNAME
ORDER BY D.LASTNAME;

-- 5. GET RECENT PRESCRIPTIONS
SELECT 
    PR.PRESCRIPTIONID,
    P.FIRSTNAME,
    D.FIRSTNAME,
    M.NAME,
    PR.DOSE,
    PR.TAKENDATE
FROM PRESCRIPTION PR
JOIN PATIENT P ON PR.PATIENTID = P.PATIENTID
JOIN DOCTOR D ON PR.DOCTORID = D.DOCTORID
JOIN MEDICINE M ON PR.MEDICINEID = M.MEDICINEID
WHERE PR.TAKENDATE >= '2024-01-01'
ORDER BY PR.TAKENDATE;

-- 6. CHECK COMPLETED LAB TESTS
SELECT 
    LT.TESTID,
    LT.TESTNAME,
    P.FIRSTNAME,
    D.FIRSTNAME,
    LT.TESTDATE,
    LT.STATUS
FROM LABTESTS LT
JOIN PATIENT P ON LT.PATIENTID = P.PATIENTID
JOIN DOCTOR D ON LT.DOCTORID = D.DOCTORID
WHERE LT.STATUS = 'COMPLETED'
ORDER BY LT.TESTDATE;

-- 7. LIST DOCTORS AND THEIR DEPARTMENTS
SELECT 
    D.DOCTORID,
    D.FIRSTNAME,
    D.LASTNAME,
    D.SPECIALITY,
    DEP.NAME
FROM DOCTOR D
JOIN DEPARTMENT DEP ON D.DEPARTMENTID = DEP.DEPARTMENTID
ORDER BY DEP.NAME;

-- 8. FIND EMPTY ROOMS
SELECT 
    R.ROOMID,
    R.ROOMNUMBER,
    R.ROOMTYPE,
    R.LOCATION
FROM ROOM R
LEFT JOIN ADMISSION A ON R.ROOMID = A.ROOMID
WHERE R.ISAVAILABLE = TRUE AND A.ADMISSIONID IS NULL
ORDER BY R.ROOMNUMBER;

-- 9. SHOW DEPARTMENTS WITH DOCTORS
SELECT 
    DEP.DEPARTMENTID,
    DEP.NAME
FROM DEPARTMENT DEP
JOIN DOCTOR D ON DEP.DEPARTMENTID = D.DEPARTMENTID
GROUP BY DEP.DEPARTMENTID, DEP.NAME
ORDER BY DEP.NAME;

-- 10. VIEW PATIENT MEDICAL RECORDS
SELECT 
    MR.RECORDID,
    P.FIRSTNAME,
    D.FIRSTNAME,
    MR.DIAGNOSIS,
    MR.VISITDATE
FROM MEDICALRECORD MR
JOIN PATIENT P ON MR.PATIENTID = P.PATIENTID
JOIN DOCTOR D ON MR.DOCTORID = D.DOCTORID
ORDER BY MR.VISITDATE;