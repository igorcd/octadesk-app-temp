import 'package:dio/dio.dart';

class NucleusClient {
  static Dio client = Dio(BaseOptions(
    baseUrl: 'https://nucleus.octadesk.com',
    sendTimeout: 45 * 1000,
    connectTimeout: 45 * 1000,
    receiveTimeout: 45 * 1000,
  ));

  static setAuthorizationHeader(String jwt) {
    client.options.headers['authorization'] = 'Bearer $jwt';
  }
}
