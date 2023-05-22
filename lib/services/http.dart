import 'package:dio/dio.dart';

import 'environment.dart';

class ResponseInterceptors extends Interceptor {}

class HttpClient {
  HttpClient._private();
  static final _dio = Dio(BaseOptions(baseUrl: Env.backendURL));
  static Dio get dio {
    _dio.interceptors.add(ResponseInterceptors());
    return _dio;
  }
}
