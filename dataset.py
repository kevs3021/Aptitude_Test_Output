import os
import csv
import hashlib
import re
from flask import Flask, jsonify, request, send_file
from db_connection import get_connection

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CSV_PATH = os.path.join(BASE_DIR, "dataset.csv")
TABLE_NAME = "BarangayCensus"
ACCOUNTS_TABLE = "Accounts"

COLUMNS = [
    ("ID", "INT PRIMARY KEY"),
    ("LastName", "VARCHAR(50)"),
    ("FirstName", "VARCHAR(50)"),
    ("MiddleName", "VARCHAR(50)"),
    ("Age", "INT"),
    ("Sex", "CHAR(1)"),
    ("DateOfBirth", "DATE"),
    ("CivilStatus", "VARCHAR(20)"),
    ("HouseNo", "VARCHAR(20)"),
    ("StreetPurok", "VARCHAR(100)"),
    ("BarangayAddress", "VARCHAR(50)"),
    ("RoleInHH", "VARCHAR(30)"),
    ("Education", "VARCHAR(50)"),
    ("Occupation", "VARCHAR(50)"),
    ("IPStatus", "VARCHAR(30)"),
    ("PWD", "VARCHAR(30)"),
    ("Beneficiary4Ps", "VARCHAR(5)"),
    ("RegisteredVoter", "VARCHAR(5)"),
    ("MonthlyIncome", "DECIMAL(10, 2)"),
    ("Status", "VARCHAR(20) DEFAULT 'enabled'"),
]

ACCOUNTS_COLUMNS = [
    ("AccountID", "INT PRIMARY KEY AUTO_INCREMENT"),
    ("Email", "VARCHAR(100) UNIQUE NOT NULL"),
    ("Username", "VARCHAR(50) UNIQUE NOT NULL"),
    ("HashedPassword", "VARCHAR(255) NOT NULL"),
    ("Status", "VARCHAR(10) DEFAULT 'Enabled'"),
    ("Type", "VARCHAR(10) NOT NULL DEFAULT 'Officer'"),
]

ACTIVITY_TABLE = "ActivityLog"
ACTIVITY_COLUMNS = [
    ("ActivityID", "INT PRIMARY KEY AUTO_INCREMENT"),
    ("TargetTable", "VARCHAR(50) NOT NULL"),
    ("TargetID", "INT NOT NULL"),
    ("ActorAccountID", "INT NOT NULL"),
    ("ActorType", "VARCHAR(10) NOT NULL"),
    ("ActivityType", "VARCHAR(10) NOT NULL"),
    ("ActivityTime", "DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP"),
]

CSV_TO_DB = {
    "ID": "ID",
    "Last Name": "LastName",
    "First Name": "FirstName",
    "Middle Name": "MiddleName",
    "Age": "Age",
    "Sex": "Sex",
    "Date of Birth": "DateOfBirth",
    "Civil Status": "CivilStatus",
    "House No.": "HouseNo",
    "Street / Purok": "StreetPurok",
    "Address (Barangay)": "BarangayAddress",
    "Role in HH": "RoleInHH",
    "Education": "Education",
    "Occupation": "Occupation",
    "IP Status": "IPStatus",
    "PWD": "PWD",
    "4Ps Beneficiary": "Beneficiary4Ps",
    "Registered Voter": "RegisteredVoter",
    "Monthly Income": "MonthlyIncome",
}

NUMERIC_FIELDS = {"ID": int, "Age": int, "MonthlyIncome": float}

app = Flask(__name__, static_folder=".", static_url_path="")


def normalize_value(key, value):
    if key in NUMERIC_FIELDS:
        if value is None or value == "":
            return 0
        try:
            return NUMERIC_FIELDS[key](value)
        except ValueError:
            return 0
    return value if value is not None else ""


def hash_password(password):
    return hashlib.sha256(password.encode("utf-8")).hexdigest()


def is_valid_email(value):
    if not value:
        return False
    return re.match(r"^[^@\s]+@[^@\s]+\.[^@\s]+$", value) is not None


def log_activity(connection, target_table, target_id, actor_account_id, actor_type, activity_type):
    if not actor_account_id or not actor_type:
        return
    cursor = connection.cursor()
    cursor.execute(
        f"""
        INSERT INTO {ACTIVITY_TABLE} (TargetTable, TargetID, ActorAccountID, ActorType, ActivityType)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (target_table, target_id, int(actor_account_id), actor_type, activity_type),
    )
    connection.commit()
    cursor.close()


def init_db():
    connection = get_connection()
    cursor = connection.cursor()
    column_sql = ", ".join([f"{name} {definition}" for name, definition in COLUMNS])
    cursor.execute(f"CREATE TABLE IF NOT EXISTS {TABLE_NAME} ({column_sql})")
    accounts_sql = ", ".join([f"{name} {definition}" for name, definition in ACCOUNTS_COLUMNS])
    cursor.execute(f"CREATE TABLE IF NOT EXISTS {ACCOUNTS_TABLE} ({accounts_sql})")
    activity_sql = ", ".join([f"{name} {definition}" for name, definition in ACTIVITY_COLUMNS])
    cursor.execute(f"CREATE TABLE IF NOT EXISTS {ACTIVITY_TABLE} ({activity_sql})")
    cursor.execute(f"SELECT COUNT(1) FROM {TABLE_NAME}")
    existing = cursor.fetchone()[0]
    if existing == 0 and os.path.exists(CSV_PATH):
        with open(CSV_PATH, newline="", encoding="utf-8") as csv_file:
            reader = csv.DictReader(csv_file)
            for row in reader:
                record = {}
                for csv_key, db_key in CSV_TO_DB.items():
                    record[db_key] = normalize_value(db_key, row.get(csv_key, ""))
                record["Status"] = "enabled"
                columns = ", ".join(record.keys())
                placeholders = ", ".join(["%s"] * len(record))
                values = list(record.values())
                cursor.execute(
                    f"INSERT INTO {TABLE_NAME} ({columns}) VALUES ({placeholders})",
                    values,
                )
        connection.commit()
    cursor.close()
    connection.close()


def fetch_record(connection, record_id):
    cursor = connection.cursor(dictionary=True)
    cursor.execute(f"SELECT * FROM {TABLE_NAME} WHERE ID = %s", (record_id,))
    row = cursor.fetchone()
    cursor.close()
    return dict(row) if row else None


def fetch_account(connection, account_id):
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f"SELECT AccountID, Email, Username, Status, Type FROM {ACCOUNTS_TABLE} WHERE AccountID = %s",
        (account_id,),
    )
    row = cursor.fetchone()
    cursor.close()
    return dict(row) if row else None


@app.get("/")
def serve_index():
    return send_file(os.path.join(BASE_DIR, "index.html"))


@app.get("/login")
def serve_login():
    return send_file(os.path.join(BASE_DIR, "login.html"))


@app.get("/style.css")
def serve_css():
    return send_file(os.path.join(BASE_DIR, "style.css"))


@app.post("/api/login")
def login():
    data = request.get_json() or {}
    identifier = (data.get("identifier") or "").strip()
    password = data.get("password") or ""
    if not identifier or not password:
        return jsonify({"error": "Missing credentials"}), 400
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f"""
        SELECT AccountID, Email, Username, HashedPassword, Status, Type
        FROM {ACCOUNTS_TABLE}
        WHERE Email = %s OR Username = %s
        LIMIT 1
        """,
        (identifier, identifier),
    )
    account = cursor.fetchone()
    cursor.close()
    connection.close()
    if not account:
        return jsonify({"error": "Invalid credentials"}), 401
    if account["Status"] != "Enabled":
        return jsonify({"error": "Account disabled"}), 403
    if account["HashedPassword"] != hash_password(password):
        return jsonify({"error": "Invalid credentials"}), 401
    return jsonify(
        {
            "AccountID": account["AccountID"],
            "Email": account["Email"],
            "Username": account["Username"],
            "Type": account["Type"],
        }
    )


@app.get("/api/records")
def get_records():
    include_disabled = request.args.get("include_disabled", "true").lower() == "true"
    page = request.args.get("page", "1")
    page_size = request.args.get("page_size", "25")
    search_column = request.args.get("search_column", "")
    search_mode = request.args.get("search_mode", "")
    search_value = request.args.get("search_value", "")
    sort_column = request.args.get("sort_column", "ID")
    sort_order = request.args.get("sort_order", "asc").lower()
    try:
        page = max(int(page), 1)
    except ValueError:
        page = 1
    try:
        page_size = min(max(int(page_size), 1), 100)
    except ValueError:
        page_size = 25
    if sort_order not in ("asc", "desc"):
        sort_order = "asc"
    offset = (page - 1) * page_size
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    where_clauses = []
    params = []
    valid_columns = {name for name, _ in COLUMNS}
    if not include_disabled:
        where_clauses.append("Status = 'enabled'")
    if search_column in valid_columns and search_value:
        if search_mode == "text":
            where_clauses.append(f"{search_column} LIKE %s")
            params.append(f"%{search_value}%")
        elif search_mode == "select":
            where_clauses.append(f"{search_column} = %s")
            params.append(search_value)
        elif search_mode == "range":
            min_raw, _, max_raw = search_value.partition(":")
            if min_raw:
                where_clauses.append(f"{search_column} >= %s")
                params.append(float(min_raw))
            if max_raw:
                where_clauses.append(f"{search_column} <= %s")
                params.append(float(max_raw))
    where_sql = f" WHERE {' AND '.join(where_clauses)}" if where_clauses else ""
    count_sql = f"SELECT COUNT(1) AS total FROM {TABLE_NAME}{where_sql}"
    cursor.execute(count_sql, params)
    total = cursor.fetchone()["total"]
    cursor.execute(f"SELECT COUNT(1) AS total FROM {TABLE_NAME} WHERE Status = 'disabled'")
    disabled_total = cursor.fetchone()["total"]
    order_sql = ""
    if sort_column in valid_columns:
        if sort_column == "Sex":
            if sort_order == "asc":
                order_sql = " ORDER BY FIELD(Sex, 'M', 'F')"
            else:
                order_sql = " ORDER BY FIELD(Sex, 'F', 'M')"
        else:
            order_sql = f" ORDER BY {sort_column} {sort_order.upper()}"
    sql = f"SELECT * FROM {TABLE_NAME}{where_sql}{order_sql} LIMIT %s OFFSET %s"
    cursor.execute(sql, (*params, page_size, offset))
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(
        {
            "items": rows,
            "page": page,
            "page_size": page_size,
            "total": total,
            "disabled_total": disabled_total,
        }
    )


@app.get("/api/records/analytics")
def get_records_analytics():
    include_disabled = request.args.get("include_disabled", "true").lower() == "true"
    scope = request.args.get("scope", "page")
    search_column = request.args.get("search_column", "")
    search_mode = request.args.get("search_mode", "")
    search_value = request.args.get("search_value", "")
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    where_clauses = []
    params = []
    valid_columns = {name for name, _ in COLUMNS}
    if not include_disabled:
        where_clauses.append("Status = 'enabled'")
    if scope != "all" and search_column in valid_columns and search_value:
        if search_mode == "text":
            where_clauses.append(f"{search_column} LIKE %s")
            params.append(f"%{search_value}%")
        elif search_mode == "select":
            where_clauses.append(f"{search_column} = %s")
            params.append(search_value)
        elif search_mode == "range":
            min_raw, _, max_raw = search_value.partition(":")
            if min_raw:
                where_clauses.append(f"{search_column} >= %s")
                params.append(float(min_raw))
            if max_raw:
                where_clauses.append(f"{search_column} <= %s")
                params.append(float(max_raw))
    where_sql = f" WHERE {' AND '.join(where_clauses)}" if where_clauses else ""
    cursor.execute(f"SELECT * FROM {TABLE_NAME}{where_sql}", params)
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify({"items": rows})


@app.post("/api/records")
def add_record():
    data = request.get_json() or {}
    actor_id = data.pop("_actor_id", None)
    actor_type = data.pop("_actor_type", None)
    connection = get_connection()
    cursor = connection.cursor()
    next_id = data.get("id")
    if not next_id:
        cursor.execute(f"SELECT COALESCE(MAX(ID), 0) + 1 FROM {TABLE_NAME}")
        next_id = cursor.fetchone()[0]
    record = {"ID": normalize_value("ID", next_id)}
    for column, _ in COLUMNS:
        if column in ("ID", "Status"):
            continue
        record[column] = normalize_value(column, data.get(column, ""))
    record["Status"] = "enabled"
    columns = ", ".join(record.keys())
    placeholders = ", ".join(["%s"] * len(record))
    cursor.execute(
        f"INSERT INTO {TABLE_NAME} ({columns}) VALUES ({placeholders})",
        list(record.values()),
    )
    connection.commit()
    created = fetch_record(connection, record["ID"])
    log_activity(connection, TABLE_NAME, created["ID"], actor_id, actor_type, "Create")
    cursor.close()
    connection.close()
    return jsonify(created), 201


@app.put("/api/records/<int:record_id>")
def update_record(record_id):
    data = request.get_json() or {}
    actor_id = data.pop("_actor_id", None)
    actor_type = data.pop("_actor_type", None)
    connection = get_connection()
    status_cursor = connection.cursor(dictionary=True)
    status_cursor.execute(
        f"SELECT Status FROM {TABLE_NAME} WHERE ID = %s",
        (record_id,),
    )
    current = status_cursor.fetchone()
    status_cursor.close()
    if not current:
        connection.close()
        return jsonify({"error": "Record not found"}), 404
    if str(current["Status"]).lower() == "disabled":
        connection.close()
        return jsonify({"error": "Record is disabled and cannot be edited"}), 403
    fields = [name for name, _ in COLUMNS if name not in ("ID", "Status")]
    values = [normalize_value(field, data.get(field, "")) for field in fields]
    values.append(record_id)
    cursor = connection.cursor()
    set_clause = ", ".join([f"{field} = %s" for field in fields])
    cursor.execute(f"UPDATE {TABLE_NAME} SET {set_clause} WHERE ID = %s", values)
    connection.commit()
    updated = fetch_record(connection, record_id)
    if not updated:
        cursor.close()
        connection.close()
        return jsonify({"error": "Record not found"}), 404
    log_activity(connection, TABLE_NAME, record_id, actor_id, actor_type, "Update")
    cursor.close()
    connection.close()
    return jsonify(updated)


@app.patch("/api/records/<int:record_id>/disable")
def disable_record(record_id):
    data = request.get_json(silent=True) or {}
    actor_id = data.get("_actor_id")
    actor_type = data.get("_actor_type")
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        f"UPDATE {TABLE_NAME} SET Status = 'disabled' WHERE ID = %s", (record_id,)
    )
    connection.commit()
    updated = fetch_record(connection, record_id)
    if not updated:
        cursor.close()
        connection.close()
        return jsonify({"error": "Record not found"}), 404
    log_activity(connection, TABLE_NAME, record_id, actor_id, actor_type, "Disable")
    cursor.close()
    connection.close()
    return jsonify(updated)


@app.get("/api/accounts")
def get_accounts():
    page = request.args.get("page", "1")
    page_size = request.args.get("page_size", "25")
    search_column = request.args.get("search_column", "")
    search_mode = request.args.get("search_mode", "")
    search_value = request.args.get("search_value", "")
    sort_column = request.args.get("sort_column", "AccountID")
    sort_order = request.args.get("sort_order", "asc").lower()
    try:
        page = max(int(page), 1)
    except ValueError:
        page = 1
    try:
        page_size = min(max(int(page_size), 1), 100)
    except ValueError:
        page_size = 25
    if sort_order not in ("asc", "desc"):
        sort_order = "asc"
    offset = (page - 1) * page_size
    valid_columns = {"AccountID", "Email", "Username", "HashedPassword", "Status", "Type"}
    where_clauses = []
    params = []
    if search_column in valid_columns and search_value:
        if search_mode == "select":
            where_clauses.append(f"{search_column} = %s")
            params.append(search_value)
        else:
            where_clauses.append(f"{search_column} LIKE %s")
            params.append(f"%{search_value}%")
    where_sql = f" WHERE {' AND '.join(where_clauses)}" if where_clauses else ""
    order_sql = ""
    if sort_column in valid_columns:
        order_sql = f" ORDER BY {sort_column} {sort_order.upper()}"
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f"SELECT COUNT(1) AS total FROM {ACCOUNTS_TABLE}{where_sql}", params
    )
    total = cursor.fetchone()["total"]
    cursor.execute(
        f"""
        SELECT AccountID, Email, Username, HashedPassword, Status, Type
        FROM {ACCOUNTS_TABLE}{where_sql}{order_sql}
        LIMIT %s OFFSET %s
        """,
        (*params, page_size, offset),
    )
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify(
        {"items": rows, "page": page, "page_size": page_size, "total": total}
    )


@app.post("/api/accounts")
def add_account():
    data = request.get_json() or {}
    actor_id = data.pop("_actor_id", None)
    actor_type = data.pop("_actor_type", None)
    email = data.get("Email", "").strip()
    username = data.get("Username", "").strip()
    password = data.get("Password", "")
    status = "Enabled"
    account_type = "Officer"
    if not email or not username or not password:
        return jsonify({"error": "Missing required fields"}), 400
    if not is_valid_email(email):
        return jsonify({"error": "Invalid email format"}), 400
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f"""
        SELECT AccountID
        FROM {ACCOUNTS_TABLE}
        WHERE Email = %s OR Username = %s
        LIMIT 1
        """,
        (email, username),
    )
    if cursor.fetchone():
        cursor.close()
        connection.close()
        return jsonify({"error": "Email or username already exists"}), 409
    cursor.close()
    cursor = connection.cursor()
    cursor.execute(
        f"""
        INSERT INTO {ACCOUNTS_TABLE} (Email, Username, HashedPassword, Status, Type)
        VALUES (%s, %s, %s, %s, %s)
        """,
        (email, username, hash_password(password), status, account_type),
    )
    connection.commit()
    account_id = cursor.lastrowid
    created = fetch_account(connection, account_id)
    log_activity(connection, ACCOUNTS_TABLE, account_id, actor_id, actor_type, "Create")
    cursor.close()
    connection.close()
    return jsonify(created), 201


@app.put("/api/accounts/<int:account_id>")
def update_account(account_id):
    data = request.get_json() or {}
    actor_id = data.pop("_actor_id", None)
    actor_type = data.pop("_actor_type", None)
    email = data.get("Email", "").strip()
    username = data.get("Username", "").strip()
    password = data.get("Password", "")
    status = data.get("Status")
    account_type = data.get("Type")
    connection = get_connection()
    status_cursor = connection.cursor(dictionary=True)
    status_cursor.execute(
        f"SELECT Status, Type FROM {ACCOUNTS_TABLE} WHERE AccountID = %s",
        (account_id,),
    )
    current = status_cursor.fetchone()
    status_cursor.close()
    if not current:
        connection.close()
        return jsonify({"error": "Account not found"}), 404
    if email and not is_valid_email(email):
        connection.close()
        return jsonify({"error": "Invalid email format"}), 400
    if current["Status"] == "Disabled":
        connection.close()
        return jsonify({"error": "Account is disabled and cannot be edited"}), 403
    if current["Type"] == "Admin":
        account_type = "Admin"
    elif account_type and account_type != "Officer":
        account_type = "Officer"
    fields = []
    values = []
    if email:
        fields.append("Email = %s")
        values.append(email)
    if username:
        fields.append("Username = %s")
        values.append(username)
    if password:
        fields.append("HashedPassword = %s")
        values.append(hash_password(password))
    if status:
        fields.append("Status = %s")
        values.append(status)
    if account_type:
        fields.append("Type = %s")
        values.append(account_type)
    if not fields:
        connection.close()
        return jsonify({"error": "No fields to update"}), 400
    values.append(account_id)
    cursor = connection.cursor()
    cursor.execute(
        f"UPDATE {ACCOUNTS_TABLE} SET {', '.join(fields)} WHERE AccountID = %s",
        values,
    )
    connection.commit()
    updated = fetch_account(connection, account_id)
    if not updated:
        cursor.close()
        connection.close()
        return jsonify({"error": "Account not found"}), 404
    log_activity(connection, ACCOUNTS_TABLE, account_id, actor_id, actor_type, "Update")
    cursor.close()
    connection.close()
    return jsonify(updated)


@app.patch("/api/accounts/<int:account_id>/disable")
def disable_account(account_id):
    data = request.get_json(silent=True) or {}
    actor_id = data.get("_actor_id")
    actor_type = data.get("_actor_type")
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(
        f"UPDATE {ACCOUNTS_TABLE} SET Status = 'Disabled' WHERE AccountID = %s",
        (account_id,),
    )
    connection.commit()
    updated = fetch_account(connection, account_id)
    if not updated:
        cursor.close()
        connection.close()
        return jsonify({"error": "Account not found"}), 404
    log_activity(connection, ACCOUNTS_TABLE, account_id, actor_id, actor_type, "Disable")
    cursor.close()
    connection.close()
    return jsonify(updated)


@app.get("/api/metadata")
def get_metadata():
    column_keys = [name for name, _ in COLUMNS]
    numeric_keys = ["Age", "MonthlyIncome"]
    text_keys = [
        key for key in column_keys if key not in numeric_keys and key not in ("Status",)
    ]
    return jsonify(
        {"columns": column_keys, "numeric_columns": numeric_keys, "text_columns": text_keys}
    )


@app.get("/api/activity")
def get_activity():
    page = int(request.args.get("page", "1"))
    page_size = int(request.args.get("pageSize", "25"))
    
    # Validate parameters
    page = max(1, page)
    page_size = max(1, min(page_size, 100))
    
    offset = (page - 1) * page_size
    
    connection = get_connection()
    cursor = connection.cursor(dictionary=True)
    
    # Get total count
    cursor.execute(f"SELECT COUNT(1) as total FROM {ACTIVITY_TABLE}")
    total = cursor.fetchone()["total"]
    
    # Get paginated results
    cursor.execute(
        f"""
        SELECT ActivityID, TargetID, ActorAccountID, ActorType, ActivityType, ActivityTime
        FROM {ACTIVITY_TABLE}
        ORDER BY ActivityTime DESC, ActivityID DESC
        LIMIT %s OFFSET %s
        """,
        (page_size, offset),
    )
    rows = cursor.fetchall()
    cursor.close()
    connection.close()
    return jsonify({
        "items": rows,
        "total": total,
        "page": page,
        "pageSize": page_size,
        "totalPages": (total + page_size - 1) // page_size
    })


@app.get("/api/stats")
def get_stats():
    connection = get_connection()
    cursor = connection.cursor()
    cursor.execute(f"SELECT COUNT(1) FROM {TABLE_NAME}")
    total = cursor.fetchone()[0]
    cursor.execute(f"SELECT COUNT(1) FROM {TABLE_NAME} WHERE Status = 'enabled'")
    enabled = cursor.fetchone()[0]
    cursor.execute(f"SELECT COUNT(1) FROM {TABLE_NAME} WHERE Status = 'disabled'")
    disabled = cursor.fetchone()[0]
    cursor.close()
    connection.close()
    return jsonify({"total": total, "enabled": enabled, "disabled": disabled})


init_db()

if __name__ == "__main__":
    app.run(debug=True)
