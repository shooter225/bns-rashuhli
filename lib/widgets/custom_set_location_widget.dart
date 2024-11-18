import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import 'custom_bottom_sheet.dart';
import 'custom_text_form.dart';

class CustomSetLocationWidget extends StatelessWidget {
  const CustomSetLocationWidget({
    super.key,
    required TextEditingController addLocationController,
    required this.regions,
  }) : _addLocationController = addLocationController;

  final TextEditingController _addLocationController;
  final List<dynamic> regions;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      customBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      controller: _addLocationController,
      onTap: () {
        customShowBottomSheet(context, regions: regions);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "هذه الخانة مطلوبه";
        }
        return null;
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(100),
      ],
      suffixIcon: const Icon(
        Icons.place,
        color: Colors.grey,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kMainColor.withOpacity(0.5)),
      ),
      minLines: 1,
      maxLines: 3,
      hintText: "ادخل الموقع (يفضل وضع موقع دقيق للمكان).",
      customHintStyle: const TextStyle(
        fontSize: 15,
        color: Colors.grey,
      ),
    );
  }
}
