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

def CurrentStockQuantity(WareHouse_ID, Material_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select quantitykg
        from stock
        where warehouse_id = :warehouse_id
          and material_id = :material_id
    """

    cursor.execute(query, warehouse_id=WareHouse_ID, material_id=Material_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return str(result[0])
    else:
        return failVariable
