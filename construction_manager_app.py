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
LOGO_PATH = APP_DIR / "assets" / "duo_builders_logo.png"
COLOR_BG = "#f4f6fb"
COLOR_PANEL = "#ffffff"
COLOR_TEXT = "#1f2440"
COLOR_MUTED = "#6d7188"
COLOR_PURPLE = "#65609f"
COLOR_PURPLE_DARK = "#3f3a72"
COLOR_CYAN = "#66d4dd"
COLOR_PANEL_BORDER = "#d9dcef"


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


SECTION_REFERENCE_OPERATIONS: dict[str, Operation] = {
    "Construction Sites": Operation(
        "Construction Site References",
        "List construction site IDs and names.",
        "ReferenceData.py",
        "ListConstructionSiteReferences",
    ),
    "Customers": Operation(
        "Customer References",
        "List customer IDs and names.",
        "ReferenceData.py",
        "ListCustomerReferences",
    ),
    "Employees": Operation(
        "Employee References",
        "List employee IDs and names.",
        "ReferenceData.py",
        "ListEmployeeReferences",
    ),
    "Payments": Operation(
        "Payment References",
        "List payment IDs and employee names.",
        "ReferenceData.py",
        "ListPaymentReferences",
    ),
    "Payroll Payment": Operation(
        "Payroll Employee References",
        "List employee IDs and names for payroll.",
        "ReferenceData.py",
        "ListPayrollPaymentReferences",
    ),
    "Machines": Operation(
        "Machine References",
        "List machine IDs and names.",
        "ReferenceData.py",
        "ListMachineReferences",
    ),
    "Materials & Warehouses": Operation(
        "Material And Warehouse References",
        "List material and warehouse IDs and names.",
        "ReferenceData.py",
        "ListMaterialWarehouseReferences",
    ),
    "External Services": Operation(
        "External Service References",
        "List external service IDs and names.",
        "ReferenceData.py",
        "ListExternalServiceReferences",
    ),
}


class ConstructionManagerApp(tk.Tk):
    def __init__(self) -> None:
        super().__init__()
        self.title("Duo Builders")
        self.geometry("1100x720")
        self.minsize(920, 600)

        self.modules: dict[str, object] = {}
        self.output_queue: queue.Queue[tuple[bool, str, str | None, bool]] = queue.Queue()
        self.reference_cache: dict[str, str] = {}
        self.loading_reference_sections: set[str] = set()
        self.current_section = "Construction Sites"
        self.current_operation = SECTIONS["Construction Sites"][0]
        self.field_vars: dict[str, tk.StringVar] = {}
        self.operation_lookup: dict[str, Operation] = {}
        self.logo_images: list[tk.PhotoImage] = []

        self._set_window_icon()
        self._configure_style()
        self._build_login()

    def _configure_style(self) -> None:
        self.configure(bg=COLOR_BG)
        style = ttk.Style(self)
        style.theme_use("clam")
        style.configure("TFrame", background=COLOR_BG)
        style.configure(
            "Panel.TFrame",
            background=COLOR_PANEL,
            relief="solid",
            borderwidth=1,
            bordercolor=COLOR_PANEL_BORDER,
            lightcolor=COLOR_PANEL,
            darkcolor=COLOR_PANEL_BORDER,
        )
        style.configure("Sidebar.TFrame", background=COLOR_PURPLE_DARK)
        style.configure("TLabel", background=COLOR_BG, foreground=COLOR_TEXT, font=("Segoe UI", 10))
        style.configure("Panel.TLabel", background=COLOR_PANEL, foreground=COLOR_TEXT)
        style.configure("Muted.Panel.TLabel", background=COLOR_PANEL, foreground=COLOR_MUTED)
        style.configure("Title.TLabel", background=COLOR_BG, foreground=COLOR_TEXT, font=("Segoe UI Semibold", 20))
        style.configure("Subtitle.TLabel", background=COLOR_BG, foreground=COLOR_MUTED, font=("Segoe UI", 10))
        style.configure("Sidebar.TLabel", background=COLOR_PURPLE_DARK, foreground="#ffffff", font=("Segoe UI Semibold", 13))
        style.configure("SidebarMuted.TLabel", background=COLOR_PURPLE_DARK, foreground="#d7d5f0", font=("Segoe UI", 9))
        style.configure("LoginTitle.TLabel", background=COLOR_PANEL, foreground=COLOR_TEXT, font=("Segoe UI Semibold", 19))
        style.configure("LoginSubtitle.TLabel", background=COLOR_PANEL, foreground=COLOR_MUTED, font=("Segoe UI", 10))
        style.configure("TButton", font=("Segoe UI Semibold", 10), padding=(12, 8))
        style.configure("Accent.TButton", background=COLOR_PURPLE, foreground="#ffffff")
        style.map(
            "Accent.TButton",
            background=[("active", COLOR_PURPLE_DARK), ("disabled", "#b6b4d1")],
            foreground=[("disabled", "#f2f2fb")],
        )
        style.configure("TEntry", padding=(8, 6))
        style.configure("TCombobox", padding=(8, 6))

    def _set_window_icon(self) -> None:
        if not LOGO_PATH.exists():
            return

        icon = tk.PhotoImage(file=str(LOGO_PATH))
        self.logo_images.append(icon)
        self.iconphoto(True, icon)

    def _build_logo(self, parent: tk.Widget, subsample: int, background: str = "#ffffff") -> tk.Label | ttk.Label:
        if not LOGO_PATH.exists():
            return ttk.Label(parent, text="Duo Builders", style="LoginTitle.TLabel")

        image = tk.PhotoImage(file=str(LOGO_PATH))
        if subsample > 1:
            image = image.subsample(subsample, subsample)
        self.logo_images.append(image)
        return tk.Label(parent, image=image, bg=background, bd=0, highlightthickness=0)

    def _build_login(self) -> None:
        self.login_user_var = tk.StringVar()
        self.login_password_var = tk.StringVar()
        self.login_status_var = tk.StringVar()

        self.login_container = ttk.Frame(self, padding=26)
        self.login_container.pack(fill="both", expand=True)
        self.login_container.columnconfigure(0, weight=1)
        self.login_container.rowconfigure(0, weight=1)

        card = ttk.Frame(self.login_container, style="Panel.TFrame", padding=34)
        card.grid(row=0, column=0)
        card.columnconfigure(0, weight=1)

        self._build_logo(card, subsample=2).grid(row=0, column=0, pady=(0, 20))
        ttk.Label(card, text="Construction Management System", style="LoginTitle.TLabel").grid(row=1, column=0)
        ttk.Label(
            card,
            text="Sign in to manage projects, payroll, materials, and services.",
            style="LoginSubtitle.TLabel",
            wraplength=360,
            justify="center",
        ).grid(
            row=2, column=0, pady=(6, 24)
        )

        ttk.Label(card, text="User", style="Panel.TLabel").grid(row=3, column=0, sticky="w")
        user_entry = ttk.Entry(card, textvariable=self.login_user_var, width=34)
        user_entry.grid(row=4, column=0, sticky="ew", pady=(4, 12))

        ttk.Label(card, text="Password", style="Panel.TLabel").grid(row=5, column=0, sticky="w")
        password_entry = ttk.Entry(card, textvariable=self.login_password_var, show="*", width=34)
        password_entry.grid(row=6, column=0, sticky="ew", pady=(4, 14))

        ttk.Button(card, text="Login", style="Accent.TButton", command=self._attempt_login).grid(row=7, column=0, sticky="ew")
        ttk.Label(card, textvariable=self.login_status_var, style="Muted.Panel.TLabel").grid(row=8, column=0, sticky="w", pady=(12, 0))

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
        root = ttk.Frame(self, padding=20)
        root.pack(fill="both", expand=True)
        root.columnconfigure(1, weight=1)
        root.rowconfigure(1, weight=1)

        header = ttk.Frame(root)
        header.grid(row=0, column=0, columnspan=2, sticky="ew", pady=(0, 16))
        header.columnconfigure(1, weight=1)
        self._build_logo(header, subsample=5, background=COLOR_BG).grid(row=0, column=0, rowspan=2, sticky="w", padx=(0, 14))
        ttk.Label(header, text="Duo Builders", style="Title.TLabel").grid(row=0, column=1, sticky="sw")
        ttk.Label(header, text="Construction Management System", style="Subtitle.TLabel").grid(row=1, column=1, sticky="nw")

        sidebar = ttk.Frame(root, style="Sidebar.TFrame", padding=16)
        sidebar.grid(row=1, column=0, sticky="nsw", padx=(0, 16))
        sidebar.rowconfigure(3, weight=1)
        ttk.Label(sidebar, text="Modules", style="Sidebar.TLabel").grid(row=0, column=0, sticky="w", pady=(0, 12))
        ttk.Label(sidebar, text="Choose a workspace area", style="SidebarMuted.TLabel").grid(row=1, column=0, sticky="w", pady=(0, 12))

        self.section_list = tk.Listbox(
            sidebar,
            width=28,
            height=12,
            activestyle="none",
            bg=COLOR_PURPLE_DARK,
            fg="#ffffff",
            selectbackground=COLOR_CYAN,
            selectforeground=COLOR_TEXT,
            highlightthickness=0,
            borderwidth=0,
            font=("Segoe UI", 10),
            relief="flat",
        )
        for section in SECTIONS:
            self.section_list.insert("end", section)
        self.section_list.selection_set(0)
        self.section_list.grid(row=2, column=0, sticky="new", pady=(8, 0))
        self.section_list.bind("<<ListboxSelect>>", self._on_section_selected)

        main = ttk.Frame(root)
        main.grid(row=1, column=1, sticky="nsew")
        main.columnconfigure(0, weight=1)
        main.rowconfigure(1, weight=1)

        self._build_query_panel(main)
        self._build_results_panel(main)

        self.status_var = tk.StringVar(value="Ready")
        ttk.Label(main, textvariable=self.status_var, foreground=COLOR_MUTED).grid(row=2, column=0, sticky="ew", pady=(10, 0))

    def _build_query_panel(self, parent: ttk.Frame) -> None:
        panel = ttk.Frame(parent, style="Panel.TFrame", padding=18)
        panel.grid(row=0, column=0, sticky="ew", pady=(0, 14))
        panel.columnconfigure(1, weight=1)

        ttk.Label(panel, text="Query", style="Panel.TLabel", font=("Segoe UI Semibold", 13)).grid(row=0, column=0, sticky="w")
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
        panel = ttk.Frame(parent, style="Panel.TFrame", padding=18)
        panel.grid(row=1, column=0, sticky="nsew")
        panel.columnconfigure(0, weight=1)
        panel.rowconfigure(1, weight=1)

        top = ttk.Frame(panel, style="Panel.TFrame")
        top.grid(row=0, column=0, sticky="ew", pady=(0, 8))
        top.columnconfigure(0, weight=1)
        ttk.Label(top, text="Results", style="Panel.TLabel", font=("Segoe UI Semibold", 13)).grid(row=0, column=0, sticky="w")
        ttk.Button(top, text="Copy", command=self._copy_results).grid(row=0, column=1, sticky="e")
        ttk.Button(top, text="Clear", command=lambda: self._set_results("")).grid(row=0, column=2, sticky="e", padx=(8, 0))

        text_frame = ttk.Frame(panel, style="Panel.TFrame")
        text_frame.grid(row=1, column=0, sticky="nsew")
        text_frame.columnconfigure(0, weight=1)
        text_frame.rowconfigure(0, weight=1)

        self.results_text = tk.Text(
            text_frame,
            wrap="word",
            bg="#fbfcff",
            fg=COLOR_TEXT,
            insertbackground=COLOR_TEXT,
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
        self.current_section = section
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
            self._load_section_reference()
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

        self._load_section_reference()

    def _load_section_reference(self) -> None:
        reference_operation = SECTION_REFERENCE_OPERATIONS.get(self.current_section)
        if reference_operation is None:
            return

        if self.current_section in self.reference_cache:
            self._set_results(self.reference_cache[self.current_section])
            self.status_var.set("Done")
            return

        if self.current_section in self.loading_reference_sections:
            return

        self.loading_reference_sections.add(self.current_section)
        self.status_var.set("Loading reference list...")
        self._set_results("Loading reference list...")

        thread = threading.Thread(
            target=self._execute_reference_operation,
            args=(self.current_section, reference_operation),
            daemon=True,
        )
        thread.start()
        self.after(100, self._poll_output_queue)

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
            self.output_queue.put((True, str(result), None, False))
        except Exception as exc:
            message = self._format_query_error(exc)
            self.output_queue.put((False, message, None, False))

    def _execute_reference_operation(self, section: str, operation: Operation) -> None:
        try:
            module = self._load_module(operation.module)
            function = getattr(module, operation.function)
            result = function()
            self.output_queue.put((True, str(result), section, True))
        except Exception as exc:
            message = self._format_query_error(exc)
            self.output_queue.put((False, message, section, True))

    def _format_query_error(self, exc: Exception) -> str:
        error_text = str(exc)
        if any(token in error_text for token in ("ORA-", "DPY-", "DPI-", "TNS:")):
            return "Connection failed."

        return "Query failed."

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
            success, output, section, is_reference = self.output_queue.get_nowait()
        except queue.Empty:
            self.after(100, self._poll_output_queue)
            return

        if is_reference and section is not None:
            self.loading_reference_sections.discard(section)
            if success:
                self.reference_cache[section] = output
            if section != self.current_section:
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
