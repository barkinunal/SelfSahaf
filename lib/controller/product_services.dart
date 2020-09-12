import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'dart:io';
import 'package:Selfsahaf/models/book.dart';
import 'package:Selfsahaf/models/category.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProductService extends GeneralServices {
  Dio _dio;
  ProductService() {
    this._dio = super.dio;
  }
  Future<APIResponse<List<Book>>> getSellerBooks(int sellerID) async {
    try {
      Response response = await _dio.get("product/getSellerBooks",
          queryParameters: {"sellerID": sellerID});
      List<Book> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((e) => Book.fromJson(e)).toList();
        } else
          result = null;
        return APIResponse<List<Book>>(data: result);
      } else if (response.statusCode == 403)
        return APIResponse<List<Book>>(
            data: null, error: true, errorMessage: response.data.toString());
      else
        return APIResponse<List<Book>>(
            data: null, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse<List<Book>>(
          data: null, error: true, errorMessage: "Some errors occurs.");
    }
  }

  Future<int> addBook(Book book, int sellerID) async {
    try {
      Response response = await _dio.post("product/addBook",
          queryParameters: {
            "price": book.price,
            "quantity": book.quantity,
            "sellerID": sellerID
          },
          data: json.encode(book.toJsonBook()));
      print(response.data.toString());
      return int.parse(response.data.toString());
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

  Future<List<Book>> getSelfBooks() async {
    print("get books");
    try {
      Response response = await _dio.get("product/getSelfBooks");
      List<Book> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          return result;
        }
      }
      print(response.statusCode);
      print(response.data);

      result = [null];

      return result;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print("statuscode");
        print(e.response.statusCode);
        return [];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);

        return [];
      }
    }
  }

  Future<APIResponse<List<Book>>> getTopBooks(int pageNo, int pageSize) async {
    try {
      Response response = await _dio.get("product/bestSeller",
          queryParameters: {"pageNo": pageNo, "pageSize": pageSize});
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<Book> result;
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
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

  Future<List<Category>> getCategories() async {
    try {
      Response response = await _dio.get("product/getCategories");
      List<Category> result = [null];
      if (response.statusCode == 200) {
        print("if");
        print(response.statusCode);
        print(response.data);
        List<dynamic> i = response.data;
        result = i.map((p) => Category.fromJson(p)).toList();
        return result;
      }
      print(response.statusCode);
      print(response.data.length);
      return result;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return [null];
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return [null];
      }
    }
  }

  Future<bool> deleteBook(int bookID) async {
    try {
      Response response = await _dio
          .delete("product/deleteBook", queryParameters: {"productId": bookID});
      print(response.statusCode);
      return (response.statusCode == 200) ? true : false;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return false;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return false;
      }
    }
  }

  Future<int> updateBook(Book book) async {
    try {
      Response response = await _dio.post("product/updateBook",
          queryParameters: {
            "price": book.price,
            "quantity": book.quantity,
            "discount": book.discount
          },
          data: jsonEncode(book.toJsonBookUpdate()));
      print(response.statusCode);
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return 406;
      }
    }
  }

  Future<int> uploadImages(
      List<File> images, int productID, ProgressDialog pr) async {
    List<MultipartFile> multiFiles = [];
    for (int i = 0; i < images.length; i++) {
      multiFiles.add(MultipartFile(
          images[0].openRead(), await images[0].length(),
          filename: images[0].path.split("/").last));
    }

    try {
      FormData formData = FormData();
      formData.fields.add(MapEntry("productID", productID.toString()));
      for (int i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
            "file",
            new MultipartFile(images[i].openRead(), await images[i].length(),
                filename: images[i].path.split("/").last)));
      }
      pr.show();
      Response response = await _dio.post(
        "product/uploadImages",
        data: formData,
        options: Options(contentType: 'multipart/form-data', method: 'POST'),
        onSendProgress: (count, total) {
          print(count);
          print(total);
          pr.update(
            progress: ((count / total)*100).toInt().toDouble(),
            message: "Photo uploading. Please wait...",
            
            progressWidget: Container(
                color: Colors.transparent,
                child: Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ))),
            maxProgress: 100.0,
            progressTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontWeight: FontWeight.w400),
            messageTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 19.0,
                fontWeight: FontWeight.w600),
          );
        },
      );
      pr.hide();
      print("response ${response.data.toString()}");
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return 406;
      }
    }
  }

  Future<int> uploadMainImage(File image, int productID) async {
    try {
      FormData formData = new FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last),
        "productID": productID
      });
      Response response = await _dio.post(
        "product/uploadMainImage",
        data: formData,
        onSendProgress: (int sent, int total) {
          print("$sent $total");
        },
      );
      return response.statusCode;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
        return e.response.statusCode;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
        return 406;
      }
    }
  }

  Future<Uint8List> getImage(int userID, int productID, int imageID) async {
    try {
      Response response = await _dio.get("product/images",
          queryParameters: {
            "path": "/./root/images/productImages/$productID/$imageID.png"
          },
          options: Options(
              contentType: 'application/json',
              method: 'GET',
              responseType: ResponseType.bytes));

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

  Future<List<Book>> getAllBooks(
      int pageNo, int pageSize, String sortBy, bool increasing) async {
    List<Book> result;
    try {
      Response response = await _dio.get("product/getBooks", queryParameters: {
        "pageNo": pageNo,
        "pageSize": pageSize,
        "sortBy": sortBy,
        "ascending": increasing
      });
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Book.fromJson(p)).toList();
          return result;
        }
      }
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

  Future<APIResponse<List<Image>>> getAllImages(int productID) async {
    try {
      Response response = await _dio.get("product/getImagePaths",
          queryParameters: {"productID": productID});
      List<Image> images = new List();
      if (response.statusCode == 200) {
        int size = response.data.length;
        for (int i = 0; i < size; i++) {
          response = await _dio.get("product/images",
              queryParameters: {
                "path": "/./root/images/productImages/$productID/${i + 1}.png"
              },
              options: Options(
                  contentType: 'application/json',
                  method: 'GET',
                  responseType: ResponseType.bytes));
          print(response.data);
          images.add(Image.memory(response.data, fit: BoxFit.cover));
        }

        return APIResponse(data: images);
      }
      return APIResponse(data: null, error: true, errorMessage: "Error occurs");
    } on DioError catch (e) {
      if (e.response != null) {
        return APIResponse(
            data: null, error: true, errorMessage: "Error occurs");
      } else {
        // Something happened in setting up or sending the request that triggered an Error

        return APIResponse(
            data: null, error: true, errorMessage: "Error occurs");
      }
    }
  }
}
