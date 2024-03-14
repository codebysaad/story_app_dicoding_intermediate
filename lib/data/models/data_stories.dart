import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_stories.g.dart';
part 'data_stories.freezed.dart';

@freezed
class DataStories with _$DataStories {
  const factory DataStories({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
}) = _DataStories;

  factory DataStories.fromJson(Map<String, dynamic> json) => _$DataStoriesFromJson(json);
}