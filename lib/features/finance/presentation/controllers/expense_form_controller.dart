import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/finance/domain/entities/expense.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseFormController extends GetxController {
  ExpenseFormController({
    required FinanceRepository repository,
    this.existingExpense,
    this.propertyId,
  }) : _repository = repository;

  final FinanceRepository _repository;
  final Expense? existingExpense;
  final int? propertyId;

  bool get isEditing => existingExpense != null;

  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  final vendorController = TextEditingController();
  final notesController = TextEditingController();

  final Rx<DateTime> expenseDate = DateTime.now().obs;
  final Rx<ExpenseCategory> category = ExpenseCategory.other.obs;
  final Rxn<int> selectedPropertyId = Rxn<int>();

  final RxBool isSubmitting = false.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    selectedPropertyId.value = propertyId;

    if (existingExpense != null) {
      amountController.text = existingExpense!.amount.toStringAsFixed(2);
      descriptionController.text = existingExpense!.description;
      vendorController.text = existingExpense!.vendor ?? '';
      notesController.text = existingExpense!.notes ?? '';
      expenseDate.value = existingExpense!.expenseDate;
      category.value = existingExpense!.category;
      selectedPropertyId.value = existingExpense!.propertyId;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    descriptionController.dispose();
    vendorController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void setExpenseDate(DateTime date) {
    expenseDate.value = date;
  }

  void setCategory(ExpenseCategory cat) {
    category.value = cat;
  }

  void setPropertyId(int? id) {
    selectedPropertyId.value = id;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;
    failure.value = null;

    try {
      final amount = double.parse(amountController.text.trim());
      final description = descriptionController.text.trim();
      final vendor = vendorController.text.trim();
      final notes = notesController.text.trim();

      Expense result;

      if (isEditing) {
        final updates = <String, dynamic>{
          'amount': amount,
          'description': description,
          'category': category.value.name,
          'expense_date': expenseDate.value.toIso8601String().split('T')[0],
          if (selectedPropertyId.value != null)
            'property_id': selectedPropertyId.value,
          if (vendor.isNotEmpty) 'vendor': vendor,
          if (notes.isNotEmpty) 'notes': notes,
        };
        result = await _repository.updateExpense(existingExpense!.id, updates);
      } else {
        result = await _repository.createExpense(
          propertyId: selectedPropertyId.value,
          category: category.value.name,
          amount: amount,
          expenseDate: expenseDate.value,
          description: description,
          vendor: vendor.isNotEmpty ? vendor : null,
          notes: notes.isNotEmpty ? notes : null,
        );
      }

      Get.back<Expense>(result: result);
      Get.snackbar(
        'Success',
        isEditing
            ? 'Expense updated successfully'
            : 'Expense created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Failure catch (f) {
      failure.value = f;
      Get.snackbar(
        'Error',
        f.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      failure.value = UnknownFailure('Failed to save expense', cause: e);
      Get.snackbar(
        'Error',
        'Failed to save expense: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value.trim());
    if (amount == null || amount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  String? validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 3) {
      return 'Description must be at least 3 characters';
    }
    return null;
  }
}
