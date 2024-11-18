import 'package:flutter/material.dart';

import '../constants/colors.dart';
import 'custom_app_logo.dart';
import 'custom_text.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: Colors.grey[400]!,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppLogoWithName(),
              SizedBox(
                height: 15,
              ),
              CustomText(
                text: "من فضلك انتظر...",
                textColor: kMainColor,
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(
                color: kMainColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
