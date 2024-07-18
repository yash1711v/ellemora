import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:elmore/features/HomeScreen/model/product_details/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../repo/repository.dart';

part 'home_state.dart';
part 'home_cubit.freezed.dart';
part 'home_cubit.g.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());
  final _repo = Repo();
  final StreamController<List<ProductDetails>> _productDetailsController = StreamController<List<ProductDetails>>();

  Stream<List<ProductDetails>> get productDetailsStream => _productDetailsController.stream;

  Future<void> getProductDetails() async {
    try {
      while (true) {
        var data = await _repo.getAllProducts();
        List<ProductDetails> products = [];
        for (int i = 0; i < data.length; i++) {
          products.add(ProductDetails.fromJson(data[i]));
        }
        _productDetailsController.add(products);
        await Future.delayed(const Duration(seconds: 5)); // Adjust the duration as needed
      }
    } catch (e) {
      _productDetailsController.addError(e);
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> close() {
    _productDetailsController.close();
    return super.close();
  }
}
