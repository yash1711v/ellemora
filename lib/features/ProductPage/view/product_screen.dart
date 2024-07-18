import 'package:elmore/features/HomeScreen/model/product_details/product_details.dart';
import 'package:elmore/features/ProductPage/controller/item_cubit.dart';
import 'package:elmore/helper/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../repo/firebase/firebase_firestore_services.dart';
import '../../../style/pallet.dart';

class ProductScreen extends StatefulWidget {
  static const id = "/ProductScreen";

  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  ProductDetails? _productDetails;
  final FireStoreService _fireStoreService = FireStoreService();
  bool isPresent = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemCubit, ItemState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.productDetails == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          _productDetails = state.productDetails;
          _fireStoreService.doesProductExist(_productDetails!).then((value) {
            if (value) {
              setState(() {
                isPresent = context.read<ItemCubit>().isPresent(true, context);
              });
              hideLoading();
            } else {
              setState(() {
                isPresent = context.read<ItemCubit>().isPresent(false, context);
              });
              hideLoading();
            }
          });
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text("Product Page"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 0.5.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: NetworkImage(_productDetails!.image),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: SizedBox(
                    width: 1.sw,
                    child: Text(
                      _productDetails!.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0.w, vertical: 8.0.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "₹ ${_productDetails!.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            showLoading();
                            if (!isPresent) {
                              _fireStoreService
                                  .addProduct(_productDetails!)
                                  .then((value) {
                                _fireStoreService
                                    .doesProductExist(_productDetails!)
                                    .then((value) {
                                  if (value) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content:
                                                Text("Product added to cart")));
                                    setState(() {
                                      isPresent = context
                                          .read<ItemCubit>()
                                          .isPresent(true, context);
                                    });
                                    hideLoading();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Product not added to cart")));
                                    setState(() {
                                      isPresent = context
                                          .read<ItemCubit>()
                                          .isPresent(false, context);
                                    });
                                    hideLoading();
                                  }
                                });
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Already Exist")));
                            }
                          },
                          icon: Icon(
                            isPresent ? Icons.done : Icons.add_shopping_cart,
                            color: Pallet.primary,
                            size: 30,
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                  child: Text(
                    _productDetails!.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
