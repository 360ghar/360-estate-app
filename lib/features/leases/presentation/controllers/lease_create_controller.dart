import 'package:estate_app/core/presentation/state/view_state.dart';
import 'package:estate_app/features/leases/domain/entities/lease.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/properties/domain/entities/property.dart';
import 'package:estate_app/features/properties/domain/repositories/properties_repository.dart';
import 'package:estate_app/features/tenants/domain/entities/tenant.dart';
import 'package:estate_app/features/tenants/domain/repositories/tenants_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaseCreateController extends GetxController {
  LeaseCreateController({
    required LeasesRepository leasesRepository,
    required PropertiesRepository propertiesRepository,
    required TenantsRepository tenantsRepository,
  })  : _leasesRepository = leasesRepository,
        _propertiesRepository = propertiesRepository,
        _tenantsRepository = tenantsRepository;

  final LeasesRepository _leasesRepository;
  final PropertiesRepository _propertiesRepository;
  final TenantsRepository _tenantsRepository;

  // Form key
  final formKey = GlobalKey<FormState>();

  // Dropdowns data
  final properties = <Property>[].obs;
  final tenants = <Tenant>[].obs;
  final isLoadingDropdowns = true.obs;

  // Selected values
  final selectedProperty = Rxn<Property>();
  final selectedTenant = Rxn<Tenant>();

  // Form fields
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();
  final monthlyRentController = TextEditingController();
  final securityDepositController = TextEditingController();
  final rentDueDay = 1.obs;
  final lateFeeAmountController = TextEditingController();
  final lateFeeGraceDaysController = TextEditingController();
  final renewalNotifyDaysController = TextEditingController(text: '30');
  final notesController = TextEditingController();

  // State
  final state = Rx<ViewState<Lease>>(ViewState.idle());

  @override
  void onInit() {
    super.onInit();
    _loadDropdownData();
  }

  @override
  void onClose() {
    monthlyRentController.dispose();
    securityDepositController.dispose();
    lateFeeAmountController.dispose();
    lateFeeGraceDaysController.dispose();
    renewalNotifyDaysController.dispose();
    notesController.dispose();
    super.onClose();
  }

  Future<void> _loadDropdownData() async {
    isLoadingDropdowns.value = true;
    try {
      // Load properties
      final propertiesPage = await _propertiesRepository.getProperties(
        page: 1,
        limit: 100,
        query: '',
      );
      properties.value = propertiesPage.items;

      // Load tenants
      final tenantsPage = await _tenantsRepository.getTenants(
        page: 1,
        limit: 100,
        query: '',
      );
      tenants.value = tenantsPage.items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load data: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingDropdowns.value = false;
    }
  }

  bool validate() {
    if (selectedProperty.value == null) {
      _showError('Please select a property');
      return false;
    }
    if (selectedTenant.value == null) {
      _showError('Please select a tenant');
      return false;
    }
    if (startDate.value == null) {
      _showError('Please select a start date');
      return false;
    }
    if (endDate.value == null) {
      _showError('Please select an end date');
      return false;
    }
    if (endDate.value!.isBefore(startDate.value!)) {
      _showError('End date must be after start date');
      return false;
    }
    if (monthlyRentController.text.trim().isEmpty) {
      _showError('Please enter monthly rent');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'Validation Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  Future<void> submit() async {
    if (!validate()) return;

    state.value = ViewState.loading();

    try {
      final lease = await _leasesRepository.createLease(
        propertyId: selectedProperty.value!.id,
        tenantUserId: selectedTenant.value!.userId,
        startDate: startDate.value!,
        endDate: endDate.value!,
        monthlyRent: double.parse(monthlyRentController.text.trim()),
        securityDeposit: securityDepositController.text.trim().isNotEmpty
            ? double.tryParse(securityDepositController.text.trim())
            : null,
        rentDueDay: rentDueDay.value,
        lateFeeAmount: lateFeeAmountController.text.trim().isNotEmpty
            ? double.tryParse(lateFeeAmountController.text.trim())
            : null,
        lateFeeGraceDays: lateFeeGraceDaysController.text.trim().isNotEmpty
            ? int.tryParse(lateFeeGraceDaysController.text.trim())
            : null,
        renewalNotifyDays:
            int.tryParse(renewalNotifyDaysController.text.trim()) ?? 30,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      );

      state.value = ViewState.success(lease);

      Get.back<bool>(result: true);
      Get.snackbar(
        'Success',
        'Lease created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      state.value = ViewState.idle();
      Get.snackbar(
        'Error',
        'Failed to create lease: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void reset() {
    selectedProperty.value = null;
    selectedTenant.value = null;
    startDate.value = null;
    endDate.value = null;
    monthlyRentController.clear();
    securityDepositController.clear();
    rentDueDay.value = 1;
    lateFeeAmountController.clear();
    lateFeeGraceDaysController.clear();
    renewalNotifyDaysController.text = '30';
    notesController.clear();
    state.value = ViewState.idle();
  }
}
