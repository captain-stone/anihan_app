// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:anihan_app/feature/data/models/dto/checkout_product_dto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void onOrderPayments({
  required String? selectOption,
  required List<String> options,
  required List<CheckoutProductDto> data,
  required BuildContext context,
  required String label,
  required String name,
  // required VoidCallback onPressedApproved,
  required void Function(String id) onPressedApproved,
  required void Function(String id, String? value) onChangeMenuButton,
}) {
  showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
            double _w = MediaQuery.of(context).size.width;
            double _h = MediaQuery.of(context).size.height;
            return Container(
                width: _w,
                height: _h * 0.5,
                padding: const EdgeInsets.all(18),
                child: label == "Payments"
                    ? Column(
                        children: [
                          Text("$label (cash)"),
                          // ...accessRolesLabel
                          const SizedBox(
                            height: 18,
                          ),
                          Container(
                              height: _h * 0.4,
                              width: _w,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // color: Colors.red.shade50,
                              ),
                              child: data.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: 100,
                                            width: _w,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.green.shade50,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(data[index].buyerName),
                                                    Text(
                                                      "Delivery Date: ${data[index].deliveryDate}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "Message: ${data[index].messageToSeller}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                    Text(
                                                      "Total Price: ${data[index].totalPrice}",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    )
                                                  ],
                                                ),
                                                TextButton(
                                                    onPressed: () =>
                                                        onPressedApproved(
                                                            data[index].id ??
                                                                "None"),
                                                    child:
                                                        const Text("approved"))
                                              ],
                                            ),
                                          ),
                                        );
                                      })
                                  : const Center(
                                      child: Text(
                                          "No Transaction made in your store"),
                                    )
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(name),
                              //     TextButton(
                              //         onPressed: () {},
                              //         child: const Text("approved"))
                              //   ],
                              // )
                              )
                        ],
                      )
                    : label == "Shipments"
                        ? Column(
                            children: [
                              Text("$label And Delivery"),
                              // ...accessRolesLabel
                              const SizedBox(
                                height: 18,
                              ),
                              Container(
                                  height: _h * 0.4,
                                  width: _w,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    // color: Colors.green.shade50,
                                  ),
                                  child: ListView.builder(
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 150,
                                            width: _w,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              color: Colors.green.shade50,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Text(
                                                    "Buyer: ${data[index].buyerName}"),
                                                Text(
                                                    "Order ID: ${data[index].id}"),
                                                const SizedBox(
                                                  height: 18,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                        "Shipment Status"),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    DropdownButton<String>(
                                                      hint: const Text(
                                                          "Status"), // Placeholder text
                                                      value:
                                                          selectOption, // Currently selected value
                                                      items: options
                                                          .map((String option) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              option, // The value represented by this item
                                                          child: Text(
                                                              option), // Widget displayed in the menu
                                                        );
                                                      }).toList(),
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          selectOption =
                                                              newValue;
                                                        });

                                                        onChangeMenuButton(
                                                            data[index].id ??
                                                                "None",
                                                            newValue);
                                                      },
                                                    ),
                                                    // CircleAvatar(),
                                                    // CircleAvatar()
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }))
                            ],
                          )
                        : label == "Done"
                            ? Column(
                                children: [
                                  Text("$label And Delivery"),
                                  // ...accessRolesLabel
                                  const SizedBox(
                                    height: 18,
                                  ),
                                  Container(
                                      height: _h * 0.4,
                                      width: _w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // color: Colors.green.shade50,
                                      ),
                                      child: ListView.builder(
                                          itemCount: data.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 150,
                                                width: _w,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 24),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Colors.green.shade50,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                    Text(
                                                        "Buyer: ${data[index].buyerName}"),
                                                    Text(
                                                        "Order ID: ${data[index].id}"),
                                                    const SizedBox(
                                                      height: 18,
                                                    ),
                                                    const Text(
                                                        "THANK YOU FOR PURCHASING!")
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))
                                ],
                              )
                            : Container());
          }));
}
