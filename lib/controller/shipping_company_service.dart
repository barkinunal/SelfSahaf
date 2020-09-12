import 'package:dio/dio.dart';
import 'package:Selfsahaf/controller/generalServices.dart';
import 'package:Selfsahaf/models/api_response.dart';
import 'package:Selfsahaf/models/shipping_company_model.dart';

class ShippingCompanyService extends GeneralServices {
  Dio _dio;
  ShippingCompanyService() {
    this._dio = super.dio;
  }
  Future<APIResponse<int>> addCompany(ShippingCompanyModel company) async {
    try {
      Response response =
          await _dio.post("shipping/addCompany", queryParameters: {
        "companyName": company.companyName,
        "price": company.price,
        "website": company.website
      });
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
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }

  Future<APIResponse<List<ShippingCompanyModel>>> getCompanies() async {
    try {
      Response response = await _dio.get(
        "shipping/getCompanies",
      );
      List<ShippingCompanyModel> result;
      if (response.statusCode == 200) {
        if (response.data.length != 0) {
          List<dynamic> i = response.data;
          result = i.map((e) => ShippingCompanyModel.fromJson(e)).toList();
          result.sort(
              (a, b) => a.shippingCompanyID.compareTo(b.shippingCompanyID));
        } else
          result = null;
        return APIResponse<List<ShippingCompanyModel>>(data: result);
      } else if (response.statusCode == 403)
        return APIResponse<List<ShippingCompanyModel>>(
            data: null, error: true, errorMessage: response.data.toString());
      else
        return APIResponse<List<ShippingCompanyModel>>(
            data: null, error: true, errorMessage: "Some errors occurs.");
    } on DioError catch (e) {
      return APIResponse<List<ShippingCompanyModel>>(
          data: null, error: true, errorMessage: "Some errors occurs.");
    }
  }

  Future<APIResponse<int>> deleteCompany(String companyName) async {
    try {
      Response response =
          await _dio.delete("shipping/removeCompany", queryParameters: {
        "companyName": companyName,
      });
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
      return APIResponse<int>(
          data: -1, error: true, errorMessage: "Some errors occurs.");
    }
  }
}
