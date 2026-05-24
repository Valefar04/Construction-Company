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

## What It Does

- Groups the project queries by area: construction sites, customers, employees, payments, machines, materials, warehouses, and external services.
- Adds a Payroll Payment module to list employees by week/year and register employee payments by Employee ID.
- Provides forms for the parameters each query needs.
- Uses the database connection already defined in the backend Python scripts.
- Runs each query in the background so the window does not freeze while Oracle responds.

## Payroll Payment

The Payroll Payment module uses:

- `Year` and `Week number` as general payroll-period inputs.
- `Employee ID` to pay one selected employee.
- An automatic employee ID/name list from `Employees.py` when opening `Register Employee Payment`.
- `Employees.CurrentPay / 4` as the weekly payment amount.
- The employee's latest historical `EmployeePayment.Tax` value as the tax deduction.
- `TRUNC(SYSDATE)` as the payment date for new payments.

If a payment already exists for the same `Year`, `WeekNumber`, and `Employee_ID`, the app shows:

```text
This employee has already been paid.
```

## Notes

The app does not change your partner's scripts. It imports them from the `scripts` folder, calls the selected function, and displays the returned text.

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
scripts/
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
database/
  Constructora_fixed.ddl
  Constructora_seed_data.sql
```
