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
