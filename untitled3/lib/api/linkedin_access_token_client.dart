import 'package:dio/dio.dart';
//import 'package:google_signin/api/response_models/linkedin_access_token.dart';
import 'package:retrofit/http.dart';
import 'package:untitled3/api/response_models/linkedin_access_token.dart';

import 'api_list.dart';

part 'linkedin_access_token_client.g.dart';

@RestApi(baseUrl: kLinkedInAccessTokenBaseURL)
abstract class LinkedInAccessTokenClient {
  factory LinkedInAccessTokenClient(Dio dio, {String baseUrl}) = _LinkedInAccessTokenClient;

  @POST(kGenerateAccessToken)
  Future<LinkedInAccessToken> getAccessToken(
      @Query('grant_type') String grantType,
      @Query('code') String code,
      @Query('redirect_uri') String redirectURI,
      @Query('state') String state,
      @Query('client_id') String clientId,
      @Query('client_secret') String clientSecret);
}
