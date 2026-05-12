import 'package:dio/dio.dart';
import '../../network/dio_client.dart';
import '../../network/url.dart';
import '../../platform/secure_storage/secure_storage.dart';

class ProductsApiService {
  final SecureStorage secureStorage;

  ProductsApiService({required this.secureStorage});

  Dio get _authClient => DioClient.authClient(secureStorage);

  Future<Response> getProducts({Map<String, dynamic>? queryParameters}) async {
    return await _authClient.get(
      Endpoint.products.products,
      queryParameters: queryParameters,
    );
  }

  Future<Response> getProductDetail(String productId) async {
    return await _authClient.get('${Endpoint.products.products}/$productId');
  }

  // create product
  Future<Response> createProduct({Map<String, dynamic>? data}) async {
    return await _authClient.post(Endpoint.products.create, data: data);
  }

  // update product
  Future<Response> updateProduct({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    return await _authClient.patch(
      '${Endpoint.products.products}/$id',
      data: data,
    );
  }

  // delete product
  Future<Response> deleteProduct(String productId) async {
    return await _authClient.delete('${Endpoint.products.products}/$productId');
  }
}
