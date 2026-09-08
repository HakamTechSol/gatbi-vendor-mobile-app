import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

import '../Models/create_ticket_model.dart';

import 'Reuse Widgets/create_ticket_form.dart';
import 'Reuse Widgets/create_ticket_header.dart';
import 'Reuse Widgets/ticket_message_field.dart';
import 'Reuse Widgets/ticket_priority_selector.dart';
import 'Reuse Widgets/ticket_submit_section.dart';
import 'Reuse Widgets/ticket_support_tip.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key, this.onBack, this.onSubmit});

  /// Called when the user wants to leave the screen.
  ///
  /// If null, Navigator.maybePop() is used.
  final VoidCallback? onBack;

  /// Called after the form passes validation.
  ///
  /// The complete form data is provided through [CreateTicketModel].
  final ValueChanged<CreateTicketModel>? onSubmit;

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
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

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

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

  String? _validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a category';
    }

    return null;
  }

  String? _validatePriority(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please select a priority';
    }

    return null;
  }

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

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid || _isSubmitting) {
      return;
    }

    final ticket = CreateTicketModel(
      subject: _subjectController.text.trim(),
      category: _selectedCategory!.trim(),
      priority: _selectedPriority!.trim(),
      message: _messageController.text.trim(),
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      widget.onSubmit?.call(ticket);

      // Temporary UI-only delay.
      //
      // This will later be replaced by the actual API request.
      await Future<void>.delayed(const Duration(milliseconds: 700));

      if (!mounted) {
        return;
      }

      _showSuccessMessage();
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Your ticket has been submitted successfully.'),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CreateTicketHeader(onBack: _handleBack),

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
                          _buildIntroSection(),

                          const SizedBox(height: 20),

                          CreateTicketForm(
                            subjectController: _subjectController,
                            selectedCategory: _selectedCategory,
                            onCategoryChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                            subjectValidator: _validateSubject,
                            categoryValidator: _validateCategory,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          TicketPrioritySelector(
                            value: _selectedPriority,
                            onChanged: (value) {
                              setState(() {
                                _selectedPriority = value;
                              });
                            },
                            validator: _validatePriority,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          TicketMessageField(
                            controller: _messageController,
                            validator: _validateMessage,
                            enabled: !_isSubmitting,
                          ),

                          const SizedBox(height: 18),

                          const TicketSupportTip(),

                          const SizedBox(height: 22),

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
