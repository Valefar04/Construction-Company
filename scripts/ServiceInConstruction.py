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

def ListServiceCompanyByTypeService(TypeService):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select sec.companyname ||
               ' Phone: ' || sec.phone ||
               ' Email: ' || sec.email ||
               ' Construction site: ' || sic.constructionsite_id ||
               ' Service: ' || sic.servicedescription
        from serviceinconstruction sic
        join serviceexternalcompany sec on sic.company_id = sec.company_id
        where sic.typeservice = :type_service
    """

    cursor.execute(query, type_service=TypeService)
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
