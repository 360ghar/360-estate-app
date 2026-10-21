import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';

/// The icon and the localized name of an expense category. Categories share
/// one ink colour: the icon and the word tell them apart.
extension ExpenseCategoryVisual on ExpenseCategory {
  IconData get icon => switch (this) {
    ExpenseCategory.maintenance => Icons.handyman_outlined,
    ExpenseCategory.repairs => Icons.build_outlined,
    ExpenseCategory.insurance => Icons.shield_outlined,
    ExpenseCategory.propertyTax => Icons.account_balance_outlined,
    ExpenseCategory.hoa => Icons.apartment_outlined,
    ExpenseCategory.utilities => Icons.bolt_outlined,
    ExpenseCategory.marketing => Icons.campaign_outlined,
    ExpenseCategory.legal => Icons.gavel_outlined,
    ExpenseCategory.other => Icons.receipt_long_outlined,
  };

  String text(AppLocalizations l10n) => switch (this) {
    ExpenseCategory.maintenance => l10n.expensesCategoryMaintenance,
    ExpenseCategory.repairs => l10n.expensesCategoryRepairs,
    ExpenseCategory.insurance => l10n.expensesCategoryInsurance,
    ExpenseCategory.propertyTax => l10n.expensesCategoryPropertyTax,
    ExpenseCategory.hoa => l10n.expensesCategoryHoa,
    ExpenseCategory.utilities => l10n.expensesCategoryUtilities,
    ExpenseCategory.marketing => l10n.expensesCategoryMarketing,
    ExpenseCategory.legal => l10n.expensesCategoryLegal,
    ExpenseCategory.other => l10n.expensesCategoryOther,
  };
}
