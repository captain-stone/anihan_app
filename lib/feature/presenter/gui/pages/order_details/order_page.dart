// ignore_for_file: use_super_parameters

import 'package:anihan_app/common/api_result.dart';
import 'package:anihan_app/common/app_module.dart';
import 'package:anihan_app/feature/data/models/api/store_user_services_api.dart';
import 'package:anihan_app/feature/domain/entities/store_data_entity.dart';
import 'package:anihan_app/feature/presenter/gui/pages/checkout_page/checkout_page.dart';
import 'package:anihan_app/feature/presenter/gui/widgets/products/add_to_cart/add_to_cart_bloc.dart';
import 'package:anihan_app/feature/services/date_services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../../../domain/entities/add_to_cart_entity.dart';

class OrdersPage extends StatefulWidget {
  final String uid;
  const OrdersPage({super.key, required this.uid});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final _cartBloc = getIt<AddToCartBloc>();
  List<AllCartEntity> productsCart = [];
  final logger = Logger();
  int currentIndex = 0;
  bool hasData = true;

  @override
  void initState() {
    super.initState();

    _cartBloc.add(const GetAllCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddToCartBloc, AddToCartState>(
      bloc: _cartBloc,
      listener: (context, state) {
        // TODO: implement listener

        logger.d(state);

        if (state is AllCartSuccessState) {
          setState(() {
            hasData = true;
            productsCart = state.dataModel;
          });
        }

        if (state is AddToCartErrorState) {
          setState(() {
            hasData = false;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
              color: Colors.white,
            ),
            title: Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Filter logic goes here
                  },
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: !hasData
              ? const Center(
                  child: Text("No products available for checkout"),
                )
              : Column(
                  children: [
                    // The list of orders
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        itemCount: productsCart.length,
                        itemBuilder: (context, index) {
                          logger.e(productsCart[index].productEntity);
                          // if (productsCart[index].cartId ==
                          //     productsCart[index].productEntity[index]
                          //         [productsCart[index].cartId]) {
                          logger.d(productsCart[index]);
                          // AllCartEntity
                          // }
                          return Column(
                            children: [
                              _OrderCard(
                                data: productsCart[index],
                                // orderId: productsCart[index].cartId,
                                // customerName: productsCart[index].storeId,
                                // dateMillis: productsCart[index].createAt,
                                // totalPrice: productsCart[index].totalPrice,
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Your button action here
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(content: Text('Checkout clicked!')),
                          // );

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CheckoutPage(
                                    uid: widget.uid,
                                    productEntity: productsCart,
                                  )));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          minimumSize:
                              const Size.fromHeight(50), // Button height
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _OrderCard extends StatefulWidget {
  // final String customerName;
  // final String orderId;
  // final int dateMillis;
  // final double totalPrice;

  final AllCartEntity data;

  const _OrderCard({
    Key? key,
    required this.data,
    // required this.customerName,
    // required this.orderId,
    // required this.dateMillis,
    // required this.totalPrice,
  }) : super(key: key);

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  bool _isExpanded = true;
  final StoreUserServicesApi storeUserServicesApi = StoreUserServicesApi();
  // late StoreDataEntity? storeDataEntity;
  String storeName = "";
  String storeAddress = '';
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    // logger.d(widget.products);

    Future.delayed(const Duration(milliseconds: 275)).then((_) async {
      var data = await storeUserServicesApi.getStoreIdInfo(widget.data.storeId);
      var status = data.status;

      if (status == Status.success && mounted) {
        // Check if widget is mounted
        setState(() {
          if (data.data != null) {
            StoreDataEntity storeDataEntity = data.data!;
            storeName = storeDataEntity.storeName;
            storeAddress = storeDataEntity.storeAddress;
          }
        });
      }
    });

    // logger.d(widget.data.productEntity);
  }

  @override
  Widget build(BuildContext context) {
    final DateTime orderDate =
        DateTime.fromMillisecondsSinceEpoch(widget.data.createAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Store: $storeName",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Order Date: ${orderDate.toLocal()}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'Location: $storeAddress',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        // Text(
                        //   'Order Total: ₱${widget.totalPrice}',
                        //   style: Theme.of(context).textTheme.bodyMedium,
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      widget.data.cartId,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const Divider(thickness: 1, height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Products:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    // Example product list

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.data.productEntity.length,
                      itemBuilder: (context, index) {
                        final product = widget.data.productEntity[index]
                            [widget.data.storeId];
                        // logger.d(product);

                        if (product != null) {
                          if (product is AddToCartProductEntity) {
                            return _buildProductItem(
                              product.name,
                              product.quantity,
                              product.price,
                              product.image,
                            );
                          }
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductItem(
      String name, int quantity, double price, String image) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: Image.network(
                image,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.broken_image,
                    size: 30,
                    color: Colors.grey,
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '$name (x$quantity)',
                style: const TextStyle(fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Text(
            '₱${(quantity * price).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
