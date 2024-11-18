import 'package:bs_rashhuli/constants/colors.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/app_services.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/cutom_material_button.dart';
import '../main_home_view.dart';

class UserRoleView extends StatefulWidget {
  const UserRoleView({super.key});

  @override
  State<UserRoleView> createState() => _UserRoleViewState();
}

class _UserRoleViewState extends State<UserRoleView> {
  String selectedRole = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomSelectButton(
                          text: "ضيف",
                          isSelected: selectedRole == 'ضيف',
                          onTap: () {
                            setState(() {
                              selectedRole = 'ضيف';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomSelectButton(
                          text: "مالك",
                          isSelected: selectedRole == 'مالك',
                          onTap: () {
                            setState(() {
                              selectedRole = 'مالك';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 29,
            left: 15,
            child: CustomMaterialButton(
              onPressed: () {
                AppServices()
                    .skipAndFinished(context, widgetName: MainHomeView());
              },
              text: "تخطى",
              color: kMainColor,
              textColor: Colors.white,
              minWidth: 96,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom button widget that can toggle between selected and unselected states.
class CustomSelectButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomSelectButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color unSelectedColor = Colors.grey[200]!;
    Color selectedColor = kMainColor;
    return GestureDetector(
      onTap: () {
        onTap();
        if (text == "مالك") {
          BlocProvider.of<AuthCubit>(context)
              .updateUserRole(context, userRole: 'owner');
        } else {
          BlocProvider.of<AuthCubit>(context)
              .updateUserRole(context, userRole: 'guest');
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.25, // Customize button height
        decoration: BoxDecoration(
          color: isSelected
              ? selectedColor
              : unSelectedColor, // Change color based on selection
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? selectedColor
                : Colors.grey, // Border color for visual separation
          ),
        ),
        child: Center(
          child: CustomText(
            text: text,
            customStyle: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.black, // Text color changes
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
