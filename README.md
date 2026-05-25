# Construction Management Desktop App

## Run

Double-click `run_construction_manager.bat`, or run:

```powershell
python construction_manager_app.py
```

If Python is installed but Oracle support is missing:

```powershell
pip install oracledb
```

## App Login

Use this login to open the desktop app:

```text
User: ConstructionCompany
Password: const123
```

The folder should contain:

```text
construction_manager_app.py
run_construction_manager.bat
scripts/
  ConstructionSite.py
  Customers.py
  EmployeePayment.py
  Employees.py
  Licenses.py
  Machines.py
  MachinesInConstruction.py
  Material.py
  ReferenceData.py
  ServiceExternalCompany.py
  ServiceInConstruction.py
  Stock.py
  WareHouse.py
database/
  Constructora_fixed.ddl
  Constructora_seed_data.sql
```
