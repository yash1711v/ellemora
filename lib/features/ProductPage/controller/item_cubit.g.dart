// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ItemStateImpl _$$ItemStateImplFromJson(Map<String, dynamic> json) =>
    _$ItemStateImpl(
      productDetails: json['productDetails'] == null
          ? null
          : ProductDetails.fromJson(
              json['productDetails'] as Map<String, dynamic>),
      isPresent: json['isPresent'] as bool? ?? false,
    );

Map<String, dynamic> _$$ItemStateImplToJson(_$ItemStateImpl instance) =>
    <String, dynamic>{
      'productDetails': instance.productDetails,
      'isPresent': instance.isPresent,
    };
