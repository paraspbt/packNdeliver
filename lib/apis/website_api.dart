import 'dart:convert';
import 'dart:core';
import 'dart:ui';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // 👈 added
import 'package:pack_n_deliver/commons/get_curr_date.dart';
import 'package:pack_n_deliver/controller/log_in_controller.dart';
import 'package:pack_n_deliver/core/core.dart';
import 'package:pack_n_deliver/core/providers.dart';
import 'package:pack_n_deliver/models/session_data.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pack_n_deliver/models/order.dart' as model;

final websiteApiProvider = Provider((ref) {
  final functions = ref.read(appwriteFunctionsProvider);
  final sessionData = ref.read(sessionStateProvider);
  return WebsiteApi(functions: functions, sessionData: sessionData);
});

class WebsiteApi {
  final Functions _functions;
  final SessionData _sessionData;
  WebsiteApi({required Functions functions, required SessionData sessionData})
      : _functions = functions,
        _sessionData = sessionData;

  Future<Map<String, dynamic>> getOrdersData() async {
    try {
      final String dateRange = getDateRange();
      final String body =
          'draw=1&start=0&length=-1&search.value=&search.regex=false&dateRange=$dateRange&customerId=&discount=&createdBy=&paymentMode=0&salestype=posonline&ordertype=0&onlineOrderStatus=&channel=';
      final Map<String, dynamic> payload = {
        "url": dotenv.env['ORDERS_URL'],
        "method": "POST",
        "headers": {
          'Accept': 'application/json, text/javascript, */*; q=0.01',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Cookie':
              'SESSION=${_sessionData.session}; react-token=${_sessionData.reactToken}',
          'x-csrf-token': _sessionData.csrf,
          'x-requested-with': 'XMLHttpRequest',
          'Priority': 'u=1, i',
        },
        "body": body
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      if (res['status'] == 'error') {
        throw Exception('Server Error: ${res['message']}');
      }
      if (res['statusCode'] != 200) {
        throw Exception('HTTP Error: ${res['statusCode']}');
      }
      return res['data'];
    } catch (e) {
      rethrow;
    }
  }

  FutureEither<void> changeStatus(String salesId, String newStatus) async {
    try {
      final String body =
          'salesids=$salesId%2C&onlinestatus=${Uri.encodeComponent(newStatus).replaceAll('%20', '+')}';
      print(body);
      final Map<String, dynamic> payload = {
        "url": dotenv.env['CHANGE_STATUS_URL'],
        "method": "POST",
        "headers": {
          'Accept': '*/*',
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'Cookie':
              'SESSION=${_sessionData.session}; react-token=${_sessionData.reactToken}',
          'x-csrf-token': _sessionData.csrf,
          'x-requested-with': 'XMLHttpRequest',
          'Priority': 'u=1, i',
        },
        "body": body
      };
      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['FUNCTION_ID']!,
        body: jsonEncode(payload),
      );
      final Map<String, dynamic> res = jsonDecode(response.responseBody);
      if (res['status'] == 'error') {
        throw Exception('Server Error: ${res['message']}');
      }
      if (res['statusCode'] != 200) {
        throw Exception('HTTP Error: ${res['statusCode']}');
      }
      if (res['data'] != 'success') {
        throw (Exception(
            'Status Code 200 but Operation not successful on Server Side'));
      }
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<void> printOrderPdf(model.Order order) async {
    try {
      final Map<String, dynamic> payload = {
        "url": "${dotenv.env['PDF_URL']}/${order.salesId}",
        "method": "GET",
        "headers": {
          'cookie':
              'SESSION=${_sessionData.session}; react-token=${_sessionData.reactToken}',
        },
        "orderDetails": {
          "custName": order.custName,
          "address": order.address,
          "phone": order.phone,
        }
      };

      final Execution response = await _functions.createExecution(
        functionId: dotenv.env['PDF_FUNCTION_ID']!,
        body: jsonEncode(payload),
      );

      final Map<String, dynamic> res = jsonDecode(response.responseBody);

      final String base64Data = res['data'];
      final Uint8List pdfBytes = base64Decode(base64Data);
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.window.open(url, '_blank');
    } catch (e) {
      print('error : ${e.toString()}');
    }
  }
}


  // Future<void> generateAndPrintPdf(model.Order order) async {
  //   try {
  //     final List<int> pdfBytesList = await printOrderPdf(order.salesId) ?? [];

  //     PdfDocument existingDocument = PdfDocument();
  //     existingDocument.pageSettings.size = const Size(200, 200);
  //     existingDocument.pages.add().graphics.drawString(
  //           'Customer Slip\n'
  //           'Customer Name: ${order.custName}\n'
  //           'Address: ${order.address}\n'
  //           'Contact: ${order.phone}',
  //           PdfStandardFont(PdfFontFamily.helvetica, 12),
  //         );
  //     final Uint8List finalPdfBytes =
  //         Uint8List.fromList(existingDocument.saveSync());
  //     existingDocument.dispose();

  //     final blob = html.Blob([finalPdfBytes], 'application/pdf');
  //     final url = html.Url.createObjectUrlFromBlob(blob);
  //     html.window.open(url, '_blank');
  //   } catch (e) {
  //     print("Error generating and printing PDF: $e");
  //   }
  // }
}
