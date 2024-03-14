// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maps_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MapsResponse _$MapsResponseFromJson(Map<String, dynamic> json) {
  return _MapsResponse.fromJson(json);
}

/// @nodoc
mixin _$MapsResponse {
  @JsonKey(name: "error")
  bool get error => throw _privateConstructorUsedError;
  @JsonKey(name: "message")
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: "listStory")
  List<DataMapsStories> get listStory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MapsResponseCopyWith<MapsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MapsResponseCopyWith<$Res> {
  factory $MapsResponseCopyWith(
          MapsResponse value, $Res Function(MapsResponse) then) =
      _$MapsResponseCopyWithImpl<$Res, MapsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "error") bool error,
      @JsonKey(name: "message") String message,
      @JsonKey(name: "listStory") List<DataMapsStories> listStory});
}

/// @nodoc
class _$MapsResponseCopyWithImpl<$Res, $Val extends MapsResponse>
    implements $MapsResponseCopyWith<$Res> {
  _$MapsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      listStory: null == listStory
          ? _value.listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<DataMapsStories>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MapsResponseImplCopyWith<$Res>
    implements $MapsResponseCopyWith<$Res> {
  factory _$$MapsResponseImplCopyWith(
          _$MapsResponseImpl value, $Res Function(_$MapsResponseImpl) then) =
      __$$MapsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "error") bool error,
      @JsonKey(name: "message") String message,
      @JsonKey(name: "listStory") List<DataMapsStories> listStory});
}

/// @nodoc
class __$$MapsResponseImplCopyWithImpl<$Res>
    extends _$MapsResponseCopyWithImpl<$Res, _$MapsResponseImpl>
    implements _$$MapsResponseImplCopyWith<$Res> {
  __$$MapsResponseImplCopyWithImpl(
      _$MapsResponseImpl _value, $Res Function(_$MapsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
  }) {
    return _then(_$MapsResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      listStory: null == listStory
          ? _value._listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<DataMapsStories>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MapsResponseImpl implements _MapsResponse {
  const _$MapsResponseImpl(
      {@JsonKey(name: "error") required this.error,
      @JsonKey(name: "message") required this.message,
      @JsonKey(name: "listStory")
      required final List<DataMapsStories> listStory})
      : _listStory = listStory;

  factory _$MapsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapsResponseImplFromJson(json);

  @override
  @JsonKey(name: "error")
  final bool error;
  @override
  @JsonKey(name: "message")
  final String message;
  final List<DataMapsStories> _listStory;
  @override
  @JsonKey(name: "listStory")
  List<DataMapsStories> get listStory {
    if (_listStory is EqualUnmodifiableListView) return _listStory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listStory);
  }

  @override
  String toString() {
    return 'MapsResponse(error: $error, message: $message, listStory: $listStory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapsResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._listStory, _listStory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message,
      const DeepCollectionEquality().hash(_listStory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapsResponseImplCopyWith<_$MapsResponseImpl> get copyWith =>
      __$$MapsResponseImplCopyWithImpl<_$MapsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MapsResponseImplToJson(
      this,
    );
  }
}

abstract class _MapsResponse implements MapsResponse {
  const factory _MapsResponse(
      {@JsonKey(name: "error") required final bool error,
      @JsonKey(name: "message") required final String message,
      @JsonKey(name: "listStory")
      required final List<DataMapsStories> listStory}) = _$MapsResponseImpl;

  factory _MapsResponse.fromJson(Map<String, dynamic> json) =
      _$MapsResponseImpl.fromJson;

  @override
  @JsonKey(name: "error")
  bool get error;
  @override
  @JsonKey(name: "message")
  String get message;
  @override
  @JsonKey(name: "listStory")
  List<DataMapsStories> get listStory;
  @override
  @JsonKey(ignore: true)
  _$$MapsResponseImplCopyWith<_$MapsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
