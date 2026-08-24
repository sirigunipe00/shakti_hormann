class PalletCodeModel {
  const PalletCodeModel({required this.name});
  final String name;

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      other is PalletCodeModel && other.name == name;

  @override
  int get hashCode => name.hashCode;
}