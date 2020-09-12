import 'package:Selfsahaf/models/user.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';

class AdminService extends GeneralServices {
  Dio _dio;
  AdminService() {
    this._dio = super.dio;
  }

  Future<APIResponse<List<User>>> getTopSellers(int count) async {
    try {
      Response response = await _dio
          .get("admin/getTopSellers", queryParameters: {"N": count});
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<User> result;
          List<dynamic> i = response.data;
          result = i.map((p) => User.fromJson(p)).toList();
          return APIResponse(data: result);
        } else {
          return APIResponse(data: null);
        }
      }
      return APIResponse(
          data: null, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: null, error: true, errorMessage: "Some errors occurs.");
    }
  }

  Future<APIResponse<int>> getOrderCount() async {
    try {
      Response response = await _dio.get("admin/getOrderCount");
      print(response.data);
      if (response.statusCode == 200)
        return APIResponse<int>(data: int.parse(response.data.toString()));
      else
        return APIResponse<int>(
            data: 0, error: true, errorMessage: response.data.toString());
    } on DioError catch (e) {
      return APIResponse<int>(
          data: 0, error: true, errorMessage: "Some errors Occurs");
    }
  }
  Future<APIResponse<int>> getSellerCount() async {
    try {
      Response response = await _dio.get("admin/getSellerCount");
      if (response.statusCode == 200)
        return APIResponse<int>(data: int.parse(response.data.toString()));
      else
        return APIResponse<int>(
            data: 0, error: true, errorMessage: response.data.toString());
    } on DioError catch (e) {
      return APIResponse<int>(
          data: 0, error: true, errorMessage: "Some errors Occurs");
    }
  }
  Future<APIResponse<int>> getUserCount() async {
    try {
      Response response = await _dio.get("admin/getUserCount");
      if (response.statusCode == 200)
        return APIResponse<int>(data: int.parse(response.data.toString()));
      else
        return APIResponse<int>(
            data: 0, error: true, errorMessage: response.data.toString());
    } on DioError catch (e) {
      return APIResponse<int>(
          data: 0, error: true, errorMessage: "Some errors Occurs");
    }
  }
}
