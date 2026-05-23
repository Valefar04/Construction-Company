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

def ConstructionInfo(Construction_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select 'Country: ' || cs.country ||
               ' City: ' || cs.city ||
               ' Street: ' || cs.street ||
               ' Address: ' || cs.address ||
               ' Customer: ' || nvl(c.name, 'No customer')
        from constructionsite cs
        left join customers c on cs.customer_id = c.customer_id
        where cs.constructionsite_id = :construction_id
    """

    cursor.execute(query, construction_id=Construction_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable

def SearchConstructionSiteByName(Name):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select 'Construction site: ' || cs.constructionsite_id ||
               ' Customer: ' || c.name ||
               ' Country: ' || cs.country ||
               ' City: ' || cs.city ||
               ' Street: ' || cs.street ||
               ' Address: ' || cs.address
        from constructionsite cs
        join customers c on cs.customer_id = c.customer_id
        where upper(c.name) like '%' || upper(:customer_name) || '%'
    """

    cursor.execute(query, customer_name=Name)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = []
        for construction_site, in result:
            aux.append(construction_site)

        return "\n".join(aux)
    else:
        return failVariable

def SearchConstructionSiteByID(ConstructionSite_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select 'Construction site: ' || cs.constructionsite_id ||
               ' Customer: ' || nvl(c.name, 'No customer') ||
               ' Country: ' || cs.country ||
               ' City: ' || cs.city ||
               ' Street: ' || cs.street ||
               ' Address: ' || cs.address
        from constructionsite cs
        left join customers c on cs.customer_id = c.customer_id
        where cs.constructionsite_id = :construction_site_id
    """

    cursor.execute(query, construction_site_id=ConstructionSite_ID)
    result = cursor.fetchone()
    cursor.close()
    connection.close()

    if result:
        return result[0]
    else:
        return failVariable

def AllOfTheEmployeesInTheConstruction(ConstructionSite_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select employee_id || ' ' || firstname || ' ' || lastname
        from employees
        where constructionsite_id = :construction_site_id
    """

    cursor.execute(query, construction_site_id=ConstructionSite_ID)
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
