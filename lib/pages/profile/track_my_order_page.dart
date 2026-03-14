import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/order_cubit.dart';
import 'package:monkeyfood/models/order.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/order_state.dart';

class TrackMyOrderPage extends StatefulWidget {
  const TrackMyOrderPage({super.key});

  @override
  State<TrackMyOrderPage> createState() => _TrackMyOrderPageState();
}

class _TrackMyOrderPageState extends State<TrackMyOrderPage> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<OrderCubit>().getOrders();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),

        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height -
                kToolbarHeight * 2 -
                kBottomNavigationBarHeight * 2,
          ),
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, orderState) {
              switch (orderState) {
                case OrderLoaded():
                  return Column(
                    children: orderState.orders
                        .map(
                          (order) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Order ID: ${order.id}'),
                              ),
                              SizedBox(height: 4),
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: order.items.length,
                                itemBuilder: (context, index) => Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 72,
                                      child: Image.network(
                                        FoodImageService.instance.url(
                                              order.items[index].food.imageName,
                                            ) ??
                                            '',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Center(
                                                  child: Icon(
                                                    Icons.error_outline,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(order.items[index].food.title),
                                            SizedBox(height: 4),
                                            Text(
                                              '\$${order.items[index].unitPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:
                                          switch (order.items[index].status) {
                                            OrderStatus.preparing => Column(
                                              children: [
                                                Icon(
                                                  Icons.restaurant_menu,
                                                  color: Colors.amber,
                                                ),
                                                Text(
                                                  'Preparing',
                                                  style: TextStyle(
                                                    color: Colors.amber,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrderStatus.delivering => Row(
                                              children: [
                                                Icon(
                                                  Icons.delivery_dining,
                                                  color: Colors.blue,
                                                ),
                                                Text(
                                                  'Delivering',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            OrderStatus.delivered => Row(
                                              children: [
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                ),
                                                Text(
                                                  'Delivered',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        )
                        .toList(),
                  );
                case OrderError():
                  return Center(
                    child: Text('Something went wrong: ${orderState.message}'),
                  );
                default:
                  return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
