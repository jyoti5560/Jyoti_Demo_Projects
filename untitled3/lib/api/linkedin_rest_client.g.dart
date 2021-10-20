// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_rest_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _LinkedInRestClient implements LinkedInRestClient {
  _LinkedInRestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.linkedin.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<LinkedInUser> getCurrentUser(projection) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'projection': projection};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LinkedInUser>(
            Options(method: 'GET', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/v2/me',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LinkedInUser.fromJson(_result.data!);
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
