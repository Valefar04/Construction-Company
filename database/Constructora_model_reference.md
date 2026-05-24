# Constructora - modelo esperado

Referencia del modelo final visto en ERwin. Usar este archivo para comparar el script SQL generado.

## Reglas de negocio asumidas

- Un cliente puede tener varias construcciones.
- Una construccion pertenece a un solo cliente.
- Una construccion puede tener empleados, almacenes, servicios externos y maquinas asignadas.
- Un empleado puede tener un jefe mediante `Boss_ID`.
- `EmployeePayment` se mantiene sin `Payment_ID`; su llave esperada es compuesta.
- `WeekNumber` y `Year` en `EmployeePayment` representan el periodo formal de nomina; `PayDate` representa la fecha real de pago.
- `Stock` representa la cantidad actual de un material en un almacen.

## Tablas esperadas

### Customers

- `Customer_ID` PK
- `Name`
- `Phone`
- `Email`
- `CustomerType`
- `RegistrationDate`

### ConstructionSite

- `ConstructionSite_ID` PK
- `Customer_ID` FK a `Customers.Customer_ID`
- `Country`
- `City`
- `Street`
- `Address`

Relacion esperada: `Customers` 1 a N `ConstructionSite`.

### Employees

- `Employee_ID` PK
- `Boss_ID` FK a `Employees.Employee_ID`
- `ConstructionSite_ID` FK a `ConstructionSite.ConstructionSite_ID`
- `FirstName`
- `LastName`
- `StartDate`
- `HireDate`
- `CurrentPay`
- `BankAccount`
- `BankName`
- `Phone`

Nota: si un empleado pudiera trabajar en varias construcciones a la vez, se necesitaria una tabla intermedia. En el modelo actual se asume una construccion asignada por empleado.

### EmployeePayment

- `Employee_ID` FK a `Employees.Employee_ID`
- `WeekNumber`
- `Year`
- `PaymentAmount`
- `Tax`
- `PayDate`

Llave esperada: PK compuesta por `Employee_ID`, `WeekNumber`, `Year`.

### Licenses

- `Employee_ID` FK a `Employees.Employee_ID`
- `Machine_ID` FK a `Machines.Machine_ID`
- `LicenseType`
- `InitialLicenseDate`
- `EndLicenseDate`

Llave esperada: probablemente compuesta por `Employee_ID` y `Machine_ID`, salvo que ERwin genere otra llave.

### Machines

- `Machine_ID` PK
- `Model`
- `Type`
- `IsUsed`

### MachinesInConstruction

- `ConstructionSite_ID` FK a `ConstructionSite.ConstructionSite_ID`
- `Machine_ID` FK a `Machines.Machine_ID`
- `StartMachineDate`
- `FinishMachineDate`

Llave esperada: PK compuesta por `ConstructionSite_ID` y `Machine_ID`.

### WareHouse

- `WareHouse_ID` PK
- `ConstructionSite_ID` FK a `ConstructionSite.ConstructionSite_ID`
- `Name`
- `Country`
- `City`
- `Street`
- `Address`
- `Phone`

### Material

- `Material_ID` PK
- `Name`
- `Propose`

Nota: el nombre en ingles correcto probablemente seria `Purpose`, pero en el modelo final aparece como `Propose`.

### Stock

- `WareHouse_ID` FK a `WareHouse.WareHouse_ID`
- `Material_ID` FK a `Material.Material_ID`
- `QuantityKg`

Llave esperada: PK compuesta por `WareHouse_ID` y `Material_ID`.

### ServiceExternalCompany

- `Company_ID` PK
- `CompanyName`
- `Phone`
- `Email`

### ServiceInConstruction

- `ConstructionSite_ID` FK a `ConstructionSite.ConstructionSite_ID`
- `Company_ID` FK a `ServiceExternalCompany.Company_ID`
- `ServiceDescription`
- `TypeService`
- `InitDateService`
- `EndDateService`

Llave esperada: PK compuesta por `ConstructionSite_ID` y `Company_ID`.

## Puntos a verificar en el script SQL

- Que existan las 12 tablas anteriores.
- Que `ConstructionSite.Customer_ID` sea FK hacia `Customers`.
- Que no exista `Customers.ConstructionSite_ID`.
- Que `EmployeePayment` conserve `Employee_ID`, `WeekNumber`, `Year`, `PaymentAmount`, `Tax` y `PayDate`.
- Que `EmployeePayment` tenga PK compuesta por `Employee_ID`, `WeekNumber`, `Year`.
- Que las tablas puente tengan llaves compuestas:
  - `Stock`: `WareHouse_ID`, `Material_ID`
  - `MachinesInConstruction`: `ConstructionSite_ID`, `Machine_ID`
  - `ServiceInConstruction`: `ConstructionSite_ID`, `Company_ID`
  - `Licenses`: `Employee_ID`, `Machine_ID`
- Que `ServiceExternalCompany` use `Company_ID` y no `Contract_ID`.
- Que `ServiceInConstruction` contenga las fechas y descripcion del servicio, no la compania externa.
- Que las FKs apunten a las tablas correctas y se creen despues de las PKs.
