// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'linkedin_access_token_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _LinkedInAccessTokenClient implements LinkedInAccessTokenClient {
  _LinkedInAccessTokenClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://www.linkedin.com/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<LinkedInAccessToken> getAccessToken(
      grantType, code, redirectURI, state, clientId, clientSecret) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'grant_type': grantType,
      r'code': code,
      r'redirect_uri': redirectURI,
      r'state': state,
      r'client_id': clientId,
      r'client_secret': clientSecret
    };
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<LinkedInAccessToken>(
            Options(method: 'POST', headers: <String, dynamic>{}, extra: _extra)
                .compose(_dio.options, '/oauth/v2/accessToken?',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = LinkedInAccessToken.fromJson(_result.data!);
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
