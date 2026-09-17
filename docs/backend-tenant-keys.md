# Backend Tenant Keys Request

Endpoints: `GET /pm/tenants`, `GET /pm/tenants/:id`

## Canonical keys today (from `more/tenants/models/tenant.g.dart`)

```json
{
  "id": 1,
  "name": "Asha",
  "full_name": "Asha Sharma",
  "phone": "9999999999",
  "email": "asha@example.com",
  "property_name": "Sunrise PG",
  "room_number": "101",
  "status": "active"
}
```

## 8 unported fields (historically parsed by the legacy `TenantDto`, now removed; canonical drops)

1. `user_id` (String?)
2. `emergency_contact` (String?)
3. `emergency_phone` (String?)
4. `government_id_type` (String?)
5. `government_id_number` (String?)
6. `notes` (String?)
7. `created_at` / `updated_at` (DateTime?)
8. `current_lease` (object?) / `lease_history` (array?)

## Question for backend

For `GET /pm/tenants` and `GET /pm/tenants/:id`: which of the
8 keys above are actually returned? For each returned key, confirm
type and nullability (e.g. `emergency_phone: string | null`).
If a key is never returned, confirm it is dead so we close this
request without porting it into the canonical model.
