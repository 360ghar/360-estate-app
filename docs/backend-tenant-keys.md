# Tenant keys (resolved)

Endpoints: `GET /pm/tenants` (`CursorPage[TenantSummary]`) and `GET /pm/tenants/{tenant_user_id}` (`TenantDetail`).

The backend contract is fixed (see `test/fixtures/api/tenants.json`, built from the backend response models):

| Key | List (`TenantSummary`) | Detail (`TenantDetail`) |
| --- | --- | --- |
| `user_id` | yes (the key of the tenant) | yes |
| `full_name`, `phone`, `email` | yes (what the owner typed on the lease, null if none) | yes |
| `status` | yes: `active` or `vacated` | no (the app derives it from the leases) |
| `property_name` | yes | no |
| `active_leases_count` | yes | no |
| `leases` | no | yes (`Lease[]`) |

The keys `id`, `name`, `room_number`, `emergency_contact`, `government_id_*`, `notes`, `current_lease` and `lease_history` are not sent. The app does not read them.
