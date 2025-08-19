import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class AppSearchBarWidget extends StatefulWidget {
  const AppSearchBarWidget({
    super.key,
    required this.onSearch,
    required this.onClear,
    this.hintText = 'Search with FBO Name',
  });

  final String? hintText;
  final Function(String) onSearch;
  final Function() onClear;

  @override
  State<AppSearchBarWidget> createState() => _AppSearchBarWidgetState();
}

class _AppSearchBarWidgetState extends State<AppSearchBarWidget> {
  final TextEditingController controller = TextEditingController();
  Timer? _debounce;
  bool showClear = false;
  final FocusNode focus = FocusNode();

  void _onSearchQuery(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearch(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFEDEDED),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        onTap: () {
          setState(() {
            showClear = true;
          });
        },
        onTapOutside: (event) {
          setState(() {
            showClear = false;
            focus.unfocus();
          });
        },
        focusNode: focus,
        controller: controller,
        cursorColor: AppColors.black,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(12.0),
          hintText: widget.hintText,
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            onPressed: () {
              if (controller.text.isEmpty) return;

              setState(() {
                controller.clear();
                focus.unfocus();
              });
              widget.onClear();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        onChanged: _onSearchQuery,
      ),
    );
  }
}
