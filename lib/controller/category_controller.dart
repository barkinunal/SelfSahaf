
import 'package:Selfsahaf/models/api_response.dart';
import 'package:Selfsahaf/models/category.dart';
import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';

class CategoryService extends GeneralServices{
  Dio _dio;
  CategoryService(){
  _dio= super.dio;
  }

  Future<APIResponse<int>> addCategory(
      String categoryName) async {
    try {
      Response response = await _dio.post("product/addCategory", queryParameters: {
        "name": categoryName,
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

  Future<APIResponse<List<Category>>> getCategories() async {
    try {
      Response response = await _dio.get("product/getCategories");
      List<Category> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((p) => Category.fromJson(p)).toList();
          return APIResponse<List<Category>>(data: result);
        } else {
          return APIResponse<List<Category>>(data: null);
        }
      }

      return APIResponse<List<Category>>(
          data: null, error: true, errorMessage: "Some error occurs");
    } on DioError catch (e) {
      return APIResponse<List<Category>>(
          data: null, error: true, errorMessage: "Some error occurs");
    }
  }
  Future<APIResponse<int>> setDiscountToCategory(int categoryID,int discount)async{
    try{
        Response response=await _dio.post("admin/setDiscount",queryParameters: {
          "categoryID":categoryID,
          "discount":discount
        });
        if(response.statusCode==200){
          return APIResponse<int>(data: response.statusCode);
        }
        return APIResponse<int>(data: response.statusCode,error: true,errorMessage: response.data.toString());
    }on DioError catch(e){
      return APIResponse<int>(data: -1,error: true, errorMessage: "Some erros occurs");
    }
  }

}