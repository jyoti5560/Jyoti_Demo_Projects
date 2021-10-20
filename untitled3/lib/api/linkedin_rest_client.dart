
import 'package:dio/dio.dart';
//import 'package:google_signin/api/api_list.dart';
//import 'package:google_signin/api/response_models/linkedin_user.dart';
/*import 'package:linkedin_login/api/api_list.dart';
import 'package:linkedin_login/api/response_models/linkedin_user.dart';*/
import 'package:retrofit/http.dart';
import 'package:untitled3/api/api_list.dart';
import 'package:untitled3/api/response_models/linkedin_user.dart';

part 'linkedin_rest_client.g.dart';

@RestApi(baseUrl: kLinkedInBaseURL)
abstract class LinkedInRestClient {
  factory LinkedInRestClient(Dio dio, {String baseUrl}) = _LinkedInRestClient;

  @GET(kMe)
  Future<LinkedInUser> getCurrentUser(@Query('projection') String projection);
}