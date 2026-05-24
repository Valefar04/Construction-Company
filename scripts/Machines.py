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

def ListAllMachines():

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select machine_id ||
               ' Model: ' || model ||
               ' Type: ' || type ||
               ' Is used: ' || isused
        from machines
    """

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for machine, in result:
            aux.append(machine)

        return "\n".join(aux)
    else:
        return failVariable
