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

def ListEmployeesForPayment():

    connection = oracledb.connect( user=USER, password=PASSWORD, dsn=dsn )
    cursor = connection.cursor()

    query = """
        select employee_id, firstname || ' ' || lastname
        from employees
        order by employee_id
    """

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = ["Employees available for payment:"]
        for employee_id, name in result:
            aux.append(f"{employee_id} | {name}")

        return "\n".join(aux)
    else:
        return failVariable

def ConsultEmployeesUnderManagers():

    # This is temp, must be deleted when we have the main conection
    connection = oracledb.connect( user=USER, password=PASSWORD, dsn=dsn )

    # This is temp, must be deleted when we have the main conection
    cursor = connection.cursor()
    
    query = """
        select e.firstname || ' ' || e.lastname || ' Boss: ', b.firstname|| ' ' || b.lastname
        from employees e join employees b on e.boss_id = b.employee_id
    """
    
    # This is temp, must be deleted when we have the main conection
    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for employee, boss in result:
            aux.append(f"{employee}{boss}")

        return "\n".join(aux)
    else:
        return failVariable

def EmployeeInfo(Employee_ID):

    # This is temp, must be deleted when we have the main conection
    connection = oracledb.connect( user=USER, password=PASSWORD, dsn=dsn )

    # This is temp, must be deleted when we have the main conection
    cursor = connection.cursor()

    query = """
        select firstname || ' ' || lastname ||
               ' Start date: ' || to_char(startdate, 'YYYY-MM-DD') ||
               ' Hire date: ' || to_char(hiredate, 'YYYY-MM-DD') ||
               ' Phone: ' || phone
        from employees
        where employee_id = :employee_id
    """

    # This is temp, must be deleted when we have the main conection
    cursor.execute(query, employee_id=Employee_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable

def EmployeesInBank(BankName):

    # This is temp, must be deleted when we have the main conection
    connection = oracledb.connect( user=USER, password=PASSWORD, dsn=dsn )

    # This is temp, must be deleted when we have the main conection
    cursor = connection.cursor()

    query = """
        select firstname || ' ' || lastname || ' Bank account: ' || bankaccount
        from employees
        where bankname = :bank_name
    """

    # This is temp, must be deleted when we have the main conection
    cursor.execute(query, bank_name=BankName)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for employee, in result:
            aux.append(employee)

        return "\n".join(aux)
    else:
        return failVariable
