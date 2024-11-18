import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.textColor = Colors.black54,
    this.fontSize = 17,
    this.fontWeight = FontWeight.normal,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.customStyle,
    this.decoration = TextDecoration.none,
    this.height,
  });
  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final TextStyle? customStyle;
  final TextDecoration? decoration;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: customStyle ??
          TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: fontWeight,
            decoration: decoration,
            decorationColor: Colors.grey.shade600,
            height: height,
          ),
    );
  }
}
