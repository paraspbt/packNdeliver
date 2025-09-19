import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/apis/website_api.dart';
import 'package:pack_n_deliver/constants/app_constants.dart';
import 'package:pack_n_deliver/constants/order_status_enum.dart';
import 'package:pack_n_deliver/controller/website_controller.dart';
import 'package:pack_n_deliver/models/order.dart';
import 'package:pack_n_deliver/theme/app_pallete.dart';

class OrderListWidget extends ConsumerWidget {
  final String title;
  final List<Order> orders;
  final BuildContext dashcontext;
  const OrderListWidget({
    super.key,
    required this.title,
    required this.orders,
    required this.dashcontext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppPallete.backgroundColor,
          child: Center(
            child: Text(title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: Scrollbar(
            radius: const Radius.circular(8),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(order.orderNo),
                        const Spacer(),
                        Text(order.phone)
                      ],
                    ),
                    subtitle: Text([
                      order.custName,
                      order.address,
                    ].join('\n')),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    tileColor: Colors.amber,
                    onTap: () => _showOptions(dashcontext, order, ref),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

void _showOptions(BuildContext dashcontext, Order order, WidgetRef ref) {
  showDialog(
    context: dashcontext,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: AppPallete.onSurfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: MediaQuery.of(dashcontext).size.width * 0.4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(order.orderNo),
              const SizedBox(height: 16),
              ListTile(
                title: const Center(child: Text('Proceed')),
                onTap: () => _changeStatus(dashcontext, ref, order.salesId,
                    AppConstants.next(order.status)),
              ),
              ListTile(
                title: const Center(child: Text('Cancel Order')),
                onTap: () => _changeStatus(
                    dashcontext, ref, order.salesId, OrderStatus.cancelled),
              ),
              ListTile(
                  title: const Center(child: Text('Print')),
                  onTap: () =>
                      ref.read(websiteApiProvider).printOrderPdf(order)),
            ],
          ),
        ),
      );
    },
  );
}

// void _printBill(BuildContext dashcontext, WidgetRef ref, String salesId) {
//   ref.read(websiteControllerProvider.notifier).printBill(dashcontext, salesId);
//   Navigator.pop(dashcontext);
// }

void _changeStatus(
    BuildContext dashcontext, WidgetRef ref, String salesId, String newStatus) {
  ref
      .read(websiteControllerProvider.notifier)
      .changeStatus(dashcontext, salesId, newStatus);
  Navigator.pop(dashcontext);
}
