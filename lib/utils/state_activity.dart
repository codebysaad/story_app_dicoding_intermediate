import 'package:freezed_annotation/freezed_annotation.dart';

part 'state_activity.freezed.dart';

@freezed
class StateActivity with _$StateActivity {
  const factory StateActivity.init() = StateActivityInit;
  const factory StateActivity.loading() = StateActivityLoading;
  const factory StateActivity.hasData() = StateActivityHasData;
  const factory StateActivity.error() = StateActivityError;
}
