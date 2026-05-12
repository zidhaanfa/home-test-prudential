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

  // create product
  Future<Response> createProduct({Map<String, dynamic>? data}) async {
    return await _noAuthClient.post(Endpoint.products.create, data: data);
  }

  // update product
  Future<Response> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await _noAuthClient.put(
      '${Endpoint.products.products}/$id',
      data: data,
    );
  }

  // delete product
  Future<Response> deleteProduct(String productId) async {
    return await _noAuthClient.delete(
      '${Endpoint.products.products}/$productId',
    );
  }
}
