"""Write backend-shaped API fixtures for the estate app's contract tests.

Each fixture is built by validating sample data through the backend's own Pydantic response
model and dumping it the way FastAPI does (`mode="json"`, `by_alias=True`). The output
therefore carries every field, default and alias the backend really sends.

The script also dumps the request schemas the app writes (`request_schemas.json`): the
property names and the required names of each body. The contract tests check that every
request body the app builds sends only declared keys and sends every required key.

It also dumps `routes.json`, the route contract of every route the app can call, read from
the backend's `docs/openapi.json`: the declared query keys (with enum values and the `limit`
maximum) and the body keys, required keys and enum values. `test/contract/requests_test.dart`
runs each repository method against a recording HTTP adapter and checks the real request
(method, path, query, body) against it.

Run from the app root with the backend environment:

    uv run --project ../../360ghar/360ghar-backend python tool/api_fixtures.py

(From the workspace root the backend is `github/360ghar/360ghar-backend`.) It imports
schemas only: no app start-up, no database, no network.
"""

from __future__ import annotations

import json
import os
import sys
from pathlib import Path

APP = Path(__file__).resolve().parents[1]
# The estate repo is github/360ghar_archived/360-estate-app. The backend is github/360ghar/360ghar-backend.
BACKEND = Path(os.environ.get("GHAR_BACKEND_DIR") or APP.parents[1] / "360ghar" / "360ghar-backend")
OUT = APP / "test" / "fixtures" / "api"
sys.path.insert(0, str(BACKEND))

from app.api.api_v1.endpoints.auth import IdentifierStatusResponse  # noqa: E402
from app.api.api_v1.endpoints.notifications import (  # noqa: E402
    DeliveryReadOut,
    DeviceRegisterIn,
    NotificationPage,
)
from app.infrastructure.errors import (  # noqa: E402
    ErrorEnvelope,
    ValidationErrorEnvelope,
)
from app.schemas.agent import Agent  # noqa: E402
from app.schemas.amenity import Amenity  # noqa: E402
from app.schemas.core import BugReportCreate, BugReportResponse  # noqa: E402
from app.schemas.pagination import CursorPage  # noqa: E402
from app.schemas.pm_application import (  # noqa: E402
    PublicRentalApplicationForm,
    PublicRentalApplicationSubmitted,
    RentalApplication,
    RentalApplicationDecision,
    RentalApplicationForm,
    RentalApplicationFormCreate,
    RentalApplicationSubmit,
)
from app.schemas.pm_dashboard import ActivityItem, DashboardOverview  # noqa: E402
from app.schemas.pm_document import Document, DocumentDownload  # noqa: E402
from app.schemas.pm_expense import Expense, ExpenseCreate, ExpenseUpdate  # noqa: E402
from app.schemas.pm_inspection import (  # noqa: E402
    InspectionChecklist,
    InspectionChecklistCreate,
    InspectionSign,
)
from app.schemas.pm_lease import (  # noqa: E402
    Lease,
    LeaseCreate,
    LeaseRenew,
    LeaseTerminate,
    LeaseUploadSigned,
)
from app.schemas.pm_maintenance import (  # noqa: E402
    MaintenanceRequest,
    MaintenanceRequestCreate,
    MaintenanceRequestUpdate,
)
from app.schemas.pm_property import (  # noqa: E402
    ManagedPropertyCreate,
    ManagedPropertyDetail,
    ManagedPropertyUpdate,
)
from app.schemas.pm_rent import (  # noqa: E402
    RentChargeGenerateRequest,
    RentChargeGenerateResult,
    RentChargeWithTotals,
    RentPayment,
    RentPaymentCreate,
)
from app.schemas.pm_report import (  # noqa: E402
    ExpenseReport,
    IncomeReport,
    MaintenanceReport,
    OccupancyReport,
    PnLReport,
    RentRollItem,
)
from app.schemas.pm_tenant import TenantDetail, TenantSummary  # noqa: E402
from app.schemas.property import Property  # noqa: E402
from app.schemas.storage import UploadResult  # noqa: E402
from app.schemas.user import AuthGateState, SelfUser, UserUpdate  # noqa: E402

NOW = "2026-10-01T10:15:02Z"
LATER = "2026-10-02T08:00:00Z"


def dump(model_cls, data):
    return model_cls.model_validate(data).model_dump(mode="json", by_alias=True)


def page(model_cls, items, *, next_cursor=None, limit=20, total=None):
    return dump(
        CursorPage[model_cls],
        {
            "items": items,
            "next_cursor": next_cursor,
            "has_more": next_cursor is not None,
            "limit": limit,
            "total": total,
        },
    )


def prop(pid: int, **extra):
    base = {
        "id": pid,
        "owner_id": 7,
        "title": f"2 BHK Sector {50 + pid}",
        "description": "Managed flat with two balconies.",
        "property_type": "apartment",
        "purpose": "rent",
        "status": "available",
        "base_price": 32_000,
        "monthly_rent": 32_000,
        "security_deposit": 64_000,
        "latitude": 28.4231,
        "longitude": 77.0851,
        "city": "Gurugram",
        "state": "Haryana",
        "pincode": "122002",
        "locality": f"Sector {50 + pid}",
        "full_address": f"Tower {pid}, Sector {50 + pid}, Gurugram",
        "area_sqft": 1180.5,
        "bedrooms": 2,
        "bathrooms": 2,
        "balconies": 2,
        "furnishing_level": "semi_furnished",
        "is_available": True,
        "view_count": 0,
        "like_count": 0,
        "interest_count": 0,
        "is_managed": True,
        "management_status": "active",
        "payment_due_day": 5,
        "grace_period_days": 3,
        "late_fee_policy": {"type": "fixed", "amount": 500},
        "created_at": NOW,
        "updated_at": NOW,
        "main_image_url": f"https://cdn.example.com/p{pid}/main.jpg",
        "images": [
            {"id": pid * 10 + 1, "property_id": pid, "image_url": f"https://cdn.example.com/p{pid}/hall.jpg",
             "image_category": "hall", "display_order": 0, "is_main_image": True},
            {"id": pid * 10 + 2, "property_id": pid, "image_url": f"https://cdn.example.com/p{pid}/kitchen.jpg",
             "image_category": "kitchen", "display_order": 1},
        ],
        "floor_plans": [
            {"id": pid * 10 + 3, "property_id": pid, "image_url": f"https://cdn.example.com/p{pid}/plan.jpg",
             "image_category": "floor_plan", "display_order": 0},
        ],
        "amenities": [
            {"id": 1, "title": "Power Backup", "icon": "battery", "category": "utilities"},
            {"id": 2, "title": "Lift", "icon": "lift", "category": "building"},
        ],
    }
    base.update(extra)
    return base


def lease(lid: int = 31, **extra):
    base = {
        "id": lid,
        "property_id": 1,
        "owner_id": 7,
        "tenant_user_id": 52,
        "tenant_name": "Meera Nair",
        "tenant_phone": "+919811112222",
        "tenant_email": "meera@example.com",
        "status": "active",
        "start_date": "2026-04-01",
        "end_date": "2027-03-31",
        "monthly_rent": 32_000,
        "security_deposit": 64_000,
        "late_fee_amount": 500,
        "late_fee_percentage": None,
        "grace_period_days": 3,
        "payment_due_day": 5,
        "signed_by_owner_at": NOW,
        "lease_document_id": 9,
        "created_at": NOW,
        "updated_at": NOW,
    }
    base.update(extra)
    return base


def charge(cid: int, status: str = "pending", **extra):
    base = {
        "charge": {
            "id": cid,
            "lease_id": 31,
            "property_id": 1,
            "owner_id": 7,
            "tenant_user_id": 52,
            "billing_month": "2026-10-01",
            "period_start": "2026-10-01",
            "period_end": "2026-10-31",
            "due_date": "2026-10-05",
            "amount_due": 32_000,
            "late_fee_assessed": 0,
            "status": status,
            "created_at": NOW,
        },
        "amount_paid_total": 12_000.5,
        "amount_due_total": 32_000,
        "outstanding": 19_999.5,
    }
    base.update(extra)
    return base


def fixtures():
    return {
        "properties": {
            "list_page": page(Property, [prop(1), prop(2, management_status="archived", floor_plans=[])],
                              next_cursor="eyJrIjpbIjIwMjYtMTAtMDEiLDJdLCJmIjoiYWJjIn0"),
            "list_last_page": page(Property, [prop(3, management_status="draft")]),
            "detail": dump(ManagedPropertyDetail, {"property": prop(1), "active_lease": lease()}),
            "detail_vacant": dump(ManagedPropertyDetail, {"property": prop(2), "active_lease": None}),
            "created": dump(Property, prop(4)),
        },
        "leases": {
            "list_page": page(
                Lease,
                [
                    lease(31),
                    lease(32, status="expiring_soon", end_date="2026-10-20"),
                    lease(33, status="pending_signature", lease_document_id=None, signed_by_owner_at=None),
                ],
                next_cursor="eyJrIjpbMzNdLCJmIjoiYWJjIn0",
            ),
            "list_last_page": page(Lease, [lease(34, status="expired", end_date="2026-09-30")]),
            "detail": dump(Lease, lease(31)),
            "terminated": dump(
                Lease,
                lease(35, status="terminated", termination_date="2026-09-15", termination_reason="Moved out"),
            ),
            "upload_signed": dump(Lease, lease(33, status="active", signed_by_owner_at=NOW, signed_by_tenant_at=NOW)),
        },
        "rent": {
            "charges_page": page(
                RentChargeWithTotals,
                [charge(101), charge(102, "partial"), charge(103, "overdue")],
                next_cursor="eyJrIjpbMTAzXSwiZiI6ImFiYyJ9",
                limit=100,
            ),
            "charges_last_page": page(
                RentChargeWithTotals,
                [charge(104, "paid", amount_paid_total=32_000, outstanding=0), charge(105, "waived", outstanding=0)],
                limit=100,
            ),
            "payment": dump(
                RentPayment,
                {
                    "id": 201,
                    "charge_id": 101,
                    "lease_id": 31,
                    "property_id": 1,
                    "owner_id": 7,
                    "tenant_user_id": 52,
                    "paid_at": NOW,
                    "amount_paid": 12_000.5,
                    "payment_method": "upi",
                    "status": "settled",
                    "reference": "UPI-1182",
                    "created_at": NOW,
                },
            ),
            "generate_result": dump(RentChargeGenerateResult, {"created": 3, "skipped": 1}),
        },
        "inspections": {
            "list_page": page(
                InspectionChecklist,
                [
                    {
                        "id": 61,
                        "property_id": 1,
                        "lease_id": 31,
                        "owner_id": 7,
                        "inspection_type": "move_in",
                        "conducted_by_user_id": 7,
                        "conducted_at": NOW,
                        "rooms_data": {"items": [{"title": "Front door lock", "status": "pass", "notes": None}]},
                        "overall_notes": "All good",
                        "signed_by_tenant_at": NOW,
                        "created_at": NOW,
                    },
                    {
                        "id": 62,
                        "property_id": 1,
                        "lease_id": 31,
                        "owner_id": 7,
                        "inspection_type": "routine",
                        "conducted_by_user_id": 7,
                        "conducted_at": LATER,
                        "rooms_data": None,
                        "created_at": LATER,
                    },
                ],
            ),
            "detail": dump(
                InspectionChecklist,
                {
                    "id": 61,
                    "property_id": 1,
                    "lease_id": 31,
                    "owner_id": 7,
                    "inspection_type": "move_out",
                    "conducted_by_user_id": 7,
                    "conducted_at": NOW,
                    "rooms_data": {"items": [{"title": "Walls", "status": "fair", "notes": "Scuffs"}]},
                    "signed_by_tenant_at": NOW,
                    "signed_by_owner_at": NOW,
                    "created_at": NOW,
                },
            ),
        },
        "maintenance": {
            "list_page": page(
                MaintenanceRequest,
                [
                    {
                        "id": 71,
                        "property_id": 1,
                        "property_title": "2 BHK Sector 51",
                        "lease_id": 31,
                        "owner_id": 7,
                        "tenant_user_id": 52,
                        "tenant_name": "Meera Nair",
                        "category": "plumbing",
                        "urgency": "emergency",
                        "title": "Kitchen tap leaking",
                        "description": "Water pooling under the sink.",
                        "request_status": "work_order_created",
                        "assigned_agent_id": 12,
                        "work_order_status": "assigned",
                        "estimated_cost": 1800,
                        "scheduled_for": LATER,
                        "created_at": NOW,
                    },
                    {
                        "id": 72,
                        "property_id": 2,
                        "owner_id": 7,
                        "category": "pest_control",
                        "urgency": "low",
                        "title": "Ants in the balcony",
                        "request_status": "in_review",
                        "created_at": NOW,
                    },
                ],
                next_cursor="eyJrIjpbNzJdLCJmIjoiYWJjIn0",
                limit=100,
            ),
        },
        "expenses": {
            "list_page": page(
                Expense,
                [
                    {
                        "id": 81,
                        "property_id": 1,
                        "property_name": "2 BHK Sector 51",
                        "owner_id": 7,
                        "category": "property_tax",
                        "title": "Q2 property tax",
                        "amount": 14_250.75,
                        "expense_date": "2026-09-30",
                        "notes": "Paid online",
                        "created_at": NOW,
                    },
                    {
                        "id": 82,
                        "property_id": 2,
                        "owner_id": 7,
                        "category": "repairs",
                        "title": None,
                        "amount": 900,
                        "expense_date": "2026-09-12",
                        "created_at": NOW,
                    },
                ],
                next_cursor="eyJrIjpbODJdLCJmIjoiYWJjIn0",
            ),
        },
        "tenants": {
            "list_page": page(
                TenantSummary,
                [
                    {"user_id": 52, "full_name": "Meera Nair", "phone": "+919811112222",
                     "email": "meera@example.com", "status": "active", "property_name": "2 BHK Sector 51",
                     "active_leases_count": 1},
                    {"user_id": 53, "full_name": None, "phone": None, "email": None, "status": "vacated",
                     "property_name": None, "active_leases_count": 0},
                ],
                limit=100,
            ),
            "detail": dump(
                TenantDetail,
                {"user_id": 52, "full_name": "Meera Nair", "phone": "+919811112222",
                 "email": "meera@example.com", "leases": [lease(31), lease(34, status="expired")]},
            ),
        },
        "documents": {
            "list_page": page(
                Document,
                [
                    {
                        "id": 91,
                        "owner_id": 7,
                        "property_id": 1,
                        "lease_id": 31,
                        "document_type": "lease_agreement",
                        "title": "Lease 2026",
                        "file_url": "https://res.example.com/signed/lease-2026.pdf",
                        "mime_type": "application/pdf",
                        "file_size": 120_300,
                        "shared_with_tenant": True,
                        "shared_with_agent": False,
                        "created_at": NOW,
                    },
                    {
                        "id": 92,
                        "owner_id": 7,
                        "document_type": "receipt",
                        "title": "Tax receipt",
                        "file_url": None,
                        "shared_with_tenant": False,
                        "shared_with_agent": False,
                        "created_at": NOW,
                    },
                ],
                next_cursor="eyJrIjpbOTJdLCJmIjoiYWJjIn0",
            ),
            "download": dump(DocumentDownload, {"url": "https://res.example.com/signed/lease-2026.pdf?sig=abc"}),
        },
        "dashboard": {
            "overview": dump(
                DashboardOverview,
                {
                    "total_properties": 12,
                    "occupied_properties": 9,
                    "vacant_properties": 2,
                    "under_maintenance_properties": 1,
                    "monthly_revenue_current": 284_500.5,
                    "monthly_revenue_previous": 261_000,
                    "outstanding_rent_total": 48_000,
                    "upcoming_expenses_total": 15_300.25,
                },
            ),
            "activity_page": page(
                ActivityItem,
                [
                    {"type": "rent_payment", "at": NOW, "title": "Rent received", "description": "Rs 32,000 from Meera Nair",
                     "id": 201, "property_id": 1, "lease_id": 31, "amount": 32_000, "status": "settled"},
                    {"type": "maintenance_request", "at": LATER, "title": "New request", "description": None,
                     "id": 71, "property_id": 1},
                    {"type": "lease", "at": LATER, "title": "Lease expiring soon"},
                ],
            ),
        },
        "applications": {
            "forms_page": page(
                RentalApplicationForm,
                [
                    {
                        "id": 41,
                        "owner_id": 7,
                        "property_id": 1,
                        "property_name": "2 BHK Sector 51",
                        "property_address": "Tower 1, Sector 51, Gurugram",
                        "title": "Apply for Sector 51",
                        "description": "Two bedroom flat.",
                        "slug": "sector-51-abc",
                        "is_active": True,
                        "expires_at": "2026-12-31T18:29:59Z",
                        "application_fee_amount": 500,
                        "custom_fields": [
                            {"id": "pets", "label": "Do you have pets?", "field_type": "boolean", "is_required": True},
                            {"id": "move_in", "label": "Move in date", "field_type": "date"},
                            {"id": "job", "label": "Occupation", "field_type": "select", "is_required": True,
                             "options": ["Salaried", "Self employed"]},
                        ],
                        "created_at": NOW,
                    },
                    {"id": 42, "owner_id": 7, "title": "General form", "slug": "general-xyz", "is_active": False,
                     "created_at": NOW},
                ],
            ),
            "form": dump(
                RentalApplicationForm,
                {
                    "id": 41,
                    "owner_id": 7,
                    "property_id": 1,
                    "title": "Apply for Sector 51",
                    "slug": "sector-51-abc",
                    "is_active": True,
                    "custom_fields": [{"id": "pets", "label": "Do you have pets?", "field_type": "boolean"}],
                    "created_at": NOW,
                },
            ),
            "public_form": dump(
                PublicRentalApplicationForm,
                {
                    "slug": "sector-51-abc",
                    "title": "Apply for Sector 51",
                    "description": "Two bedroom flat.",
                    "property_id": 1,
                    "property_name": "2 BHK Sector 51",
                    "property_address": "Tower 1, Sector 51, Gurugram",
                    "application_fee_amount": 500,
                    "expires_at": "2026-12-31T18:29:59Z",
                    "custom_fields": [
                        {"id": "pets", "label": "Do you have pets?", "field_type": "boolean", "is_required": True},
                        {"id": "job", "label": "Occupation", "field_type": "select", "options": ["Salaried", "Other"]},
                    ],
                },
            ),
            "submitted": dump(PublicRentalApplicationSubmitted, {"id": 301, "status": "applicant", "submitted_at": NOW}),
            "inbox_page": page(
                RentalApplication,
                [
                    {
                        "id": 301,
                        "form_id": 41,
                        "property_id": 1,
                        "property_name": "2 BHK Sector 51",
                        "property_address": "Tower 1, Sector 51, Gurugram",
                        "owner_id": 7,
                        "status": "applicant",
                        "applicant_full_name": "Karan Mehta",
                        "applicant_phone": "+919822223333",
                        "applicant_email": "karan@example.com",
                        "answers": {"pets": True, "job": "Salaried"},
                        "application_data": {"notes": "Need parking"},
                        "submitted_at": NOW,
                        "created_at": NOW,
                    },
                    {
                        "id": 302,
                        "form_id": 41,
                        "property_id": 1,
                        "owner_id": 7,
                        "status": "rejected",
                        "applicant_full_name": "Isha Rao",
                        "decision_notes": "Income proof missing",
                        "decision_at": LATER,
                        "decided_by_user_id": 7,
                        "submitted_at": NOW,
                        "created_at": NOW,
                    },
                ],
                next_cursor="eyJrIjpbMzAyXSwiZiI6ImFiYyJ9",
            ),
            "detail": dump(
                RentalApplication,
                {
                    "id": 301,
                    "form_id": 41,
                    "property_id": 1,
                    "owner_id": 7,
                    "status": "approved",
                    "applicant_full_name": "Karan Mehta",
                    "answers": {"pets": False},
                    "application_data": {"notes": "Need parking"},
                    "decision_notes": "Welcome",
                    "decision_at": LATER,
                    "decided_by_user_id": 7,
                    "submitted_at": NOW,
                    "created_at": NOW,
                },
            ),
        },
        "reports": {
            "rent_roll_page": page(
                RentRollItem,
                [
                    {"property_id": 1, "title": "2 BHK Sector 51", "occupancy": "occupied", "tenant_user_id": 52,
                     "monthly_rent": 32_000, "lease_end_date": "2027-03-31"},
                    {"property_id": 2, "title": "1 BHK Sector 52", "occupancy": "vacant"},
                ],
                limit=100,
            ),
            "income": dump(IncomeReport, {"total_income": 284_500.5, "start": "2026-10-01", "end": "2026-10-31"}),
            "income_all_time": dump(IncomeReport, {"total_income": 1_000_000}),
            "expenses": dump(ExpenseReport, {"total_expenses": 15_300.25, "start": "2026-10-01", "end": "2026-10-31"}),
            "pnl": dump(
                PnLReport,
                {"total_income": 284_500.5, "total_expenses": 15_300.25, "net_income": 269_200.25,
                 "start": "2026-10-01", "end": "2026-10-31"},
            ),
            "occupancy": dump(OccupancyReport, {"total": 12, "occupied": 9, "vacant": 3}),
            "maintenance": dump(MaintenanceReport, {"total_requests": 7}),
        },
        "notifications": {
            "inbox_page": dump(
                NotificationPage,
                {
                    "items": [
                        {"id": "d-1001", "type": "rent_due", "title": "Rent due", "body": "Rent is due on 5 Oct.",
                         "data": {"route": "/collections"}, "created_at": NOW, "read_at": None},
                        {"id": "d-1000", "type": None, "title": "Welcome", "body": "Hello", "data": None,
                         "created_at": LATER, "read_at": LATER},
                    ],
                    "next_cursor": "eyJrIjpbIjIwMjYtMTAtMDEiLCJkLTEwMDAiXSwiZiI6ImFiYyJ9",
                    "has_more": True,
                    "limit": 50,
                    "total": None,
                    "unread_count": 1,
                },
            ),
            "inbox_last_page": dump(
                NotificationPage,
                {"items": [], "next_cursor": None, "has_more": False, "limit": 50, "total": None, "unread_count": 0},
            ),
            "opened": dump(DeliveryReadOut, {"delivery_id": "d-1001", "read_at": NOW}),
        },
        "users": {
            "profile": dump(
                SelfUser,
                {
                    "id": 7,
                    "supabase_user_id": "0f5e8d9a-1c2b-4d3e-8f7a-6b5c4d3e2f1a",
                    "email": "owner@example.com",
                    "phone": "+919800000000",
                    "full_name": "Asha Verma",
                    "date_of_birth": "1988-04-02",
                    "role": "user",
                    "is_active": True,
                    "is_verified": True,
                    "profile_image_url": "https://cdn.example.com/u7.webp",
                    "created_at": NOW,
                },
            ),
            "auth_gate": dump(
                AuthGateState,
                {"stage": "profile_completion", "next_action": "complete_profile", "missing_fields": ["full_name"]},
            ),
            "identifier_status": dump(
                IdentifierStatusResponse,
                {"exists": True, "verified": True, "has_password": False, "channel": "phone", "next_step": "otp"},
            ),
            "bug": dump(
                BugReportResponse,
                {"id": 3, "user_id": 7, "source": "mobile", "bug_type": "feature_request", "severity": "low",
                 "status": "open", "title": "Add dark map", "description": "Please.", "steps_to_reproduce": None,
                 "expected_behavior": None, "actual_behavior": None, "device_info": None, "app_version": "1.0.0",
                 "media_urls": None, "tags": None, "assigned_to": None, "resolution": None, "resolved_at": None,
                 "created_at": NOW, "updated_at": None},
            ),
        },
        "amenities": {
            "page": page(
                Amenity,
                [
                    {"id": 1, "title": "Power Backup", "icon": "battery", "category": "utilities",
                     "is_active": True, "created_at": NOW, "updated_at": NOW},
                    {"id": 2, "title": "Lift", "icon": None, "category": None,
                     "is_active": True, "created_at": NOW, "updated_at": NOW},
                ],
                next_cursor="eyJrIjpbMl0sImYiOiJhYmMifQ",
                limit=100,
            ),
        },
        "agents": {
            "assigned": dump(
                Agent,
                {"id": 12, "name": "Ravi Kumar", "agent_type": "general", "experience_level": "intermediate",
                 "is_active": True, "is_available": True, "total_users_assigned": 4,
                 "user_satisfaction_rating": 4.5, "created_at": NOW},
            ),
        },
        "uploads": {
            "upload_result": dump(
                UploadResult,
                {"file_path": "ghar/uploads/7/abc", "public_url": "https://res.example.com/ghar/uploads/7/abc.jpg",
                 "file_type": "image", "file_size": 20_480, "content_type": "image/jpeg",
                 "original_filename": "front.jpg", "media": None},
            ),
        },
        "errors": {
            "not_found": dump(ErrorEnvelope, {"error": {"code": "NOT_FOUND", "message": "Lease not found"}}),
            "forbidden": dump(ErrorEnvelope, {"error": {"code": "USER_INACTIVE", "message": "Account is inactive"}}),
            "token_invalid": dump(ErrorEnvelope, {"error": {"code": "TOKEN_INVALID", "message": "Token has expired"}}),
            "bad_request": dump(
                ErrorEnvelope,
                {"error": {"code": "BAD_REQUEST", "message": "Payment amount (900.00) exceeds outstanding balance (500.00)",
                           "details": {"outstanding": "500.00"}}},
            ),
            "rate_limited": dump(ErrorEnvelope, {"error": {"code": "RATE_LIMITED", "message": "Too many requests"}}),
            "validation": dump(
                ValidationErrorEnvelope,
                {
                    "error": {
                        "code": "VALIDATION_ERROR",
                        "message": "Request validation failed",
                        "details": {
                            "fields": [
                                {"field": "body.monthly_rent", "msg": "Input should be greater than 0",
                                 "type": "greater_than"},
                                {"field": "body.start_date", "msg": "Field required", "type": "missing"},
                            ]
                        },
                    }
                },
            ),
            "invalid_cursor": dump(
                ValidationErrorEnvelope,
                {"error": {"code": "INVALID_CURSOR", "message": "Invalid cursor", "details": {"fields": []}}},
            ),
        },
    }


# The request bodies the app writes. Each entry: name -> pydantic model. The dump is the set
# of property names and required names, plus whether unknown keys are refused.
REQUEST_SCHEMAS = {
    "ManagedPropertyCreate": ManagedPropertyCreate,
    "ManagedPropertyUpdate": ManagedPropertyUpdate,
    "LeaseCreate": LeaseCreate,
    "LeaseRenew": LeaseRenew,
    "LeaseTerminate": LeaseTerminate,
    "LeaseUploadSigned": LeaseUploadSigned,
    "RentChargeGenerateRequest": RentChargeGenerateRequest,
    "RentPaymentCreate": RentPaymentCreate,
    "InspectionChecklistCreate": InspectionChecklistCreate,
    "InspectionSign": InspectionSign,
    "MaintenanceRequestCreate": MaintenanceRequestCreate,
    "MaintenanceRequestUpdate": MaintenanceRequestUpdate,
    "ExpenseCreate": ExpenseCreate,
    "ExpenseUpdate": ExpenseUpdate,
    "RentalApplicationFormCreate": RentalApplicationFormCreate,
    "RentalApplicationDecision": RentalApplicationDecision,
    "RentalApplicationSubmit": RentalApplicationSubmit,
    "DeviceRegisterIn": DeviceRegisterIn,
    "UserUpdate": UserUpdate,
    "BugReportCreate": BugReportCreate,
}


def request_schemas():
    out = {}
    for name, model in REQUEST_SCHEMAS.items():
        schema = model.model_json_schema()
        out[name] = {
            "properties": sorted(schema.get("properties", {})),
            "required": sorted(schema.get("required", [])),
            "strict": schema.get("additionalProperties") is False,
        }
    return out


# Routes the app can call, by path prefix (without /api/v1).
ROUTE_PREFIXES = (
    "/pm/",
    "/notifications/",
    "/users/me",
    "/users/profile",
    "/auth/",
    "/amenities",
    "/agents/assigned",
    "/upload",
    "/bugs",
)


def routes():
    """Route contract from docs/openapi.json: query keys, body keys, enum values."""
    spec = json.loads((BACKEND / "docs" / "openapi.json").read_text())
    schemas = spec["components"]["schemas"]

    def resolve(schema):
        while isinstance(schema, dict) and "$ref" in schema:
            schema = schemas[schema["$ref"].rsplit("/", 1)[-1]]
        if isinstance(schema, dict) and "anyOf" in schema:
            options = [o for o in schema["anyOf"] if o.get("type") != "null"]
            if len(options) == 1:
                return resolve(options[0])
        return schema

    def enum_of(schema):
        schema = resolve(schema)
        if "enum" in schema:
            return list(schema["enum"])
        if schema.get("type") == "array":
            return enum_of(schema.get("items", {}))
        return None

    def kind_of(schema):
        """JSON type and format of a property: `integer`, `number`, `string:date`, ..."""
        schema = resolve(schema)
        kind = schema.get("type")
        if kind is None:
            return None
        return f"{kind}:{schema['format']}" if "format" in schema else kind

    out = {}
    for path, item in sorted(spec["paths"].items()):
        short = path.removeprefix("/api/v1")
        if not short.startswith(ROUTE_PREFIXES):
            continue
        for method, op in item.items():
            if method not in ("get", "post", "put", "patch", "delete"):
                continue
            query = {}
            for param in op.get("parameters", []):
                if param["in"] != "query":
                    continue
                entry = {}
                schema = resolve(param["schema"])
                values = enum_of(param["schema"])
                if values is not None:
                    entry["enum"] = values
                if kind_of(param["schema"]):
                    entry["kind"] = kind_of(param["schema"])
                if "maximum" in schema:
                    entry["maximum"] = schema["maximum"]
                query[param["name"]] = entry
            body = None
            request_body = op.get("requestBody")
            if request_body:
                content_type, media = next(iter(request_body["content"].items()))
                schema = resolve(media["schema"])
                properties = schema.get("properties", {})
                body = {
                    "content_type": content_type,
                    "required_body": bool(request_body.get("required")),
                    "properties": sorted(properties),
                    "required": sorted(schema.get("required", [])),
                    "strict": schema.get("additionalProperties") is False,
                    "enums": {
                        name: values
                        for name, prop in properties.items()
                        if (values := enum_of(prop)) is not None
                    },
                    "kinds": {
                        name: kind
                        for name, prop in properties.items()
                        if (kind := kind_of(prop)) is not None
                    },
                }
            out[f"{method.upper()} {short}"] = {"query": query, "body": body}
    return out


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    data = fixtures()
    data["request_schemas"] = request_schemas()
    data["routes"] = routes()
    for group, content in data.items():
        path = OUT / f"{group}.json"
        path.write_text(json.dumps(content, indent=2, ensure_ascii=False, sort_keys=True) + "\n")
        print(f"wrote {path.relative_to(APP)}")


if __name__ == "__main__":
    main()
