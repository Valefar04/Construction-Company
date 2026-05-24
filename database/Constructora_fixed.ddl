CREATE TABLE Customers
(
	Customer_ID          VARCHAR2(20) NOT NULL,
	Name                 VARCHAR2(80) NOT NULL,
	Phone                VARCHAR2(20) NULL,
	Email                VARCHAR2(100) NULL,
	CustomerType         VARCHAR2(30) NULL,
	RegistrationDate     DATE NULL,
	CONSTRAINT XPKCustomers PRIMARY KEY (Customer_ID)
);

CREATE TABLE ConstructionSite
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL,
	Customer_ID          VARCHAR2(20) NULL,
	Country              VARCHAR2(50) NULL,
	City                 VARCHAR2(50) NULL,
	Street               VARCHAR2(80) NULL,
	Address              VARCHAR2(120) NULL,
	CONSTRAINT XPKConstructionSite PRIMARY KEY (ConstructionSite_ID),
	CONSTRAINT R_23 FOREIGN KEY (Customer_ID)
		REFERENCES Customers (Customer_ID)
		ON DELETE SET NULL
);

CREATE TABLE Employees
(
	Employee_ID          VARCHAR2(20) NOT NULL,
	Boss_ID              VARCHAR2(20) NULL,
	ConstructionSite_ID  VARCHAR2(20) NULL,
	FirstName            VARCHAR2(50) NOT NULL,
	LastName             VARCHAR2(50) NOT NULL,
	StartDate            DATE NULL,
	HireDate             DATE NULL,
	CurrentPay           NUMBER(10,2) NULL,
	BankAccount          VARCHAR2(30) NULL,
	BankName             VARCHAR2(60) NULL,
	Phone                VARCHAR2(20) NULL,
	CONSTRAINT XPKEmployees PRIMARY KEY (Employee_ID),
	CONSTRAINT R_17 FOREIGN KEY (ConstructionSite_ID)
		REFERENCES ConstructionSite (ConstructionSite_ID)
		ON DELETE SET NULL,
	CONSTRAINT R_18 FOREIGN KEY (Boss_ID)
		REFERENCES Employees (Employee_ID)
		ON DELETE SET NULL
);

CREATE TABLE EmployeePayment
(
	WeekNumber           NUMBER(2) NOT NULL,
	Year                 NUMBER(4) NOT NULL,
	Employee_ID          VARCHAR2(20) NOT NULL,
	PaymentAmount        NUMBER(10,2) NULL,
	Tax                  NUMBER(10,2) NULL,
	PayDate              DATE NULL,
	CONSTRAINT XPKEmployeePayment PRIMARY KEY (WeekNumber, Year, Employee_ID),
	CONSTRAINT R_14 FOREIGN KEY (Employee_ID)
		REFERENCES Employees (Employee_ID),
	CONSTRAINT CK_EmployeePayment_Week CHECK (WeekNumber BETWEEN 1 AND 53)
);

CREATE TABLE Machines
(
	Machine_ID           VARCHAR2(20) NOT NULL,
	Model                VARCHAR2(50) NULL,
	Type                 VARCHAR2(50) NULL,
	IsUsed               NUMBER(1) DEFAULT 0 NOT NULL,
	CONSTRAINT XPKMachines PRIMARY KEY (Machine_ID),
	CONSTRAINT CK_Machines_IsUsed CHECK (IsUsed IN (0, 1))
);

CREATE TABLE Licenses
(
	Employee_ID          VARCHAR2(20) NOT NULL,
	Machine_ID           VARCHAR2(20) NOT NULL,
	LicenseType          VARCHAR2(50) NULL,
	InitialLicenseDate   DATE NULL,
	EndLicenseDate       DATE NULL,
	CONSTRAINT XPKLicenses PRIMARY KEY (Employee_ID, Machine_ID),
	CONSTRAINT R_11 FOREIGN KEY (Employee_ID)
		REFERENCES Employees (Employee_ID),
	CONSTRAINT R_12 FOREIGN KEY (Machine_ID)
		REFERENCES Machines (Machine_ID)
);

CREATE TABLE WareHouse
(
	WareHouse_ID         VARCHAR2(20) NOT NULL,
	ConstructionSite_ID  VARCHAR2(20) NULL,
	Name                 VARCHAR2(80) NULL,
	Country              VARCHAR2(50) NULL,
	City                 VARCHAR2(50) NULL,
	Street               VARCHAR2(80) NULL,
	Address              VARCHAR2(120) NULL,
	Phone                VARCHAR2(20) NULL,
	CONSTRAINT XPKWareHouse PRIMARY KEY (WareHouse_ID),
	CONSTRAINT R_16 FOREIGN KEY (ConstructionSite_ID)
		REFERENCES ConstructionSite (ConstructionSite_ID)
		ON DELETE SET NULL
);

CREATE TABLE Material
(
	Material_ID          VARCHAR2(20) NOT NULL,
	Name                 VARCHAR2(80) NOT NULL,
	Purpose              VARCHAR2(100) NULL,
	CONSTRAINT XPKMaterial PRIMARY KEY (Material_ID)
);

CREATE TABLE Stock
(
	WareHouse_ID         VARCHAR2(20) NOT NULL,
	Material_ID          VARCHAR2(20) NOT NULL,
	QuantityKg           NUMBER(10,2) NULL,
	CONSTRAINT XPKStock PRIMARY KEY (WareHouse_ID, Material_ID),
	CONSTRAINT R_9 FOREIGN KEY (WareHouse_ID)
		REFERENCES WareHouse (WareHouse_ID),
	CONSTRAINT R_10 FOREIGN KEY (Material_ID)
		REFERENCES Material (Material_ID),
	CONSTRAINT CK_Stock_QuantityKg CHECK (QuantityKg >= 0)
);

CREATE TABLE MachinesInConstruction
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL,
	Machine_ID           VARCHAR2(20) NOT NULL,
	StartMachineDate     DATE NULL,
	FinishMachineDate    DATE NULL,
	CONSTRAINT XPKMachinesInConstruction PRIMARY KEY (ConstructionSite_ID, Machine_ID),
	CONSTRAINT R_21 FOREIGN KEY (ConstructionSite_ID)
		REFERENCES ConstructionSite (ConstructionSite_ID),
	CONSTRAINT R_22 FOREIGN KEY (Machine_ID)
		REFERENCES Machines (Machine_ID)
);

CREATE TABLE ServiceExternalCompany
(
	Company_ID           VARCHAR2(20) NOT NULL,
	CompanyName          VARCHAR2(80) NOT NULL,
	Phone                VARCHAR2(20) NULL,
	Email                VARCHAR2(100) NULL,
	CONSTRAINT XPKServiceExternalCompany PRIMARY KEY (Company_ID)
);

CREATE TABLE ServiceInConstruction
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL,
	Company_ID           VARCHAR2(20) NOT NULL,
	ServiceDescription   VARCHAR2(120) NULL,
	TypeService          VARCHAR2(50) NULL,
	InitDateService      DATE NULL,
	EndDateService       DATE NULL,
	CONSTRAINT XPKServiceInConstruction PRIMARY KEY (ConstructionSite_ID, Company_ID),
	CONSTRAINT R_19 FOREIGN KEY (ConstructionSite_ID)
		REFERENCES ConstructionSite (ConstructionSite_ID),
	CONSTRAINT R_20 FOREIGN KEY (Company_ID)
		REFERENCES ServiceExternalCompany (Company_ID)
);
