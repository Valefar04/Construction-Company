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

def ServiceExternalCompanies():

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select companyname ||
               ' Phone: ' || phone ||
               ' Email: ' || email
        from serviceexternalcompany
    """

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for company, in result:
            aux.append(company)

        return "\n".join(aux)
    else:
        return failVariable
