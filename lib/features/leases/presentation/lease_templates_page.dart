import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/section_header.dart';
import 'package:flutter/material.dart';

/// Predefined lease templates for different property types
enum LeaseTemplateType {
  residential,
  commercial,
  pg,
  monthToMonth,
}

class LeaseTemplate {
  const LeaseTemplate({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.content,
  });

  final String id;
  final LeaseTemplateType type;
  final String name;
  final String description;
  final String content;
}

/// Available lease templates
const availableTemplates = [
  LeaseTemplate(
    id: 'residential_std',
    type: LeaseTemplateType.residential,
    name: 'Standard Residential Lease',
    description: 'Standard 11-month residential lease agreement for apartments/houses',
    content: '''
RESIDENTIAL LEASE AGREEMENT

This Lease Agreement is made on {{date}} between:

LANDLORD: {{landlord_name}}
{{landlord_address}}

TENANT: {{tenant_name}}
{{tenant_address}}

PROPERTY: {{property_address}}

1. TERM: The lease shall commence on {{start_date}} and end on {{end_date}}.

2. RENT: Monthly rent of INR {{rent_amount}} is due on the {{due_day}} day of each month.

3. SECURITY DEPOSIT: Tenant has deposited INR {{deposit_amount}} as security deposit.

4. USAGE: Property shall be used for residential purposes only.

5. OCCUPANTS: Maximum {{max_occupants}} persons allowed to reside.

6. UTILITIES: Tenant is responsible for {{utilities}}.

7. MAINTENANCE: Tenant shall maintain premises in good condition.

8. DEFAULT: Rent remaining unpaid for {{grace_period}} days shall be default.

9. TERMINATION: {{termination_notice_days}} days notice required for termination.

LANDLORD SIGNATURE: _________________ DATE: _______
TENANT SIGNATURE: _________________ DATE: _______
''',
  ),
  LeaseTemplate(
    id: 'commercial_std',
    type: LeaseTemplateType.commercial,
    name: 'Commercial Lease',
    description: 'Commercial lease agreement for office/retail spaces',
    content: '''
COMMERCIAL LEASE AGREEMENT

This Commercial Lease Agreement is made on {{date}} between:

LANDLORD: {{landlord_name}}
{{landlord_address}}

TENANT: {{tenant_name}}
{{tenant_address}}

PROPERTY: {{property_address}}

1. TERM: Lease commences on {{start_date}} and ends on {{end_date}}.

2. RENT: Monthly rent of INR {{rent_amount}} plus {{maintenance_charge}} maintenance.

3. SECURITY DEPOSIT: INR {{deposit_amount}} payable by Tenant.

4. USAGE: Property shall be used for {{business_type}} only.

5. BUSINESS HOURS: Operation hours from {{start_time}} to {{end_time}}.

6. UTILITIES: Tenant responsible for electricity, water, and other utilities.

7. ALTERATIONS: No alterations without written consent from Landlord.

8. INSURANCE: Tenant shall maintain business liability insurance.

LANDLORD SIGNATURE: _________________ DATE: _______
TENANT SIGNATURE: _________________ DATE: _______
''',
  ),
  LeaseTemplate(
    id: 'pg_agreement',
    type: LeaseTemplateType.pg,
    name: 'PG/Co-living Agreement',
    description: 'Agreement for paying guest or co-living accommodations',
    content: '''
PG/CO-LIVING ACCOMMODATION AGREEMENT

This Agreement is made on {{date}} between:

PROPERTY OWNER: {{landlord_name}}
{{landlord_address}}

OCCUPANT: {{tenant_name}}
{{tenant_address}}

PROPERTY: {{property_address}}

1. TERM: From {{start_date}} to {{end_date}}.

2. CHARGES: Monthly charges of INR {{rent_amount}} inclusive of:

   - Rent: {{base_rent}}
   - Food: {{food_charges}}
   - Utilities: {{utility_charges}}
   - Services: {{service_charges}}

3. SECURITY DEPOSIT: INR {{deposit_amount}} refundable deposit.

4. FACILITIES: Included facilities - {{facilities}}.

5. HOUSE RULES: Occupant agrees to follow house rules regarding:
   - Visitor timings
   - Meal timings
   - Common area usage
   - Noise restrictions

6. TERMINATION: {{termination_notice_days}} days notice required.

PROPERTY OWNER: _________________ DATE: _______
OCCUPANT: _________________ DATE: _______
''',
  ),
  LeaseTemplate(
    id: 'month_to_month',
    type: LeaseTemplateType.monthToMonth,
    name: 'Month-to-Month Agreement',
    description: 'Flexible month-to-month rental agreement',
    content: '''
MONTH-TO-MONTH RENTAL AGREEMENT

This Agreement is made on {{date}} between:

LANDLORD: {{landlord_name}}
{{landlord_address}}

TENANT: {{tenant_name}}
{{tenant_address}}

PROPERTY: {{property_address}}

1. TERM: Month-to-month tenancy starting {{start_date}}.

2. RENT: INR {{rent_amount}} due on the {{due_day}} day of each month.

3. SECURITY DEPOSIT: INR {{deposit_amount}}.

4. TERMINATION: Either party may terminate with {{termination_notice_days}} days written notice.

5. MAINTENANCE: Tenant responsible for routine maintenance.

LANDLORD: _________________ DATE: _______
TENANT: _________________ DATE: _______
''',
  ),
];

/// Page displaying available lease templates
class LeaseTemplatesPage extends StatelessWidget {
  const LeaseTemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        title: const Text('Lease Templates'),
        actions: [
          IconButton(
            onPressed: () => _showCreateTemplateDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Create custom template',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Predefined Templates',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Select a template to use for a new lease',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          ...availableTemplates.map((template) => _TemplateCard(
                template: template,
                onTap: () => _showTemplatePreview(context, template),
              )),
          const SizedBox(height: AppSpacing.xl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Custom Templates',
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text(
                  'Your saved custom templates',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
          _CustomTemplatesSection(),
        ],
      ),
    );
  }

  void _showTemplatePreview(BuildContext context, LeaseTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _TemplatePreviewPage(template: template),
      ),
    );
  }

  void _showCreateTemplateDialog(BuildContext context) {
    // TODO: Implement custom template creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Custom template creation coming soon')),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.onTap,
  });

  final LeaseTemplate template;
  final VoidCallback onTap;

  IconData get _typeIcon {
    switch (template.type) {
      case LeaseTemplateType.residential:
        return Icons.home_outlined;
      case LeaseTemplateType.commercial:
        return Icons.business_outlined;
      case LeaseTemplateType.pg:
        return Icons.bed_outlined;
      case LeaseTemplateType.monthToMonth:
        return Icons.calendar_today_outlined;
    }
  }

  Color _getTypeColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (template.type) {
      case LeaseTemplateType.residential:
        return scheme.primary;
      case LeaseTemplateType.commercial:
        return scheme.tertiary;
      case LeaseTemplateType.pg:
        return scheme.secondary;
      case LeaseTemplateType.monthToMonth:
        return scheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: _getTypeColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _typeIcon,
                  color: _getTypeColor(context),
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      template.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTemplatesSection extends StatelessWidget {
  const _CustomTemplatesSection();

  @override
  Widget build(BuildContext context) {
    // Placeholder for custom templates
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Icon(
              Icons.description_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No custom templates yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Create your own lease templates for reuse',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TemplatePreviewPage extends StatefulWidget {
  const _TemplatePreviewPage({required this.template});

  final LeaseTemplate template;

  @override
  State<_TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends State<_TemplatePreviewPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  final _fields = const {
    'landlord_name': 'Landlord Name',
    'tenant_name': 'Tenant Name',
    'property_address': 'Property Address',
    'start_date': 'Start Date (YYYY-MM-DD)',
    'end_date': 'End Date (YYYY-MM-DD)',
    'rent_amount': 'Monthly Rent (₹)',
    'deposit_amount': 'Security Deposit (₹)',
    'due_day': 'Payment Due Day (1-31)',
    'date': 'Agreement Date',
  };

  final _optionalFields = const {
    'landlord_address': 'Landlord Address',
    'tenant_address': 'Tenant Address',
    'max_occupants': 'Max Occupants',
    'utilities': 'Utilities (water, electricity, etc.)',
    'grace_period': 'Grace Period (days)',
    'termination_notice_days': 'Termination Notice (days)',
    'base_rent': 'Base Rent (₹)',
    'food_charges': 'Food Charges (₹)',
    'utility_charges': 'Utility Charges (₹)',
    'service_charges': 'Service Charges (₹)',
    'facilities': 'Facilities Included',
    'business_type': 'Business Type',
    'maintenance_charge': 'Maintenance Charges (₹)',
    'start_time': 'Business Start Time',
    'end_time': 'Business End Time',
  };

  @override
  void initState() {
    super.initState();
    for (var field in [..._fields.keys, ..._optionalFields.keys]) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String _generatePreview() {
    String content = widget.template.content;
    _controllers.forEach((key, controller) {
      final placeholder = '{{$key}}';
      content = content.replaceAll(placeholder, controller.text.trim());
    });
    return content;
  }

  void _useTemplate() {
    // TODO: Navigate to lease form with pre-filled template
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Template applied! Create your lease now.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.template.name),
        actions: [
          TextButton.icon(
            onPressed: _useTemplate,
            icon: const Icon(Icons.check),
            label: const Text('Use Template'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Required Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._fields.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: TextFormField(
                          controller: _controllers[entry.key],
                          decoration: InputDecoration(
                            labelText: entry.value,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Required'
                                  : null,
                          onChanged: (_) => setState(() {}),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Optional Information',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ..._optionalFields.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: TextFormField(
                          controller: _controllers[entry.key],
                          decoration: InputDecoration(
                            labelText: entry.value,
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const SectionHeader(title: 'Preview'),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: SelectableText(
                  _generatePreview(),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}
