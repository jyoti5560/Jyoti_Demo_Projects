import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {
  final String symbol;

  final int decimalDigits;

  final bool symbolBeforeTheNumber;

  @JsonKey(name: 'currency')
  final String currencyDisplay;

  final String currencyCode;

  final int smallestUnitRate;

  Currency({
    required this.symbol,
    required this.decimalDigits,
    required this.symbolBeforeTheNumber,
    required this.currencyDisplay,
    required this.currencyCode,
    required this.smallestUnitRate,
  });

  factory Currency.fromJson(Map<String, dynamic> json) =>
      _$CurrencyFromJson(json);
  Map<String, dynamic> toJson(instance) => _$CurrencyToJson(this);
}
