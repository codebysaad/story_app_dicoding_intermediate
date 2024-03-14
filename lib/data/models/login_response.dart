import 'package:freezed_annotation/freezed_annotation.dart' hide JsonKey;
import 'package:json_annotation/json_annotation.dart';
import 'login_data.dart';

part 'login_response.g.dart';
part 'login_response.freezed.dart';

@freezed

class LoginResponse with _$LoginResponse{
  const factory LoginResponse({
    @JsonKey(name: "error") required bool error,
    @JsonKey(name: "message") required String message,
    @JsonKey(name: "loginResult") required LoginData loginData,
}) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}
