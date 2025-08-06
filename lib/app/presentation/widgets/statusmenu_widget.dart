
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class StatusMenuWidget extends StatefulWidget {
  const StatusMenuWidget({
    super.key,
    required this.onChange,
    required this.items,
    this.defaultSel,
    this.defaultStatus,
  });

  final List<String> items;
  final String? defaultSel;
  final void Function(String status) onChange;
    final String? defaultStatus;
  @override
  State<StatusMenuWidget> createState() => _StatusMenuWidgetState();
}

class _StatusMenuWidgetState extends State<StatusMenuWidget> {
  String? _selectedDuration;
  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.defaultSel ?? widget.items.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isDense: true,
      isExpanded: false,
      value: _selectedDuration,
      dropdownColor: AppColors.white,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.white,
            ),
            borderRadius: BorderRadius.circular(8)),
        fillColor: Colors.white,
        filled: true,
        border: InputBorder.none,
      ),
      items: widget.items.map((e) {
        return DropdownMenuItem<String>(
          value: e,
          alignment: Alignment.center,
          child: Text(e,
              style: context.textTheme.labelLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _selectedDuration = value;
        });
        widget.onChange.call(value!);
      },
    );
  }
}
