import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_maps_stories.g.dart';
part 'data_maps_stories.freezed.dart';

@freezed
class DataMapsStories with _$DataMapsStories {
  const factory DataMapsStories({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    required double lat,
    required double lon,
  }) = _DataMapsStories;

  factory DataMapsStories.fromJson(Map<String, dynamic> json) => _$DataMapsStoriesFromJson(json);
}