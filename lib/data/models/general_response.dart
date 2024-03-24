import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/utils/typedef.dart';

part 'general_response.g.dart';

@JsonSerializable()
class GeneralResponse{
  final bool error;
  final String message;

  GeneralResponse({
    required this.error,
    required this.message,
  });

  factory GeneralResponse.fromJson(DataMap json) => _$GeneralResponseFromJson(json);

  DataMap toJson() => _$GeneralResponseToJson(this);
}