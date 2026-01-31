import 'dart:convert';
import 'package:dio/dio.dart';

import '../../core/exceptions/app_exceptions.dart';
import '../../core/network/soap_client.dart';
import '../models/account_models.dart';
import '../models/auth_models.dart';
import '../models/promo_models.dart';
import '../models/trade_models.dart';


class RemoteDataSource {
  final Dio _dio;
  final SoapClient _soapClient;

  RemoteDataSource(this._dio) : _soapClient = SoapClient();

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/IsAccountCredentialsCorrect',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      } else {
        throw ServerException('Login failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        final data = e.response!.data;

        if (statusCode == 400) {
          // Handle validation errors
          if (data is Map && data.containsKey('errors')) {
            final errors = data['errors'];
            if (errors is Map && errors.containsKey('login')) {
              throw ValidationException('Invalid account number format');
            }
          }
          throw ValidationException('Invalid request format');
        } else if (statusCode == 401) {
          // Handle unauthorized (invalid credentials)
          try {
            final loginResponse = LoginResponse.fromJson(data);
            if (!loginResponse.result) {
              throw AuthException('Invalid account number or password');
            }
          } catch (_) {
            throw AuthException('Invalid account number or password');
          }
          throw AuthException('Authentication failed');
        } else if (statusCode == 500) {
          throw ServerException('Server error. Please try again later.');
        } else {
          throw ServerException('Server error: $statusCode');
        }
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw NetworkException('Unknown error occurred');
    }
  }

  Future<AccountInformation> getAccountInformation(AccountInfoRequest request) async {
    try {
      final response = await _dio.post(
        '/api/ClientCabinetBasic/GetAccountInformation',
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AccountInformation.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw AuthException('Session expired. Please login again.');
      } else if (response.statusCode == 500) {
        throw ServerException('Server error. Please try again later.');
      } else {
        throw ServerException('Failed to get account info: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw AuthException('Session expired. Please login again.');
        } else if (e.response!.statusCode == 500) {
          throw ServerException('Server error. Please try again later.');
        }
        throw ServerException('Server error: ${e.response!.statusCode}');
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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data.toString();
      } else if (response.statusCode == 401) {
        throw AuthException('Session expired. Please login again.');
      } else if (response.statusCode == 500) {
        throw ServerException('Server error. Please try again later.');
      } else {
        throw ServerException('Failed to get phone: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw AuthException('Session expired. Please login again.');
        } else if (e.response!.statusCode == 500) {
          throw ServerException('Server error. Please try again later.');
        }
        throw ServerException('Server error: ${e.response!.statusCode}');
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
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Trade.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw AuthException('Session expired. Please login again.');
      } else if (response.statusCode == 500) {
        throw ServerException('Server error. Please try again later.');
      } else {
        throw ServerException('Failed to get trades: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        if (e.response!.statusCode == 401) {
          throw AuthException('Session expired. Please login again.');
        } else if (e.response!.statusCode == 500) {
          throw ServerException('Server error. Please try again later.');
        }
        throw ServerException('Server error: ${e.response!.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    }
  }

  Future<List<PromoItem>> getPromotionalCampaigns(String lang) async {
    try {
      final request = PromoRequest(lang: lang);
      final xmlResponse = await _soapClient.postSoapRequest(
        '/Services/CabinetMicroService.svc',
        request.toXml(),
      );
      print("xmlResponse: \n$xmlResponse");

      return PromoResponse.fromXml(xmlResponse).items;
    } on DioException catch (e) {
      if (e.response != null) {
        throw ServerException('Server error: ${e.response?.statusCode}');
      } else {
        throw NetworkException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw NetworkException('Failed to load promotional campaigns');
    }
  }
}