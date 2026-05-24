from __future__ import annotations

import importlib.util
import queue
import sys
import threading
import tkinter as tk
from dataclasses import dataclass
from pathlib import Path
from tkinter import messagebox, ttk


APP_DIR = Path(__file__).resolve().parent
SCRIPT_DIR = APP_DIR / "scripts"
APP_USERNAME = "ConstructionCompany"
APP_PASSWORD = "const123"


@dataclass(frozen=True)
class Field:
    key: str
    label: str
    kind: str = "text"


@dataclass(frozen=True)
class Operation:
    title: str
    description: str
    module: str
    function: str
    fields: tuple[Field, ...] = ()


SECTIONS: dict[str, tuple[Operation, ...]] = {
    "Construction Sites": (
        Operation(
            "Construction Info",
            "Find address and customer information by construction site ID.",
            "ConstructionSite.py",
            "ConstructionInfo",
            (Field("construction_id", "Construction site ID"),),
        ),
        Operation(
            "Search Construction By Customer",
            "Search construction sites by customer name.",
            "ConstructionSite.py",
            "SearchConstructionSiteByName",
            (Field("name", "Customer name"),),
        ),
        Operation(
            "Search Construction By ID",
            "Find a construction site by ID.",
            "ConstructionSite.py",
            "SearchConstructionSiteByID",
            (Field("construction_site_id", "Construction site ID"),),
        ),
        Operation(
            "Employees In Construction",
            "List employees assigned to a construction site.",
            "ConstructionSite.py",
            "AllOfTheEmployeesInTheConstruction",
            (Field("construction_site_id", "Construction site ID"),),
        ),
    ),
    "Customers": (
        Operation(
            "Customer Info",
            "Find phone, email, and customer type by customer ID.",
            "Customers.py",
            "CustomerInfo",
            (Field("customer_id", "Customer ID"),),
        ),
        Operation(
            "Customer Type",
            "Find a customer's type by customer ID.",
            "Customers.py",
            "SearchCustomerTypeByID",
            (Field("customer_id", "Customer ID"),),
        ),
    ),
    "Employees": (
        Operation(
            "Employees Under Managers",
            "List employees together with their manager.",
            "Employees.py",
            "ConsultEmployeesUnderManagers",
        ),
        Operation(
            "Employee Info",
            "Find contact and employment dates by employee ID.",
            "Employees.py",
            "EmployeeInfo",
            (Field("employee_id", "Employee ID"),),
        ),
        Operation(
            "Employees By Bank",
            "List employees that use a specific bank.",
            "Employees.py",
            "EmployeesInBank",
            (Field("bank_name", "Bank name"),),
        ),
        Operation(
            "Employees By License",
            "List employees that share a license type.",
            "Licenses.py",
            "EmployeesWithSameLicense",
            (Field("license_type", "License type"),),
        ),
    ),
    "Payments": (
        Operation(
            "Paid Amount",
            "Consult payment amount for a year, week, and employee.",
            "EmployeePayment.py",
            "ConsultPaidPeriod",
            (
                Field("year", "Year", "int"),
                Field("week_number", "Week number", "int"),
                Field("employee_id", "Employee ID"),
            ),
        ),
        Operation(
            "Deductible Tax",
            "Consult tax for a year, week, and employee.",
            "EmployeePayment.py",
            "ConsultDeductibleTax",
            (
                Field("year", "Year", "int"),
                Field("week_number", "Week number", "int"),
                Field("employee_id", "Employee ID"),
            ),
        ),
        Operation(
            "Week Was Paid",
            "Check whether an employee has a pay date for a week.",
            "EmployeePayment.py",
            "PayWeek",
            (
                Field("year", "Year", "int"),
                Field("week_number", "Week number", "int"),
                Field("employee_id", "Employee ID"),
            ),
        ),
    ),
    "Payroll Payment": (
        Operation(
            "Employees To Pay",
            "List every employee with current pay, calculated payment, tax, and pay status for a week.",
            "EmployeePayment.py",
            "ListEmployeesToPay",
            (
                Field("year", "Year", "int"),
                Field("week_number", "Week number", "int"),
            ),
        ),
        Operation(
            "Register Employee Payment",
            "Pay one employee for a week using CurrentPay and the employee's last tax value.",
            "EmployeePayment.py",
            "PayEmployee",
            (
                Field("year", "Year", "int"),
                Field("week_number", "Week number", "int"),
                Field("employee_id", "Employee ID"),
            ),
        ),
    ),
    "Machines": (
        Operation(
            "All Machines",
            "List every machine and whether it is in use.",
            "Machines.py",
            "ListAllMachines",
        ),
        Operation(
            "Machines In Construction",
            "List machines assigned to a construction site.",
            "MachinesInConstruction.py",
            "ListAllMachinesInConstruction",
            (Field("construction_site_id", "Construction site ID"),),
        ),
    ),
    "Materials & Warehouses": (
        Operation(
            "Material Purpose",
            "Find the purpose of a material by name.",
            "Material.py",
            "MaterialPurpose",
            (Field("name", "Material name"),),
        ),
        Operation(
            "Current Stock Quantity",
            "Find stock quantity for a warehouse and material.",
            "Stock.py",
            "CurrentStockQuantity",
            (
                Field("warehouse_id", "Warehouse ID"),
                Field("material_id", "Material ID"),
            ),
        ),
        Operation(
            "All Warehouses",
            "List all warehouses.",
            "WareHouse.py",
            "ListAllWarehouses",
        ),
        Operation(
            "Warehouses In Construction",
            "List warehouses assigned to a construction site.",
            "WareHouse.py",
            "WhichWareHousesAreInTheConstructionSite",
            (Field("construction_site_id", "Construction site ID"),),
        ),
    ),
    "External Services": (
        Operation(
            "External Companies",
            "List external service companies.",
            "ServiceExternalCompany.py",
            "ServiceExternalCompanies",
        ),
        Operation(
            "Companies By Service Type",
            "List service companies by service type.",
            "ServiceInConstruction.py",
            "ListServiceCompanyByTypeService",
            (Field("type_service", "Service type"),),
        ),
    ),
}


class ConstructionManagerApp(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title("Construction Management")
        self.geometry("1100x720")
        self.minsize(920, 600)

        self.modules: dict[str, object] = {}
        self.output_queue: queue.Queue[tuple[bool, str]] = queue.Queue()
        self.current_operation = SECTIONS["Construction Sites"][0]
        self.field_vars: dict[str, tk.StringVar] = {}
        self.operation_lookup: dict[str, Operation] = {}

        self._configure_style()
        self._build_login()

    def _configure_style(self) -> None:
        self.configure(bg="#f5f6f2")
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TFrame", background="#f5f6f2")
        style.configure("Panel.TFrame", background="#ffffff", relief="solid", borderwidth=1)
        style.configure("Sidebar.TFrame", background="#24312f")
        style.configure("TLabel", background="#f5f6f2", foreground="#1d2524", font=("Segoe UI", 10))
        style.configure("Panel.TLabel", background="#ffffff", foreground="#1d2524")
        style.configure("Muted.Panel.TLabel", background="#ffffff", foreground="#66706b")
        style.configure("Title.TLabel", background="#f5f6f2", foreground="#17201f", font=("Segoe UI Semibold", 18))
        style.configure("Sidebar.TLabel", background="#24312f", foreground="#f6f2e8", font=("Segoe UI Semibold", 13))
        style.configure("LoginTitle.TLabel", background="#ffffff", foreground="#17201f", font=("Segoe UI Semibold", 20))
        style.configure("TButton", font=("Segoe UI Semibold", 10), padding=(12, 8))
        style.configure("Accent.TButton", background="#2f6f5e", foreground="#ffffff")
        style.map("Accent.TButton", background=[("active", "#285f51"), ("disabled", "#9bb2aa")])
        style.configure("TEntry", padding=(8, 6))
        style.configure("TCombobox", padding=(8, 6))

    def _build_login(self) -> None:
        self.login_user_var = tk.StringVar()
        self.login_password_var = tk.StringVar()
        self.login_status_var = tk.StringVar()

        self.login_container = ttk.Frame(self, padding=18)
        self.login_container.pack(fill="both", expand=True)
        self.login_container.columnconfigure(0, weight=1)
        self.login_container.rowconfigure(0, weight=1)

        card = ttk.Frame(self.login_container, style="Panel.TFrame", padding=28)
        card.grid(row=0, column=0)
        card.columnconfigure(0, weight=1)

        ttk.Label(card, text="Construction Management", style="LoginTitle.TLabel").grid(row=0, column=0, sticky="w")
        ttk.Label(card, text="Sign in to continue", style="Muted.Panel.TLabel").grid(row=1, column=0, sticky="w", pady=(6, 22))

        ttk.Label(card, text="User", style="Panel.TLabel").grid(row=2, column=0, sticky="w")
        user_entry = ttk.Entry(card, textvariable=self.login_user_var, width=34)
        user_entry.grid(row=3, column=0, sticky="ew", pady=(4, 12))

        ttk.Label(card, text="Password", style="Panel.TLabel").grid(row=4, column=0, sticky="w")
        password_entry = ttk.Entry(card, textvariable=self.login_password_var, show="*", width=34)
        password_entry.grid(row=5, column=0, sticky="ew", pady=(4, 14))

        ttk.Button(card, text="Login", style="Accent.TButton", command=self._attempt_login).grid(row=6, column=0, sticky="ew")
        ttk.Label(card, textvariable=self.login_status_var, style="Muted.Panel.TLabel").grid(row=7, column=0, sticky="w", pady=(12, 0))

        self.bind("<Return>", lambda _event: self._attempt_login())
        user_entry.focus_set()

    def _attempt_login(self) -> None:
        username = self.login_user_var.get().strip()
        password = self.login_password_var.get()
        if username == APP_USERNAME and password == APP_PASSWORD:
            self.unbind("<Return>")
            self.login_container.destroy()
            self._build_layout()
            self._populate_operations("Construction Sites")
            self._show_operation(self.current_operation.title)
            return

        self.login_password_var.set("")
        self.login_status_var.set("Invalid user or password.")

    def _build_layout(self) -> None:
        root = ttk.Frame(self, padding=18)
        root.pack(fill="both", expand=True)
        root.columnconfigure(1, weight=1)
        root.rowconfigure(1, weight=1)

        header = ttk.Frame(root)
        header.grid(row=0, column=0, columnspan=2, sticky="ew", pady=(0, 14))
        header.columnconfigure(0, weight=1)
        ttk.Label(header, text="Construction Management", style="Title.TLabel").grid(row=0, column=0, sticky="w")

        sidebar = ttk.Frame(root, style="Sidebar.TFrame", padding=14)
        sidebar.grid(row=1, column=0, sticky="nsw", padx=(0, 14))
        sidebar.rowconfigure(2, weight=1)
        ttk.Label(sidebar, text="Modules", style="Sidebar.TLabel").grid(row=0, column=0, sticky="w", pady=(0, 12))

        self.section_list = tk.Listbox(
            sidebar,
            width=26,
            height=12,
            activestyle="none",
            bg="#24312f",
            fg="#f6f2e8",
            selectbackground="#d4a843",
            selectforeground="#17201f",
            highlightthickness=0,
            borderwidth=0,
            font=("Segoe UI", 10),
        )
        for section in SECTIONS:
            self.section_list.insert("end", section)
        self.section_list.selection_set(0)
        self.section_list.grid(row=1, column=0, sticky="ew")
        self.section_list.bind("<<ListboxSelect>>", self._on_section_selected)

        main = ttk.Frame(root)
        main.grid(row=1, column=1, sticky="nsew")
        main.columnconfigure(0, weight=1)
        main.rowconfigure(1, weight=1)

        self._build_query_panel(main)
        self._build_results_panel(main)

        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(main, textvariable=self.status_var, foreground="#59635f").grid(row=2, column=0, sticky="ew", pady=(10, 0))

    def _build_query_panel(self, parent: ttk.Frame) -> None:
        panel = ttk.Frame(parent, style="Panel.TFrame", padding=14)
        panel.grid(row=0, column=0, sticky="ew", pady=(0, 12))
        panel.columnconfigure(1, weight=1)

        ttk.Label(panel, text="Query", style="Panel.TLabel", font=("Segoe UI Semibold", 12)).grid(row=0, column=0, sticky="w")
        self.operation_var = tk.StringVar()
        self.operation_combo = ttk.Combobox(panel, textvariable=self.operation_var, state="readonly")
        self.operation_combo.grid(row=0, column=1, sticky="ew", padx=(12, 0))
        self.operation_combo.bind("<<ComboboxSelected>>", lambda _event: self._show_operation(self.operation_var.get()))

        self.description_var = tk.StringVar()
        ttk.Label(panel, textvariable=self.description_var, style="Muted.Panel.TLabel").grid(
            row=1, column=0, columnspan=2, sticky="w", pady=(8, 0)
        )

        self.form_frame = ttk.Frame(panel, style="Panel.TFrame")
        self.form_frame.grid(row=2, column=0, columnspan=2, sticky="ew", pady=(12, 0))

        actions = ttk.Frame(panel, style="Panel.TFrame")
        actions.grid(row=3, column=0, columnspan=2, sticky="ew", pady=(14, 0))
        self.run_button = ttk.Button(actions, text="Run Query", style="Accent.TButton", command=self._run_current_operation)
        self.run_button.pack(side="left")
        ttk.Button(actions, text="Clear Fields", command=self._clear_fields).pack(side="left", padx=(8, 0))

    def _build_results_panel(self, parent: ttk.Frame) -> None:
        panel = ttk.Frame(parent, style="Panel.TFrame", padding=14)
        panel.grid(row=1, column=0, sticky="nsew")
        panel.columnconfigure(0, weight=1)
        panel.rowconfigure(1, weight=1)

        top = ttk.Frame(panel, style="Panel.TFrame")
        top.grid(row=0, column=0, sticky="ew", pady=(0, 8))
        top.columnconfigure(0, weight=1)
        ttk.Label(top, text="Results", style="Panel.TLabel", font=("Segoe UI Semibold", 12)).grid(row=0, column=0, sticky="w")
        ttk.Button(top, text="Copy", command=self._copy_results).grid(row=0, column=1, sticky="e")
        ttk.Button(top, text="Clear", command=lambda: self._set_results("")).grid(row=0, column=2, sticky="e", padx=(8, 0))

        text_frame = ttk.Frame(panel, style="Panel.TFrame")
        text_frame.grid(row=1, column=0, sticky="nsew")
        text_frame.columnconfigure(0, weight=1)
        text_frame.rowconfigure(0, weight=1)

        self.results_text = tk.Text(
            text_frame,
            wrap="word",
            bg="#fbfbf8",
            fg="#1d2524",
            insertbackground="#1d2524",
            relief="flat",
            padx=12,
            pady=12,
            font=("Consolas", 10),
        )
        scrollbar = ttk.Scrollbar(text_frame, orient="vertical", command=self.results_text.yview)
        self.results_text.configure(yscrollcommand=scrollbar.set)
        self.results_text.grid(row=0, column=0, sticky="nsew")
        scrollbar.grid(row=0, column=1, sticky="ns")

    def _on_section_selected(self, _event: tk.Event) -> None:
        selection = self.section_list.curselection()
        if not selection:
            return
        section = self.section_list.get(selection[0])
        self._populate_operations(section)
        self._show_operation(self.operation_combo["values"][0])

    def _populate_operations(self, section: str) -> None:
        operations = SECTIONS[section]
        self.operation_lookup = {operation.title: operation for operation in operations}
        self.operation_combo["values"] = tuple(self.operation_lookup)
        self.operation_var.set(operations[0].title)

    def _show_operation(self, title: str) -> None:
        self.current_operation = self.operation_lookup[title]
        self.operation_var.set(title)
        self.description_var.set(self.current_operation.description)

        for child in self.form_frame.winfo_children():
            child.destroy()
        self.field_vars = {}

        if not self.current_operation.fields:
            ttk.Label(
                self.form_frame,
                text="This query does not need extra input.",
                style="Muted.Panel.TLabel",
            ).grid(row=0, column=0, sticky="w")
            return

        for col in range(3):
            self.form_frame.columnconfigure(col, weight=1)

        for index, field in enumerate(self.current_operation.fields):
            row = index // 3
            col = index % 3
            cell = ttk.Frame(self.form_frame, style="Panel.TFrame")
            cell.grid(row=row, column=col, sticky="ew", padx=(0 if col == 0 else 10, 0), pady=(0, 10))
            cell.columnconfigure(0, weight=1)
            ttk.Label(cell, text=field.label, style="Panel.TLabel").grid(row=0, column=0, sticky="w")
            variable = tk.StringVar()
            ttk.Entry(cell, textvariable=variable).grid(row=1, column=0, sticky="ew", pady=(4, 0))
            self.field_vars[field.key] = variable

    def _clear_fields(self) -> None:
        for variable in self.field_vars.values():
            variable.set("")

    def _run_current_operation(self) -> None:
        try:
            args = self._collect_args()
        except ValueError as exc:
            messagebox.showwarning("Check input", str(exc))
            return

        self.run_button.configure(state="disabled")
        self.status_var.set(f"Running {self.current_operation.title}...")
        self._set_results("Loading...")

        thread = threading.Thread(target=self._execute_operation, args=(self.current_operation, args), daemon=True)
        thread.start()
        self.after(100, self._poll_output_queue)

    def _collect_args(self) -> list[object]:
        args: list[object] = []
        for field in self.current_operation.fields:
            raw_value = self.field_vars[field.key].get().strip()
            if not raw_value:
                raise ValueError(f"{field.label} is required.")
            if field.kind == "int":
                try:
                    args.append(int(raw_value))
                except ValueError as exc:
                    raise ValueError(f"{field.label} must be a whole number.") from exc
            else:
                args.append(raw_value)
        return args

    def _execute_operation(self, operation: Operation, args: list[object]) -> None:
        try:
            module = self._load_module(operation.module)
            function = getattr(module, operation.function)
            result = function(*args)
            self.output_queue.put((True, str(result)))
        except Exception as exc:
            message = self._format_query_error(exc)
            self.output_queue.put((False, message))

    def _format_query_error(self, exc: Exception) -> str:
        error_text = str(exc)
        if "ORA-01017" in error_text:
            return (
                f"{type(exc).__name__}: {error_text}\n\n"
                "Oracle rejected the database username or password from the backend scripts.\n"
                "The desktop app login uses the same credentials shown below, so if the app login worked "
                "but Oracle still rejects the query, the database user may not exist, may be locked, "
                "or may have a different password inside Oracle.\n\n"
                "Current backend Oracle credentials found in the scripts:\n"
                "User: ConstructionCompany\n"
                "Password: const123\n"
                "DSN: localhost:1521/XEPDB1\n\n"
                "Fix this by creating/unlocking that Oracle user with the same password, "
                "or by changing USER and PASSWORD in the backend scripts to match your real Oracle schema."
            )

        return (
            f"{type(exc).__name__}: {error_text}\n\n"
            "Check that Oracle Database is running, the oracledb package is installed, "
            "and the backend script connection constants match your local database."
        )

    def _load_module(self, filename: str) -> object:
        if filename in self.modules:
            return self.modules[filename]

        path = SCRIPT_DIR / filename
        if not path.exists():
            raise FileNotFoundError(f"Could not find {path}")

        module_name = f"construction_db_{path.stem}"
        spec = importlib.util.spec_from_file_location(module_name, path)
        if spec is None or spec.loader is None:
            raise ImportError(f"Could not load {path}")
        module = importlib.util.module_from_spec(spec)
        sys.modules[module_name] = module
        spec.loader.exec_module(module)
        self.modules[filename] = module
        return module

    def _poll_output_queue(self) -> None:
        try:
            success, output = self.output_queue.get_nowait()
        except queue.Empty:
            self.after(100, self._poll_output_queue)
            return

        self._set_results(output)
        self.run_button.configure(state="normal")
        self.status_var.set("Done" if success else "Query failed")

    def _set_results(self, value: str) -> None:
        self.results_text.configure(state="normal")
        self.results_text.delete("1.0", "end")
        self.results_text.insert("1.0", value)
        self.results_text.configure(state="normal")

    def _copy_results(self) -> None:
        value = self.results_text.get("1.0", "end-1c")
        self.clipboard_clear()
        self.clipboard_append(value)
        self.status_var.set("Results copied")


if __name__ == "__main__":
    app = ConstructionManagerApp()
    app.mainloop()
