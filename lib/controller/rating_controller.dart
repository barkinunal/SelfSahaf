import 'package:Selfsahaf/models/rating.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';

class RatingService extends GeneralServices {
  Dio _dio;
  RatingService() {
    this._dio = super.dio;
  }

  Future<APIResponse<List<Rating>>> getRatings(int sellerID) async {
    try {
      Response response = await _dio.get(
        "rating/getRatings", queryParameters: {
          "sellerID":sellerID
        }
      );
      List<Rating> result = new List();
      print(response);

      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Rating.fromJson(p)).toList();
          return APIResponse<List<Rating>>(data: result, error: false);
        } else
          return APIResponse<List<Rating>>(data: null, error: false);
      } else if (response.statusCode == 403)
        return APIResponse<List<Rating>>(
            data: null, error: true, errorMessage: "Something went wrong!");
      else
        return APIResponse<List<Rating>>(
            data: null, error: true, errorMessage: "Some errors occurs.!");
    } on DioError catch (e) {
      return APIResponse<List<Rating>>(
          data: null, error: true, errorMessage: "Some errors occurs!");
    }
  }
  
  Future<APIResponse<int>> getAvgRating(int sellerID) async {
    try {
      Response response = await _dio.get(
        "rating/getAverageRating", queryParameters: {
          "sellerID":sellerID
        }
      );
      List<Rating> result = new List();
      print(response);

      if (response.statusCode == 200) {
        if (response.data != null) {
          int i = response.data;
          
          return APIResponse<int>(data: i, error: false);
        } else
          return APIResponse<int>(data: null, error: false);
      } else if (response.statusCode == 403)
        return APIResponse<int>(
            data: null, error: true, errorMessage: "Something went wrong!");
      else
        return APIResponse<int>(
            data: null, error: true, errorMessage: "Some errors occurs.!");
    } on DioError catch (e) {
      return APIResponse<int>(
          data: null, error: true, errorMessage: "Some errors occurs!");
    }
  }

  Future<APIResponse<int>> rateSeller(int orderDetailID, Rating rating) async {
    try {
      Response response = await _dio.post(
        "rating/rateSeller", queryParameters: {
          "orderDetailID":orderDetailID,
          
        }, data: rating.toJsonRating()
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          int i = response.statusCode;
          
          return APIResponse<int>(data: i, error: false);
        } else
          return APIResponse<int>(data: null, error: false);
      } else if (response.statusCode == 403)
        return APIResponse<int>(
            data: null, error: true, errorMessage: "Something went wrong!");
      else
        return APIResponse<int>(
            data: null, error: true, errorMessage: "Some errors occurs.!");
    } on DioError catch (e) {
      return APIResponse<int>(
          data: null, error: true, errorMessage: "Some errors occurs!");
    }
  }
}
