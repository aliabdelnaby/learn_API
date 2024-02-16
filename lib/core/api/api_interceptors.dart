import 'package:dio/dio.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/api/end_points.dart';
import 'package:happy_tech_mastering_api_with_flutter/core/cache/cache_helper.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[ApiKeys.token] =
        CacheHelper().getData(key: ApiKeys.token) != null
            ? "FOODAPI ${CacheHelper().getData(key: ApiKeys.token)}"
            : null;
    super.onRequest(options, handler);
  }
}
