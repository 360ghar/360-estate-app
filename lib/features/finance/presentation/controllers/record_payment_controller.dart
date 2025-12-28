import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/finance/domain/entities/rent_charge.dart';
import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';
import 'package:estate_app/features/finance/domain/repositories/finance_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordPaymentController extends GetxController {
  RecordPaymentController({
    required FinanceRepository repository,
    required this.rentCharge,
  }) : _repository = repository;

  final FinanceRepository _repository;
  final RentCharge rentCharge;

  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final referenceController = TextEditingController();
  final notesController = TextEditingController();

  final Rx<DateTime> paymentDate = DateTime.now().obs;
  final Rx<PaymentMethod> paymentMethod = PaymentMethod.bankTransfer.obs;

  final RxBool isSubmitting = false.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  @override
  void onInit() {
    super.onInit();
    // Pre-fill amount with remaining balance
    amountController.text = rentCharge.balance.toStringAsFixed(2);
  }

  @override
  void onClose() {
    amountController.dispose();
    referenceController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void setPaymentDate(DateTime date) {
    paymentDate.value = date;
  }

  void setPaymentMethod(PaymentMethod method) {
    paymentMethod.value = method;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isSubmitting.value = true;
    failure.value = null;

    try {
      final amount = double.parse(amountController.text.trim());
      final reference = referenceController.text.trim();
      final notes = notesController.text.trim();

      final payment = await _repository.recordPayment(
        rentChargeId: rentCharge.id,
        leaseId: rentCharge.leaseId,
        amount: amount,
        paymentDate: paymentDate.value,
        paymentMethod: paymentMethod.value.name,
        referenceNumber: reference.isNotEmpty ? reference : null,
        notes: notes.isNotEmpty ? notes : null,
      );

      Get.back<RentPayment>(result: payment);
      Get.snackbar(
        'Success',
        'Payment recorded successfully',
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
      failure.value = UnknownFailure('Failed to record payment', cause: e);
      Get.snackbar(
        'Error',
        'Failed to record payment: $e',
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
    if (amount > rentCharge.balance) {
      return 'Amount cannot exceed balance (₹${rentCharge.balance.toStringAsFixed(2)})';
    }
    return null;
  }
}
