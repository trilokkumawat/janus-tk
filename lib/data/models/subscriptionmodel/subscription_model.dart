import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:timezone/timezone.dart';
import 'package:janus/core/utils/timezone_utils.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

/// Subscription plan model representing a subscription plan entity
@Freezed()
class SubscriptionPlanModel with _$SubscriptionPlanModel {
  const factory SubscriptionPlanModel({
    required String id,
    @TZDateTimeConverter() @JsonKey(name: 'created_at') TZDateTime? createdAt,
    @JsonKey(name: 'planname') String? planname,
    double? price,
    @JsonKey(name: 'stripepriceid') String? stripePriceId,
    String? features,
  }) = _SubscriptionPlanModel;

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanModelFromJson(json);
}
