import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/presentation/controllers/expense_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpenseFormPage extends GetView<ExpenseFormController> {
  const ExpenseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.isEditing ? 'Edit Expense' : 'New Expense'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Category selection
            Text(
              'Category *',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ExpenseCategory.values.map((category) {
                    final isSelected = controller.category.value == category;
                    return ChoiceChip(
                      avatar: Icon(
                        category.icon,
                        size: 18,
                        color: isSelected ? Colors.white : category.color,
                      ),
                      label: Text(category.displayName),
                      selected: isSelected,
                      selectedColor: category.color,
                      onSelected: (_) => controller.setCategory(category),
                    );
                  }).toList(),
                ),),
            const SizedBox(height: 24),

            // Amount
            TextFormField(
              controller: controller.amountController,
              decoration: const InputDecoration(
                labelText: 'Amount *',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: controller.validateAmount,
            ),
            const SizedBox(height: 16),

            // Description
            TextFormField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description *',
                hintText: 'What was this expense for?',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: controller.validateDescription,
            ),
            const SizedBox(height: 16),

            // Expense date
            Obx(() => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Expense Date'),
                  subtitle: Text(
                    DateFormat.yMMMd().format(controller.expenseDate.value),
                  ),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: controller.expenseDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      controller.setExpenseDate(date);
                    }
                  },
                ),),
            const SizedBox(height: 16),

            // Vendor
            TextFormField(
              controller: controller.vendorController,
              decoration: const InputDecoration(
                labelText: 'Vendor',
                hintText: 'Who did you pay?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: controller.notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional details...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit button
            Obx(() => FilledButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submit,
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(controller.isEditing ? 'Update Expense' : 'Create Expense'),
                ),),
          ],
        ),
      ),
    );
  }
}
