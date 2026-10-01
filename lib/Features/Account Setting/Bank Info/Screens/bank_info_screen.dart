import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Edit Profile/Reuse Widgets/edit_profile_header.dart';
import '../../Get Profile/Controller/get_profile_controller.dart';
import '../Controller/bank_info_controller.dart';

class BankInfoScreen extends ConsumerStatefulWidget {
  const BankInfoScreen({super.key});

  @override
  ConsumerState<BankInfoScreen> createState() => _BankInfoScreenState();
}

class _BankInfoScreenState extends ConsumerState<BankInfoScreen> {
  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _bankAccountNameController =
      TextEditingController();

  final TextEditingController _bankAccountNumberController =
      TextEditingController();

  // ============================================================
  // STATE
  // ============================================================

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isSaving = false;

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadBankInfo();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();

    super.dispose();
  }

  // ============================================================
  // GET PROFILE / LOAD BANK INFO
  // ============================================================

  Future<void> _loadBankInfo({bool isRefresh = false}) async {
    if (!mounted) return;

    if (_isRefreshing || _isSaving) {
      return;
    }

    setState(() {
      if (isRefresh) {
        _isRefreshing = true;
      } else {
        _isLoading = true;
      }

      _errorMessage = null;
    });

    try {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('         BANK INFO - GET PROFILE              ');
      debugPrint('==============================================');
      debugPrint('Fetching merchant bank information...');
      debugPrint('');

      final result = await ref
          .read(vendorSettingsControllerProvider)
          .getVendorSettings();

      if (!mounted) return;

      if (result.merchant == null) {
        throw const ApiException(
          message: 'Merchant profile information was not found.',
          code: 'MERCHANT_NOT_FOUND',
        );
      }

      final merchant = result.merchant!;

      final bankAccountName = merchant.bankAccountName?.trim() ?? '';

      final bankAccountNumber = merchant.bankAccountNumber?.trim() ?? '';

      debugPrint('Bank Info GET API Success');
      debugPrint('Merchant ID       : ${merchant.id}');
      debugPrint('Bank Account Name : $bankAccountName');
      debugPrint('Bank Account No   : $bankAccountNumber');
      debugPrint('==============================================');
      debugPrint('');

      _bankAccountNameController.text = bankAccountName;
      _bankAccountNumberController.text = bankAccountNumber;

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _isRefreshing = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('          BANK INFO - GET API ERROR           ');
      debugPrint('==============================================');
      debugPrint('Code    : ${error.code}');
      debugPrint('Message : ${error.message}');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _errorMessage = error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to load bank information.';

        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('       BANK INFO - GET UNKNOWN ERROR          ');
      debugPrint('==============================================');
      debugPrint('Error: $error');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';

        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshBankInfo() async {
    if (_isRefreshing || _isSaving) {
      return;
    }

    await _loadBankInfo(isRefresh: true);
  }

  // ============================================================
  // SAVE / UPDATE BANK INFORMATION
  // ============================================================

  Future<void> _handleSave() async {
    FocusScope.of(context).unfocus();

    if (_isSaving || _isRefreshing) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bankAccountName = _bankAccountNameController.text.trim();

    final bankAccountNumber = _bankAccountNumberController.text.trim();

    setState(() {
      _isSaving = true;
    });

    try {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('        BANK INFO - UPDATE API                ');
      debugPrint('==============================================');
      debugPrint('Bank Account Name : $bankAccountName');
      debugPrint('Account / IBAN    : $bankAccountNumber');
      debugPrint('Sending update request...');
      debugPrint('');

      final result = await ref
          .read(bankInfoControllerProvider)
          .updateBankInfo(
            bankAccountName: bankAccountName,
            bankAccountNumber: bankAccountNumber,
          );

      if (!mounted) return;

      debugPrint('Bank Info Update API Response');
      debugPrint('Success : ${result.success}');
      debugPrint('Message : ${result.message}');
      debugPrint('==============================================');
      debugPrint('');

      // ========================================================
      // API SUCCESS
      // ========================================================

      if (result.success) {
        debugPrint('');
        debugPrint('==============================================');
        debugPrint('       BANK INFO UPDATE SUCCESS              ');
        debugPrint('==============================================');
        debugPrint('Update successful.');
        debugPrint('Refreshing Get Profile API...');
        debugPrint('');

        // ------------------------------------------------------
        // Update successful hone ke baad Get Profile dobara call
        // ------------------------------------------------------

        setState(() {
          _isSaving = false;
        });

        await _loadBankInfo(isRefresh: true);

        if (!mounted) return;

        _showSuccessSnackBar(
          result.message?.trim().isNotEmpty == true
              ? result.message!.trim()
              : 'Bank information updated successfully.',
        );

        return;
      }

      // ========================================================
      // API RETURNED success = false
      // ========================================================

      debugPrint('Bank Info Update API returned success = false');

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showErrorSnackBar(
        result.message?.trim().isNotEmpty == true
            ? result.message!.trim()
            : 'Unable to update bank information.',
      );
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('       BANK INFO - UPDATE API ERROR           ');
      debugPrint('==============================================');
      debugPrint('Code    : ${error.code}');
      debugPrint('Message : ${error.message}');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showErrorSnackBar(
        error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to update bank information.',
      );
    } catch (error) {
      debugPrint('');
      debugPrint('==============================================');
      debugPrint('     BANK INFO - UPDATE UNKNOWN ERROR         ');
      debugPrint('==============================================');
      debugPrint('Error: $error');
      debugPrint('==============================================');
      debugPrint('');

      if (!mounted) return;

      setState(() {
        _isSaving = false;
      });

      _showErrorSnackBar('Something went wrong. Please try again.');
    }
  }

  // ============================================================
  // VALIDATORS
  // ============================================================

  String? _bankAccountNameValidator(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Bank account name is required.';
    }

    return null;
  }

  String? _bankAccountNumberValidator(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'Account number or IBAN is required.';
    }

    if (text.length < 4) {
      return 'Please enter a valid account number or IBAN.';
    }

    return null;
  }

  // ============================================================
  // SUCCESS SNACKBAR
  // ============================================================

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // ERROR SNACKBAR
  // ============================================================

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // MAIN BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // HEADER
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: EditProfileHeader(
                title: 'Bank Information',
                subtitle: 'Manage your bank account details securely.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),

            // ==================================================
            // CONTENT
            // ==================================================
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

Widget _buildBody() {
  if (_isLoading) {
    return _buildInitialLoading();
  }

  if (_errorMessage != null) {
    return _buildErrorState();
  }

  return RefreshIndicator(
    color: AppColors.primary,
    backgroundColor: AppColors.white,
    onRefresh: _refreshBankInfo,
    child: LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            20,
            8,
            20,
            32,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 40,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // BANK INFO CARD
                    // ==================================================

                    _buildBankInfoCard(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // REFRESHING INDICATOR
                    // ==================================================

                    if (_isRefreshing) ...[
                      _buildRefreshingIndicator(),
                      const SizedBox(height: 16),
                    ],

                    // ==================================================
                    // SAVE BUTTON
                    // ==================================================

                    CustomButton(
                      text: 'Save Bank Information',
                      icon: Icons.save_outlined,
                      onPressed: _handleSave,
                      isLoading: _isSaving,
                      isEnabled:
                          !_isRefreshing && !_isSaving,
                    ),

                    const SizedBox(height: 12),

                    // ==================================================
                    // INFO NOTE
                    // ==================================================

                    _buildInfoNote(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}


  // ============================================================
  // BANK INFO CARD
  // ============================================================

  Widget _buildBankInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================================================
          // CARD HEADER
          // ==================================================
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bank Details', style: AppTextStyles.titleLarge),
                    const SizedBox(height: 3),
                    Text(
                      'Enter the account details used for payouts.',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ==================================================
          // BANK ACCOUNT NAME
          // ==================================================
          CustomTextField(
            controller: _bankAccountNameController,
            label: 'Bank Account Name',
            hintText: 'Enter bank account name',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: _bankAccountNameValidator,
            enabled: !_isSaving,
          ),

          const SizedBox(height: 18),

          // ==================================================
          // ACCOUNT NUMBER / IBAN
          // ==================================================
          CustomTextField(
            controller: _bankAccountNumberController,
            label: 'Account Number',
            hintText: 'Enter account number',
            prefixIcon: Icons.credit_card_outlined,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
            ],
            validator: _bankAccountNumberValidator,
            enabled: !_isSaving,
          ),

          const SizedBox(height: 8),

          Text(
            'You can enter either your bank account number or IBAN.',
            style: AppTextStyles.formHelper,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INITIAL LOADING
  // ============================================================

  Widget _buildInitialLoading() {
    return Center(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.8,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Text(
              'Loading bank information',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 6),

            Text(
              'Please wait while we fetch your merchant details.',
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // REFRESHING INDICATOR
  // ============================================================

  Widget _buildRefreshingIndicator() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Text(
            'Refreshing bank information...',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.errorBorder),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 28,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Unable to load bank information',
                style: AppTextStyles.errorTitle,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                _errorMessage ?? 'Something went wrong. Please try again.',
                style: AppTextStyles.errorDescription,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: 'Try Again',
                icon: Icons.refresh_rounded,
                onPressed: () {
                  _loadBankInfo();
                },
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // INFO NOTE
  // ============================================================

  Widget _buildInfoNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.info,
            size: 20,
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              'Your bank account information is used for merchant payout processing.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.infoDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
