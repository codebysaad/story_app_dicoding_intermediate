import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'data_maps_stories.dart';

part 'maps_response.g.dart';
part 'maps_response.freezed.dart';

@freezed

class MapsResponse with _$MapsResponse {
  const factory MapsResponse({
    @JsonKey(name: "error") required bool error,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "listStory") required List<DataMapsStories> listStory,
  }) = _MapsResponse;

  factory MapsResponse.fromJson(Map<String, dynamic> json) => _$MapsResponseFromJson(json);
}
