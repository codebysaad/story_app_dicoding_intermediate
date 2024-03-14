// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'details_story_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DetailsStoryResponse _$DetailsStoryResponseFromJson(Map<String, dynamic> json) {
  return _DetailsStoryResponse.fromJson(json);
}

/// @nodoc
mixin _$DetailsStoryResponse {
  @JsonKey(name: "error")
  bool get error => throw _privateConstructorUsedError;
  @JsonKey(name: "message")
  String get message => throw _privateConstructorUsedError;
  @JsonKey(name: "story")
  StoryDetails get story => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DetailsStoryResponseCopyWith<DetailsStoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailsStoryResponseCopyWith<$Res> {
  factory $DetailsStoryResponseCopyWith(DetailsStoryResponse value,
          $Res Function(DetailsStoryResponse) then) =
      _$DetailsStoryResponseCopyWithImpl<$Res, DetailsStoryResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "error") bool error,
      @JsonKey(name: "message") String message,
      @JsonKey(name: "story") StoryDetails story});

  $StoryDetailsCopyWith<$Res> get story;
}

/// @nodoc
class _$DetailsStoryResponseCopyWithImpl<$Res,
        $Val extends DetailsStoryResponse>
    implements $DetailsStoryResponseCopyWith<$Res> {
  _$DetailsStoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? story = null,
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
      story: null == story
          ? _value.story
          : story // ignore: cast_nullable_to_non_nullable
              as StoryDetails,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $StoryDetailsCopyWith<$Res> get story {
    return $StoryDetailsCopyWith<$Res>(_value.story, (value) {
      return _then(_value.copyWith(story: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DetailsStoryResponseImplCopyWith<$Res>
    implements $DetailsStoryResponseCopyWith<$Res> {
  factory _$$DetailsStoryResponseImplCopyWith(_$DetailsStoryResponseImpl value,
          $Res Function(_$DetailsStoryResponseImpl) then) =
      __$$DetailsStoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "error") bool error,
      @JsonKey(name: "message") String message,
      @JsonKey(name: "story") StoryDetails story});

  @override
  $StoryDetailsCopyWith<$Res> get story;
}

/// @nodoc
class __$$DetailsStoryResponseImplCopyWithImpl<$Res>
    extends _$DetailsStoryResponseCopyWithImpl<$Res, _$DetailsStoryResponseImpl>
    implements _$$DetailsStoryResponseImplCopyWith<$Res> {
  __$$DetailsStoryResponseImplCopyWithImpl(_$DetailsStoryResponseImpl _value,
      $Res Function(_$DetailsStoryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? story = null,
  }) {
    return _then(_$DetailsStoryResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      story: null == story
          ? _value.story
          : story // ignore: cast_nullable_to_non_nullable
              as StoryDetails,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DetailsStoryResponseImpl implements _DetailsStoryResponse {
  const _$DetailsStoryResponseImpl(
      {@JsonKey(name: "error") required this.error,
      @JsonKey(name: "message") required this.message,
      @JsonKey(name: "story") required this.story});

  factory _$DetailsStoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$DetailsStoryResponseImplFromJson(json);

  @override
  @JsonKey(name: "error")
  final bool error;
  @override
  @JsonKey(name: "message")
  final String message;
  @override
  @JsonKey(name: "story")
  final StoryDetails story;

  @override
  String toString() {
    return 'DetailsStoryResponse(error: $error, message: $message, story: $story)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailsStoryResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.story, story) || other.story == story));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message, story);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailsStoryResponseImplCopyWith<_$DetailsStoryResponseImpl>
      get copyWith =>
          __$$DetailsStoryResponseImplCopyWithImpl<_$DetailsStoryResponseImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DetailsStoryResponseImplToJson(
      this,
    );
  }
}

abstract class _DetailsStoryResponse implements DetailsStoryResponse {
  const factory _DetailsStoryResponse(
          {@JsonKey(name: "error") required final bool error,
          @JsonKey(name: "message") required final String message,
          @JsonKey(name: "story") required final StoryDetails story}) =
      _$DetailsStoryResponseImpl;

  factory _DetailsStoryResponse.fromJson(Map<String, dynamic> json) =
      _$DetailsStoryResponseImpl.fromJson;

  @override
  @JsonKey(name: "error")
  bool get error;
  @override
  @JsonKey(name: "message")
  String get message;
  @override
  @JsonKey(name: "story")
  StoryDetails get story;
  @override
  @JsonKey(ignore: true)
  _$$DetailsStoryResponseImplCopyWith<_$DetailsStoryResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
