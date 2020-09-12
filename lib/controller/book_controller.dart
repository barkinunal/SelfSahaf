import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/controller/generalServices.dart';

class BookService extends GeneralServices {
  Dio _dio;
  BookService() {
    this._dio = super.dio;
  }

  

  Future<List<Book>> getBooks(int pageNo, int pageSize, bool increasing,
      String sortBy ) async {
    try {
      Response response = await _dio.get("product/getBooks", queryParameters: {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "sortBy": sortBy,
        "ascending":increasing
      });
      List<Book> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          print("gelen veri uzunluıgu");
          print(result.length);
          return result;
        }
        else{
          print("boş liste");
          print(response);
         return [];
         }
      }

      //_token = response.data["token"];
   
      return [];
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return [];
      }
    }
  }
   Future<Uint8List> getImage(int userID,int productID, int imageID) async {
    try {
     Response response= await _dio.get("product/images", queryParameters:{
       "path": "/./root/images/productImages/$productID/$imageID.png"
     },options: Options(contentType: 'application/json',  method: 'GET', responseType: ResponseType.bytes) );
    
     return response.data;
    } on DioError catch (e) {
      if (e.response != null) {

        return null;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        
        return null;
      }
    }
  }

  
}
