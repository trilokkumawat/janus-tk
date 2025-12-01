// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
  Map<String, dynamic> json,
) {
  return _SubscriptionPlanModel.fromJson(json);
}

/// @nodoc
mixin _$SubscriptionPlanModel {
  String get id => throw _privateConstructorUsedError;
  @TZDateTimeConverter()
  @JsonKey(name: 'created_at')
  TZDateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'planname')
  String? get planname => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'stripepriceid')
  String? get stripePriceId => throw _privateConstructorUsedError;
  String? get features => throw _privateConstructorUsedError;

  /// Serializes this SubscriptionPlanModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubscriptionPlanModelCopyWith<SubscriptionPlanModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubscriptionPlanModelCopyWith<$Res> {
  factory $SubscriptionPlanModelCopyWith(
    SubscriptionPlanModel value,
    $Res Function(SubscriptionPlanModel) then,
  ) = _$SubscriptionPlanModelCopyWithImpl<$Res, SubscriptionPlanModel>;
  @useResult
  $Res call({
    String id,
    @TZDateTimeConverter() @JsonKey(name: 'created_at') TZDateTime? createdAt,
    @JsonKey(name: 'planname') String? planname,
    double? price,
    @JsonKey(name: 'stripepriceid') String? stripePriceId,
    String? features,
  });
}

/// @nodoc
class _$SubscriptionPlanModelCopyWithImpl<
  $Res,
  $Val extends SubscriptionPlanModel
>
    implements $SubscriptionPlanModelCopyWith<$Res> {
  _$SubscriptionPlanModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? planname = freezed,
    Object? price = freezed,
    Object? stripePriceId = freezed,
    Object? features = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as TZDateTime?,
            planname: freezed == planname
                ? _value.planname
                : planname // ignore: cast_nullable_to_non_nullable
                      as String?,
            price: freezed == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double?,
            stripePriceId: freezed == stripePriceId
                ? _value.stripePriceId
                : stripePriceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            features: freezed == features
                ? _value.features
                : features // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SubscriptionPlanModelImplCopyWith<$Res>
    implements $SubscriptionPlanModelCopyWith<$Res> {
  factory _$$SubscriptionPlanModelImplCopyWith(
    _$SubscriptionPlanModelImpl value,
    $Res Function(_$SubscriptionPlanModelImpl) then,
  ) = __$$SubscriptionPlanModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @TZDateTimeConverter() @JsonKey(name: 'created_at') TZDateTime? createdAt,
    @JsonKey(name: 'planname') String? planname,
    double? price,
    @JsonKey(name: 'stripepriceid') String? stripePriceId,
    String? features,
  });
}

/// @nodoc
class __$$SubscriptionPlanModelImplCopyWithImpl<$Res>
    extends
        _$SubscriptionPlanModelCopyWithImpl<$Res, _$SubscriptionPlanModelImpl>
    implements _$$SubscriptionPlanModelImplCopyWith<$Res> {
  __$$SubscriptionPlanModelImplCopyWithImpl(
    _$SubscriptionPlanModelImpl _value,
    $Res Function(_$SubscriptionPlanModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? planname = freezed,
    Object? price = freezed,
    Object? stripePriceId = freezed,
    Object? features = freezed,
  }) {
    return _then(
      _$SubscriptionPlanModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as TZDateTime?,
        planname: freezed == planname
            ? _value.planname
            : planname // ignore: cast_nullable_to_non_nullable
                  as String?,
        price: freezed == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double?,
        stripePriceId: freezed == stripePriceId
            ? _value.stripePriceId
            : stripePriceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        features: freezed == features
            ? _value.features
            : features // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SubscriptionPlanModelImpl implements _SubscriptionPlanModel {
  const _$SubscriptionPlanModelImpl({
    required this.id,
    @TZDateTimeConverter() @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'planname') this.planname,
    this.price,
    @JsonKey(name: 'stripepriceid') this.stripePriceId,
    this.features,
  });

  factory _$SubscriptionPlanModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubscriptionPlanModelImplFromJson(json);

  @override
  final String id;
  @override
  @TZDateTimeConverter()
  @JsonKey(name: 'created_at')
  final TZDateTime? createdAt;
  @override
  @JsonKey(name: 'planname')
  final String? planname;
  @override
  final double? price;
  @override
  @JsonKey(name: 'stripepriceid')
  final String? stripePriceId;
  @override
  final String? features;

  @override
  String toString() {
    return 'SubscriptionPlanModel(id: $id, createdAt: $createdAt, planname: $planname, price: $price, stripePriceId: $stripePriceId, features: $features)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubscriptionPlanModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.planname, planname) ||
                other.planname == planname) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stripePriceId, stripePriceId) ||
                other.stripePriceId == stripePriceId) &&
            (identical(other.features, features) ||
                other.features == features));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    createdAt,
    planname,
    price,
    stripePriceId,
    features,
  );

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubscriptionPlanModelImplCopyWith<_$SubscriptionPlanModelImpl>
  get copyWith =>
      __$$SubscriptionPlanModelImplCopyWithImpl<_$SubscriptionPlanModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SubscriptionPlanModelImplToJson(this);
  }
}

abstract class _SubscriptionPlanModel implements SubscriptionPlanModel {
  const factory _SubscriptionPlanModel({
    required final String id,
    @TZDateTimeConverter()
    @JsonKey(name: 'created_at')
    final TZDateTime? createdAt,
    @JsonKey(name: 'planname') final String? planname,
    final double? price,
    @JsonKey(name: 'stripepriceid') final String? stripePriceId,
    final String? features,
  }) = _$SubscriptionPlanModelImpl;

  factory _SubscriptionPlanModel.fromJson(Map<String, dynamic> json) =
      _$SubscriptionPlanModelImpl.fromJson;

  @override
  String get id;
  @override
  @TZDateTimeConverter()
  @JsonKey(name: 'created_at')
  TZDateTime? get createdAt;
  @override
  @JsonKey(name: 'planname')
  String? get planname;
  @override
  double? get price;
  @override
  @JsonKey(name: 'stripepriceid')
  String? get stripePriceId;
  @override
  String? get features;

  /// Create a copy of SubscriptionPlanModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubscriptionPlanModelImplCopyWith<_$SubscriptionPlanModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
