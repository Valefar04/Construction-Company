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

def MaterialPurpose(Name):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select purpose
        from material
        where upper(name) = upper(:material_name)
    """

    cursor.execute(query, material_name=Name)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable
