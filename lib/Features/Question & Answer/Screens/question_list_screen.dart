import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Answer/Controller/answer_controller.dart';

import '../Question/Controller/question_controller.dart';
import '../Question/Models/question_item_model.dart';

import '../Reuse Widgets/question_card.dart';
import '../Reuse Widgets/question_empty_state.dart';
import '../Reuse Widgets/question_error_state.dart';
import '../Reuse Widgets/question_list_header.dart';
import '../Reuse Widgets/question_loading.dart';

class QuestionListScreen extends ConsumerStatefulWidget {
  const QuestionListScreen({super.key});

  @override
  ConsumerState<QuestionListScreen> createState() => _QuestionListScreenState();
}

class _QuestionListScreenState extends ConsumerState<QuestionListScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  late final ScrollController _scrollController;

  // ============================================================
  // Questions
  // ============================================================

  final List<QuestionItemModel> _questions = [];

  // ============================================================
  // Loading States
  // ============================================================

  bool _isInitialLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;

  /// Answer submit ke baad full shimmer show karne ke liye.
  bool _isAnswerRefreshing = false;

  // ============================================================
  // Error
  // ============================================================

  String? _questionsError;

  // ============================================================
  // Pagination
  // ============================================================

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;

  static const int _pageLimit = 100;

  // ============================================================
  // Answer Loading
  // ============================================================

  final Set<int> _answeringQuestionIds = <int>{};

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialQuestions();
    });
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // Initial Load
  // ============================================================

  Future<void> _loadInitialQuestions() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isInitialLoading = true;
      _questionsError = null;
    });

    try {
      final controller = ref.read(questionControllerProvider);

      final result = await controller.getQuestions(page: 1, limit: _pageLimit);

      if (!mounted) {
        return;
      }

      setState(() {
        _questions
          ..clear()
          ..addAll(result.questions);

        _currentPage = result.pagination?.currentPage ?? 1;
        _totalPages = result.pagination?.totalPages ?? 1;
        _totalItems = result.pagination?.totalItems ?? result.questions.length;

        _questionsError = null;
        _isInitialLoading = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _questionsError = _getApiErrorMessage(error);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _questionsError = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // Pull To Refresh
  // ============================================================

  Future<void> _refreshQuestions() async {
    if (_isRefreshing || _isInitialLoading || _isAnswerRefreshing) {
      return;
    }

    if (mounted) {
      setState(() {
        _isRefreshing = true;
        _questionsError = null;
      });
    }

    try {
      final controller = ref.read(questionControllerProvider);

      final result = await controller.getQuestions(page: 1, limit: _pageLimit);

      if (!mounted) {
        return;
      }

      setState(() {
        _questions
          ..clear()
          ..addAll(result.questions);

        _currentPage = result.pagination?.currentPage ?? 1;
        _totalPages = result.pagination?.totalPages ?? 1;
        _totalItems = result.pagination?.totalItems ?? result.questions.length;

        _questionsError = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      final message = _getApiErrorMessage(error);

      setState(() {
        _questionsError = message;
      });

      _showError(message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      const message = 'Something went wrong. Please try again.';

      setState(() {
        _questionsError = message;
      });

      _showError(message);
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isRefreshing = false;
      });
    }
  }

  // ============================================================
  // Pagination
  // ============================================================

  Future<void> _loadMoreQuestions() async {
    if (_isInitialLoading ||
        _isRefreshing ||
        _isAnswerRefreshing ||
        _isLoadingMore ||
        _currentPage >= _totalPages) {
      return;
    }

    final nextPage = _currentPage + 1;

    if (mounted) {
      setState(() {
        _isLoadingMore = true;
      });
    }

    try {
      final controller = ref.read(questionControllerProvider);

      final result = await controller.getQuestions(
        page: nextPage,
        limit: _pageLimit,
      );

      if (!mounted) {
        return;
      }

      final existingIds = _questions
          .map((item) => item.id)
          .whereType<int>()
          .toSet();

      final newQuestions = result.questions.where((item) {
        final id = item.id;

        if (id == null) {
          return true;
        }

        return !existingIds.contains(id);
      }).toList();

      setState(() {
        _questions.addAll(newQuestions);

        _currentPage = result.pagination?.currentPage ?? nextPage;

        _totalPages = result.pagination?.totalPages ?? _totalPages;

        _totalItems = result.pagination?.totalItems ?? _totalItems;

        _isLoadingMore = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showError(_getApiErrorMessage(error));
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showError('Something went wrong while loading more questions.');
    }
  }

  // ============================================================
  // Scroll Listener
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_isAnswerRefreshing) {
      return;
    }

    final position = _scrollController.position;

    const threshold = 500.0;

    if (position.maxScrollExtent - position.pixels <= threshold) {
      unawaited(_loadMoreQuestions());
    }
  }

  // ============================================================
  // Answer Question
  // ============================================================

  Future<void> _submitAnswer({
    required QuestionItemModel question,
    required String answer,
  }) async {
    final questionId = question.id;

    if (questionId == null) {
      _showError('Question ID is missing. Unable to submit the answer.');
      return;
    }

    if (_answeringQuestionIds.contains(questionId)) {
      return;
    }

    if (mounted) {
      setState(() {
        _answeringQuestionIds.add(questionId);
      });
    }

    try {
      final controller = ref.read(answerControllerProvider);

      final result = await controller.answerQuestion(
        questionId: questionId,
        answer: answer,
      );

      if (!mounted) {
        return;
      }

      // ==========================================================
      // API FAILED
      // ==========================================================

      if (result.success == false) {
        _showError(
          result.message?.trim().isNotEmpty == true
              ? result.message!.trim()
              : 'Unable to submit the answer.',
        );
        return;
      }

      // ==========================================================
      // ANSWER API SUCCESS
      // ==========================================================

      _showSuccess(
        result.message?.trim().isNotEmpty == true
            ? result.message!.trim()
            : 'Answer submitted successfully.',
      );

      // ==========================================================
      // IMPORTANT
      // ==========================================================
      //
      // Answer successfully submit hone ke baad:
      //
      // 1. Existing list hide
      // 2. Full shimmer show
      // 3. Questions GET API call
      // 4. Fresh response list mein set
      // 5. Shimmer hide
      //
      // ==========================================================

      await _reloadQuestionsWithShimmer();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(_getApiErrorMessage(error));
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError('Something went wrong while submitting the answer.');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _answeringQuestionIds.remove(questionId);
      });
    }
  }

  // ============================================================
  // Reload Questions With Shimmer
  // ============================================================

  Future<void> _reloadQuestionsWithShimmer() async {
    if (!mounted) {
      return;
    }

    // ==========================================================
    // SHOW FULL SHIMMER
    // ==========================================================

    setState(() {
      _isAnswerRefreshing = true;
      _questionsError = null;
    });

    try {
      final controller = ref.read(questionControllerProvider);

      // ========================================================
      // GET FRESH QUESTIONS
      // ========================================================

      final result = await controller.getQuestions(page: 1, limit: _pageLimit);

      if (!mounted) {
        return;
      }

      // ========================================================
      // UPDATE LIST FROM SERVER
      // ========================================================

      setState(() {
        _questions
          ..clear()
          ..addAll(result.questions);

        _currentPage = result.pagination?.currentPage ?? 1;

        _totalPages = result.pagination?.totalPages ?? 1;

        _totalItems = result.pagination?.totalItems ?? result.questions.length;

        _questionsError = null;

        _isAnswerRefreshing = false;
      });

      // ========================================================
      // OPTIONAL: TOP PAR WAPAS
      // ========================================================

      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAnswerRefreshing = false;
        _questionsError = _getApiErrorMessage(error);
      });

      _showError('Answer submitted, but questions could not be refreshed.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isAnswerRefreshing = false;
        _questionsError = 'Something went wrong while refreshing questions.';
      });

      _showError('Answer submitted, but questions could not be refreshed.');
    }
  }

  // ============================================================
  // Retry
  // ============================================================

  Future<void> _retry() async {
    await _loadInitialQuestions();
  }

  // ============================================================
  // API Error Message
  // ============================================================

  String _getApiErrorMessage(ApiException error) {
    final message = error.message.trim();

    if (message.isNotEmpty) {
      return message;
    }

    return 'Something went wrong. Please try again.';
  }

  // ============================================================
  // Success SnackBar
  // ============================================================

  void _showSuccess(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.success,
        ),
      );
  }

  // ============================================================
  // Error SnackBar
  // ============================================================

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(message)),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.error,
        ),
      );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: QuestionListHeader(
          onBack: () {
            context.pop();
          },
        ),
      ),
    );
  }

  // ============================================================
  // Questions Section Header
  // ============================================================

  Widget _buildSectionHeader() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 2, 16, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Questions',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _buildQuestionCountText(),
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildCountBadge(),
          ],
        ),
      ),
    );
  }

  String _buildQuestionCountText() {
    if (_totalItems == 0) {
      return 'Questions from your customers';
    }

    if (_totalItems == 1) {
      return '1 customer question';
    }

    return '$_totalItems customer questions';
  }

  Widget _buildCountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$_totalItems',
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ============================================================
  // Question List
  // ============================================================

  Widget _buildQuestionList() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final question = _questions[index];

          final questionId = question.id;

          final isAnswering =
              questionId != null && _answeringQuestionIds.contains(questionId);

          return QuestionCard(
            question: question,
            isAnswering: isAnswering,
            onSubmitAnswer: question.isAnswered == true
                ? null
                : (answer) {
                    return _submitAnswer(question: question, answer: answer);
                  },
          );
        }, childCount: _questions.length),
      ),
    );
  }

  // ============================================================
  // Pagination Loader
  // ============================================================

  Widget _buildPaginationLoader() {
    if (!_isLoadingMore) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 17,
                  height: 17,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 9),
                Text(
                  'Loading more...',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Full Shimmer
  // ============================================================

  Widget _buildAnswerRefreshShimmer() {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        _buildHeader(),

        const SliverToBoxAdapter(child: SizedBox(height: 4)),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: QuestionLoading(itemCount: 3),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    // ============================================================
    // ANSWER SUCCESS -> FULL SHIMMER
    // ============================================================

    if (_isAnswerRefreshing) {
      return _buildAnswerRefreshShimmer();
    }

    // ============================================================
    // INITIAL LOADING
    // ============================================================

    if (_isInitialLoading) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildHeader(),

          const SliverToBoxAdapter(child: SizedBox(height: 4)),

          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: QuestionLoading(itemCount: 3),
            ),
          ),
        ],
      );
    }

    // ============================================================
    // ERROR STATE
    // ============================================================

    if (_questionsError != null && _questions.isEmpty) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildHeader(),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: QuestionErrorState(
                message: _questionsError!,
                onRetry: _retry,
              ),
            ),
          ),
        ],
      );
    }

    // ============================================================
    // MAIN CONTENT
    // ============================================================

    return RefreshIndicator(
      onRefresh: _refreshQuestions,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          _buildHeader(),

          // ======================================================
          // SECTION HEADER
          // ======================================================
          if (_questions.isNotEmpty) _buildSectionHeader(),

          // ======================================================
          // EMPTY - CENTER
          // ======================================================
          if (_questions.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: Center(child: QuestionEmptyState()),
              ),
            ),

          // ======================================================
          // QUESTIONS
          // ======================================================
          if (_questions.isNotEmpty) _buildQuestionList(),

          // ======================================================
          // PAGINATION
          // ======================================================
          if (_questions.isNotEmpty) _buildPaginationLoader(),

          // ======================================================
          // BOTTOM SPACE
          // ======================================================
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
        ],
      ),
    );
  }
}
