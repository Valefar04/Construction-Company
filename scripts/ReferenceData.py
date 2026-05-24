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


def _run_reference_query(title, query):
    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    cursor.execute(query)
    result = cursor.fetchall()
    cursor.close()
    connection.close()

    if result:
        aux = [title]
        for item_id, name in result:
            aux.append(f"{item_id} | {name}")

        return "\n".join(aux)
    else:
        return failVariable


def _run_combined_reference_query(parts):
    output = []

    connection = oracledb.connect(user=USER, password=PASSWORD, dsn=dsn)
    cursor = connection.cursor()

    for title, query in parts:
        cursor.execute(query)
        result = cursor.fetchall()

        if result:
            output.append(title)
            for item_id, name in result:
                output.append(f"{item_id} | {name}")
            output.append("")

    cursor.close()
    connection.close()

    if output:
        return "\n".join(output).strip()
    else:
        return failVariable


def ListConstructionSiteReferences():
    query = """
        select cs.constructionsite_id,
               nvl(c.name, 'No customer') || ' - ' || nvl(cs.city, 'No city')
        from constructionsite cs
        left join customers c on cs.customer_id = c.customer_id
        order by cs.constructionsite_id
    """

    return _run_reference_query("Construction sites:", query)


def ListCustomerReferences():
    query = """
        select customer_id, name
        from customers
        order by customer_id
    """

    return _run_reference_query("Customers:", query)


def ListEmployeeReferences():
    parts = (
        (
            "Employees:",
            """
                select employee_id, firstname || ' ' || lastname
                from employees
                order by employee_id
            """,
        ),
        (
            "Licenses:",
            """
                select l.employee_id || '-' || l.machine_id,
                       e.firstname || ' ' || e.lastname || ' - ' || nvl(l.licensetype, 'No license type')
                from licenses l
                join employees e on l.employee_id = e.employee_id
                order by l.employee_id, l.machine_id
            """,
        ),
    )

    return _run_combined_reference_query(parts)


def ListPaymentReferences():
    parts = (
        (
            "Employee payment records:",
            """
                select ep.year || '-W' || lpad(ep.weeknumber, 2, '0') || '-' || ep.employee_id,
                       e.firstname || ' ' || e.lastname
                from employeepayment ep
                join employees e on ep.employee_id = e.employee_id
                order by ep.year, ep.weeknumber, ep.employee_id
            """,
        ),
        (
            "Employees:",
            """
                select employee_id, firstname || ' ' || lastname
                from employees
                order by employee_id
            """,
        ),
    )

    return _run_combined_reference_query(parts)


def ListPayrollPaymentReferences():
    query = """
        select employee_id, firstname || ' ' || lastname
        from employees
        order by employee_id
    """

    return _run_reference_query("Employees available for payment:", query)


def ListMachineReferences():
    parts = (
        (
            "Machines:",
            """
                select machine_id, nvl(model, 'No model') || ' - ' || nvl(type, 'No type')
                from machines
                order by machine_id
            """,
        ),
        (
            "Machines in construction:",
            """
                select mc.constructionsite_id || '-' || mc.machine_id,
                       nvl(m.model, 'No model') || ' - ' || nvl(m.type, 'No type')
                from machinesinconstruction mc
                join machines m on mc.machine_id = m.machine_id
                order by mc.constructionsite_id, mc.machine_id
            """,
        ),
    )

    return _run_combined_reference_query(parts)


def ListMaterialWarehouseReferences():
    parts = (
        (
            "Materials:",
            """
                select material_id, name
                from material
                order by material_id
            """,
        ),
        (
            "Warehouses:",
            """
                select warehouse_id, name
                from warehouse
                order by warehouse_id
            """,
        ),
        (
            "Stock:",
            """
                select s.warehouse_id || '-' || s.material_id,
                       nvl(w.name, 'No warehouse') || ' - ' || nvl(m.name, 'No material')
                from stock s
                join warehouse w on s.warehouse_id = w.warehouse_id
                join material m on s.material_id = m.material_id
                order by s.warehouse_id, s.material_id
            """,
        ),
    )

    return _run_combined_reference_query(parts)


def ListExternalServiceReferences():
    parts = (
        (
            "External service companies:",
            """
                select company_id, companyname
                from serviceexternalcompany
                order by company_id
            """,
        ),
        (
            "Services in construction:",
            """
                select sic.constructionsite_id || '-' || sic.company_id,
                       sec.companyname || ' - ' || nvl(sic.typeservice, 'No service type')
                from serviceinconstruction sic
                join serviceexternalcompany sec on sic.company_id = sec.company_id
                order by sic.constructionsite_id, sic.company_id
            """,
        ),
    )

    return _run_combined_reference_query(parts)
