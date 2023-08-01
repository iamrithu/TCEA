import 'dart:io';
import 'package:dio/dio.dart';
import '../config/config.dart';

class Api {
  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: 30000),
      baseUrl: Config.URL,
      responseType: ResponseType.json,
      contentType: ContentType.json.toString(),
    ),
  );

  Future otpGenerator(String email) async {
    try {
      Response response = await dio.post(
        "/api/otp",
        data: {"email": email},
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future otpVerification(String email, String otp) async {
    try {
      Response response = await dio.post(
        "/api/otpverification",
        data: {"email": email, "otpValue": otp},
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future getUser(String id) async {
    try {
      Response response = await dio.get(
        "/api/user/${id}",
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future changeStatus(String id, String status) async {
    try {
      Response response =
          await dio.post("/api/lead/${id}", data: {"status": status});

      print(response.data["suppliers"]["leads"]);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future getAllSuppliers() async {
    try {
      Response response = await dio.get(
        "/api/supplier",
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future getAllCategory() async {
    try {
      Response response = await dio.get(
        "/api/category",
      );
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future updateProfile(
    String id,
    String email,
    String name,
    String role,
    String mobile,
    String companyName,
    String companyDesc,
    String image,
    String postData,
  ) async {
    Map<String, dynamic> val = {
      "id": id,
      "email": email,
      "name": name,
      "role": role,
      "mobile": mobile,
      "companyName": companyName,
      "companyDesc": companyDesc,
      "image": image,
      "postData": postData,
    };
    try {
      Response response = await dio.post("/api/mb-member", data: val);

      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future updateSupplierProfile(
      String id,
      String email,
      String name,
      String role,
      String mobile,
      String companyName,
      String companyDesc,
      String shopiImage,
      List cat,
      String image,
      String address) async {
    Map<String, dynamic> val = {
      "id": id,
      "email": email,
      "name": name,
      "role": role,
      "mobile": mobile,
      "companyName": companyName,
      "companyDesc": companyDesc,
      "image": image,
      "shopiImage": shopiImage,
      "cat": cat,
      "address": address,
    };

    print(val);

    try {
      Response response = await dio.post("/api/mb-supplier", data: val);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }

  Future generateEnquiry(
    String categoryId,
    String memberId,
    List<String> supplierId,
    String description,
    String categoryName,
    String brand,
  ) async {
    Map<String, dynamic> val = {
      "categoryId": categoryId,
      "memberId": memberId,
      "supplierId": supplierId,
      "description": description,
      "brand": "",
      "categoryName": categoryName,
    };

    try {
      Response response = await dio.post("/api/inquiry", data: val);
      return response;
    } on DioException catch (e) {
      return e.response;
    }
  }
}
