import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:Selfsahaf/models/user.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/models/book.dart';

class SearchService extends GeneralServices {
  Dio _dio;
  SearchService() {
    this._dio = super.dio;
  }
  Future<APIResponse<List<Book>>> searchBooksByName(
      String name, int pageNo, int pageSize) async {
    try {
      Response response = await _dio.get("product_search/searchBookByName",
          queryParameters: {
            "name": name,
            "pageNo": pageNo,
            "pageSize": pageSize
          });
      print(response.data.length);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          result.sort((a, b) => a.productID.compareTo(b.productID));
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

  Future<APIResponse<List<Book>>> searchBookByCategory(
      String categoryName, int pageNo, int pageSize) async {
    try {
      Response response = await _dio.get("product_search/searchBookByCategory",
          queryParameters: {
            "category": categoryName,
            "pageNo": pageNo,
            "pageSize": pageSize
          });

      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          result.sort((a, b) => a.productID.compareTo(b.productID));
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

  Future<APIResponse<List<Book>>> searchBookByISBN(
      String isbn, int pageNo, int pageSize) async {
    try {
      Response response = await _dio.get("product_search/searchBookByISBN",
          queryParameters: {
            "isbn": isbn,
            "pageNo": pageNo,
            "pageSize": pageSize
          });
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          result.sort((a, b) => a.productID.compareTo(b.productID));
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

  Future<APIResponse<List<Book>>> searchBookByLanguage(
      String language, int pageNo, int pageSize) async {
    try {
      Response response = await _dio.get("product_search/searchBookByLanguage",
          queryParameters: {
            "language": language,
            "pageNo": pageNo,
            "pageSize": pageSize
          });
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          result.sort((a, b) => a.productID.compareTo(b.productID));
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

  Future<APIResponse<List<Book>>> searchBookByPriceRange(
      double to, double from, int pageNo, int pageSize) async {
    try {
      Response response = await _dio
          .get("product_search/searchBookByPriceRange", queryParameters: {
        "from": from,
        "to": to,
        "pageNo": pageNo,
        "pageSize": pageSize
      });
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          result.sort((a, b) => a.productID.compareTo(b.productID));
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

  Future<APIResponse<List<User>>> searchUserByName(String name) async {
    try {
      Response response = await _dio
          .get("user_search/searchUser", queryParameters: {"name": name});
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<User> result;
          List<dynamic> i = response.data;
          result = i.map((p) => User.fromJson(p)).toList();
          result.sort((a, b) => a.userID.compareTo(b.userID));
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
  
  Future<APIResponse<List<User>>> getAllUsers() async {
    try {
      Response response = await _dio
          .get("user/all");
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
}
