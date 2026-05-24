import oracledb

# Conexion Data
USER = "ConstructionCompany"
PASSWORD = "const123"
HOST = "localhost"
PORT = 1521
SERVICE_NAME = "XEPDB1"

# Null return
failVariable = "No variable found in the DB"

dsn = f"{HOST}:{PORT}/{SERVICE_NAME}"

def _format_money(value):
    return f"{float(value):.2f}"

def _last_tax_for_employee(cursor, Employee_ID):
    query = """
        select tax
        from employeepayment
        where employee_id = :employee_id
          and tax is not null
        order by year desc, weeknumber desc
        fetch first 1 row only
    """

    cursor.execute(query, employee_id=Employee_ID)
    result = cursor.fetchone()

    if result:
        return float(result[0])
    else:
        return 0.0

def _employee_payment_data(cursor, Employee_ID):
    query = """
        select employee_id, firstname || ' ' || lastname, currentpay
        from employees
        where employee_id = :employee_id
    """

    cursor.execute(query, employee_id=Employee_ID)
    return cursor.fetchone()

def ListEmployeesToPay(Year, WeekNumber):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select e.employee_id,
               e.firstname || ' ' || e.lastname,
               e.currentpay,
               case
                   when ep.employee_id is null then 'Pending'
                   else 'Paid'
               end
        from employees e
        left join employeepayment ep
          on ep.employee_id = e.employee_id
         and ep.year = :year
         and ep.weeknumber = :week_number
        order by e.employee_id
    """

    cursor.execute(query, year=Year, week_number=WeekNumber)
    result = cursor.fetchall()

    if result:
        aux = [f"Payment week: {WeekNumber} Year: {Year}"]
        for employee_id, name, current_pay, status in result:
            weekly_payment = float(current_pay) / 4
            tax = _last_tax_for_employee(cursor, employee_id)
            net_payment = weekly_payment - tax
            aux.append(
                f"{employee_id} {name} | Current pay: {_format_money(current_pay)} | "
                f"Payment amount: {_format_money(weekly_payment)} | "
                f"Tax deducted: {_format_money(tax)} | "
                f"Net payment: {_format_money(net_payment)} | Status: {status}"
            )

        cursor.close()
        connection.close()
        return "\n".join(aux)

    cursor.close()
    connection.close()
    return failVariable

def PayEmployee(Year, WeekNumber, Employee_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    employee = _employee_payment_data(cursor, Employee_ID)

    if not employee:
        cursor.close()
        connection.close()
        return failVariable

    employee_id, name, current_pay = employee
    weekly_payment = float(current_pay) / 4
    tax = _last_tax_for_employee(cursor, employee_id)
    net_payment = weekly_payment - tax

    check_query = """
        select paymentamount, tax, to_char(paydate, 'YYYY-MM-DD')
        from employeepayment
        where year = :year
          and weeknumber = :week_number
          and employee_id = :employee_id
    """

    cursor.execute(check_query, year=Year, week_number=WeekNumber, employee_id=Employee_ID)
    existing_payment = cursor.fetchone()

    if existing_payment:
        cursor.close()
        connection.close()
        return (
            "This employee has already been paid.\n"
            f"Employee ID: {employee_id}\n"
            f"Employee: {name}\n"
            f"Week: {WeekNumber}\n"
            f"Year: {Year}\n"
            f"Current pay: {_format_money(current_pay)}\n"
            f"Payment amount: {_format_money(existing_payment[0])}\n"
            f"Tax deducted: {_format_money(existing_payment[1])}\n"
            f"Net payment: {_format_money(float(existing_payment[0]) - float(existing_payment[1]))}\n"
            f"Pay date: {existing_payment[2]}"
        )

    insert_query = """
        insert into employeepayment (weeknumber, year, employee_id, paymentamount, tax, paydate)
        values (:week_number, :year, :employee_id, :payment_amount, :tax, trunc(sysdate))
    """

    cursor.execute(
        insert_query,
        week_number=WeekNumber,
        year=Year,
        employee_id=Employee_ID,
        payment_amount=weekly_payment,
        tax=tax,
    )
    connection.commit()

    cursor.close()
    connection.close()

    return (
        "Payment registered successfully.\n"
        f"Employee ID: {employee_id}\n"
        f"Employee: {name}\n"
        f"Week: {WeekNumber}\n"
        f"Year: {Year}\n"
        f"Current pay: {_format_money(current_pay)}\n"
        f"Payment amount: {_format_money(weekly_payment)}\n"
        f"Tax deducted: {_format_money(tax)}\n"
        f"Net payment: {_format_money(net_payment)}"
    )

def ConsultPaidPeriod(Year, WeekNumber, Employee_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select paymentamount
        from employeepayment
        where year = :year
          and weeknumber = :week_number
          and employee_id = :employee_id
    """

    cursor.execute(query, year=Year, week_number=WeekNumber, employee_id=Employee_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return str(result[0])
    else:
        return failVariable

def ConsultDeductibleTax(Year, WeekNumber, Employee_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select tax
        from employeepayment
        where year = :year
          and weeknumber = :week_number
          and employee_id = :employee_id
    """

    cursor.execute(query, year=Year, week_number=WeekNumber, employee_id=Employee_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return str(result[0])
    else:
        return failVariable

def PayWeek(Year, WeekNumber, Employee_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select count(*)
        from employeepayment
        where year = :year
          and weeknumber = :week_number
          and employee_id = :employee_id
          and paydate is not null
    """

    cursor.execute(query, year=Year, week_number=WeekNumber, employee_id=Employee_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result[0] > 0:
        return "True"
    else:
        return "False"
