import 'package:freezed_annotation/freezed_annotation.dart';

part 'pallet_details.freezed.dart';
part 'pallet_details.g.dart';

@freezed
class PalletDetails with _$PalletDetails {
  const factory PalletDetails({
    @JsonKey(name: 'status') int? status,
    @JsonKey(name: 'data') PalletData? data,
  }) = _PalletDetails;

  factory PalletDetails.fromJson(Map<String, dynamic> json) =>
      _$PalletDetailsFromJson(json);
}

@freezed
class PalletData with _$PalletData {
  const factory PalletData({
    @JsonKey(name: 'doctype') String? doctype,
    @JsonKey(name: 'pallet_no') String? palletNo,
    @JsonKey(name: 'total_qty') int? totalQty,
    @JsonKey(name: 'sales_orders') List<String>? salesOrders,
  }) = _PalletData;

  factory PalletData.fromJson(Map<String, dynamic> json) =>
      _$PalletDataFromJson(json);
}