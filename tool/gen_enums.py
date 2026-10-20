"""Write lib/core/api/wire_enums.dart from the backend enum export.

Source of truth: contract-audit/enums.json (written by contract-audit/export_enums.py
from 360ghar-backend/docs/openapi.json). Pass --openapi to read the OpenAPI
document directly instead.

Each Dart enum has:
  - `wire`: the exact value the backend sends and accepts.
  - `fromJson(Object?)`: wire value to enum. An unknown value gives null and is logged.
    There is no fallback to a real value.
  - `toJson()` and static `toJsonValue(X?)`: the wire value, for request bodies.

Run from the app root:

    python3 tool/gen_enums.py
    python3 tool/gen_enums.py --openapi ../../360ghar/360ghar-backend/docs/openapi.json  # path relative to the app root

The script uses the Python standard library only.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

APP = Path(__file__).resolve().parents[1]
# The estate repo is github/360ghar_archived/360-estate-app. The audit is github/360ghar.
DEFAULT_ENUMS = APP.parents[1] / "360ghar" / "contract-audit" / "enums.json"
OUT = APP / "lib" / "core" / "api" / "wire_enums.dart"

# Dart name -> key in enums.json. Named schema enums use the schema name.
# Inline enums (a field or a query key) use the key that export_enums.py writes.
ENUMS: dict[str, str] = {
    "ActivityType": "ActivityItem.type",
    "ApplicationDecision": "RentalApplicationDecision.decision",
    "ApplicationFieldType": "ApplicationFieldType",
    "AppKey": "AppKey",
    "AuthGateNextAction": "AuthGateState.next_action",
    "AuthGateStage": "AuthGateState.stage",
    "BugSeverity": "BugSeverity",
    "BugStatus": "BugStatus",
    "BugType": "BugType",
    "DevicePlatform": "DevicePlatform",
    "DocumentType": "DocumentType",
    "ExpenseCategory": "ExpenseCategory",
    "FurnishingLevel": "FurnishingLevel",
    "IdentifierStatusChannel": "IdentifierStatusResponse.channel",
    "IdentifierStatusNextStep": "IdentifierStatusResponse.next_step",
    "InspectionType": "InspectionType",
    "LeaseStatus": "LeaseStatus",
    "MaintenanceCategory": "MaintenanceCategory",
    "MaintenanceRequestStatus": "MaintenanceRequestStatus",
    "MaintenanceUrgency": "MaintenanceUrgency",
    "ManagedPropertyStatus": "ManagedPropertyStatus",
    "OccupancyFilter": "GET /api/v1/pm/properties query.occupancy",
    "PaymentMethod": "PaymentMethod",
    "PropertyPurpose": "PropertyPurpose",
    "PropertyStatus": "PropertyStatus",
    "PropertyType": "PropertyType",
    "RentChargeStatus": "RentChargeStatus",
    "RentPaymentStatus": "RentPaymentStatus",
    "RentRollOccupancy": "RentRollItem.occupancy",
    "RentalApplicationStatus": "RentalApplicationStatus",
    "StorageFolderType": "StorageFolderType",
    "TenantStatus": "TenantStatus",
    "TourVisibility": "TourVisibility",
    "UserRole": "UserRole",
    "WorkOrderStatus": "WorkOrderStatus",
}

DART_RESERVED = {
    "abstract", "as", "assert", "async", "await", "break", "case", "catch", "class",
    "const", "continue", "default", "do", "else", "enum", "export", "extends", "extension",
    "external", "factory", "false", "final", "finally", "for", "get", "if", "implements",
    "import", "in", "interface", "is", "late", "library", "mixin", "new", "null", "on",
    "operator", "part", "required", "rethrow", "return", "set", "static", "super", "switch",
    "this", "throw", "true", "try", "typedef", "var", "void", "while", "with", "yield",
    "values", "name", "index", "hashCode", "runtimeType", "wire",
}


def member_name(value: str) -> str:
    parts = [p for p in re.split(r"[^0-9A-Za-z]+", value) if p]
    name = parts[0].lower() + "".join(p[:1].upper() + p[1:].lower() for p in parts[1:])
    if name[0].isdigit():
        name = "v" + name
    if name in DART_RESERVED:
        name += "Value"
    return name


def render_enum(dart_name: str, key: str, values: list[str]) -> str:
    members = [(member_name(v), v) for v in values]
    names = [n for n, _ in members]
    if len(set(names)) != len(names):
        raise SystemExit(f"{dart_name}: duplicate Dart member names {names}")
    body = ",\n".join(f"  {n}('{v}')" for n, v in members)
    return f"""/// Wire values of `{key}`.
enum {dart_name} {{
{body};

  const {dart_name}(this.wire);

  /// The exact value the backend sends and accepts.
  final String wire;

  /// Wire value to enum. An unknown value gives null and is logged.
  static {dart_name}? fromJson(Object? value) {{
    if (value == null) return null;
    for (final candidate in values) {{
      if (candidate.wire == value) return candidate;
    }}
    logUnknownWireValue('{dart_name}', value);
    return null;
  }}

  String toJson() => wire;

  static String? toJsonValue({dart_name}? value) => value?.wire;
}}
"""


def load(path: Path | None, openapi: Path | None) -> dict[str, list[str]]:
    if openapi is not None:
        sys.path.insert(0, str(openapi.resolve().parents[2] / "contract-audit"))
        import export_enums  # type: ignore[import-not-found]  # noqa: PLC0415

        tmp = APP / ".enums.tmp.json"
        export_enums.main(str(openapi), str(tmp))
        try:
            return json.loads(tmp.read_text())
        finally:
            tmp.unlink(missing_ok=True)
    return json.loads(path.read_text())


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--enums", type=Path, default=DEFAULT_ENUMS)
    parser.add_argument("--openapi", type=Path, default=None)
    args = parser.parse_args()
    source = load(args.enums, args.openapi)
    chunks = []
    for dart_name in sorted(ENUMS):
        key = ENUMS[dart_name]
        if key not in source:
            raise SystemExit(f"{key} is not in the enum export (needed for {dart_name})")
        chunks.append(render_enum(dart_name, key, source[key]))
    header = (
        "// GENERATED by tool/gen_enums.py from contract-audit/enums.json. Do not edit.\n"
        "// Run: python3 tool/gen_enums.py\n"
        "//\n"
        "// Every enum maps unknown wire values to null (and logs). There is no fallback to a\n"
        "// real value. Send `wire` (or `toJson()`) in request bodies.\n"
        "\n"
        "import 'package:estate_app/core/api/wire_log.dart';\n"
    )
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(header + "\n" + "\n".join(chunks))
    print(f"wrote {OUT.relative_to(APP)} ({len(chunks)} enums)")


if __name__ == "__main__":
    main()
