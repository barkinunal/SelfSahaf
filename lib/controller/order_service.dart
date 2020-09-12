import 'dart:convert';
import 'dart:io';
import 'package:Selfsahaf/models/given_orders.dart';
import 'package:Selfsahaf/models/order.dart';
import 'package:Selfsahaf/models/refund_model.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:Selfsahaf/models/card_model.dart';
import 'package:flutter/material.dart';

class OrderService extends GeneralServices {
  Dio _dio;
  OrderService() {
    this._dio = super.dio;
  }
  Future<APIResponse<int>> confirmOrder(
      int addressID, int shippingCompanyID, CardModel card) async {
    try {
      Response response = await _dio.post("order/confirmOrder",
          queryParameters: {
            "addressID": addressID,
            "shippingCompanyID": shippingCompanyID
          },
          data: json.encode(card.toJson()));
      print(response.data);
      if (response.statusCode == 200)
        return APIResponse<int>(data: response.statusCode);
      else if (response.statusCode == 403)
        return APIResponse<int>(
            data: response.statusCode,
            error: true,
            errorMessage: response.data.toString());
      else
        return APIResponse<int>(
            data: response.statusCode,
            error: true,
            errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }

  Future<APIResponse<List<Order>>> getTakenOrders() async {
    try {
      Response response = await _dio.get("order/takenOrders");
      List<Order> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Order.fromJson(p)).toList();
          return APIResponse<List<Order>>(data: result);
        } else {
          return APIResponse<List<Order>>(data: null);
        }
      }

      return APIResponse<List<Order>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<Order>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<int>> markOrder(
      int orderID, String status) async {
    try {
    print("sa");
      Response response = await _dio.post("order/markOrder", queryParameters: {
        "orderDetailID": orderID,
        "status": status
      });
      print(response.data);
      if (response.statusCode == 200) {
        return APIResponse<int>(data: response.statusCode);
      } else if (response.statusCode == 403) {
        return APIResponse<int>(
            data: 403, error: true, errorMessage: response.data.toString());
      }
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<int>> cancelOrder(
      int orderDetailID) async {
    try {
      Response response = await _dio.post("order/cancel", queryParameters: {
        "orderDetailID": orderDetailID,
      });
      if (response.statusCode == 200) {
        return APIResponse<int>(data: response.statusCode);
      } else if (response.statusCode == 403) {
        return APIResponse<int>(
            data: 403, error: true, errorMessage: response.data.toString());
      }
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<List<GivenOrders>>> givenOrders() async {
    try {
      Response response = await _dio.get("order/givenOrders");
      List<GivenOrders> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => GivenOrders.fromJson(p)).toList();
          return APIResponse<List<GivenOrders>>(data: result);
        } else {
          return APIResponse<List<GivenOrders>>(data: null);
        }
      }
      return APIResponse<List<GivenOrders>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<GivenOrders>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<List<Order>>> givenOrderDetails(int orderID) async {
    try {
      Response response = await _dio
          .get("order/getOrderDetails", queryParameters: {"orderID": orderID});
      List<Order> result;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Order.fromJson(p)).toList();
          return APIResponse<List<Order>>(data: result);
        } else {
          return APIResponse<List<Order>>(data: null);
        }
      }
      return APIResponse<List<Order>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<Order>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<int>> refundEvaulate(bool confirm, int refundID) async {
    try {
      Response response = await _dio.post("order/refundEvaluate",
          queryParameters: {"confirm": confirm,
           "refundId": refundID});
      if (response.statusCode == 200) {
        return APIResponse<int>(data: response.statusCode);
      }
      return APIResponse<int>(
          data: response.statusCode,
          error: true,
          errorMessage: response.data.toString());
    } on DioError catch (e) {
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<List<Image>>> getRefundImages(int refundID) async {
    try {
      Response response = await _dio.get("order/refundImagePath",
          queryParameters: {"refundID": refundID});
      List<Image> images = new List();
      print(response.data);
      if (response.statusCode == 200) {
        if (response.data.length == 0) return APIResponse(data: null);

        int size = response.data.length;
        for (int i = 0; i < size; i++) {
          response = await _dio.get("product/images",
              queryParameters: {
                "path": "/./root/images/refunds/$refundID/${i + 1}.png"
              },
              options: Options(
                  contentType: 'application/json',
                  method: 'GET',
                  responseType: ResponseType.bytes));
          print(response.data);
          images.add(Image.memory(
            response.data,
            fit: BoxFit.fill,
            width: 650,
            height: 650,
          ));
        }

        return APIResponse(data: images);
      }

      return APIResponse(data: null, error: true, errorMessage: "Error occurs");
    } on DioError catch (e) {
      return APIResponse(data: null, error: true, errorMessage: "Error occurs");

      // Something happened in setting up or sending the request that triggered an Error

    }
  }

  Future<APIResponse<int>> sendRefundRequest(
      List<File> images, int orderDetailID, String message) async {
    try {
      List<MultipartFile> multiFiles = [];
      for (int i = 0; i < images.length; i++) {
        multiFiles.add(MultipartFile(
            images[0].openRead(), await images[0].length(),
            filename: images[0].path.split("/").last));
      }
      FormData formData = FormData();
      for (int i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
            "file",
            new MultipartFile(images[i].openRead(), await images[i].length(),
                filename: images[i].path.split("/").last)));
      }

      Response response = await _dio.post("order/refundRequest",
          data: formData,
          queryParameters: {"message": message, "orderDetailID": orderDetailID},
          options: Options(contentType: 'multipart/form-data', method: 'POST'));

      if (response.statusCode == 200) {
        return APIResponse<int>(data: response.statusCode);
      }
      return APIResponse<int>(
          data: response.statusCode,
          error: true,
          errorMessage: response.data.toString());
    } on DioError catch (e) {
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<List<RefundModel>>> getRefundRequestsForAdmin() async {
    try {
      Response response = await _dio.get("order/refundRequests");
      List<RefundModel> result;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => RefundModel.fromJson(p)).toList();
          return APIResponse<List<RefundModel>>(data: result);
        } else {
          return APIResponse<List<RefundModel>>(data: null);
        }
      }
      return APIResponse<List<RefundModel>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<RefundModel>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }

  Future<APIResponse<List<RefundModel>>> getRefundRequestsForSeller() async {
    try {
      Response response = await _dio.get("order/sellerRefundRequests");
      List<RefundModel> result;
      if (response.statusCode == 200) {
        print(response.data);
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => RefundModel.fromJson(p)).toList();
          return APIResponse<List<RefundModel>>(data: result);
        } else {
          return APIResponse<List<RefundModel>>(data: null);
        }
      }
      return APIResponse<List<RefundModel>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<RefundModel>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }
}
