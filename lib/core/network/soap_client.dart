import 'package:dio/dio.dart';

import '../exceptions/app_exceptions.dart';


class SoapClient {
  final Dio _dio;

  SoapClient() : _dio = Dio() {
    _dio.options.baseUrl = 'https://api-forexcopy.contentdatapro.com';
    _dio.options.connectTimeout = const Duration(seconds: 50);
    _dio.options.receiveTimeout = const Duration(seconds: 50);
    _dio.options.headers['Content-Type'] = 'text/xml; charset=utf-8';
    _dio.options.headers['SOAPAction'] = 'http://tempuri.org/ICabinetMicroService/GetCCPromo';
  }

  Future<String> postSoapRequest(String endpoint, String xmlBody) async {
    try {
      print("postSoapRequest() called");
      final response = await _dio.post(
        endpoint,
        data: xmlBody,
        options: Options(
          headers: {
            'Content-Type': 'text/xml; charset=utf-8',
            'SOAPAction': 'http://tempuri.org/ICabinetMicroService/GetCCPromo',
          },
        ),
      );
      print("soap response: $response");
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw ServerException('SOAP request failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      throw NetworkException('Unknown error occurred');
    }
  }
}