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

def ListAllWarehouses():

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select name ||
               ' Country: ' || country ||
               ' City: ' || city ||
               ' Street: ' || street ||
               ' Address: ' || address ||
               ' Phone: ' || phone
        from warehouse
    """

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for warehouse, in result:
            aux.append(warehouse)

        return "\n".join(aux)
    else:
        return failVariable

def WhichWareHousesAreInTheConstructionSite(ConstructionSite_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select warehouse_id || ' ' || name ||
               ' Country: ' || country ||
               ' City: ' || city ||
               ' Street: ' || street ||
               ' Address: ' || address ||
               ' Phone: ' || phone
        from warehouse
        where constructionsite_id = :construction_site_id
    """

    cursor.execute(query, construction_site_id=ConstructionSite_ID)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for warehouse, in result:
            aux.append(warehouse)

        return "\n".join(aux)
    else:
        return failVariable
