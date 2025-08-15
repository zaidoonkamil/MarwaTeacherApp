import 'package:dio/dio.dart';

class DioHelperVimeo {
  static late Dio dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.vimeo.com',
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/vnd.vimeo.*+json;version=3.4',
        },
      ),
    );
  }

  static Future<Response> getDataVimeo({
    required String url,
    required String token,
    Map<String, dynamic>? query,
  }) async {
    return dio.get(
      url,
      queryParameters: query,
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
    );
  }
}