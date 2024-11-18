import 'package:flutter/material.dart';
import 'custom_text.dart';

class CustomMaterialButton extends StatelessWidget {
  const CustomMaterialButton({
    super.key,
    this.isLastPage = false,
    required this.onPressed,
    this.text,
    required this.color,
    this.textColor,
    this.textSized,
    this.fontWeight,
    this.widget,
    this.minWidth,
    this.height,
  });

  final bool isLastPage;
  final String? text;
  final void Function()? onPressed;
  final Color color;
  final Color? textColor;
  final double? textSized;
  final FontWeight? fontWeight;
  final Widget? widget;
  final double? minWidth;
  final double? height;
  @override
  Widget build(BuildContext context) {
    final defaultwidth = MediaQuery.of(context).size.width * 0.9;
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      minWidth: minWidth ?? defaultwidth,
      height: height ?? 58,
      color: color,
      // textColor: Colors.white,
      child: widget ??
          CustomText(
            text: text ?? '',
            textColor: textColor,
            fontSize: text != null ? textSized : 15,
            fontWeight: fontWeight,
          ),
    );
  }
}
