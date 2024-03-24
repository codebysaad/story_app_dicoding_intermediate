import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/utils/typedef.dart';
import 'data_maps_stories.dart';

part 'maps_response.g.dart';
part 'maps_response.freezed.dart';

@freezed

class MapsResponse with _$MapsResponse {
  const factory MapsResponse({
    required bool error,
    required String message,
    required List<DataMapsStories> listStory,
  }) = _MapsResponse;

  factory MapsResponse.fromJson(DataMap json) => _$MapsResponseFromJson(json);
}
