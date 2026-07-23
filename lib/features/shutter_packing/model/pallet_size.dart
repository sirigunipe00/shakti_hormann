import 'package:freezed_annotation/freezed_annotation.dart';

part 'pallet_size.freezed.dart';
part 'pallet_size.g.dart';

@freezed
class PalletSize with _$PalletSize {
  const factory PalletSize({
    @JsonKey(name: 'name') String? name,
      }) = _PalletSize;

  factory PalletSize.fromJson(Map<String, dynamic> json) =>
      _$PalletSizeFromJson(json);
}
