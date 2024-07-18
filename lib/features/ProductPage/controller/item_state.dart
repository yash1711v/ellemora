part of 'item_cubit.dart';

@freezed
class ItemState with _$ItemState {
  const factory ItemState({
    ProductDetails? productDetails,
    @Default(false) bool? isPresent,
  }) = _ItemState;

  factory ItemState.fromJson(Map<String, dynamic> json) =>
      _$ItemStateFromJson(json);
}
