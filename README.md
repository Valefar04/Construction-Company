# Construction Management Desktop App

This is a Tkinter frontend for the Oracle query scripts. Put this app file in the same folder as the backend scripts.

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

## What It Does

- Groups the project queries by area: construction sites, customers, employees, payments, machines, materials, warehouses, and external services.
- Provides forms for the parameters each query needs.
- Uses the database connection already defined in the backend Python scripts.
- Runs each query in the background so the window does not freeze while Oracle responds.

## Notes

The app does not change your partner's scripts. It imports them from the same folder, calls the selected function, and displays the returned text.

The app login now matches the Oracle credentials in the backend scripts. If Oracle shows `ORA-01017: invalid username/password; logon denied`, Oracle is rejecting those credentials at the database level. The scripts currently use:

```text
User: ConstructionCompany
Password: const123
DSN: localhost:1521/XEPDB1
```

Create/unlock that Oracle user with the same password, or change the backend script constants to match the database user you created.

The folder should contain:

```text
construction_manager_app.py
run_construction_manager.bat
ConstructionSite.py
Customers.py
EmployeePayment.py
Employees.py
Licenses.py
Machines.py
MachinesInConstruction.py
Material.py
ServiceExternalCompany.py
ServiceInConstruction.py
Stock.py
WareHouse.py
```
