import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/utils/typedef.dart';

part 'login_data.g.dart';
part 'login_data.freezed.dart';

@freezed
class LoginData with _$LoginData {
  const factory LoginData ({
    required String userId,
    required String name,
    required String token,
}) = _LoginData;

  factory LoginData.fromJson(DataMap json) => _$LoginDataFromJson(json);
}