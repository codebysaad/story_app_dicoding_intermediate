import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/utils/typedef.dart';

part 'story_details.g.dart';
part 'story_details.freezed.dart';

@freezed
class StoryDetails with _$StoryDetails{
  const factory StoryDetails({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
}) = _StoryDetails;

  factory StoryDetails.fromJson(DataMap json) => _$StoryDetailsFromJson(json);
}