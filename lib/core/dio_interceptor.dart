import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture/core/constants/urls.dart';

class DioInterceptors extends InterceptorsWrapper {
  final Dio _dio;
  DioInterceptors(this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("onRequest Dio");
    print(options.path);

    if (options.headers.containsKey('requiresApiKey')) {
      options.queryParameters["api_key"] = Urls.kApiKey;
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("onResponse Dio");
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError dioError, ErrorInterceptorHandler handler) async {
    print("onError Dio");
    int? responseCode = dioError.response?.statusCode;
    // if (responseCode != null && responseCode == 401) {
    //   // No Api Key
    //   print("401");
    //   Options options = Options(
    //     method: dioError.requestOptions.method,
    //     headers: dioError.requestOptions.headers
    //       ..addAll({'requiresApiKey': true}),
    //   );
    //   final newRequest = await _dio.request(
    //     dioError.requestOptions.path,
    //     options: options,
    //     data: dioError.requestOptions.data,
    //     queryParameters: dioError.requestOptions.queryParameters,
    //   );

    //   return handler.resolve(newRequest);
    // }

    return super.onError(dioError, handler);
  }
}
