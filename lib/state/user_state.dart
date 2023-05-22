
import 'package:dio/dio.dart';
import 'package:flutter_idcard_reader/models/error_model.dart';
import 'package:flutter_idcard_reader/models/pageable_with_search.dart';
import 'package:flutter_idcard_reader/models/user_model.dart';
import 'package:flutter_idcard_reader/repositorys/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/login_model.dart';
import '../services/http.dart';
import '../services/shared_service.dart';

AutoDisposeStateProvider<AsyncValue<Pagination<List<UserModel>>?>> usersList =
    StateProvider.autoDispose<AsyncValue<Pagination<List<UserModel>>?>>((ref) {
  return const AsyncValue.loading();
});

AutoDisposeStateProvider<UserModel?> currentUser =
    StateProvider.autoDispose<UserModel?>((ref) {
  return null;
});

AutoDisposeStateProvider<AppError?> errorState =
    StateProvider.autoDispose<AppError?>((ref) {
  return null;
});

final userRepositoryProvider =
    Provider.autoDispose((ref) => UserRepository(HttpClient.dio));

final userController = Provider.autoDispose((ref) => UserController(ref));

class UserController {
  final Ref _read;

  UserController(this._read);

  Future<void> init() async {
    await fetchAllUsers(0, 15, '');
  }

  Future<void> dispose() async {}

  Future<void> fetchAllUsers(int offset, int limit, String name) async {
    try {
      final out = await _read.read(userRepositoryProvider).getAllUsers(
          PageableWithSearch(offset: offset, limit: limit, search: name));
      _read.read(usersList.notifier).state = AsyncValue.data(out);
    } on DioError catch (err) {
      _read.read(errorState.notifier).state =
          AppError.fromJson(err.response?.data);
      _read.read(usersList.notifier).state = AsyncValue.error(err);
    }
  }

  Future<void> loginUsers(LoginModel model) async {
    try {
      final out = await _read.read(userRepositoryProvider).userLogin(model);
      SharedService.setLoginDetails(out);
      _read.read(currentUser.notifier).state = out;
    } on DioError catch (err) {
      _read.read(errorState.notifier).state =
          AppError.fromJson(err.response?.data);
    }
  }
}
