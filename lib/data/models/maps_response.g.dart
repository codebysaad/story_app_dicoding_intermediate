// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maps_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MapsResponseImpl _$$MapsResponseImplFromJson(Map<String, dynamic> json) =>
    _$MapsResponseImpl(
      error: json['error'] as bool,
      message: json['message'] as String,
      listStory: (json['listStory'] as List<dynamic>)
          .map((e) => DataMapsStories.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$MapsResponseImplToJson(_$MapsResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
    };
