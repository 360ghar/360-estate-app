import 'package:estate_app/features/finance/domain/entities/rent_payment.dart';
import 'package:estate_app/features/finance/presentation/controllers/record_payment_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecordPaymentPage extends GetView<RecordPaymentController> {
  const RecordPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Payment'),
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Charge info card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.rentCharge.propertyTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.rentCharge.tenantName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Due',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          currencyFormat.format(controller.rentCharge.totalDue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Already Paid',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          currencyFormat
                              .format(controller.rentCharge.amountPaid),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Balance',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          currencyFormat.format(controller.rentCharge.balance),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Amount field
            TextFormField(
              controller: controller.amountController,
              decoration: const InputDecoration(
                labelText: 'Amount *',
                prefixText: '₹ ',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              validator: controller.validateAmount,
            ),
            const SizedBox(height: 16),

            // Payment date
            Obx(
              () => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Payment Date'),
                subtitle: Text(
                  DateFormat.yMMMd().format(controller.paymentDate.value),
                ),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: controller.paymentDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    controller.setPaymentDate(date);
                  }
                },
              ),
            ),
            const SizedBox(height: 16),

            // Payment method
            Text(
              'Payment Method',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Obx(
              () => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PaymentMethod.values.map((method) {
                  final isSelected = controller.paymentMethod.value == method;
                  return ChoiceChip(
                    label: Text(method.displayName),
                    selected: isSelected,
                    onSelected: (_) => controller.setPaymentMethod(method),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Reference number
            TextFormField(
              controller: controller.referenceController,
              decoration: const InputDecoration(
                labelText: 'Reference Number',
                hintText: 'Transaction ID, Cheque number, etc.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Notes
            TextFormField(
              controller: controller.notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                hintText: 'Any additional notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit button
            Obx(
              () => FilledButton(
                onPressed:
                    controller.isSubmitting.value ? null : controller.submit,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Record Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
