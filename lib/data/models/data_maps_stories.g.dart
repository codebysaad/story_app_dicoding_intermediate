// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_maps_stories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DataMapsStoriesImpl _$$DataMapsStoriesImplFromJson(
        Map<String, dynamic> json) =>
    _$DataMapsStoriesImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$$DataMapsStoriesImplToJson(
        _$DataMapsStoriesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'lat': instance.lat,
      'lon': instance.lon,
    };
