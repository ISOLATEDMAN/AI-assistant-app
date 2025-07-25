import 'package:ass_app/models/ProductModel.dart';
import 'package:dio/dio.dart';

class ShopService {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://localhost:3000';

  Future<List<ProductModel>> getProducts() async {
    try {
      // Make the GET request
      final response = await _dio.get('$_baseUrl/prodData');

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        // The API returns a map with a 'products' key, which holds the list
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> productListJson = responseData['products'];

        // Map the JSON list to a list of ProductModel objects
        return productListJson
            .map((json) => ProductModel.fromJson(json))
            .toList();
      } else {
        // Handle non-200 status codes
        throw Exception(
            'Failed to load products. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network issues, timeouts)
      throw Exception('Failed to load products: ${e.message}');
    } catch (e) {
      // Handle other potential errors
      throw Exception('An unknown error occurred: $e');
    }
  }
}