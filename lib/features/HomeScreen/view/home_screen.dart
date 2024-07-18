import 'package:cached_network_image/cached_network_image.dart';
import 'package:elmore/features/CartPage/cart_page.dart';
import 'package:elmore/features/HomeScreen/controller/home_cubit.dart';
import 'package:elmore/features/ProductPage/controller/item_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../repo/firebase/firebase_firestore_services.dart';
import '../../../style/pallet.dart';
import '../../ProductPage/view/product_screen.dart';
import '../model/product_details/product_details.dart';

class HomeScreen extends StatefulWidget {
  static const id = "/homeScreen";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FireStoreService _fireStoreService = FireStoreService();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getProductDetails();
  }

  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    isDarkMode = !isDarkMode;
    await prefs.setBool('isDarkMode', isDarkMode);
    themeNotifier.value = isDarkMode;
  }

  @override
  Widget build(BuildContext mainContext) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CartPage.id);
            },
            icon: FutureBuilder<int>(
              future: _fireStoreService.countProducts(),
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Pallet.primary,
                        size: 30, // You can adjust the size as needed
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: const Center(
                            child: Text(
                              '!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Stack(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Pallet.primary,
                        size: 30, // You can adjust the size as needed
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
          IconButton(
            icon:
                Icon(themeNotifier.value ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ProductDetails>>(
              stream: context.read<HomeCubit>().productDetailsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available.'));
                } else {
                  var products = snapshot.data!;
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
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.all(7.0.r),
                          height: 800.h,
                          width: 100.w,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
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
                                Text("₹ ${products[index].price}",
                                    style: const TextStyle(
                                      color: Pallet.primary,
                                    )),
                                Spacer(),
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
                                    )
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 2.0,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
