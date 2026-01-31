import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../models/account_models.dart';
import '../models/auth_models.dart';
import '../models/trade_models.dart';

class RemoteDataSource {
  final Dio _dio;

  RemoteDataSource(this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/IsAccountCredentialsCorrect',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ServerException('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    }
  }

  Future<AccountInformation> getAccountInformation(
      AccountInfoRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/GetAccountInformation',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return AccountInformation.fromJson(response.data);
      } else {
        throw ServerException('Failed to get account info: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    }
  }

  Future<String> getLastFourPhoneNumbers(AccountInfoRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/GetLastFourNumbersPhone',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw ServerException('Failed to get phone: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    }
  }

  Future<List<Trade>> getOpenTrades(TradeRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/GetOpenTrades',
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Trade.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to get trades: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    }
  }
}