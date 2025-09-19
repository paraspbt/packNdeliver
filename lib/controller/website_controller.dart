import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/apis/website_api.dart';
import 'package:pack_n_deliver/commons/dialog.dart';
import 'package:pack_n_deliver/models/order.dart';
import 'package:pack_n_deliver/constants/order_status_enum.dart';
// ignore: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;

final websiteControllerProvider =
    StateNotifierProvider<WebsiteController, bool>((ref) {
  final websiteApi = ref.read(websiteApiProvider);
  return WebsiteController(websiteApi: websiteApi, ref: ref);
});

final orderListProvider = FutureProvider<Map<String, List<Order>>>((ref) async {
  final websiteController = ref.read(websiteControllerProvider.notifier);
  return websiteController.getOrdersData();
});

class WebsiteController extends StateNotifier<bool> {
  final WebsiteApi _websiteApi;
  final Ref _ref;
  WebsiteController({required WebsiteApi websiteApi, required Ref ref})
      : _websiteApi = websiteApi,
        _ref = ref,
        super(false);

  Future<Map<String, List<Order>>> getOrdersData() async {
    try {
      final data = await _websiteApi.getOrdersData();
      if (data['error'] != null) {
        throw (Exception('Error in ERP Server'));
      }
      final List<dynamic> orderList = data['data'];
      Map<String, List<Order>> categorizedOrders = {
        OrderStatus.pending: [],
        OrderStatus.inprogress: [],
        OrderStatus.out: [],
      };
      for (var orderJson in orderList) {
        final order = Order.fromMap(orderJson);
        if (order.status == OrderStatus.pending) {
          categorizedOrders[OrderStatus.pending]!.add(order);
        } else if (order.status == OrderStatus.inprogress) {
          categorizedOrders[OrderStatus.inprogress]!.add(order);
        } else if (order.status == OrderStatus.out) {
          categorizedOrders[OrderStatus.out]!.add(order);
        }
      }
      return categorizedOrders;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changeStatus(
      BuildContext context, String salesId, String newStatus) async {
    state = true;
    final res = await _websiteApi.changeStatus(salesId, newStatus);
    state = false;
    res.fold((l) {
      textDialog(context, 'Error in Changing Status', l.message);
    }, (r) {
      _ref.invalidate(orderListProvider);
    });
  }

  // Future<void> printBill(BuildContext context, String salesId) async {
  //   state = true;
  //   final res = await _websiteApi.printOrderPdf(salesId);
  //   state = false;
  //   res.fold((l) {
  //     textDialog(context, 'Error in Printing Bill', l.message);
  //   }, (url) {
  //     html.window.open(url, '_blank');
  //     html.Url.revokeObjectUrl(url);
  //   });
  // }
}
