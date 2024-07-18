import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../repo/firebase/firebase_firestore_services.dart';
import '../../style/pallet.dart';
import '../HomeScreen/model/product_details/product_details.dart';
import '../ProductPage/controller/item_cubit.dart';
import '../ProductPage/view/product_screen.dart';

class CartPage extends StatefulWidget {
  static const id = "/CartPage";

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Page"),
      ),
      body: FutureBuilder<List<ProductDetails>>(
        future: _fireStoreService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No products found');
          } else {
            List<ProductDetails> products = snapshot.data!;
            return GridView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context
                        .read<ItemCubit>()
                        .setProductDetails(products[index], mainContext);
                    Navigator.of(context).pushNamed(ProductScreen.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 6,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(7.0.r),
                    height: 800.h,
                    width: 100.w,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: SizedBox(
                              height: 100.h,
                              width: 50.w,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: CachedNetworkImage(
                                  imageUrl: products[index].image,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "₹ ${products[index].price}",
                            style: const TextStyle(
                              color: Pallet.primary,
                            ),
                          ),
                          SizedBox(
                              height: 50.h,
                              width: 400.w,
                              child: Text(
                                textDirection: TextDirection.ltr,
                                products[index].title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  color: Pallet.secondary,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 2.0,
              ),
            );
          }
        },
      ),
    );
  }
}
