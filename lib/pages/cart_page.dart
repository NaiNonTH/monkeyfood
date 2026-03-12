import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/states/cart_state.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();

    context.read<CartCubit>().loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        switch (state) {
          case CartItemUpdated():
          case CartItemDeleted():
            context.read<CartCubit>().loadCartItems();
            break;
        }
      },
      builder: (context, state) {
        switch (state) {
          case CartLoaded():
            if (state.cartItems.isEmpty) {
              return const Center(child: Text('Cart of Empty.'));
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) => Row(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 72,
                          child: Image.network(
                            state.cartItems[index].item.imageName ?? '',
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
                                      '\$${state.cartItems[index].totalOriginalPrice}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '\$${state.cartItems[index].totalPrice}',
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
                                    bottom: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
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
                                        context
                                            .read<CartCubit>()
                                            .decrementItemAmount(index);
                                      },
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      state.cartItems[index].amount.toString(),
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.add, size: 16),
                                      ),
                                      onTap: () {
                                        context
                                            .read<CartCubit>()
                                            .incrementItemAmount(index);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  context.read<CartCubit>().removeCartItem(
                                    index,
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
                  ElevatedButton(
                    onPressed: (state is CartUpdatingAmount) ? () {} : () {},
                    child: (state is CartUpdatingAmount)
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('Place Order'),
                  ),
                ],
              ),
            );
          case CartError():
            return Center(
              child: Text('Something went wrong: ${state.message}'),
            );
          default:
            return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
