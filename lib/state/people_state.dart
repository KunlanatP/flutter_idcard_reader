import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_idcard_reader/models/query_model.dart';
import 'package:flutter_idcard_reader/state/user_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/error_model.dart';
import '../models/image_model.dart';
import '../repositorys/image_repository.dart';
import '../services/http.dart';

AutoDisposeStateProvider<AsyncValue<List<ImageModel>?>> imageList =
    StateProvider.autoDispose<AsyncValue<List<ImageModel>?>>((ref) {
  return const AsyncValue.loading();
});

AutoDisposeStateProvider<AsyncValue<ImageModel>> imageData =
    StateProvider.autoDispose<AsyncValue<ImageModel>>((ref) {
  return const AsyncValue.loading();
});

AutoDisposeProvider<ImageRepository> imageRepositoryProvider =
    Provider.autoDispose((ref) => ImageRepository(HttpClient.dio));

AutoDisposeProvider<ImageByteRepository> imageByteRepositoryProvider =
    Provider.autoDispose((ref) => ImageByteRepository(HttpClient.dio));

AutoDisposeProvider<ImageController> imageController =
    Provider.autoDispose((ref) => ImageController(ref));

AutoDisposeStateProvider<bool> isDeletedImage =
    StateProvider.autoDispose<bool>((ref) {
  return false;
});

class ImageController {
  final Ref _ref;

  ImageController(this._ref);

  Future<void> init() async {
    _ref.read(imageList.notifier).state = const AsyncValue.loading();
  }

  Future<void> createImage(QueryModelImage query, File image) async {
    try {
      final out =
          await _ref.read(imageRepositoryProvider).createImage(query, image);
      final prev = _ref.read(imageList).value;
      final data = <ImageModel>[...prev ?? [], out];
      _ref.read(imageList.notifier).state = AsyncValue.data(data);
    } on DioError catch (err) {
      _ref.read(errorState.notifier).state = AppError.fromJson(err.response?.data);
    }
  }

  // Future<void> createImageFromByte(
  //     String appId, Uint8List image, String imageName) async {
  //   try {
  //     final out = await _ref(imageByteRepositoryProvider)
  //         .createImageFromByte(appId, image, imageName);
  //     final prev = _ref(imageList).value;
  //     final data = <ImageModel>[...prev ?? [], out];
  //     _ref(imageList.notifier).state = AsyncValue.data(data);
  //   } on DioError catch (err) {
  //     _ref(errorState.notifier).state = AppError.fromJson(err.response?.data);
  //   }
  // }

  // Future<void> deleteImageByID(String appID, String id) async {
  //   try {
  //     await _ref(imageRepositoryProvider).deleteImageById(appID, id);

  //     final prev = _ref(imageList).value;
  //     prev?.removeWhere((item) => item.id == id);
  //     _ref(imageList.notifier).state = AsyncValue.data([...prev!]);
  //     await fetchImage(appID);
  //   } on DioError catch (err) {
  //     if (err.response?.statusCode != 404) {
  //       _ref(errorState.notifier).state =
  //           AppError.fromJson(err.response?.data);
  //       _ref(imageList.notifier).state = AsyncValue.error(err);
  //     }
  //   }
  // }

  // Future<void> dispose() async {
  //   _ref(imageList.notifier).state = const AsyncValue.loading();
  // }

  // Future<void> fetchImage(String appId) async {
  //   try {
  //     final out = await _ref(imageRepositoryProvider).getImageByAppId(appId);
  //     _ref(imageList.notifier).state = AsyncValue.data(out);
  //   } on DioError catch (err) {
  //     _ref(errorState.notifier).state = AppError(ErrorMessage(err.message));
  //     _ref(imageList.notifier).state = AsyncValue.error(err);
  //   }
  // }

  // Future<void> fetchImageByID(String appId, String id) async {
  //   try {
  //     final out = await _ref(imageRepositoryProvider).getImageById(appId, id);
  //     _ref(imageData.notifier).state = AsyncValue.data(out);
  //   } on DioError catch (err) {
  //     _ref(errorState.notifier).state = AppError(ErrorMessage(err.message));
  //     _ref(imageData.notifier).state = AsyncValue.error(err);
  //   }
  // }
}
