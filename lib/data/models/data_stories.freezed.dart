// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_stories.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DataStories _$DataStoriesFromJson(Map<String, dynamic> json) {
  return _DataStories.fromJson(json);
}

/// @nodoc
mixin _$DataStories {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get photoUrl => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DataStoriesCopyWith<DataStories> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DataStoriesCopyWith<$Res> {
  factory $DataStoriesCopyWith(
          DataStories value, $Res Function(DataStories) then) =
      _$DataStoriesCopyWithImpl<$Res, DataStories>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String photoUrl,
      DateTime createdAt,
      double? lat,
      double? lon});
}

/// @nodoc
class _$DataStoriesCopyWithImpl<$Res, $Val extends DataStories>
    implements $DataStoriesCopyWith<$Res> {
  _$DataStoriesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DataStoriesImplCopyWith<$Res>
    implements $DataStoriesCopyWith<$Res> {
  factory _$$DataStoriesImplCopyWith(
          _$DataStoriesImpl value, $Res Function(_$DataStoriesImpl) then) =
      __$$DataStoriesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String photoUrl,
      DateTime createdAt,
      double? lat,
      double? lon});
}

/// @nodoc
class __$$DataStoriesImplCopyWithImpl<$Res>
    extends _$DataStoriesCopyWithImpl<$Res, _$DataStoriesImpl>
    implements _$$DataStoriesImplCopyWith<$Res> {
  __$$DataStoriesImplCopyWithImpl(
      _$DataStoriesImpl _value, $Res Function(_$DataStoriesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? photoUrl = null,
    Object? createdAt = null,
    Object? lat = freezed,
    Object? lon = freezed,
  }) {
    return _then(_$DataStoriesImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: null == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: freezed == lon
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DataStoriesImpl implements _DataStories {
  const _$DataStoriesImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.photoUrl,
      required this.createdAt,
      this.lat,
      this.lon});

  factory _$DataStoriesImpl.fromJson(Map<String, dynamic> json) =>
      _$$DataStoriesImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String photoUrl;
  @override
  final DateTime createdAt;
  @override
  final double? lat;
  @override
  final double? lon;

  @override
  String toString() {
    return 'DataStories(id: $id, name: $name, description: $description, photoUrl: $photoUrl, createdAt: $createdAt, lat: $lat, lon: $lon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DataStoriesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lon, lon) || other.lon == lon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, photoUrl, createdAt, lat, lon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DataStoriesImplCopyWith<_$DataStoriesImpl> get copyWith =>
      __$$DataStoriesImplCopyWithImpl<_$DataStoriesImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DataStoriesImplToJson(
      this,
    );
  }
}

abstract class _DataStories implements DataStories {
  const factory _DataStories(
      {required final String id,
      required final String name,
      required final String description,
      required final String photoUrl,
      required final DateTime createdAt,
      final double? lat,
      final double? lon}) = _$DataStoriesImpl;

  factory _DataStories.fromJson(Map<String, dynamic> json) =
      _$DataStoriesImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get photoUrl;
  @override
  DateTime get createdAt;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  @JsonKey(ignore: true)
  _$$DataStoriesImplCopyWith<_$DataStoriesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
