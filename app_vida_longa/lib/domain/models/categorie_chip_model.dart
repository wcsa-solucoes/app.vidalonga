import 'package:equatable/equatable.dart';

class ChipCategorieModel extends Equatable {
  final String label;
  final bool selected;
  final String uuid;
  const ChipCategorieModel({
    this.label = "",
    this.selected = false,
    this.uuid = "",
  });

  @override
  List<Object?> get props => [
        label,
        selected,
        uuid,
      ];

  ChipCategorieModel copyWith({
    String? label,
    bool? selected,
    String? uuid,
  }) {
    return ChipCategorieModel(
      label: label ?? this.label,
      selected: selected ?? this.selected,
      uuid: uuid ?? this.uuid,
    );
  }
}
