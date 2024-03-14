// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_story_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DetailsStoryResponseImpl _$$DetailsStoryResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DetailsStoryResponseImpl(
      error: json['error'] as bool,
      message: json['message'] as String,
      story: StoryDetails.fromJson(json['story'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DetailsStoryResponseImplToJson(
        _$DetailsStoryResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'story': instance.story,
    };
