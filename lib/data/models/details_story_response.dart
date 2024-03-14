import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'story_details.dart';

part 'details_story_response.g.dart';
part 'details_story_response.freezed.dart';

@freezed

class DetailsStoryResponse with _$DetailsStoryResponse{
  const factory DetailsStoryResponse({

  @JsonKey(name: "error") required bool error,
  @JsonKey(name: "message") required String message,
  @JsonKey(name: "story") required StoryDetails story,
}) = _DetailsStoryResponse;

  factory DetailsStoryResponse.fromJson(Map<String, dynamic> json) => _$DetailsStoryResponseFromJson(json);
}
