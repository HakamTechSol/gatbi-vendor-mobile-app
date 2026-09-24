// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../../../Services/api_exception.dart';
// import '../../../../../Services/dio.dart';
// import '../../../../../Services/dio_client.dart';
// import '../Models/get_categories_model.dart';
// import '../Repo/get_categories_repo.dart';

// // ============================================================
// // Get Categories Provider
// // ============================================================

// final getCategoriesControllerProvider = Provider<GetCategoriesController>((
//   ref,
// ) {
//   final dioClient = ref.watch(dioProvider);

//   return GetCategoriesController(dioClient: dioClient);
// });

// // ============================================================
// // Get Categories Controller
// // ============================================================

// class GetCategoriesController {
//   GetCategoriesController({required DioClient dioClient})
//     : _repository = GetCategoriesRepository(dioClient);

//   final GetCategoriesRepository _repository;

//   // ==========================================================
//   // Get Categories
//   // ==========================================================

//   Future<GetCategoriesModel> getCategories() async {
//     try {
//       final result = await _repository.getCategories();

//       return result;
//     } on ApiException {
//       // Existing API exception ko as-is UI tak jane dein.
//       // Is se statusCode, code aur validation/error details
//       // preserve rehti hain.
//       rethrow;
//     } catch (error) {
//       // Unexpected errors ko standard ApiException mein convert
//       // kar rahe hain.
//       throw ApiException(
//         message: 'Something went wrong. Please try again.',
//         code: 'UNKNOWN_ERROR',
//         originalError: error,
//       );
//     }
//   }
// }
