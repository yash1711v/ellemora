import 'package:bloc/bloc.dart';
import 'package:elmore/features/HomeScreen/model/product_details/product_details.dart';
import 'package:elmore/routes/routes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_cubit.freezed.dart';
part 'item_cubit.g.dart';
part 'item_state.dart';

class ItemCubit extends Cubit<ItemState> {
  ItemCubit() : super(const ItemState());

  void setProductDetails(ProductDetails productDetails, BuildContext context) {
    emit(ItemState(productDetails: productDetails));
  }

  bool isPresent(bool isPresent, BuildContext context) {
    return isPresent;
  }
}
