/// Centralized mock data factory for Property Management features.
/// Generates realistic Indian property data with consistent relationships.
library;

import 'dart:math';

final class MockDataFactory {
  MockDataFactory._();

  static final Random _random = Random(42); // Fixed seed for consistent data

  // ============================================================
  // PROPERTIES
  // ============================================================
  static final List<Map<String, dynamic>> properties = [
    {
      'id': 1,
      'title': 'Sunrise Apartments - 3BHK',
      'nickname': 'Sunrise 3BHK',
      'address_line': 'Tower A, Floor 5, Unit 502',
      'city': 'Gurugram',
      'state': 'Haryana',
      'pincode': '122002',
      'country': 'India',
      'property_type': 'apartment',
      'property_category': 'residential',
      'bedroom_count': 3,
      'bathroom_count': 2,
      'balcony_count': 2,
      'floor_area_sqft': 1450.0,
      'images': [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
      ],
      'management_status': 'active',
      'payment_due_day': 5,
      'notes': 'Corner unit with good ventilation',
      'monthly_rent_inr': 35000,
      'active_lease': {
        'id': 1,
        'tenant_name': 'Rahul Sharma',
        'start_date': '2025-06-01',
        'end_date': '2026-05-31',
        'monthly_rent': 35000.0,
        'security_deposit': 105000.0,
        'status': 'active',
      },
      'created_at': '2024-01-15T10:00:00Z',
      'updated_at': '2025-12-01T15:30:00Z',
    },
    {
      'id': 2,
      'title': 'Palm Grove Villa',
      'nickname': 'Palm Villa',
      'address_line': 'Plot 45, Sector 56',
      'city': 'Gurugram',
      'state': 'Haryana',
      'pincode': '122011',
      'country': 'India',
      'property_type': 'villa',
      'property_category': 'residential',
      'bedroom_count': 4,
      'bathroom_count': 4,
      'balcony_count': 3,
      'floor_area_sqft': 3200.0,
      'images': [
        'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800',
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
      ],
      'management_status': 'active',
      'payment_due_day': 1,
      'notes': 'Premium villa with private garden',
      'monthly_rent_inr': 85000,
      'active_lease': null,
      'created_at': '2023-08-20T09:00:00Z',
      'updated_at': '2025-11-15T12:00:00Z',
    },
    {
      'id': 3,
      'title': 'Green Park Residency - 2BHK',
      'nickname': 'Green Park 2BHK',
      'address_line': 'Block C, Flat 301',
      'city': 'Noida',
      'state': 'Uttar Pradesh',
      'pincode': '201301',
      'country': 'India',
      'property_type': 'apartment',
      'property_category': 'residential',
      'bedroom_count': 2,
      'bathroom_count': 2,
      'balcony_count': 1,
      'floor_area_sqft': 1100.0,
      'images': [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
      ],
      'management_status': 'active',
      'payment_due_day': 10,
      'notes': 'Near metro station',
      'monthly_rent_inr': 22000,
      'active_lease': {
        'id': 2,
        'tenant_name': 'Priya Patel',
        'start_date': '2025-03-01',
        'end_date': '2026-02-28',
        'monthly_rent': 22000.0,
        'security_deposit': 44000.0,
        'status': 'active',
      },
      'created_at': '2024-05-10T14:00:00Z',
      'updated_at': '2025-10-20T09:15:00Z',
    },
    {
      'id': 4,
      'title': 'Tech Park Commercial Space',
      'nickname': 'Tech Park Office',
      'address_line': 'Unit 5, Ground Floor, Tech Park',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'pincode': '560066',
      'country': 'India',
      'property_type': 'commercial',
      'property_category': 'commercial',
      'bedroom_count': null,
      'bathroom_count': 2,
      'balcony_count': 0,
      'floor_area_sqft': 2500.0,
      'images': [
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
      ],
      'management_status': 'active',
      'payment_due_day': 1,
      'notes': 'Suitable for IT company',
      'monthly_rent_inr': 150000,
      'active_lease': {
        'id': 3,
        'tenant_name': 'TechStart Solutions Pvt Ltd',
        'start_date': '2025-01-01',
        'end_date': '2027-12-31',
        'monthly_rent': 150000.0,
        'security_deposit': 900000.0,
        'status': 'active',
      },
      'created_at': '2024-10-01T11:00:00Z',
      'updated_at': '2025-12-15T16:45:00Z',
    },
    {
      'id': 5,
      'title': 'Skyline Heights - 1BHK',
      'nickname': 'Skyline Studio',
      'address_line': 'Tower B, Floor 12, Unit 1204',
      'city': 'Mumbai',
      'state': 'Maharashtra',
      'pincode': '400053',
      'country': 'India',
      'property_type': 'apartment',
      'property_category': 'residential',
      'bedroom_count': 1,
      'bathroom_count': 1,
      'balcony_count': 1,
      'floor_area_sqft': 650.0,
      'images': [
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      ],
      'management_status': 'inactive',
      'payment_due_day': 5,
      'notes': 'Under renovation',
      'monthly_rent_inr': 45000,
      'active_lease': null,
      'created_at': '2023-03-15T08:00:00Z',
      'updated_at': '2025-11-01T10:00:00Z',
    },
  ];

  // ============================================================
  // TENANTS
  // ============================================================
  static final List<Map<String, dynamic>> tenants = [
    {
      'id': 1,
      'user_id': 'user_001',
      'full_name': 'Rahul Sharma',
      'email': 'rahul.sharma@email.com',
      'phone': '+91 98765 43210',
      'emergency_contact': 'Amit Sharma (Brother)',
      'emergency_phone': '+91 98765 43211',
      'government_id_type': 'Aadhaar',
      'government_id_number': 'XXXX XXXX 4321',
      'notes': 'Works in IT sector, punctual with payments',
      'status': 'active',
      'created_at': '2025-05-15T10:00:00Z',
      'updated_at': '2025-12-01T15:30:00Z',
      'current_lease': {
        'id': 1,
        'property_id': 1,
        'property_title': 'Sunrise Apartments - 3BHK',
        'start_date': '2025-06-01',
        'end_date': '2026-05-31',
        'monthly_rent': 35000.0,
      },
    },
    {
      'id': 2,
      'user_id': 'user_002',
      'full_name': 'Priya Patel',
      'email': 'priya.patel@email.com',
      'phone': '+91 87654 32109',
      'emergency_contact': 'Meera Patel (Mother)',
      'emergency_phone': '+91 87654 32100',
      'government_id_type': 'PAN',
      'government_id_number': 'ABCDE1234F',
      'notes': 'Young professional, very clean tenant',
      'status': 'active',
      'created_at': '2025-02-20T11:00:00Z',
      'updated_at': '2025-10-20T09:15:00Z',
      'current_lease': {
        'id': 2,
        'property_id': 3,
        'property_title': 'Green Park Residency - 2BHK',
        'start_date': '2025-03-01',
        'end_date': '2026-02-28',
        'monthly_rent': 22000.0,
      },
    },
    {
      'id': 3,
      'user_id': 'user_003',
      'full_name': 'TechStart Solutions Pvt Ltd',
      'email': 'admin@techstart.in',
      'phone': '+91 80 4567 8900',
      'emergency_contact': 'Vikram Reddy (Director)',
      'emergency_phone': '+91 99887 76655',
      'government_id_type': 'GSTIN',
      'government_id_number': '29AABCT1234F1ZP',
      'notes': 'Corporate tenant, 3-year lease',
      'status': 'active',
      'created_at': '2024-12-01T09:00:00Z',
      'updated_at': '2025-12-15T16:45:00Z',
      'current_lease': {
        'id': 3,
        'property_id': 4,
        'property_title': 'Tech Park Commercial Space',
        'start_date': '2025-01-01',
        'end_date': '2027-12-31',
        'monthly_rent': 150000.0,
      },
    },
    {
      'id': 4,
      'user_id': 'user_004',
      'full_name': 'Arun Kumar',
      'email': 'arun.kumar@email.com',
      'phone': '+91 76543 21098',
      'emergency_contact': 'Sunita Kumar (Wife)',
      'emergency_phone': '+91 76543 21099',
      'government_id_type': 'Aadhaar',
      'government_id_number': 'XXXX XXXX 5678',
      'notes': 'Previous tenant, terminated lease early',
      'status': 'inactive',
      'created_at': '2024-01-10T14:00:00Z',
      'updated_at': '2025-06-30T18:00:00Z',
      'current_lease': null,
    },
  ];

  // ============================================================
  // LEASES
  // ============================================================
  static final List<Map<String, dynamic>> leases = [
    {
      'id': 1,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'tenant_user_id': 'user_001',
      'tenant_name': 'Rahul Sharma',
      'start_date': '2025-06-01',
      'end_date': '2026-05-31',
      'monthly_rent': 35000.0,
      'security_deposit': 105000.0,
      'rent_due_day': 5,
      'late_fee_amount': 500.0,
      'late_fee_grace_days': 5,
      'renewal_notify_days': 30,
      'signed_document_url': null,
      'status': 'active',
      'notes': 'Standard 11-month lease with auto-renewal clause',
      'created_at': '2025-05-15T10:00:00Z',
      'updated_at': '2025-12-01T15:30:00Z',
    },
    {
      'id': 2,
      'property_id': 3,
      'property_title': 'Green Park Residency - 2BHK',
      'tenant_user_id': 'user_002',
      'tenant_name': 'Priya Patel',
      'start_date': '2025-03-01',
      'end_date': '2026-02-28',
      'monthly_rent': 22000.0,
      'security_deposit': 44000.0,
      'rent_due_day': 10,
      'late_fee_amount': 300.0,
      'late_fee_grace_days': 3,
      'renewal_notify_days': 30,
      'signed_document_url': 'https://storage.example.com/leases/lease_2_signed.pdf',
      'status': 'active',
      'notes': 'Includes parking space',
      'created_at': '2025-02-20T11:00:00Z',
      'updated_at': '2025-10-20T09:15:00Z',
    },
    {
      'id': 3,
      'property_id': 4,
      'property_title': 'Tech Park Commercial Space',
      'tenant_user_id': 'user_003',
      'tenant_name': 'TechStart Solutions Pvt Ltd',
      'start_date': '2025-01-01',
      'end_date': '2027-12-31',
      'monthly_rent': 150000.0,
      'security_deposit': 900000.0,
      'rent_due_day': 1,
      'late_fee_amount': 5000.0,
      'late_fee_grace_days': 7,
      'renewal_notify_days': 90,
      'signed_document_url': 'https://storage.example.com/leases/lease_3_signed.pdf',
      'status': 'active',
      'notes': 'Long-term commercial lease with annual escalation of 5%',
      'created_at': '2024-12-01T09:00:00Z',
      'updated_at': '2025-12-15T16:45:00Z',
    },
    {
      'id': 4,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'tenant_user_id': 'user_004',
      'tenant_name': 'Arun Kumar',
      'start_date': '2024-06-01',
      'end_date': '2025-05-31',
      'monthly_rent': 32000.0,
      'security_deposit': 96000.0,
      'rent_due_day': 5,
      'late_fee_amount': 500.0,
      'late_fee_grace_days': 5,
      'renewal_notify_days': 30,
      'signed_document_url': 'https://storage.example.com/leases/lease_4_signed.pdf',
      'status': 'terminated',
      'notes': 'Terminated early due to relocation',
      'created_at': '2024-05-15T10:00:00Z',
      'updated_at': '2025-05-01T12:00:00Z',
    },
  ];

  // ============================================================
  // RENT CHARGES
  // ============================================================
  static List<Map<String, dynamic>> get rentCharges {
    final now = DateTime.now();
    return [
      {
        'id': 1,
        'lease_id': 1,
        'property_id': 1,
        'property_title': 'Sunrise Apartments - 3BHK',
        'tenant_name': 'Rahul Sharma',
        'period_start': '2026-01-01',
        'period_end': '2026-01-31',
        'due_date': '2026-01-05',
        'amount_due': 35000.0,
        'amount_paid': 0.0,
        'late_fee': 0.0,
        'status': 'pending',
        'created_at': '2025-12-25T00:00:00Z',
        'updated_at': '2025-12-25T00:00:00Z',
      },
      {
        'id': 2,
        'lease_id': 1,
        'property_id': 1,
        'property_title': 'Sunrise Apartments - 3BHK',
        'tenant_name': 'Rahul Sharma',
        'period_start': '2025-12-01',
        'period_end': '2025-12-31',
        'due_date': '2025-12-05',
        'amount_due': 35000.0,
        'amount_paid': 35000.0,
        'late_fee': 0.0,
        'status': 'paid',
        'created_at': '2025-11-25T00:00:00Z',
        'updated_at': '2025-12-03T14:30:00Z',
      },
      {
        'id': 3,
        'lease_id': 2,
        'property_id': 3,
        'property_title': 'Green Park Residency - 2BHK',
        'tenant_name': 'Priya Patel',
        'period_start': '2026-01-01',
        'period_end': '2026-01-31',
        'due_date': '2026-01-10',
        'amount_due': 22000.0,
        'amount_paid': 0.0,
        'late_fee': 0.0,
        'status': 'pending',
        'created_at': '2025-12-25T00:00:00Z',
        'updated_at': '2025-12-25T00:00:00Z',
      },
      {
        'id': 4,
        'lease_id': 2,
        'property_id': 3,
        'property_title': 'Green Park Residency - 2BHK',
        'tenant_name': 'Priya Patel',
        'period_start': '2025-12-01',
        'period_end': '2025-12-31',
        'due_date': '2025-12-10',
        'amount_due': 22000.0,
        'amount_paid': 22000.0,
        'late_fee': 0.0,
        'status': 'paid',
        'created_at': '2025-11-25T00:00:00Z',
        'updated_at': '2025-12-08T11:00:00Z',
      },
      {
        'id': 5,
        'lease_id': 3,
        'property_id': 4,
        'property_title': 'Tech Park Commercial Space',
        'tenant_name': 'TechStart Solutions Pvt Ltd',
        'period_start': '2026-01-01',
        'period_end': '2026-01-31',
        'due_date': '2026-01-01',
        'amount_due': 150000.0,
        'amount_paid': 150000.0,
        'late_fee': 0.0,
        'status': 'paid',
        'created_at': '2025-12-20T00:00:00Z',
        'updated_at': '2025-12-28T09:00:00Z',
      },
      {
        'id': 6,
        'lease_id': 1,
        'property_id': 1,
        'property_title': 'Sunrise Apartments - 3BHK',
        'tenant_name': 'Rahul Sharma',
        'period_start': '2025-11-01',
        'period_end': '2025-11-30',
        'due_date': '2025-11-05',
        'amount_due': 35000.0,
        'amount_paid': 35000.0,
        'late_fee': 500.0,
        'status': 'paid',
        'created_at': '2025-10-25T00:00:00Z',
        'updated_at': '2025-11-12T16:00:00Z',
      },
    ];
  }

  // ============================================================
  // EXPENSES
  // ============================================================
  static final List<Map<String, dynamic>> expenses = [
    {
      'id': 1,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'category': 'maintenance',
      'amount': 5500.0,
      'expense_date': '2025-12-15',
      'description': 'Annual AC servicing for all units',
      'vendor': 'CoolAir Services',
      'receipt_url': null,
      'notes': 'Includes cleaning and gas top-up',
      'created_at': '2025-12-15T10:00:00Z',
      'updated_at': '2025-12-15T10:00:00Z',
    },
    {
      'id': 2,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'category': 'taxes',
      'amount': 15000.0,
      'expense_date': '2025-10-01',
      'description': 'Quarterly property tax payment',
      'vendor': 'Municipal Corporation Gurugram',
      'receipt_url': 'https://storage.example.com/receipts/tax_q4_2025.pdf',
      'notes': 'Q4 2025',
      'created_at': '2025-10-01T09:00:00Z',
      'updated_at': '2025-10-01T09:00:00Z',
    },
    {
      'id': 3,
      'property_id': 3,
      'property_title': 'Green Park Residency - 2BHK',
      'category': 'repairs',
      'amount': 8500.0,
      'expense_date': '2025-11-20',
      'description': 'Plumbing repair - bathroom leak',
      'vendor': 'QuickFix Plumbers',
      'receipt_url': null,
      'notes': 'Emergency repair',
      'created_at': '2025-11-20T14:00:00Z',
      'updated_at': '2025-11-20T14:00:00Z',
    },
    {
      'id': 4,
      'property_id': 2,
      'property_title': 'Palm Grove Villa',
      'category': 'insurance',
      'amount': 45000.0,
      'expense_date': '2025-08-15',
      'description': 'Annual property insurance premium',
      'vendor': 'ICICI Lombard',
      'receipt_url': 'https://storage.example.com/receipts/insurance_2025.pdf',
      'notes': 'Coverage: 2 Crores',
      'created_at': '2025-08-15T11:00:00Z',
      'updated_at': '2025-08-15T11:00:00Z',
    },
    {
      'id': 5,
      'property_id': 4,
      'property_title': 'Tech Park Commercial Space',
      'category': 'utilities',
      'amount': 12000.0,
      'expense_date': '2025-12-01',
      'description': 'Common area electricity for December',
      'vendor': 'BESCOM',
      'receipt_url': null,
      'notes': 'Shared between tenants',
      'created_at': '2025-12-05T09:00:00Z',
      'updated_at': '2025-12-05T09:00:00Z',
    },
  ];

  // ============================================================
  // MAINTENANCE REQUESTS
  // ============================================================
  static final List<Map<String, dynamic>> maintenanceRequests = [
    {
      'id': 1,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'lease_id': 1,
      'tenant_name': 'Rahul Sharma',
      'category': 'plumbing',
      'priority': 'high',
      'request_status': 'in_progress',
      'title': 'Kitchen sink leaking',
      'description': 'Water is dripping from under the kitchen sink. Started yesterday evening.',
      'assigned_to': 'Maintenance Team',
      'estimated_cost': 2000.0,
      'actual_cost': null,
      'scheduled_date': '2026-01-04',
      'completed_date': null,
      'notes': 'Plumber scheduled for Saturday morning',
      'image_urls': [
        'https://images.unsplash.com/photo-1585704032915-c3400ca199e7?w=400',
      ],
      'created_at': '2026-01-02T10:00:00Z',
      'updated_at': '2026-01-03T09:00:00Z',
    },
    {
      'id': 2,
      'property_id': 3,
      'property_title': 'Green Park Residency - 2BHK',
      'lease_id': 2,
      'tenant_name': 'Priya Patel',
      'category': 'electrical',
      'priority': 'medium',
      'request_status': 'open',
      'title': 'Bedroom light flickering',
      'description': 'The ceiling light in the master bedroom has been flickering for the past week.',
      'assigned_to': null,
      'estimated_cost': null,
      'actual_cost': null,
      'scheduled_date': null,
      'completed_date': null,
      'notes': null,
      'image_urls': null,
      'created_at': '2026-01-01T15:30:00Z',
      'updated_at': '2026-01-01T15:30:00Z',
    },
    {
      'id': 3,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'lease_id': 1,
      'tenant_name': 'Rahul Sharma',
      'category': 'hvac',
      'priority': 'low',
      'request_status': 'completed',
      'title': 'AC making noise',
      'description': 'Living room AC is making a rattling noise when running.',
      'assigned_to': 'CoolAir Services',
      'estimated_cost': 1500.0,
      'actual_cost': 1200.0,
      'scheduled_date': '2025-12-20',
      'completed_date': '2025-12-20',
      'notes': 'Fixed loose fan blade',
      'image_urls': null,
      'created_at': '2025-12-15T11:00:00Z',
      'updated_at': '2025-12-20T16:00:00Z',
    },
    {
      'id': 4,
      'property_id': 4,
      'property_title': 'Tech Park Commercial Space',
      'lease_id': 3,
      'tenant_name': 'TechStart Solutions Pvt Ltd',
      'category': 'security',
      'priority': 'urgent',
      'request_status': 'completed',
      'title': 'Main door lock broken',
      'description': 'The electronic lock on the main entrance is not working. Cannot lock the office properly.',
      'assigned_to': 'SecureLock Systems',
      'estimated_cost': 8000.0,
      'actual_cost': 7500.0,
      'scheduled_date': '2025-12-28',
      'completed_date': '2025-12-28',
      'notes': 'Replaced lock mechanism, new keys issued',
      'image_urls': null,
      'created_at': '2025-12-27T18:00:00Z',
      'updated_at': '2025-12-28T20:00:00Z',
    },
  ];

  // ============================================================
  // DASHBOARD OVERVIEW
  // ============================================================
  static Map<String, dynamic> get dashboardOverview {
    // Calculate from properties
    final totalProperties = properties.length;
    final occupiedProperties = properties.where((p) => p['active_lease'] != null).length;
    final vacantProperties = properties.where((p) => 
      p['active_lease'] == null && p['management_status'] == 'active',
    ).length;
    final underMaintenanceProperties = properties.where((p) => 
      p['management_status'] == 'inactive',
    ).length;

    // Calculate revenue from rent charges
    final currentMonthCharges = rentCharges.where((c) =>
      c['period_start'].toString().startsWith('2026-01'),
    );
    final previousMonthCharges = rentCharges.where((c) =>
      c['period_start'].toString().startsWith('2025-12'),
    );

    final currentRevenue = previousMonthCharges
        .where((c) => c['status'] == 'paid')
        .fold<double>(0.0, (sum, c) => sum + (c['amount_paid'] as double));
    
    final previousRevenue = 207000.0; // Static for demo

    final outstandingRent = rentCharges
        .where((c) => c['status'] == 'pending' || c['status'] == 'overdue')
        .fold<double>(0.0, (sum, c) => sum + ((c['amount_due'] as double) - (c['amount_paid'] as double)));

    final upcomingExpenses = 25000.0; // Static for demo

    return {
      'total_properties': totalProperties,
      'occupied_properties': occupiedProperties,
      'vacant_properties': vacantProperties,
      'under_maintenance_properties': underMaintenanceProperties,
      'monthly_revenue_current': currentRevenue,
      'monthly_revenue_previous': previousRevenue,
      'outstanding_rent_total': outstandingRent,
      'upcoming_expenses_total': upcomingExpenses,
    };
  }

  // ============================================================
  // RECENT ACTIVITIES
  // ============================================================
  static List<Map<String, dynamic>> get recentActivities => [
    {
      'id': 1,
      'type': 'payment_received',
      'title': 'Rent Payment Received',
      'description': 'TechStart Solutions paid ₹1,50,000 for January 2026',
      'property_id': 4,
      'property_title': 'Tech Park Commercial Space',
      'timestamp': '2025-12-28T09:00:00Z',
    },
    {
      'id': 2,
      'type': 'maintenance_completed',
      'title': 'Maintenance Completed',
      'description': 'Door lock replacement completed at Tech Park',
      'property_id': 4,
      'property_title': 'Tech Park Commercial Space',
      'timestamp': '2025-12-28T20:00:00Z',
    },
    {
      'id': 3,
      'type': 'maintenance_created',
      'title': 'New Maintenance Request',
      'description': 'Kitchen sink leak reported at Sunrise Apartments',
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'timestamp': '2026-01-02T10:00:00Z',
    },
    {
      'id': 4,
      'type': 'payment_received',
      'title': 'Rent Payment Received',
      'description': 'Rahul Sharma paid ₹35,000 for December 2025',
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'timestamp': '2025-12-03T14:30:00Z',
    },
    {
      'id': 5,
      'type': 'expense_recorded',
      'title': 'Expense Recorded',
      'description': 'AC servicing expense of ₹5,500',
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'timestamp': '2025-12-15T10:00:00Z',
    },
    {
      'id': 6,
      'type': 'lease_expiring',
      'title': 'Lease Expiring Soon',
      'description': 'Lease for Green Park 2BHK expires in 57 days',
      'property_id': 3,
      'property_title': 'Green Park Residency - 2BHK',
      'timestamp': '2026-01-03T00:00:00Z',
    },
  ];

  // ============================================================
  // INSPECTIONS
  // ============================================================
  static final List<Map<String, dynamic>> inspections = [
    {
      'id': 1,
      'property_id': 1,
      'property_title': 'Sunrise Apartments - 3BHK',
      'lease_id': 1,
      'tenant_name': 'Rahul Sharma',
      'inspection_type': 'move_in',
      'inspection_date': '2025-06-01',
      'status': 'completed',
      'inspector_name': 'Owner',
      'overall_condition': 'excellent',
      'notes': 'Property in excellent condition at move-in',
      'rooms_inspected': [
        {'room': 'Living Room', 'condition': 'excellent', 'notes': 'No issues'},
        {'room': 'Master Bedroom', 'condition': 'excellent', 'notes': 'Fresh paint'},
        {'room': 'Kitchen', 'condition': 'good', 'notes': 'Minor wear on countertop'},
        {'room': 'Bathroom 1', 'condition': 'excellent', 'notes': 'All fixtures working'},
        {'room': 'Bathroom 2', 'condition': 'excellent', 'notes': 'All fixtures working'},
      ],
      'created_at': '2025-06-01T10:00:00Z',
      'updated_at': '2025-06-01T12:00:00Z',
    },
  ];

  // ============================================================
  // DOCUMENTS
  // ============================================================
  static final List<Map<String, dynamic>> documents = [
    {
      'id': 1,
      'property_id': 1,
      'document_type': 'lease_agreement',
      'title': 'Lease Agreement - Rahul Sharma',
      'file_url': 'https://storage.example.com/docs/lease_1.pdf',
      'file_size_bytes': 245000,
      'uploaded_by': 'Owner',
      'created_at': '2025-05-15T10:00:00Z',
    },
    {
      'id': 2,
      'property_id': 1,
      'document_type': 'property_deed',
      'title': 'Property Registration Document',
      'file_url': 'https://storage.example.com/docs/deed_1.pdf',
      'file_size_bytes': 1250000,
      'uploaded_by': 'Owner',
      'created_at': '2024-01-15T10:00:00Z',
    },
    {
      'id': 3,
      'property_id': 2,
      'document_type': 'insurance',
      'title': 'Property Insurance Policy',
      'file_url': 'https://storage.example.com/docs/insurance_2.pdf',
      'file_size_bytes': 520000,
      'uploaded_by': 'Owner',
      'created_at': '2025-08-15T11:00:00Z',
    },
  ];

  // ============================================================
  // HELPER METHODS
  // ============================================================
  static Map<String, dynamic>? findPropertyById(int id) {
    try {
      return properties.firstWhere((p) => p['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? findTenantById(int id) {
    try {
      return tenants.firstWhere((t) => t['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic>? findLeaseById(int id) {
    try {
      return leases.firstWhere((l) => l['id'] == id);
    } catch (_) {
      return null;
    }
  }

  static List<Map<String, dynamic>> getLeasesByPropertyId(int propertyId) {
    return leases.where((l) => l['property_id'] == propertyId).toList();
  }

  static List<Map<String, dynamic>> getRentChargesByLeaseId(int leaseId) {
    return rentCharges.where((r) => r['lease_id'] == leaseId).toList();
  }

  static List<Map<String, dynamic>> getMaintenanceByPropertyId(int propertyId) {
    return maintenanceRequests
        .where((m) => m['property_id'] == propertyId)
        .toList();
  }
}
