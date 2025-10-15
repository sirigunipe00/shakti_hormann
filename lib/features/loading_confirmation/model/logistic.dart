
import 'package:freezed_annotation/freezed_annotation.dart';

part 'logistic.freezed.dart';
part 'logistic.g.dart';

@freezed
class LogisticModel with _$LogisticModel {
  const factory LogisticModel({
    @JsonKey(name : 'sales_order') String? name,
    @JsonKey(name: 'state') String? state,   
    @JsonKey(name: 'city') String? city,  }) = _LogisticModel;
factory LogisticModel.fromJson(Map<String, dynamic> json) => _$LogisticModelFromJson(json);
}