import 'package:dio/dio.dart';
import '../../network/dio_client.dart';
import '../../network/url.dart';

class ProductsApiService {
  final Dio _noAuthClient = DioClient.noAuthClient;

  Future<Response> getProducts({Map<String, dynamic>? queryParameters}) async {
    return await _noAuthClient.get(
      Endpoint.products.products,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getProductDetail(String productId) async {
    return await _noAuthClient.get('${Endpoint.products.products}/$productId');
  }
}
