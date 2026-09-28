import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Campaign Types/Models/campaign_type_model.dart';
import '../Controller/create_campaign_controller.dart';
import '../Models/create_campaign_model.dart';
import '../Reuse Widgets/campaign_type_dropdown.dart';
import '../Reuse Widgets/date_range_field.dart';
import '../Reuse Widgets/product_multiselect_dropdown.dart';
import '../Utils/date_helper.dart';

class CreateCampaignScreen extends ConsumerStatefulWidget {
  const CreateCampaignScreen({super.key});

  static const routeName = '/create-campaign';

  @override
  ConsumerState<CreateCampaignScreen> createState() =>
      _CreateCampaignScreenState();
}

class _CreateCampaignScreenState extends ConsumerState<CreateCampaignScreen> {
  // ── Form state ──
  CampaignTypeData? _selectedType;
  final Set<int> _selectedProductIds = {};

  late DateTime _startDate;
  late DateTime _endDate;

  final TextEditingController _notesController = TextEditingController();
  final FocusNode _notesFocusNode = FocusNode();

  // ── Form key (jaise LoginScreen mein hai) ──
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ── Manual errors (non-textform fields ke liye) ──
  String? _campaignTypeError;
  String? _productsError;
  String? _startDateError;
  String? _endDateError;

  // ── UI state ──
  bool _submitting = false;

  // ── Notes constraints (backend ke mutabiq) ──
  static const int _notesMinLength = 10;
  static const int _notesMaxLength = 2000;

  @override
  void initState() {
    super.initState();

    // Default: start = today
    _startDate = DateHelper.today;

    // Default: end = current month ki last date
    _endDate = DateHelper.currentMonthLastDate;

    // Notes: rebuild counter on each keystroke
    _notesController.addListener(_onNotesChanged);
  }

  @override
  void dispose() {
    _notesController.removeListener(_onNotesChanged);
    _notesController.dispose();
    _notesFocusNode.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // NOTES — LIVE COUNTER REBUILD
  // ═══════════════════════════════════════════════════════════════════════

  void _onNotesChanged() {
    // Counter aur red border ko live update karne ke liye
    if (mounted) setState(() {});
  }

  /// ✅ Notes validator — REQUIRED + 10..2000 chars
  String? _validateNotes(String? value) {
    final notes = (value ?? '').trim();

    // 🔴 REQUIRED — empty allowed nahi
    if (notes.isEmpty) {
      return 'Notes is required';
    }

    if (notes.length < _notesMinLength) {
      return 'Notes must be at least $_notesMinLength characters';
    }

    if (notes.length > _notesMaxLength) {
      return 'Notes must be between $_notesMinLength and $_notesMaxLength characters';
    }

    return null;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // MANUAL VALIDATION (dropdown / multi-select / dates)
  // ═══════════════════════════════════════════════════════════════════════

  bool _validateManualFields() {
    String? campaignTypeError;
    String? productsError;
    String? startDateError;
    String? endDateError;

    // Campaign type
    if (_selectedType == null || _selectedType!.id == null) {
      campaignTypeError = 'Please select a campaign type';
    }

    // Products
    if (_selectedProductIds.isEmpty) {
      productsError = 'Please select at least one product';
    }

    // Start date
    if (_startDate.isBefore(DateHelper.today)) {
      startDateError = 'Start date cannot be in the past';
    } else if (_startDate.isAfter(DateHelper.currentMonthLastDate)) {
      startDateError = 'Start date must be within this month';
    }

    // End date
    if (_endDate.isBefore(DateHelper.today)) {
      endDateError = 'End date cannot be in the past';
    } else if (_endDate.isAfter(DateHelper.currentMonthLastDate)) {
      endDateError = 'End date must be within this month';
    } else if (_endDate.isBefore(_startDate)) {
      endDateError = 'End date cannot be before start date';
    }

    setState(() {
      _campaignTypeError = campaignTypeError;
      _productsError = productsError;
      _startDateError = startDateError;
      _endDateError = endDateError;
    });

    return campaignTypeError == null &&
        productsError == null &&
        startDateError == null &&
        endDateError == null;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SUBMIT
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_submitting) return;

    // ✅ Step 1: Form validator (CustomTextField ka notes validator)
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // ✅ Step 2: Manual validation (dropdown, products, dates)
    final isManualValid = _validateManualFields();

    if (!isFormValid || !isManualValid) {
      _showSnack('Please fix the highlighted errors', isError: true);
      return;
    }

    setState(() => _submitting = true);

    try {
      final request = CreateCampaignRequestModel(
        campaignType: _selectedType!.id!,
        productIds: _selectedProductIds.join(','),
        startDate: DateHelper.toApiDate(_startDate),
        endDate: DateHelper.toApiDate(_endDate),
        notes: _notesController.text.trim(),
      );

      final controller = ref.read(createCampaignControllerProvider);
      final CreateCampaignModel result = await controller.createCampaign(
        request,
      );

      if (!mounted) return;

      if (result.success) {
        final message = result.ticketNumber != null
            ? 'Campaign created successfully. Ticket: ${result.ticketNumber}'
            : (result.message ?? 'Campaign created successfully.');

        _showSnack(message, isError: false);

        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (mounted) Navigator.pop(context);
      } else {
        _showSnack(
          result.message ?? 'Failed to create campaign',
          isError: true,
        );
      }
    } on ApiException catch (e) {
      if (!mounted) return;

      _applyBackendFieldErrors(e.errors);
      _showSnack(e.message, isError: true);
    } catch (e) {
      if (!mounted) return;
      _showSnack('Something went wrong. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  /// Backend se aane wale field-level errors ko UI fields par map karo
  void _applyBackendFieldErrors(Map<String, dynamic>? errors) {
    if (errors == null || errors.isEmpty) return;

    String? pick(String key) {
      final v = errors[key];
      if (v is List && v.isNotEmpty) return v.first.toString();
      if (v is String) return v;
      return null;
    }

    setState(() {
      _campaignTypeError = pick('campaign_type') ?? _campaignTypeError;
      _productsError = pick('product_Ids') ?? _productsError;
      _startDateError = pick('start_date') ?? _startDateError;
      _endDateError = pick('end_date') ?? _endDateError;
    });

    // Notes backend error ke liye Form revalidate
    _formKey.currentState?.validate();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SNACKBAR
  // ═══════════════════════════════════════════════════════════════════════

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isError
                    ? Icons.error_outline_rounded
                    : Icons.check_circle_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: isError ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text('Create Campaign', style: AppTextStyles.headlineSmall),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        // ✅ Form wrapper — jaise LoginScreen mein hai
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Section: Campaign Info ──
                      _SectionCard(
                        title: 'Campaign Information',
                        icon: Icons.campaign_outlined,
                        children: [
                          CampaignTypeDropdown(
                            selectedId: _selectedType?.id,
                            errorText: _campaignTypeError,
                            onChanged: (type) {
                              setState(() {
                                _selectedType = type;
                                _campaignTypeError = null;
                              });
                            },
                          ),
                          const SizedBox(height: 18),
                          ProductMultiSelectDropdown(
                            selectedIds: _selectedProductIds,
                            errorText: _productsError,
                            onChanged: (ids) {
                              setState(() {
                                _selectedProductIds
                                  ..clear()
                                  ..addAll(ids);
                                if (ids.isNotEmpty) _productsError = null;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Section: Schedule ──
                      _SectionCard(
                        title: 'Schedule',
                        icon: Icons.date_range_outlined,
                        children: [
                          DateRangeField(
                            startDate: _startDate,
                            endDate: _endDate,
                            startErrorText: _startDateError,
                            endErrorText: _endDateError,
                            onStartChanged: (d) {
                              setState(() {
                                _startDate = d;
                                _startDateError = null;
                                if (_endDate.isBefore(d)) {
                                  _endDate = DateHelper.currentMonthLastDate;
                                  _endDateError = null;
                                }
                              });
                            },
                            onEndChanged: (d) {
                              setState(() {
                                _endDate = d;
                                _endDateError = null;
                              });
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Section: Notes ──
                      _SectionCard(
                        title: 'Additional Notes',
                        icon: Icons.notes_rounded,
                        children: [
                          // ✅ CustomTextField — required + validator
                          CustomTextField(
                            controller: _notesController,
                            focusNode: _notesFocusNode,
                            label: 'Notes',
                            hintText:
                                'Add any instructions for this campaign (10–2000 characters)',
                            maxLines: 5,
                            minLines: 3,
                            maxLength: _notesMaxLength,
                            showCounter: false, // custom counter niche
                            textCapitalization: TextCapitalization.sentences,
                            // ✅ YE HAI ASLI VALIDATION
                            validator: _validateNotes,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ── Sticky CTA ──
              Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  12 + MediaQuery.of(context).padding.bottom,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  border: Border(top: BorderSide(color: AppColors.divider)),
                ),
                child: CustomButton(
                  text: 'Create Campaign',
                  isLoading: _submitting,
                  onPressed: _submitting ? null : _submit,
                  icon: Icons.check_circle_outline_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SECTION CARD
// ═══════════════════════════════════════════════════════════════════════════

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.formSectionTitle),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }
}
