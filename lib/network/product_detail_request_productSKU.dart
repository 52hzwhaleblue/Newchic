import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:onboarding_demo/models/api-product-dedtails.dart';
import 'package:http/http.dart' as http;

import 'package:onboarding_demo/views/trang-san-pham-chi-tiet/product_details_constants.dart';

// ignore: camel_case_types
class requestProductDetailSKU {
  static String url =
      "http://192.168.1.220:9000/api/getProductDetailSKU/$productSKU";

  static List<api_product_details> parseProductDetailSKU(String responseBody) {
    var list = json.decode(responseBody) as List<dynamic>;
    List<api_product_details> posts =
        list.map((model) => api_product_details.fromJson(model)).toList();
    return posts;
  }

  static Future<List<api_product_details>> fetchProductDetailSKU(
      {int page = 1}) async {
    final response = await http.get(Uri.parse('$url'));
    if (response.statusCode == 200) {
      return compute(parseProductDetailSKU, response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Can\'t get product details');
    }
  }
}
