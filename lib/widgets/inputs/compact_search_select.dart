import 'package:flutter/material.dart';

const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);
const _accent = Color(0xFFF2A93E);
const _accentSoft = Color(0xFFFFF4E4);
const _fieldBorder = Color(0xFFD6DCE8);
const _fieldFill = Color(0xFFFBFBFD);

/// Pallet Creation–style searchable select.
/// Menu opens in an [Overlay] so it never overflows fixed app-bar heights.
class CompactSearchSelect<T> extends StatefulWidget {
  const CompactSearchSelect({
    super.key,
    required this.label,
    required this.hint,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    required this.leadingIcon,
    this.value,
    this.subtitleOf,
    this.matchesQuery,
    this.isRequired = false,
    this.locked = false,
    this.isLoading = false,
    this.maxMenuHeight = 280,
    this.searchIcon = Icons.search_rounded,
    this.labelColor,
  });

  final String label;
  final String hint;
  final List<T> options;
  final T? value;
  final String Function(T item) labelOf;
  final String? Function(T item)? subtitleOf;
  final bool Function(T item, String query)? matchesQuery;
  final ValueChanged<T> onChanged;
  final IconData leadingIcon;
  final IconData searchIcon;
  final bool isRequired;
  final bool locked;
  final bool isLoading;
  final double maxMenuHeight;
  final Color? labelColor;

  @override
  State<CompactSearchSelect<T>> createState() => _CompactSearchSelectState<T>();
}

class _CompactSearchSelectState<T> extends State<CompactSearchSelect<T>> {
  final LayerLink _link = LayerLink();
  final GlobalKey _fieldKey = GlobalKey();
  OverlayEntry? _overlay;
  late final TextEditingController _search;
  late List<T> _filtered;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _filtered = widget.options;
  }

  @override
  void didUpdateWidget(covariant CompactSearchSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.options != widget.options) {
      _applyFilter(_search.text, rebuildOverlay: true);
    }
    if (widget.locked && _expanded) {
      _closeOverlay();
    }
  }

  @override
  void dispose() {
    _closeOverlay();
    _search.dispose();
    super.dispose();
  }

  void _applyFilter(String query, {bool rebuildOverlay = false}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      _filtered = widget.options;
    } else {
      _filtered = widget.options.where((item) {
        if (widget.matchesQuery != null) {
          return widget.matchesQuery!(item, q);
        }
        final label = widget.labelOf(item).toLowerCase();
        final sub = widget.subtitleOf?.call(item)?.toLowerCase() ?? '';
        return label.contains(q) || sub.contains(q);
      }).toList();
    }
    if (_expanded || rebuildOverlay) {
      _overlay?.markNeedsBuild();
    } else if (mounted) {
      setState(() {});
    }
  }

  void _toggle() {
    if (widget.locked || widget.isLoading) return;
    if (_expanded) {
      _closeOverlay();
    } else {
      _openOverlay();
    }
  }

  void _openOverlay() {
    _filtered = widget.options;
    _search.clear();
    final overlay = Overlay.of(context);
    final box = _fieldKey.currentContext?.findRenderObject() as RenderBox?;
    final fieldWidth = box?.size.width ?? MediaQuery.sizeOf(context).width - 24;
    final screenH = MediaQuery.sizeOf(context).height;
    final fieldOffset = box?.localToGlobal(Offset.zero) ?? Offset.zero;
    final spaceBelow = screenH - fieldOffset.dy - (box?.size.height ?? 56) - 24;
    final menuH = widget.maxMenuHeight.clamp(160.0, spaceBelow.clamp(160.0, 360.0));

    _overlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closeOverlay,
                child: const ColoredBox(color: Colors.transparent),
              ),
            ),
            CompositedTransformFollower(
              link: _link,
              showWhenUnlinked: false,
              offset: Offset(0, (box?.size.height ?? 52) + 6),
              child: Material(
                elevation: 10,
                shadowColor: const Color(0xFF0E1446).withValues(alpha: 0.18),
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: fieldWidth,
                  height: menuH,
                  child: _MenuPanel(
                    search: _search,
                    searchIcon: widget.searchIcon,
                    filtered: _filtered,
                    value: widget.value,
                    labelOf: widget.labelOf,
                    subtitleOf: widget.subtitleOf,
                    onQuery: (q) => _applyFilter(q, rebuildOverlay: true),
                    onSelect: (item) {
                      widget.onChanged(item);
                      _closeOverlay();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlay!);
    setState(() => _expanded = true);
  }

  void _closeOverlay() {
    _overlay?.remove();
    _overlay = null;
    _search.clear();
    _filtered = widget.options;
    if (_expanded && mounted) {
      setState(() => _expanded = false);
    } else {
      _expanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;
    final borderColor = widget.locked
        ? _fieldBorder
        : (_expanded ? const Color(0xFFB8C4DE) : _fieldBorder);
    final display = hasValue ? widget.labelOf(widget.value as T) : widget.hint;
    final subtitle =
        hasValue ? widget.subtitleOf?.call(widget.value as T) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(
          widget.label,
          required: widget.isRequired,
          color: widget.labelColor ?? _ink,
        ),
        const SizedBox(height: 8),
        CompositedTransformTarget(
          link: _link,
          child: AnimatedContainer(
            key: _fieldKey,
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: widget.locked ? const Color(0xFFF3F5F8) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: _expanded
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0E1446).withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _toggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        widget.leadingIcon,
                        size: 20,
                        color: hasValue ? _ink : _muted,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              display,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: hasValue
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: hasValue ? _ink : _muted,
                                fontFamily: 'Urbanist',
                              ),
                            ),
                            if (subtitle != null && subtitle.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _muted,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (widget.isLoading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else if (widget.locked)
                        const Icon(
                          Icons.lock_outline,
                          color: _muted,
                          size: 18,
                        )
                      else
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 180),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _muted,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuPanel<T> extends StatelessWidget {
  const _MenuPanel({
    required this.search,
    required this.searchIcon,
    required this.filtered,
    required this.value,
    required this.labelOf,
    required this.subtitleOf,
    required this.onQuery,
    required this.onSelect,
  });

  final TextEditingController search;
  final IconData searchIcon;
  final List<T> filtered;
  final T? value;
  final String Function(T item) labelOf;
  final String? Function(T item)? subtitleOf;
  final ValueChanged<String> onQuery;
  final ValueChanged<T> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
          child: TextField(
            controller: search,
            autofocus: true,
            onChanged: onQuery,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: const TextStyle(
                color: _muted,
                fontWeight: FontWeight.w500,
                fontFamily: 'Urbanist',
              ),
              prefixIcon: Icon(searchIcon, size: 18, color: _muted),
              suffixIcon: search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      color: _muted,
                      onPressed: () {
                        search.clear();
                        onQuery('');
                      },
                    ),
              filled: true,
              fillColor: _fieldFill,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Flexible(
          child: filtered.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'No matches',
                    style: TextStyle(
                      color: _muted,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final option = filtered[index];
                    final selected = identical(option, value) ||
                        (value != null &&
                            labelOf(option) == labelOf(value as T));
                    final title = labelOf(option);
                    final sub = subtitleOf?.call(option);
                    return Material(
                      color: selected ? _accentSoft : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => onSelect(option),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 11,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: selected
                                      ? _accent
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selected
                                        ? _accent
                                        : const Color(0xFFC5CAD3),
                                    width: 2,
                                  ),
                                ),
                                child: selected
                                    ? const Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: selected
                                            ? FontWeight.w700
                                            : FontWeight.w600,
                                        color: _ink,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    if (sub != null && sub.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        sub,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _muted,
                                          fontFamily: 'Urbanist',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text, {this.required = false, this.color = _ink});

  final String text;
  final bool required;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Urbanist',
        ),
        children: [
          TextSpan(text: text),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: Color(0xFFE11D48)),
            ),
        ],
      ),
    );
  }
}
