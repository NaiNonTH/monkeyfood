import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkeyfood/cubit/add_to_cart_cubit.dart';
import 'package:monkeyfood/cubit/cart_cubit.dart';
import 'package:monkeyfood/cubit/place_order_cubit.dart';
import 'package:monkeyfood/services/image_service.dart';
import 'package:monkeyfood/states/add_to_cart_state.dart';
import 'package:monkeyfood/states/cart_state.dart';
import 'package:monkeyfood/states/place_order_state.dart';

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
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CartCubit>().loadCartItems();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddToCartCubit, AddToCartState>(
            listener: (context, addToCartState) {
              if (addToCartState is AddedToCart) {
                context.read<CartCubit>().loadCartItems();
              }
            },
          ),
          BlocListener<PlaceOrderCubit, PlaceOrderState>(
            listener: (context, placeOrderState) {
              if (placeOrderState is OrderPlaced) {
                context.read<CartCubit>().loadCartItems();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Order Placed')));
              } else if (placeOrderState is PlaceOrderError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${placeOrderState.message}')),
                );
              }
            },
          ),
        ],
        child: BlocConsumer<CartCubit, CartState>(
          listener: (context, cartState) {
            switch (cartState) {
              case CartItemUpdated():
              case CartItemDeleted():
                context.read<CartCubit>().loadCartItems();
                break;
            }
          },
          builder: (context, cartState) {
            switch (cartState) {
              case CartLoaded():
                if (cartState.cartItems.isEmpty) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight:
                            MediaQuery.of(context).size.height -
                            kToolbarHeight * 2 -
                            kBottomNavigationBarHeight * 2,
                      ),
                      child: Center(child: Text('Cart is empty.')),
                    ),
                  );
                }

                return SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight:
                          MediaQuery.of(context).size.height -
                          kToolbarHeight * 2 -
                          kBottomNavigationBarHeight * 2,
                    ),
                    child: Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1),
                          itemCount: cartState.cartItems.length,
                          itemBuilder: (context, index) => Row(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 72,
                                child: Image.network(
                                  FoodImageService.instance.url(
                                        cartState
                                            .cartItems[index]
                                            .item
                                            .imageName,
                                      ) ??
                                      '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(child: Icon(Icons.error_outline)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartState.cartItems[index].item.title,
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${cartState.cartItems[index].totalOriginalPrice.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '\$${cartState.cartItems[index].totalPrice.toStringAsFixed(2)}',
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
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                size: 16,
                                              ),
                                            ),
                                            onTap: () {
                                              context
                                                  .read<CartCubit>()
                                                  .decrementItemAmount(
                                                    cartState
                                                        .cartItems[index]
                                                        .id,
                                                  );
                                            },
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            cartState.cartItems[index].amount
                                                .toString(),
                                          ),
                                          SizedBox(width: 4),
                                          GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Icon(Icons.add, size: 16),
                                            ),
                                            onTap: () {
                                              context
                                                  .read<CartCubit>()
                                                  .incrementItemAmount(
                                                    cartState
                                                        .cartItems[index]
                                                        .id,
                                                  );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<CartCubit>()
                                            .removeCartItem(
                                              cartState.cartItems[index].id,
                                            );
                                      },
                                      child: Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: (cartState is CartUpdatingAmount)
                              ? () {}
                              : () {
                                  context.read<PlaceOrderCubit>().placeOrder(
                                    cartState.cartItems,
                                  );
                                },
                          child: (cartState is CartUpdatingAmount)
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text('Place Order'),
                        ),
                      ],
                    ),
                  ),
                );
              case CartError():
                return Center(
                  child: Text('Something went wrong: ${cartState.message}'),
                );
              default:
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
