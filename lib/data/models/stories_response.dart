import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/utils/typedef.dart';
import 'data_stories.dart';

part 'stories_response.g.dart';
part 'stories_response.freezed.dart';

@freezed

class StoriesResponse with _$StoriesResponse {
  const factory StoriesResponse({
    required bool error,
    required String message,
    required List<DataStories> listStory,
}) = _StoriesResponse;

  factory StoriesResponse.fromJson(DataMap json) => _$StoriesResponseFromJson(json);
}
