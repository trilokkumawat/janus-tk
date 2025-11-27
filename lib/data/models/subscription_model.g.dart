// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubscriptionPlanModelImpl _$$SubscriptionPlanModelImplFromJson(
  Map<String, dynamic> json,
) => _$SubscriptionPlanModelImpl(
  id: json['id'] as String,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  planname: json['planname'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  stripePriceId: json['stripepriceid'] as String?,
  features: json['features'] as String?,
);

Map<String, dynamic> _$$SubscriptionPlanModelImplToJson(
  _$SubscriptionPlanModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'created_at': instance.createdAt?.toIso8601String(),
  'planname': instance.planname,
  'price': instance.price,
  'stripepriceid': instance.stripePriceId,
  'features': instance.features,
};
