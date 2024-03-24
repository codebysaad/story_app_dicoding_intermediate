import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/utils/typedef.dart';
import 'story_details.dart';

part 'details_story_response.g.dart';
part 'details_story_response.freezed.dart';

@freezed

class DetailsStoryResponse with _$DetailsStoryResponse{
  const factory DetailsStoryResponse({
  required bool error,
  required String message,
  required StoryDetails story,
}) = _DetailsStoryResponse;

  factory DetailsStoryResponse.fromJson(DataMap json) => _$DetailsStoryResponseFromJson(json);
}
