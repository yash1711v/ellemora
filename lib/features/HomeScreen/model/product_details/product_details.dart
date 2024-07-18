import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_details.freezed.dart';
part 'product_details.g.dart';

@freezed
class ProductDetails with _$ProductDetails {
  factory ProductDetails({
    @JsonKey(name: "id") @Default(0) int id,
    @JsonKey(name: "title") @Default("") String title,
    @JsonKey(name: "price") @Default(0.0) double price,
    @JsonKey(name: "description") @Default("") String description,
    @JsonKey(name: "category") @Default("") String category,
    @JsonKey(name: "image") @Default("") String image,
  }) = _ProductDetails;

  factory ProductDetails.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsFromJson(json);
}
