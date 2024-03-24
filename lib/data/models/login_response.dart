import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'package:story_app/utils/typedef.dart';
import 'login_data.dart';

part 'login_response.g.dart';
part 'login_response.freezed.dart';

@freezed

class LoginResponse with _$LoginResponse{
  const factory LoginResponse({
    required bool error,
    required String message,
    required LoginData loginData,
}) = _LoginResponse;

  factory LoginResponse.fromJson(DataMap json) => _$LoginResponseFromJson(json);
}
