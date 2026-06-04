import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
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
    final textTheme = Theme.of(context).textTheme;

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
      scrollable: true,
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Predefined Templates Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                    borderRadius: AppRadii.sm,
                  ),
                  child: Icon(
                    Icons.article_outlined,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Predefined Templates',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Padding(
              padding: const EdgeInsets.only(left: 44),
              child: Text(
                'Select a template to use for a new lease',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Grid of templates (2 columns)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.85,
              ),
              itemCount: availableTemplates.length,
              itemBuilder: (context, index) {
                return _TemplateGridTile(
                  template: availableTemplates[index],
                  onTap: () => _showTemplatePreview(
                    context,
                    availableTemplates[index],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),

            // Custom Templates Section
            AppSectionCard(
              title: 'Custom Templates',
              icon: Icons.edit_note_outlined,
              children: [
                const _CustomTemplatesSection(),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  void _showTemplatePreview(BuildContext context, LeaseTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
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

class _TemplateGridTile extends StatelessWidget {
  const _TemplateGridTile({
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
    switch (template.type) {
      case LeaseTemplateType.residential:
        return AppColors.primary;
      case LeaseTemplateType.commercial:
        return AppColors.info;
      case LeaseTemplateType.pg:
        return AppColors.success;
      case LeaseTemplateType.monthToMonth:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final typeColor = _getTypeColor(context);

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: AppRadii.md,
            ),
            child: Icon(
              _typeIcon,
              color: typeColor,
              size: 24,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Title
          Text(
            template.name,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          // Description
          Expanded(
            child: Text(
              template.description,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Arrow indicator
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 18,
              color: typeColor.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomTemplatesSection extends StatelessWidget {
  const _CustomTemplatesSection();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Placeholder for custom templates
    return Column(
      children: [
        const SizedBox(height: AppSpacing.md),
        Icon(
          Icons.description_outlined,
          size: 40,
          color: AppColors.textDisabled,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'No custom templates yet',
          style: textTheme.titleSmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Create your own lease templates for reuse',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
      ],
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
    'rent_amount': 'Monthly Rent (\u20B9)',
    'deposit_amount': 'Security Deposit (\u20B9)',
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
    'base_rent': 'Base Rent (\u20B9)',
    'food_charges': 'Food Charges (\u20B9)',
    'utility_charges': 'Utility Charges (\u20B9)',
    'service_charges': 'Service Charges (\u20B9)',
    'facilities': 'Facilities Included',
    'business_type': 'Business Type',
    'maintenance_charge': 'Maintenance Charges (\u20B9)',
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
    return AppScaffold(
      appBar: AppBar(
        title: Text(widget.template.name),
        actions: [
          TextButton.icon(
            onPressed: _useTemplate,
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Use Template'),
          ),
        ],
      ),
      scrollable: true,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Required Information
              AppSectionCard(
                title: 'Required Information',
                icon: Icons.edit_outlined,
                children: [
                  ..._fields.entries.map((entry) {
                    final isAmount = entry.value.contains('\u20B9');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: TextFormField(
                        controller: _controllers[entry.key],
                        decoration: InputDecoration(
                          labelText: entry.value,
                          prefixText: isAmount ? '\u20B9 ' : null,
                        ),
                        keyboardType: isAmount
                            ? TextInputType.number
                            : TextInputType.text,
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
              const SizedBox(height: AppSpacing.lg),

              // Optional Information
              AppSectionCard(
                title: 'Optional Information',
                icon: Icons.tune_outlined,
                children: [
                  ..._optionalFields.entries.map((entry) {
                    final isAmount = entry.value.contains('\u20B9');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: TextFormField(
                        controller: _controllers[entry.key],
                        decoration: InputDecoration(
                          labelText: entry.value,
                          prefixText: isAmount ? '\u20B9 ' : null,
                        ),
                        keyboardType: isAmount
                            ? TextInputType.number
                            : TextInputType.text,
                        onChanged: (_) => setState(() {}),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Preview
              AppSectionCard(
                title: 'Preview',
                icon: Icons.preview_outlined,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: AppRadii.md,
                  ),
                  child: SelectableText(
                    _generatePreview(),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
