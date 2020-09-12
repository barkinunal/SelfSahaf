
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:dio/dio.dart';

class MailService extends GeneralServices {
  Dio _dio;
  MailService() {
    this._dio = super.dio;
  }
  Future<APIResponse<int>> sendEmailToUser(String context, String userEmail, String title) async{
    try{
      Response response=await _dio.post("email/sendEmailToUser",queryParameters: {
        "context":context,
        "email":userEmail,
        "title":title
      });
      print(response.statusCode);
      print(response.data);
      if(response.statusCode==200){
        return APIResponse<int>(data: response.statusCode);
      }
      return APIResponse<int>(data: response.statusCode, error: true, errorMessage: "Some error occurs");

    }on DioError catch(e){
return APIResponse<int>(data: -1, error: true, errorMessage: "Some error occurs");
    }

  }
  Future<APIResponse<int>> sendEmailToAllUsers(String context,  String title)async{
 try{
      Response response=await _dio.post("email/sendEmailToUsers",queryParameters: {
        "context":context,
        "title":title
      });
      if(response.statusCode==200){
        return APIResponse<int>(data: response.statusCode);
      }
      return APIResponse<int>(data: response.statusCode, error: true, errorMessage: "Some error occurs");

    }on DioError catch(e){
return APIResponse<int>(data: -1, error: true, errorMessage: "Some error occurs");
    }
  }
  }