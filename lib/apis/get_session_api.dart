import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pack_n_deliver/commons/extractor.dart';
import 'package:pack_n_deliver/core/core.dart';
import 'package:pack_n_deliver/core/providers.dart';
import 'package:pack_n_deliver/models/session_data.dart';

final getSessionApiProvider = Provider((ref) {
  final functions = ref.read(appwriteFunctionsProvider);
  return GetSessionApi(functions: functions);
});

class GetSessionApi {
  final Functions _functions;
  GetSessionApi({required Functions functions}) : _functions = functions;

  FutureEither<SessionData> call() async {
    try {
      final res = await _getSession();
      String session = res['session']!;
      String csrf = res['csrf']!;
      await _postLogin(session, csrf);
      String reactToken = await _getReactToken(session);
      csrf = await _getCsrfToken(session, reactToken);
      return right(SessionData(
        reactToken: reactToken,
        session: session,
        csrf: csrf,
      ));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<Map<String, String>> _getSession() async {
    try {
      final Map<String, dynamic> payload = {
        "url": dotenv.env['LOGIN_URL'],
        "method": "GET",
        "headers": {},
        "body": null
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      final String status = res['status'];
      if (status == 'error') {
        throw (Exception('Server Error: ${res['message']}'));
      }
      final int statusCode = res['statusCode'];
      final String data = res['data'];
      final Map<String, String> headers =
          Map<String, String>.from(res['headers']);
      if (statusCode == 200) {
        String session = extractSession(headers);
        String csrf = extractCsrf(data);
        return {'session': session, 'csrf': csrf};
      } else {
        throw Exception('$statusCode');
      }
    } catch (e) {
      throw Exception('Error in getSession: $e');
    }
  }

  Future<void> _postLogin(String session, String csrf) async {
    try {
      final String body = 'return='
          '&hostName=${dotenv.env['HOST_NAME']}'
          '&_csrf=${Uri.encodeQueryComponent(csrf)}'
          '&userName=${dotenv.env['USERNAME']}'
          '&password=${Uri.encodeQueryComponent(dotenv.env['PASSWORD']!)}'
          '&otpCheck=';
      final Map<String, dynamic> payload = {
        "url": dotenv.env['LOGIN_URL'],
        "method": "POST",
        "headers": {
          'Cookie': 'SESSION=$session',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        "body": body,
        "allowRedirect": false,
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      final String status = res['status'];
      if (status == 'error') {
        throw (Exception('Server Error: ${res['message']}'));
      }
      final int statusCode = res['statusCode'];
      if (statusCode != 302) {
        throw Exception('$statusCode');
      }
    } on Exception catch (e) {
      throw Exception('Error in postLogin: $e');
    }
  }

  Future<String> _getReactToken(String session) async {
    try {
      final Map<String, dynamic> payload = {
        "url": dotenv.env['SUCCESS_URL'],
        "method": "GET",
        "headers": {
          'Cookie': 'SESSION=$session',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        },
        "body": null,
        "allowRedirect": false,
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      final String status = res['status'];
      if (status == 'error') {
        throw (Exception('Server Error: ${res['message']}'));
      }
      final int statusCode = res['statusCode'];
      final Map<String, String> headers =
          Map<String, String>.from(res['headers']);
      if (statusCode != 302) {
        throw Exception('$statusCode');
      }
      final reactToken = extractReactToken(headers);
      return reactToken;
    } on Exception catch (e) {
      throw Exception('Error in getReactToken: $e');
    }
  }

  Future<String> _getCsrfToken(String session, String reactToken) async {
    try {
      final Map<String, dynamic> payload = {
        "url": dotenv.env['REPORT_URL'],
        "method": "GET",
        "headers": {
          'Cookie': 'SESSION=$session; react-token=$reactToken',
          'Accept':
              'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
        },
        "body": null,
        "allowRedirect": false,
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      final String status = res['status'];
      if (status == 'error') {
        throw (Exception('Server Error: ${res['message']}'));
      }
      final int statusCode = res['statusCode'];
      final String data = res['data'];
      if (statusCode != 200) {
        throw (Exception('$statusCode'));
      }
      final csrf = extractCsrf(data);
      return csrf;
    } on Exception catch (e) {
      throw (Exception('Error in getCsrfToken: $e'));
    }
  }
}
