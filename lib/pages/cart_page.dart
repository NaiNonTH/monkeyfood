import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/widgets/main_app_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 1),
          itemCount: state.cartItems.length,
          itemBuilder: (context, index) => Row(
            children: [
              SizedBox(
                width: 100,
                height: 72,
                child: Image.network(
                  state.cartItems[index].item.imageUrl ?? '',
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.cartItems[index].item.title),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${state.cartItems[index].item.originalPrice * state.cartItems[index].amount}',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '\$${state.cartItems[index].item.price * state.cartItems[index].amount}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.remove, size: 16),
                            ),
                            onTap: () {
                              context.read<CartCubit>().updateCartItemAmount(
                                index,
                                state.cartItems[index].amount - 1,
                              );
                            },
                          ),
                          SizedBox(width: 4),
                          Text(state.cartItems[index].amount.toString()),
                          SizedBox(width: 4),
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.add, size: 16),
                            ),
                            onTap: () {
                              context.read<CartCubit>().updateCartItemAmount(
                                index,
                                state.cartItems[index].amount + 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        context.read<CartCubit>().removeCartItem(
                          state.cartItems[index],
                        );
                      },
                      child: Icon(Icons.delete_outline, size: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
