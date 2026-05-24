
CREATE TABLE ConstructionSite
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL ,
	Country              VARCHAR2(20) NULL ,
	City                 VARCHAR2(20) NULL ,
	Street               VARCHAR2(20) NULL ,
	Address              INTEGER NULL ,
	Customer_ID          VARCHAR2(20) NULL 
);



CREATE UNIQUE INDEX XPKConstructionSite ON ConstructionSite
(ConstructionSite_ID   ASC);



ALTER TABLE ConstructionSite
	ADD CONSTRAINT  XPKConstructionSite PRIMARY KEY (ConstructionSite_ID);



CREATE TABLE Customers
(
	Customer_ID          VARCHAR2(20) NOT NULL ,
	Name                 DATE NULL ,
	Phone                VARCHAR2(20) NULL ,
	Email                VARCHAR2(20) NULL ,
	CustomerType         VARCHAR2(20) NULL ,
	RegistrationDate     DATE NULL 
);



CREATE UNIQUE INDEX XPKCustomers ON Customers
(Customer_ID   ASC);



ALTER TABLE Customers
	ADD CONSTRAINT  XPKCustomers PRIMARY KEY (Customer_ID);



CREATE TABLE EmployeePayment
(
	WeekNumber           INTEGER NOT NULL ,
	Year                 INTEGER NOT NULL ,
	Employee_ID          VARCHAR2(20) NOT NULL ,
	PaymentAmount        VARCHAR2(20) NULL ,
	Tax                  INTEGER NULL ,
	PayDate              DATE NULL 
);



CREATE UNIQUE INDEX XPKEmployeePayment ON EmployeePayment
(WeekNumber   ASC,Year   ASC,Employee_ID   ASC);



ALTER TABLE EmployeePayment
	ADD CONSTRAINT  XPKEmployeePayment PRIMARY KEY (WeekNumber,Year,Employee_ID);



CREATE TABLE Employees
(
	Employee_ID          VARCHAR2(20) NOT NULL ,
	Boss_ID              VARCHAR2(20) NULL ,
	FirstName            VARCHAR2(20) NULL ,
	LastName             VARCHAR2(20) NULL ,
	StartDate            DATE NULL ,
	ConstructionSite_ID  VARCHAR2(20) NULL ,
	CurrentPay           INTEGER NULL ,
	BankAccount          VARCHAR2(20) NULL ,
	BankName             VARCHAR2(20) NULL ,
	Phone                VARCHAR2(20) NULL ,
	HireDate             DATE NULL 
);



CREATE UNIQUE INDEX XPKEmployees ON Employees
(Employee_ID   ASC);



ALTER TABLE Employees
	ADD CONSTRAINT  XPKEmployees PRIMARY KEY (Employee_ID);



CREATE TABLE Licenses
(
	Employee_ID          VARCHAR2(20) NOT NULL ,
	Machine_ID           VARCHAR2(20) NOT NULL ,
	LicenseType          VARCHAR2(20) NULL ,
	InitialLicenseDate   DATE NULL ,
	EndLicenseDate       DATE NULL 
);



CREATE UNIQUE INDEX XPKLicenses ON Licenses
(Employee_ID   ASC,Machine_ID   ASC);



ALTER TABLE Licenses
	ADD CONSTRAINT  XPKLicenses PRIMARY KEY (Employee_ID,Machine_ID);



CREATE TABLE Machines
(
	Machine_ID           VARCHAR2(20) NOT NULL ,
	Model                VARCHAR2(20) NULL ,
	Type                 VARCHAR2(20) NULL ,
	IsUsed               BLOB NULL 
);



CREATE UNIQUE INDEX XPKMachines ON Machines
(Machine_ID   ASC);



ALTER TABLE Machines
	ADD CONSTRAINT  XPKMachines PRIMARY KEY (Machine_ID);



CREATE TABLE MachinesInConstruction
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL ,
	Machine_ID           VARCHAR2(20) NOT NULL ,
	StartMachineDate     DATE NULL ,
	FinishMachineDate    DATE NULL 
);



CREATE UNIQUE INDEX XPKMachinesInConstruction ON MachinesInConstruction
(ConstructionSite_ID   ASC,Machine_ID   ASC);



ALTER TABLE MachinesInConstruction
	ADD CONSTRAINT  XPKMachinesInConstruction PRIMARY KEY (ConstructionSite_ID,Machine_ID);



CREATE TABLE Material
(
	Material_ID          VARCHAR2(20) NOT NULL ,
	Name                 VARCHAR2(20) NULL ,
	Prupose              INTEGER NULL 
);



CREATE UNIQUE INDEX XPKMaterial ON Material
(Material_ID   ASC);



ALTER TABLE Material
	ADD CONSTRAINT  XPKMaterial PRIMARY KEY (Material_ID);



CREATE TABLE ServiceExternalCompany
(
	Company_ID           VARCHAR2(20) NOT NULL ,
	CompanyName          VARCHAR2(20) NULL ,
	Phone                VARCHAR2(20) NULL ,
	Email                VARCHAR2(20) NULL 
);



CREATE UNIQUE INDEX XPKServiceExternalCompany ON ServiceExternalCompany
(Company_ID   ASC);



ALTER TABLE ServiceExternalCompany
	ADD CONSTRAINT  XPKServiceExternalCompany PRIMARY KEY (Company_ID);



CREATE TABLE ServiceInConstruction
(
	ConstructionSite_ID  VARCHAR2(20) NOT NULL ,
	Company_ID           VARCHAR2(20) NOT NULL ,
	ServiceDescription   VARCHAR2(20) NULL ,
	TypeService          VARCHAR2(20) NULL ,
	InitDateService      DATE NULL ,
	EndDateService       DATE NULL 
);



CREATE UNIQUE INDEX XPKServiceInConstruction ON ServiceInConstruction
(ConstructionSite_ID   ASC,Company_ID   ASC);



ALTER TABLE ServiceInConstruction
	ADD CONSTRAINT  XPKServiceInConstruction PRIMARY KEY (ConstructionSite_ID,Company_ID);



CREATE TABLE Stock
(
	WareHouse_ID         VARCHAR2(20) NOT NULL ,
	Material_ID          VARCHAR2(20) NOT NULL ,
	QuantityKg           INTEGER NULL 
);



CREATE UNIQUE INDEX XPKStock ON Stock
(WareHouse_ID   ASC,Material_ID   ASC);



ALTER TABLE Stock
	ADD CONSTRAINT  XPKStock PRIMARY KEY (WareHouse_ID,Material_ID);



CREATE TABLE WareHouse
(
	WareHouse_ID         VARCHAR2(20) NOT NULL ,
	Country              VARCHAR2(20) NULL ,
	City                 VARCHAR2(20) NULL ,
	Street               VARCHAR2(20) NULL ,
	Address              INTEGER NULL ,
	ConstructionSite_ID  VARCHAR2(20) NULL ,
	Name                 VARCHAR2(20) NULL ,
	Phone                INTEGER NULL 
);



CREATE UNIQUE INDEX XPKWareHouse ON WareHouse
(WareHouse_ID   ASC);



ALTER TABLE WareHouse
	ADD CONSTRAINT  XPKWareHouse PRIMARY KEY (WareHouse_ID);



ALTER TABLE ConstructionSite
	ADD (CONSTRAINT R_23 FOREIGN KEY (Customer_ID) REFERENCES Customers (Customer_ID) ON DELETE SET NULL);



ALTER TABLE EmployeePayment
	ADD (CONSTRAINT R_14 FOREIGN KEY (Employee_ID) REFERENCES Employees (Employee_ID));



ALTER TABLE Employees
	ADD (CONSTRAINT R_17 FOREIGN KEY (ConstructionSite_ID) REFERENCES ConstructionSite (ConstructionSite_ID) ON DELETE SET NULL);



ALTER TABLE Employees
	ADD (CONSTRAINT R_18 FOREIGN KEY (Boss_ID) REFERENCES Employees (Employee_ID) ON DELETE SET NULL);



ALTER TABLE Licenses
	ADD (CONSTRAINT R_11 FOREIGN KEY (Employee_ID) REFERENCES Employees (Employee_ID));



ALTER TABLE Licenses
	ADD (CONSTRAINT R_12 FOREIGN KEY (Machine_ID) REFERENCES Machines (Machine_ID));



ALTER TABLE MachinesInConstruction
	ADD (CONSTRAINT R_21 FOREIGN KEY (ConstructionSite_ID) REFERENCES ConstructionSite (ConstructionSite_ID));



ALTER TABLE MachinesInConstruction
	ADD (CONSTRAINT R_22 FOREIGN KEY (Machine_ID) REFERENCES Machines (Machine_ID));



ALTER TABLE ServiceInConstruction
	ADD (CONSTRAINT R_19 FOREIGN KEY (ConstructionSite_ID) REFERENCES ConstructionSite (ConstructionSite_ID));



ALTER TABLE ServiceInConstruction
	ADD (CONSTRAINT R_20 FOREIGN KEY (Company_ID) REFERENCES ServiceExternalCompany (Company_ID));



ALTER TABLE Stock
	ADD (CONSTRAINT R_9 FOREIGN KEY (WareHouse_ID) REFERENCES WareHouse (WareHouse_ID));



ALTER TABLE Stock
	ADD (CONSTRAINT R_10 FOREIGN KEY (Material_ID) REFERENCES Material (Material_ID));



ALTER TABLE WareHouse
	ADD (CONSTRAINT R_16 FOREIGN KEY (ConstructionSite_ID) REFERENCES ConstructionSite (ConstructionSite_ID) ON DELETE SET NULL);



CREATE  TRIGGER tI_ConstructionSite BEFORE INSERT ON ConstructionSite for each row
-- ERwin Builtin Trigger
-- INSERT trigger on ConstructionSite 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Customers  ConstructionSite on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00011800", PARENT_OWNER="", PARENT_TABLE="Customers"
    CHILD_OWNER="", CHILD_TABLE="ConstructionSite"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="Customer_ID" */
    UPDATE ConstructionSite
      SET
        /* %SetFK(ConstructionSite,NULL) */
        ConstructionSite.Customer_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Customers
            WHERE
              /* %JoinFKPK(:%New,Customers," = "," AND") */
              :new.Customer_ID = Customers.Customer_ID
        ) 
        /* %JoinPKPK(ConstructionSite,:%New," = "," AND") */
         and ConstructionSite.ConstructionSite_ID = :new.ConstructionSite_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_ConstructionSite AFTER DELETE ON ConstructionSite for each row
-- ERwin Builtin Trigger
-- DELETE trigger on ConstructionSite 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ConstructionSite  MachinesInConstruction on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00040b5b", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ConstructionSite_ID" */
    SELECT count(*) INTO NUMROWS
      FROM MachinesInConstruction
      WHERE
        /*  %JoinFKPK(MachinesInConstruction,:%Old," = "," AND") */
        MachinesInConstruction.ConstructionSite_ID = :old.ConstructionSite_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete ConstructionSite because MachinesInConstruction exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  ServiceInConstruction on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="ConstructionSite_ID" */
    SELECT count(*) INTO NUMROWS
      FROM ServiceInConstruction
      WHERE
        /*  %JoinFKPK(ServiceInConstruction,:%Old," = "," AND") */
        ServiceInConstruction.ConstructionSite_ID = :old.ConstructionSite_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete ConstructionSite because ServiceInConstruction exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  Employees on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ConstructionSite_ID" */
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.ConstructionSite_ID = NULL
      WHERE
        /* %JoinFKPK(Employees,:%Old," = "," AND") */
        Employees.ConstructionSite_ID = :old.ConstructionSite_ID;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  WareHouse on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="WareHouse"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ConstructionSite_ID" */
    UPDATE WareHouse
      SET
        /* %SetFK(WareHouse,NULL) */
        WareHouse.ConstructionSite_ID = NULL
      WHERE
        /* %JoinFKPK(WareHouse,:%Old," = "," AND") */
        WareHouse.ConstructionSite_ID = :old.ConstructionSite_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_ConstructionSite AFTER UPDATE ON ConstructionSite for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on ConstructionSite 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* ConstructionSite  MachinesInConstruction on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0005f039", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ConstructionSite_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.ConstructionSite_ID <> :new.ConstructionSite_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM MachinesInConstruction
      WHERE
        /*  %JoinFKPK(MachinesInConstruction,:%Old," = "," AND") */
        MachinesInConstruction.ConstructionSite_ID = :old.ConstructionSite_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update ConstructionSite because MachinesInConstruction exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* ConstructionSite  ServiceInConstruction on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="ConstructionSite_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.ConstructionSite_ID <> :new.ConstructionSite_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM ServiceInConstruction
      WHERE
        /*  %JoinFKPK(ServiceInConstruction,:%Old," = "," AND") */
        ServiceInConstruction.ConstructionSite_ID = :old.ConstructionSite_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update ConstructionSite because ServiceInConstruction exists.'
      );
    END IF;
  END IF;

  /* ConstructionSite  Employees on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ConstructionSite_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.ConstructionSite_ID <> :new.ConstructionSite_ID
  THEN
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.ConstructionSite_ID = NULL
      WHERE
        /* %JoinFKPK(Employees,:%Old," = ",",") */
        Employees.ConstructionSite_ID = :old.ConstructionSite_ID;
  END IF;

  /* ConstructionSite  WareHouse on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="WareHouse"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ConstructionSite_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.ConstructionSite_ID <> :new.ConstructionSite_ID
  THEN
    UPDATE WareHouse
      SET
        /* %SetFK(WareHouse,NULL) */
        WareHouse.ConstructionSite_ID = NULL
      WHERE
        /* %JoinFKPK(WareHouse,:%Old," = ",",") */
        WareHouse.ConstructionSite_ID = :old.ConstructionSite_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* Customers  ConstructionSite on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Customers"
    CHILD_OWNER="", CHILD_TABLE="ConstructionSite"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="Customer_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Customers
    WHERE
      /* %JoinFKPK(:%New,Customers," = "," AND") */
      :new.Customer_ID = Customers.Customer_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.Customer_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update ConstructionSite because Customers does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Customers AFTER DELETE ON Customers for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Customers 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Customers  ConstructionSite on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0000ce96", PARENT_OWNER="", PARENT_TABLE="Customers"
    CHILD_OWNER="", CHILD_TABLE="ConstructionSite"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="Customer_ID" */
    UPDATE ConstructionSite
      SET
        /* %SetFK(ConstructionSite,NULL) */
        ConstructionSite.Customer_ID = NULL
      WHERE
        /* %JoinFKPK(ConstructionSite,:%Old," = "," AND") */
        ConstructionSite.Customer_ID = :old.Customer_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Customers AFTER UPDATE ON Customers for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Customers 
DECLARE NUMROWS INTEGER;
BEGIN
  /* Customers  ConstructionSite on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="0000fe4b", PARENT_OWNER="", PARENT_TABLE="Customers"
    CHILD_OWNER="", CHILD_TABLE="ConstructionSite"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_23", FK_COLUMNS="Customer_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Customer_ID <> :new.Customer_ID
  THEN
    UPDATE ConstructionSite
      SET
        /* %SetFK(ConstructionSite,NULL) */
        ConstructionSite.Customer_ID = NULL
      WHERE
        /* %JoinFKPK(ConstructionSite,:%Old," = ",",") */
        ConstructionSite.Customer_ID = :old.Customer_ID;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_EmployeePayment BEFORE INSERT ON EmployeePayment for each row
-- ERwin Builtin Trigger
-- INSERT trigger on EmployeePayment 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Employees  EmployeePayment on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0000f67b", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="EmployeePayment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="Employee_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Employees
      WHERE
        /* %JoinFKPK(:%New,Employees," = "," AND") */
        :new.Employee_ID = Employees.Employee_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert EmployeePayment because Employees does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_EmployeePayment AFTER UPDATE ON EmployeePayment for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on EmployeePayment 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Employees  EmployeePayment on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000f09b", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="EmployeePayment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="Employee_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Employees
    WHERE
      /* %JoinFKPK(:%New,Employees," = "," AND") */
      :new.Employee_ID = Employees.Employee_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update EmployeePayment because Employees does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Employees BEFORE INSERT ON Employees for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Employees 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Employees  Employees on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00021aa4", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="Boss_ID" */
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.Boss_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM Employees
            WHERE
              /* %JoinFKPK(:%New,Employees," = "," AND") */
              :new.Boss_ID = Employees.Employee_ID
        ) 
        /* %JoinPKPK(Employees,:%New," = "," AND") */
         and Employees.Employee_ID = :new.Employee_ID;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  Employees on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ConstructionSite_ID" */
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.ConstructionSite_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM ConstructionSite
            WHERE
              /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
              :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID
        ) 
        /* %JoinPKPK(Employees,:%New," = "," AND") */
         and Employees.Employee_ID = :new.Employee_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_Employees AFTER DELETE ON Employees for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Employees 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Employees  Employees on parent delete set null */
    /* ERWIN_RELATION:CHECKSUM="0002a7d3", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="Boss_ID" */
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.Boss_ID = NULL
      WHERE
        /* %JoinFKPK(Employees,:%Old," = "," AND") */
        Employees.Boss_ID = :old.Employee_ID;

    /* ERwin Builtin Trigger */
    /* Employees  EmployeePayment on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="EmployeePayment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="Employee_ID" */
    SELECT count(*) INTO NUMROWS
      FROM EmployeePayment
      WHERE
        /*  %JoinFKPK(EmployeePayment,:%Old," = "," AND") */
        EmployeePayment.Employee_ID = :old.Employee_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Employees because EmployeePayment exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* Employees  Licenses on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Employee_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Licenses
      WHERE
        /*  %JoinFKPK(Licenses,:%Old," = "," AND") */
        Licenses.Employee_ID = :old.Employee_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Employees because Licenses exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Employees AFTER UPDATE ON Employees for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Employees 
DECLARE NUMROWS INTEGER;
BEGIN
  /* Employees  Employees on parent update set null */
  /* ERWIN_RELATION:CHECKSUM="00056cb0", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="Boss_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Employee_ID <> :new.Employee_ID
  THEN
    UPDATE Employees
      SET
        /* %SetFK(Employees,NULL) */
        Employees.Boss_ID = NULL
      WHERE
        /* %JoinFKPK(Employees,:%Old," = ",",") */
        Employees.Boss_ID = :old.Employee_ID;
  END IF;

  /* ERwin Builtin Trigger */
  /* Employees  EmployeePayment on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="EmployeePayment"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_14", FK_COLUMNS="Employee_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Employee_ID <> :new.Employee_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM EmployeePayment
      WHERE
        /*  %JoinFKPK(EmployeePayment,:%Old," = "," AND") */
        EmployeePayment.Employee_ID = :old.Employee_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Employees because EmployeePayment exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Employees  Licenses on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Employee_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Employee_ID <> :new.Employee_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Licenses
      WHERE
        /*  %JoinFKPK(Licenses,:%Old," = "," AND") */
        Licenses.Employee_ID = :old.Employee_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Employees because Licenses exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Employees  Employees on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_18", FK_COLUMNS="Boss_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Employees
    WHERE
      /* %JoinFKPK(:%New,Employees," = "," AND") */
      :new.Boss_ID = Employees.Employee_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.Boss_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Employees because Employees does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* ConstructionSite  Employees on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="Employees"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_17", FK_COLUMNS="ConstructionSite_ID" */
  SELECT count(*) INTO NUMROWS
    FROM ConstructionSite
    WHERE
      /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
      :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.ConstructionSite_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Employees because ConstructionSite does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Licenses BEFORE INSERT ON Licenses for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Licenses 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Machines  Licenses on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001f3b5", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Machine_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Machines
      WHERE
        /* %JoinFKPK(:%New,Machines," = "," AND") */
        :new.Machine_ID = Machines.Machine_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Licenses because Machines does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* Employees  Licenses on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Employee_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Employees
      WHERE
        /* %JoinFKPK(:%New,Employees," = "," AND") */
        :new.Employee_ID = Employees.Employee_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Licenses because Employees does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Licenses AFTER UPDATE ON Licenses for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Licenses 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Machines  Licenses on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001efac", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Machine_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Machines
    WHERE
      /* %JoinFKPK(:%New,Machines," = "," AND") */
      :new.Machine_ID = Machines.Machine_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Licenses because Machines does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* Employees  Licenses on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Employees"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="Employee_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Employees
    WHERE
      /* %JoinFKPK(:%New,Employees," = "," AND") */
      :new.Employee_ID = Employees.Employee_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Licenses because Employees does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Machines AFTER DELETE ON Machines for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Machines 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Machines  MachinesInConstruction on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0001e690", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Machine_ID" */
    SELECT count(*) INTO NUMROWS
      FROM MachinesInConstruction
      WHERE
        /*  %JoinFKPK(MachinesInConstruction,:%Old," = "," AND") */
        MachinesInConstruction.Machine_ID = :old.Machine_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Machines because MachinesInConstruction exists.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* Machines  Licenses on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Machine_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Licenses
      WHERE
        /*  %JoinFKPK(Licenses,:%Old," = "," AND") */
        Licenses.Machine_ID = :old.Machine_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Machines because Licenses exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Machines AFTER UPDATE ON Machines for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Machines 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Machines  MachinesInConstruction on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00022fc6", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Machine_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Machine_ID <> :new.Machine_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM MachinesInConstruction
      WHERE
        /*  %JoinFKPK(MachinesInConstruction,:%Old," = "," AND") */
        MachinesInConstruction.Machine_ID = :old.Machine_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Machines because MachinesInConstruction exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* Machines  Licenses on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="Licenses"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_12", FK_COLUMNS="Machine_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Machine_ID <> :new.Machine_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Licenses
      WHERE
        /*  %JoinFKPK(Licenses,:%Old," = "," AND") */
        Licenses.Machine_ID = :old.Machine_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Machines because Licenses exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_MachinesInConstruction BEFORE INSERT ON MachinesInConstruction for each row
-- ERwin Builtin Trigger
-- INSERT trigger on MachinesInConstruction 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Machines  MachinesInConstruction on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00022adc", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Machine_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Machines
      WHERE
        /* %JoinFKPK(:%New,Machines," = "," AND") */
        :new.Machine_ID = Machines.Machine_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert MachinesInConstruction because Machines does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  MachinesInConstruction on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ConstructionSite_ID" */
    SELECT count(*) INTO NUMROWS
      FROM ConstructionSite
      WHERE
        /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
        :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert MachinesInConstruction because ConstructionSite does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_MachinesInConstruction AFTER UPDATE ON MachinesInConstruction for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on MachinesInConstruction 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Machines  MachinesInConstruction on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="000226a5", PARENT_OWNER="", PARENT_TABLE="Machines"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Machine_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Machines
    WHERE
      /* %JoinFKPK(:%New,Machines," = "," AND") */
      :new.Machine_ID = Machines.Machine_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update MachinesInConstruction because Machines does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* ConstructionSite  MachinesInConstruction on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="MachinesInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_21", FK_COLUMNS="ConstructionSite_ID" */
  SELECT count(*) INTO NUMROWS
    FROM ConstructionSite
    WHERE
      /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
      :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update MachinesInConstruction because ConstructionSite does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_Material AFTER DELETE ON Material for each row
-- ERwin Builtin Trigger
-- DELETE trigger on Material 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Material  Stock on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000cf3f", PARENT_OWNER="", PARENT_TABLE="Material"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Material_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Stock
      WHERE
        /*  %JoinFKPK(Stock,:%Old," = "," AND") */
        Stock.Material_ID = :old.Material_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete Material because Stock exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Material AFTER UPDATE ON Material for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Material 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Material  Stock on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0000ff91", PARENT_OWNER="", PARENT_TABLE="Material"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Material_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Material_ID <> :new.Material_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Stock
      WHERE
        /*  %JoinFKPK(Stock,:%Old," = "," AND") */
        Stock.Material_ID = :old.Material_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update Material because Stock exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER  tD_ServiceExternalCompany AFTER DELETE ON ServiceExternalCompany for each row
-- ERwin Builtin Trigger
-- DELETE trigger on ServiceExternalCompany 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ServiceExternalCompany  ServiceInConstruction on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="000108da", PARENT_OWNER="", PARENT_TABLE="ServiceExternalCompany"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Company_ID" */
    SELECT count(*) INTO NUMROWS
      FROM ServiceInConstruction
      WHERE
        /*  %JoinFKPK(ServiceInConstruction,:%Old," = "," AND") */
        ServiceInConstruction.Company_ID = :old.Company_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete ServiceExternalCompany because ServiceInConstruction exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_ServiceExternalCompany AFTER UPDATE ON ServiceExternalCompany for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on ServiceExternalCompany 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* ServiceExternalCompany  ServiceInConstruction on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001314d", PARENT_OWNER="", PARENT_TABLE="ServiceExternalCompany"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Company_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.Company_ID <> :new.Company_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM ServiceInConstruction
      WHERE
        /*  %JoinFKPK(ServiceInConstruction,:%Old," = "," AND") */
        ServiceInConstruction.Company_ID = :old.Company_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update ServiceExternalCompany because ServiceInConstruction exists.'
      );
    END IF;
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_ServiceInConstruction BEFORE INSERT ON ServiceInConstruction for each row
-- ERwin Builtin Trigger
-- INSERT trigger on ServiceInConstruction 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ServiceExternalCompany  ServiceInConstruction on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="000256ea", PARENT_OWNER="", PARENT_TABLE="ServiceExternalCompany"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Company_ID" */
    SELECT count(*) INTO NUMROWS
      FROM ServiceExternalCompany
      WHERE
        /* %JoinFKPK(:%New,ServiceExternalCompany," = "," AND") */
        :new.Company_ID = ServiceExternalCompany.Company_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert ServiceInConstruction because ServiceExternalCompany does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* ConstructionSite  ServiceInConstruction on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="ConstructionSite_ID" */
    SELECT count(*) INTO NUMROWS
      FROM ConstructionSite
      WHERE
        /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
        :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert ServiceInConstruction because ConstructionSite does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_ServiceInConstruction AFTER UPDATE ON ServiceInConstruction for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on ServiceInConstruction 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* ServiceExternalCompany  ServiceInConstruction on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00025114", PARENT_OWNER="", PARENT_TABLE="ServiceExternalCompany"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_20", FK_COLUMNS="Company_ID" */
  SELECT count(*) INTO NUMROWS
    FROM ServiceExternalCompany
    WHERE
      /* %JoinFKPK(:%New,ServiceExternalCompany," = "," AND") */
      :new.Company_ID = ServiceExternalCompany.Company_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update ServiceInConstruction because ServiceExternalCompany does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* ConstructionSite  ServiceInConstruction on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="ServiceInConstruction"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_19", FK_COLUMNS="ConstructionSite_ID" */
  SELECT count(*) INTO NUMROWS
    FROM ConstructionSite
    WHERE
      /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
      :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update ServiceInConstruction because ConstructionSite does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_Stock BEFORE INSERT ON Stock for each row
-- ERwin Builtin Trigger
-- INSERT trigger on Stock 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* Material  Stock on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="0001fb36", PARENT_OWNER="", PARENT_TABLE="Material"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Material_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Material
      WHERE
        /* %JoinFKPK(:%New,Material," = "," AND") */
        :new.Material_ID = Material.Material_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Stock because Material does not exist.'
      );
    END IF;

    /* ERwin Builtin Trigger */
    /* WareHouse  Stock on child insert restrict */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="WareHouse"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="WareHouse_ID" */
    SELECT count(*) INTO NUMROWS
      FROM WareHouse
      WHERE
        /* %JoinFKPK(:%New,WareHouse," = "," AND") */
        :new.WareHouse_ID = WareHouse.WareHouse_ID;
    IF (
      /* %NotnullFK(:%New," IS NOT NULL AND") */
      
      NUMROWS = 0
    )
    THEN
      raise_application_error(
        -20002,
        'Cannot insert Stock because WareHouse does not exist.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_Stock AFTER UPDATE ON Stock for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on Stock 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* Material  Stock on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="0001f086", PARENT_OWNER="", PARENT_TABLE="Material"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Material_ID" */
  SELECT count(*) INTO NUMROWS
    FROM Material
    WHERE
      /* %JoinFKPK(:%New,Material," = "," AND") */
      :new.Material_ID = Material.Material_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Stock because Material does not exist.'
    );
  END IF;

  /* ERwin Builtin Trigger */
  /* WareHouse  Stock on child update restrict */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="WareHouse"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="WareHouse_ID" */
  SELECT count(*) INTO NUMROWS
    FROM WareHouse
    WHERE
      /* %JoinFKPK(:%New,WareHouse," = "," AND") */
      :new.WareHouse_ID = WareHouse.WareHouse_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update Stock because WareHouse does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/


CREATE  TRIGGER tI_WareHouse BEFORE INSERT ON WareHouse for each row
-- ERwin Builtin Trigger
-- INSERT trigger on WareHouse 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* ConstructionSite  WareHouse on child insert set null */
    /* ERWIN_RELATION:CHECKSUM="00011801", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="WareHouse"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ConstructionSite_ID" */
    UPDATE WareHouse
      SET
        /* %SetFK(WareHouse,NULL) */
        WareHouse.ConstructionSite_ID = NULL
      WHERE
        NOT EXISTS (
          SELECT * FROM ConstructionSite
            WHERE
              /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
              :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID
        ) 
        /* %JoinPKPK(WareHouse,:%New," = "," AND") */
         and WareHouse.WareHouse_ID = :new.WareHouse_ID;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER  tD_WareHouse AFTER DELETE ON WareHouse for each row
-- ERwin Builtin Trigger
-- DELETE trigger on WareHouse 
DECLARE NUMROWS INTEGER;
BEGIN
    /* ERwin Builtin Trigger */
    /* WareHouse  Stock on parent delete restrict */
    /* ERWIN_RELATION:CHECKSUM="0000d0fd", PARENT_OWNER="", PARENT_TABLE="WareHouse"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="WareHouse_ID" */
    SELECT count(*) INTO NUMROWS
      FROM Stock
      WHERE
        /*  %JoinFKPK(Stock,:%Old," = "," AND") */
        Stock.WareHouse_ID = :old.WareHouse_ID;
    IF (NUMROWS > 0)
    THEN
      raise_application_error(
        -20001,
        'Cannot delete WareHouse because Stock exists.'
      );
    END IF;


-- ERwin Builtin Trigger
END;
/

CREATE  TRIGGER tU_WareHouse AFTER UPDATE ON WareHouse for each row
-- ERwin Builtin Trigger
-- UPDATE trigger on WareHouse 
DECLARE NUMROWS INTEGER;
BEGIN
  /* ERwin Builtin Trigger */
  /* WareHouse  Stock on parent update restrict */
  /* ERWIN_RELATION:CHECKSUM="0002414d", PARENT_OWNER="", PARENT_TABLE="WareHouse"
    CHILD_OWNER="", CHILD_TABLE="Stock"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="WareHouse_ID" */
  IF
    /* %JoinPKPK(:%Old,:%New," <> "," OR ") */
    :old.WareHouse_ID <> :new.WareHouse_ID
  THEN
    SELECT count(*) INTO NUMROWS
      FROM Stock
      WHERE
        /*  %JoinFKPK(Stock,:%Old," = "," AND") */
        Stock.WareHouse_ID = :old.WareHouse_ID;
    IF (NUMROWS > 0)
    THEN 
      raise_application_error(
        -20005,
        'Cannot update WareHouse because Stock exists.'
      );
    END IF;
  END IF;

  /* ERwin Builtin Trigger */
  /* ConstructionSite  WareHouse on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ConstructionSite"
    CHILD_OWNER="", CHILD_TABLE="WareHouse"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_16", FK_COLUMNS="ConstructionSite_ID" */
  SELECT count(*) INTO NUMROWS
    FROM ConstructionSite
    WHERE
      /* %JoinFKPK(:%New,ConstructionSite," = "," AND") */
      :new.ConstructionSite_ID = ConstructionSite.ConstructionSite_ID;
  IF (
    /* %NotnullFK(:%New," IS NOT NULL AND") */
    :new.ConstructionSite_ID IS NOT NULL AND
    NUMROWS = 0
  )
  THEN
    raise_application_error(
      -20007,
      'Cannot update WareHouse because ConstructionSite does not exist.'
    );
  END IF;


-- ERwin Builtin Trigger
END;
/

