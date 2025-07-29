import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class AppTextField extends StatelessWidget {
  AppTextField({
    super.key,
    this.title,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputType = TextInputType.text,
    this.minLines = 1,
    this.maxLines = 1,
    this.maxLength = 255,
    this.readOnly = false,
    this.helperText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.autofocus = false,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.isRequired = false,
    this.contentPadding = const EdgeInsets.all(12.0),
    this.validator,
    this.textInputAction = TextInputAction.done,
    TextEditingController? controller,
  })  : controller = controller ?? TextEditingController(),
        super() {
    if (initialValue?.isNotEmpty == true) {
      this.controller.text = initialValue!;
    }
  }

  final String? title;
  final String? labelText;
  final String? initialValue;
  final Function(String text)? onChanged;
  final Function(String text)? onFieldSubmitted;
  final TextInputType inputType;
  final int minLines;
  final int maxLines;
  final int maxLength;
  final bool readOnly;
  final String? helperText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffix;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final TextEditingController controller;
  final bool autofocus;
  final bool obscureText;
  final bool isRequired;
  final EdgeInsets contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(4.0),
      borderSide: const BorderSide(color: AppColors.green),
    );

    return SpacedColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
      defaultHeight: 4.0,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title.containsValidValue) ...[
          CaptionText(title: title.valueOrEmpty, isRequired: isRequired),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText ?? title?.replaceAll(':', ''),
            hintStyle: context.textTheme.labelSmall?.copyWith(
              color: AppColors.chimneySweep,
            ),
            border: textFieldBorder,
            enabledBorder: textFieldBorder,
            focusedBorder: textFieldBorder,
            contentPadding: contentPadding,
            suffix: suffix,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            filled: readOnly,
            fillColor: AppColors.bleachedSilk.withOpacity(0.5),
            counterText: '',
            helperText: helperText,
          ),
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
          obscuringCharacter: '*',
          inputFormatters: inputFormatters,
          keyboardType: inputType,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          readOnly: readOnly,
          autocorrect: false,
          autofocus: autofocus,
          onChanged: onChanged,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          textInputAction: textInputAction,
        ),
      ],
    );
  }
}
