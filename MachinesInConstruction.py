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

def ListAllMachinesInConstruction(ConstructionSite_ID):

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    query = """
        select m.machine_id ||
               ' Model: ' || m.model ||
               ' Type: ' || m.type ||
               ' Start date: ' || to_char(mc.startmachinedate, 'YYYY-MM-DD') ||
               ' Finish date: ' || to_char(mc.finishmachinedate, 'YYYY-MM-DD')
        from machinesinconstruction mc
        join machines m on mc.machine_id = m.machine_id
        where mc.constructionsite_id = :construction_site_id
    """

    cursor.execute(query, construction_site_id=ConstructionSite_ID)
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
