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

def EmployeesWithSameLicense(LicenseType):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select e.employee_id || ' ' || e.firstname || ' ' || e.lastname ||
               ' Machine: ' || l.machine_id ||
               ' License type: ' || l.licensetype
        from licenses l
        join employees e on l.employee_id = e.employee_id
        where l.licensetype = :license_type
    """

    cursor.execute(query, license_type=LicenseType)
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
