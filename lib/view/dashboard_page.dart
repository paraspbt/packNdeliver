import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pack_n_deliver/commons/order_list_widget.dart';
import 'package:pack_n_deliver/constants/order_status_enum.dart';
import 'package:pack_n_deliver/controller/website_controller.dart';
import 'package:pack_n_deliver/theme/app_pallete.dart';

class DashboardPage extends ConsumerStatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const DashboardPage());
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(websiteControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(orderListProvider);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ref.watch(orderListProvider).when(
                skipLoadingOnRefresh: false,
                data: (orderLists) {
                  return Row(
                    children: [
                      Expanded(
                          child: OrderListWidget(
                        title: 'New Orders',
                        orders: orderLists[OrderStatus.pending]!,
                        dashcontext: context,
                      )),
                      const VerticalDivider(
                        color: AppPallete.darkGreen,
                        thickness: 2,
                      ),
                      Expanded(
                          child: OrderListWidget(
                        title: 'Packing',
                        orders: orderLists[OrderStatus.inprogress]!,
                        dashcontext: context,
                      )),
                      const VerticalDivider(
                        color: AppPallete.darkGreen,
                        thickness: 2,
                      ),
                      Expanded(
                          child: OrderListWidget(
                        title: 'Out for Delivery',
                        orders: orderLists[OrderStatus.out]!,
                        dashcontext: context,
                      )),
                    ],
                  );
                },
                error: (error, stackTrace) =>
                    Center(child: Text('Failed to load orders: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
    );
  }
}
