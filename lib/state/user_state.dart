import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/mock_data.dart';
import '../models/error_model.dart';
import '../models/login_model.dart';
import '../models/pageable_with_search.dart';
import '../models/user_model.dart';
import '../repositorys/user_repository.dart';
import '../services/http.dart';
import '../services/shared_service.dart';

AutoDisposeStateProvider<AsyncValue<Pagination<List<UserModel>>?>> usersList =
    StateProvider.autoDispose<AsyncValue<Pagination<List<UserModel>>?>>((ref) {
  return const AsyncValue.loading();
});

AutoDisposeStateProvider<UserModel?> currentUser =
    StateProvider.autoDispose<UserModel?>((ref) {
  return mockUserData;
});

AutoDisposeStateProvider<AppError?> errorState =
    StateProvider.autoDispose<AppError?>((ref) {
  return null;
});

final userRepositoryProvider =
    Provider.autoDispose((ref) => UserRepository(HttpClient.dio));

final userController = Provider.autoDispose((ref) => UserController(ref));

class UserController {
  final Ref _ref;

  UserController(this._ref);

  Future<void> init() async {
    await fetchAllUsers(0, 15, '');
  }

  Future<void> dispose() async {}

  Future<void> fetchAllUsers(int offset, int limit, String name) async {
    try {
      final out = await _ref.read(userRepositoryProvider).getAllUsers(
          PageableWithSearch(offset: offset, limit: limit, search: name));
      _ref.read(usersList.notifier).state = AsyncValue.data(out);
    } on DioError catch (err) {
      _ref.read(errorState.notifier).state =
          AppError(ErrorMessage('${err.message}'));
      _ref.read(usersList.notifier).state = AsyncValue.error(err);
    }
  }

  Future<void> loginUsers(LoginModel model) async {
    try {
      final out = await _ref.read(userRepositoryProvider).userLogin(model);
      SharedService.setLoginDetails(out);
      _ref.read(currentUser.notifier).state = out;
    } on DioError catch (err) {
      _ref.read(errorState.notifier).state =
          AppError.fromJson(err.response?.data);
    }
  }
}
