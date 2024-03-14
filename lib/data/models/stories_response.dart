import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'data_stories.dart';

part 'stories_response.g.dart';
part 'stories_response.freezed.dart';

@freezed

class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    @JsonKey(name: "error") required bool error,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "listStory") required List<DataStories> listStory,
}) = _StoriesResponse;

  factory StoriesResponse.fromJson(Map<String, dynamic> json) => _$StoriesResponseFromJson(json);
}
