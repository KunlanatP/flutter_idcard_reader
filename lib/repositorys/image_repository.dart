import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_idcard_reader/models/image_model.dart';
import 'package:flutter_idcard_reader/models/query_model.dart';

import '../services/environment.dart';

import 'dart:io';
import 'package:retrofit/retrofit.dart';

part 'image_repository.g.dart';

@RestApi()
abstract class ImageRepository {
  factory ImageRepository(Dio dio) = _ImageRepository;
  @POST('/images')
  @MultiPart()
  Future<ImageModel> createImage(
    @Queries() QueryModelImage query,
    @Part() File image,
  );

  // @GET('/apps/{appId}/images')
  // Future<List<ImageModel>?> getImageByAppId(@Path('appId') String appID);

  // @GET('/apps/{appId}/images/{id}')
  // Future<ImageModel> getImageById(
  //   @Path('appId') String appID,
  //   @Path('id') String id,
  // );

  // @DELETE('/apps/{appid}/images/{id}')
  // Future<StatusModel> deleteImageById(
  //   @Path('appid') String appId,
  //   @Path('id') String id,
  // );
}

class ImageByteRepository {
  final Dio _dio;

  ImageByteRepository(this._dio);

  Future<ImageModel> createImageFromByte(
      String appID, Uint8List byteImage, String filename) async {
    const extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final headers = <String, dynamic>{};
    final data = FormData();
    data.files.add(MapEntry(
        'image', MultipartFile.fromBytes(byteImage, filename: filename)));
    final result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ImageModel>(Options(
                method: 'POST',
                headers: headers,
                extra: extra,
                contentType: 'multipart/form-data')
            .compose(_dio.options, '/apps/$appID/images',
                queryParameters: queryParameters, data: data)
            .copyWith(baseUrl: Env.backendURL)));
    final value = ImageModel.fromJson(result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
