import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:Selfsahaf/models/user.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/address.dart';

class AuthService extends GeneralServices {
  Dio _dio;
  User _user;
  AuthService() {
    _dio = super.dio;
  }
  Future<APIResponse<int>> loginWithEmail(String email, String password) async {
    try {
      Response response = await _dio.post(
        "login?email=" + email + "&password=" + password,
      );

      if(response.statusCode==403)
        return APIResponse<int>(data: response.statusCode , error: true, errorMessage: "Email or password is wrong!") ;
      else if(response.statusCode==200||response.statusCode==302)
      return APIResponse<int>(data: response.statusCode ) ;
      else 
            return APIResponse<int>(data: response.statusCode , error: true, errorMessage: "Some error occurs!") ;
    } on DioError catch (e) {

       if (e.response != null) {
         print(e.response.statusCode);
        return APIResponse<int>(data: e.response.statusCode, error: true, errorMessage: e.response.data) ;
      } else {
         print(e);
        //server is crashed
        if(e.type==DioErrorType.CONNECT_TIMEOUT){
          return APIResponse<int>(data: 500, errorMessage: "Connection Timeout", error: true);
        }
        // internet is not open
        if(e.type== DioErrorType.DEFAULT){
          return APIResponse<int>(data: 101, errorMessage: "Internet is not avaible.", error: true);
        }
        return APIResponse<int>(data: -1, errorMessage: "Some error occurs.", error: true);
      }
    }
  }

  Future<APIResponse<String>> signup(data) async {
    try {
      Response response = await _dio.post("user/add", data: data);
       
         return APIResponse<String>(data: response.data.toString()) ;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return APIResponse<String>(data: e.response.statusMessage,error:true, errorMessage: e.response.statusMessage);
      } else {
        //server is crashed
        if(e.type==DioErrorType.CONNECT_TIMEOUT){
          return APIResponse<String>(data: "500", errorMessage: "Connection Timeout", error: true);
        }
        // internet is not open
        if(e.type== DioErrorType.DEFAULT){
          return APIResponse<String>(data: "101", errorMessage: "Internet is not avaible.", error: true);
        }
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }

  Future<APIResponse<int>> initUser() async {
    try {
      Response response = await _dio.get("user/get");
      if(response.statusCode==200){
     this._user = new User.fromJson(response.data);
     return APIResponse<int>(data: response.statusCode);
      }
 
      
      return APIResponse<int>(data: response.statusCode, error: true, errorMessage:"some errors occurs");
    } on DioError catch (e) {
      return APIResponse<int>(data: -1, error: true, errorMessage:"some errors occurs");
    }
  }

  Future<int> addUserAddress(Address address) async {
    try {
      Response response = await _dio.post("user/addAddress",
          data: json.encode(address.toJson()), );
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }
   Future<int> updateAddress(Address address) async {
    try {
      Response response = await _dio.post("user/updateAddress",
          data: json.encode(address.toUpdateJson()));
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }

  Future<APIResponse<List<Address>>> getUserAddresses() async {
    try {
      Response response = await _dio.get(
        "user/getadress",
      );
      List<Address> result=new List();
      print(response);

       if (response.statusCode==200) {
         if(response.data.length != 0){
          List<dynamic> i = response.data;
          result = i.map((p) => Address.fromJson(p)).toList();
          result.sort((a,b)=>a.addressID.compareTo(b.addressID));
          return APIResponse<List<Address>>(data: result,error: false);
          }
          else
          return APIResponse<List<Address>>(data: null,error: false);
        }
      
       else  if(response.statusCode==403)
        return APIResponse<List<Address>>(data: null,error: true, errorMessage: "Something went wrong!");
      else
        return APIResponse<List<Address>>(data: null,error: true, errorMessage: "Some errors occurs.!");
    } on DioError catch (e) {
      return APIResponse<List<Address>>(data: null,error: true, errorMessage: "Some errors occurs!");
    }
  }

  Future<int> deleteAddress(int addressID) async {
    try {
      Response response = await _dio.delete(
        "user/deleteAddress",
        queryParameters: {
          "addressID":addressID
        }
      );
      print("${response.statusCode}");
        return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return 500;
      }
    }
  }

    Future<int> addSellerAddress(Address address) async {
    try {
      Response response = await _dio.post("user/addSellerAddress",
          data: json.encode(address.toJson()));
      
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }
  Future<int> updateUser(User user,bool changePassword) async {
    try {
      Response response = await _dio.post("user/update",
          data: json.encode(user.toJsonUpdate(changePassword)));
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }
  Future<int> becameSeller(User user) async {
    try {
      Response response = await _dio.post("user/update",
          data: json.encode(user.toJsonBecameSeller()));
      print(response);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.statusCode);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return null;
      }
    }
  }
  Future<APIResponse<Address>> getSellerAddress()async{
    try{
        Response response=await _dio.get("user/getselleradress");
        if(response.statusCode==200)
          return APIResponse<Address>(data: Address.fromJson(response.data));
        return APIResponse<Address>(data: null, error: true,errorMessage: response.data.toString());
    }on DioError catch(e){
   return APIResponse<Address>(data: null, error: true,errorMessage:"some error occurs.");
    }
  }
  User getUser() {
    return _user;
  }
  void setUser(User user)=> this._user=user;
}
