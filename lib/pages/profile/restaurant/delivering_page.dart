import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/change_order_status_cubit.dart';
import 'package:monkeyfood/cubit/view_orders_cubit.dart';
import 'package:monkeyfood/models/order.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/change_order_status_state.dart';
import 'package:monkeyfood/states/view_orders_state.dart';
import 'package:monkeyfood/widgets/line_box.dart';
import 'package:monkeyfood/widgets/show_error.dart';

class DeliveringPage extends StatefulWidget {
  const DeliveringPage({super.key});

  @override
  State<DeliveringPage> createState() => _DeliveringPageState();
}

class _DeliveringPageState extends State<DeliveringPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getDeliveringOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivering')),
      body: BlocConsumer<ChangeOrderStatusCubit, ChangeOrderStatusState>(
        listener: (context, changeOrderStatusState) {
          if (changeOrderStatusState is OrderStatusChanged) {
            context.read<OrderCubit>().getDeliveringOrders();
          }
        },
        builder: (context, changeOrderStatusState) =>
            BlocBuilder<OrderCubit, OrderState>(
              builder: (context, orderState) {
                switch (orderState) {
                  case IncomingOrderLoaded():
                    final orders = orderState.orders;

                    return Column(
                      children: orders
                          .map(
                            (order) => _buildOrderItemDetails(
                              order,
                              changeOrderStatusState,
                            ),
                          )
                          .toList(),
                    );
                  case OrderError():
                    return ShowError(message: orderState.message);
                  default:
                    return Center(child: CircularProgressIndicator());
                }
              },
            ),
      ),
    );
  }

  Widget _buildOrderItemDetails(
    IncomingOrderItem order,
    ChangeOrderStatusState changeOrderStatusState,
  ) {
    return LineBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                width: 100,
                height: 100,
                child: Image.network(
                  FoodImageService.instance.url(order.food.imageName) ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Center(child: Icon(Icons.error_outline)),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.food.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 4),
                      Text(order.profile.displayName),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed:
                            (changeOrderStatusState is ChangingOrderStatus)
                            ? () {}
                            : () {
                                context
                                    .read<ChangeOrderStatusCubit>()
                                    .finishDelivery(order.id);
                              },
                        child:
                            (changeOrderStatusState is ChangingOrderStatus &&
                                changeOrderStatusState.orderItemId == order.id)
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Row(
                                children: [
                                  const Icon(Icons.check),
                                  SizedBox(width: 4),
                                  const Text('Finish Delivery'),
                                ],
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.0),
          Text(
            'Location',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 8.0),
          Text(order.profile.location),
        ],
      ),
    );
  }
}
