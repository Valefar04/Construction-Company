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

def CustomerInfo(Customer_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select name ||
               ' Phone: ' || phone ||
               ' Email: ' || email ||
               ' Customer type: ' || customertype
        from customers
        where customer_id = :customer_id
    """

    cursor.execute(query, customer_id=Customer_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable

def SearchCustomerTypeByID(Customer_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select customertype
        from customers
        where customer_id = :customer_id
    """

    cursor.execute(query, customer_id=Customer_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable
