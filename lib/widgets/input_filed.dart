import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/caption_text.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class InputField extends StatelessWidget {
  InputField({
    super.key,
    required this.title,
    this.initialValue,
    this.onChanged,
    this.onSubmitted,
    this.inputType = TextInputType.text,
    this.maxLength = 255,
    this.readOnly = false,
    this.hintText,
    this.suffixIcon,
    this.autofocus = false,
    this.borderColor,
    this.minLines,
    this.maxLines,
    this.inputFormatters,
    this.focusNode,
    this.color=AppColors.black,
    this.isRequired = false,
    TextEditingController? controller,
    this.validator,
  }) {
    this.controller = controller ?? TextEditingController();
    if (initialValue?.isNotEmpty == true) {
      this.controller?.text = initialValue!;
    }
  }

  final String title;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType inputType;
  final int maxLength;
  final bool readOnly;
  final String? hintText;
  final Widget? suffixIcon;
  final FocusNode? focusNode;
  final Color? borderColor;
  final String? Function(String?)? validator;
  late final TextEditingController? controller;
  final bool autofocus;
  final bool isRequired;
  final Color color;
  final int? minLines;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    final textFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: AppColors.black, width: 0.8),
    );

    return Focus(
      focusNode: focusNode,
      child: SpacedColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        defaultHeight: 4.0,
        children: [
          CaptionText(title: title, isRequired: isRequired, color:color ,),
          Container(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              // border: Border.all(color: AppColors.white),
              // boxShadow: [
              //   BoxShadow(
              //     color: borderColor ?? AppColors.white,
              //     blurRadius: 2,
              //     offset: const Offset(2, 2)
              //   ),
              // ],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: TextFormField(
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              controller: controller,

              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: suffixIcon,
                counterText: '',
                hintText: hintText,
                hintStyle: TextStyle(fontFamily: 'Urabnist',fontWeight: FontWeight.w500,fontSize: 10)
              ),
              obscuringCharacter: '*',
              textInputAction: TextInputAction.done,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              onChanged: onChanged,
              validator: validator,
              // onSubmitted: onSubmitted,
              keyboardType: inputType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              textCapitalization: TextCapitalization.none,
              readOnly: readOnly,
              minLines: minLines,
              maxLines: minLines,
              autocorrect: false,
              autofocus: autofocus,
            ),
          ),
        ],
      ),
    );
  }
}
