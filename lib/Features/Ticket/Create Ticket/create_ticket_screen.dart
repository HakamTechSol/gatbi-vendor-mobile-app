import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';

import 'Models/create_ticket_model.dart';
import 'Controller/create_ticket_controller.dart';
import 'Reuse Widgets/create_ticket_form.dart';
import 'Reuse Widgets/create_ticket_header.dart';
import 'Reuse Widgets/ticket_message_field.dart';
import 'Reuse Widgets/ticket_priority_selector.dart';
import 'Reuse Widgets/ticket_submit_section.dart';
import 'Reuse Widgets/ticket_support_tip.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key, this.onBack, this.onSubmit});

  /// Called when the user wants to leave the screen.
  ///
  /// If null, Navigator.maybePop() is used.
  final VoidCallback? onBack;

  /// Called after the ticket is successfully created.
  ///
  /// The complete API response is provided through [CreateTicketModel].
  final ValueChanged<CreateTicketModel>? onSubmit;

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _subjectController;
  late final TextEditingController _messageController;

  String? _selectedCategory;
  String? _selectedPriority;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _subjectController = TextEditingController();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  // ============================================================
  // BACK
  // ============================================================

  void _handleBack() {
    if (_isSubmitting) {
      return;
    }

    if (widget.onBack != null) {
      widget.onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

  // ============================================================
  // SUBJECT VALIDATOR
  // ============================================================

  String? _validateSubject(String? value) {
    final subject = value?.trim() ?? '';

    if (subject.isEmpty) {
      return 'Please enter a subject';
    }

    if (subject.length < 5) {
      return 'Subject must be at least 5 characters';
    }

    if (subject.length > 150) {
      return 'Subject cannot exceed 150 characters';
    }

    return null;
  }

  // ============================================================
  // CATEGORY VALIDATOR
  // ============================================================

  String? _validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category';
    }

    return null;
  }

  // ============================================================
  // PRIORITY VALIDATOR
  // ============================================================

  String? _validatePriority(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a priority';
    }

    return null;
  }

  // ============================================================
  // MESSAGE VALIDATOR
  // ============================================================

  String? _validateMessage(String? value) {
    final message = value?.trim() ?? '';

    if (message.isEmpty) {
      return 'Please describe your issue';
    }

    if (message.length < 10) {
      return 'Message must be at least 10 characters';
    }

    if (message.length > 2000) {
      return 'Message cannot exceed 2000 characters';
    }

    return null;
  }

  // ============================================================
  // CREATE TICKET
  // ============================================================

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (_isSubmitting) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // ----------------------------------------------------------
    // Validate Selected Values
    // ----------------------------------------------------------

    final category = _selectedCategory?.trim();
    final priority = _selectedPriority?.trim();

    if (category == null || category.isEmpty) {
      _showErrorMessage('Please select a category.');
      return;
    }

    if (priority == null || priority.isEmpty) {
      _showErrorMessage('Please select a priority.');
      return;
    }

    // ----------------------------------------------------------
    // Request Values
    // ----------------------------------------------------------

    final subject = _subjectController.text.trim();
    final message = _messageController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      // --------------------------------------------------------
      // Get Controller
      // --------------------------------------------------------

      final controller = ref.read(createTicketControllerProvider);

      // --------------------------------------------------------
      // API Request
      // --------------------------------------------------------

      final result = await controller.createTicket(
        subject: subject,
        category: category,
        priority: priority,
        message: message,
      );

      // --------------------------------------------------------
      // Mounted Check
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // API Success Validation
      // --------------------------------------------------------

      if (result.success) {
        // ------------------------------------------------------
        // Notify Parent
        // ------------------------------------------------------

        widget.onSubmit?.call(result);

        context.push(AppRoutes.supportTickets);

        // ------------------------------------------------------
        // Show Success
        // ------------------------------------------------------

        _showSuccessMessage(result);

        // ------------------------------------------------------
        // Clear Form
        // ------------------------------------------------------

        _clearForm();

        return;
      }

      // --------------------------------------------------------
      // API Returned success = false
      // --------------------------------------------------------

      _showErrorMessage(
        result.message?.trim().isNotEmpty == true
            ? result.message!.trim()
            : 'Unable to create support ticket. Please try again.',
      );
    } on ApiException catch (error) {
      // --------------------------------------------------------
      // API Exception
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      _showErrorMessage(
        error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Unable to create support ticket. Please try again.',
      );
    } catch (error) {
      // --------------------------------------------------------
      // Unexpected Error
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      _showErrorMessage('Something went wrong. Please try again.');
    } finally {
      // --------------------------------------------------------
      // Stop Loading
      // --------------------------------------------------------

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // CLEAR FORM
  // ============================================================

  void _clearForm() {
    _subjectController.clear();
    _messageController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedPriority = null;
    });

    _formKey.currentState?.reset();
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage(CreateTicketModel result) {
    final ticket = result.ticket;

    final ticketNumber = ticket?.ticketNumber?.trim();

    final message = ticketNumber != null && ticketNumber.isNotEmpty
        ? 'Ticket $ticketNumber created successfully.'
        : result.message?.trim().isNotEmpty == true
        ? result.message!.trim()
        : 'Your ticket has been submitted successfully.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red.shade600,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // Header
            // --------------------------------------------------
            CreateTicketHeader(onBack: _handleBack),

            // --------------------------------------------------
            // Form
            // --------------------------------------------------
            Expanded(
              child: Form(
                key: _formKey,
                child: CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // ----------------------------------
                          // Intro
                          // ----------------------------------
                          _buildIntroSection(),

                          const SizedBox(height: 20),

                          // ----------------------------------
                          // Subject + Category
                          // ----------------------------------
                          CreateTicketForm(
                            subjectController: _subjectController,
                            selectedCategory: _selectedCategory,
                            onCategoryChanged: (value) {
                              if (_isSubmitting) {
                                return;
                              }

                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            subjectValidator: _validateSubject,
                            categoryValidator: _validateCategory,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          // ----------------------------------
                          // Priority
                          // ----------------------------------
                          TicketPrioritySelector(
                            value: _selectedPriority,
                            onChanged: (value) {
                              if (_isSubmitting) {
                                return;
                              }

                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                            validator: _validatePriority,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          // ----------------------------------
                          // Message
                          // ----------------------------------
                          TicketMessageField(
                            controller: _messageController,
                            validator: _validateMessage,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          // ----------------------------------
                          // Support Tip
                          // ----------------------------------
                          const TicketSupportTip(),

                          const SizedBox(height: 22),

                          // ----------------------------------
                          // Submit
                          // ----------------------------------
                          TicketSubmitSection(
                            onSubmit: _handleSubmit,
                            isLoading: _isSubmitting,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 8),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INTRO SECTION
  // ============================================================

  Widget _buildIntroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How can we help?',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Fill in the details below and our support team will get back to you.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}
