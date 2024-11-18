import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailingWidget,
    this.subtitle,
    this.textColor,
    this.iconColor,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final void Function()? onTap;
  final Widget? trailingWidget;
  final Color? textColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      color: Colors.grey[100],
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? Colors.black54,
          size: 30,
        ),
        title: CustomText(
          text: title,
          fontSize: 15,
          textColor: textColor ?? Colors.black,
          fontWeight: FontWeight.w500,
        ),
        subtitle: subtitle != null
            ? CustomText(
                text: subtitle!,
                fontSize: 12,
                textColor: Colors.grey,
                fontWeight: FontWeight.w500,
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        trailing: trailingWidget ??
            const Icon(
              Icons.arrow_forward_ios,
            ),
      ),
    );
  }
}
