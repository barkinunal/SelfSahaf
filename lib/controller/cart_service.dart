import 'package:Selfsahaf/models/cart_model.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';

class CartService extends GeneralServices {
  Dio _dio;
  CartService() {
    this._dio = super.dio;
  }
  Future<APIResponse<int>> addItemToCart(
      int amount, int productID, int sellerID) async {
    try {
      Response response = await _dio.post("cart/addItemToCart",
          queryParameters: {
            "amount": amount,
            "productID": productID,
            "sellerID": sellerID
          });
      print(response.data);
      if (response.statusCode == 200)
        return APIResponse<int>(data: response.statusCode);
      else if (response.statusCode == 403)
        return APIResponse<int>(
            data: response.statusCode,
            error: true,
            errorMessage: response.data.toString());
      else if (response.statusCode == 500)
        return APIResponse<int>(
            data: 500,
            error: true,
            errorMessage:
                "You have aldready add book to cart please update it!");
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

  Future<APIResponse<List<CartModel>>> getCart() async {
    try {
      Response response = await _dio.get("cart/getCart");
      print(response.data);
      List<CartModel> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((e) => CartModel.fromJson(e)).toList();
          result.sort((a,b)=>a.productID.compareTo(b.productID));
        } else
          result = null;
        return APIResponse<List<CartModel>>(data: result);
      } else if (response.statusCode == 403)
        return APIResponse<List<CartModel>>(
            data: result, error: true, errorMessage: response.data.toString());
      else
        return APIResponse<List<CartModel>>(
            data: result, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: null, error: true, errorMessage: "Some errors occurs.");
    }
  }
  Future<APIResponse<int>> deleteItemFromCart(int productID)async{
    try {
      Response response = await _dio.delete("cart/removeFromCart", queryParameters: {
        "productID":productID
      });
      print(response.data);
      if (response.statusCode == 200) 
      return APIResponse<int>(data: 200);    
    else if (response.statusCode == 403)
        return APIResponse<int>(
            data: 403, error: true, errorMessage: response.data.toString());
      else
        return APIResponse<int>(
            data: -1, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }
  Future<APIResponse<int>> updateItemFromCart(int productID,int amount)async{
    try {
      Response response = await _dio.post("cart/updateCart", queryParameters: {
        "productID":productID,
        "amount":amount
      });
      print(response.data);
      if (response.statusCode == 200) 
      return APIResponse<int>(data: 200);    
    else if (response.statusCode == 403)
        return APIResponse<int>(
            data: 403, error: true, errorMessage: response.data.toString());
      else
        return APIResponse<int>(
            data: -1, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }
  Future<APIResponse<int>> cartCheckout()async{
    try {
      Response response = await _dio.post("cart/checkout");
      print(response.data[0].toString());
      if (response.statusCode == 200) 
      return APIResponse<int>(data: 200);    
    else if (response.statusCode == 403)
        return APIResponse<int>(
            data: 403, error: true, errorMessage: response.data[0].toString());
      else
        return APIResponse<int>(
            data: -1, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }
}
