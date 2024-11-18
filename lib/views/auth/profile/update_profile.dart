import 'package:bs_rashhuli/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../helper/helper.dart';
import '../../../constants/constants.dart';
import '../../../cubits/app_cubit/app_cubit.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_states.dart';
import '../../../widgets/custom_set_location_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form.dart';
import '../../../widgets/cutom_material_button.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key, required this.userData});
  final UserModel userData;
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addLocationController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.userData.email;
    nameController.text = widget.userData.name;
    addLocationController.text = widget.userData.location ?? '';
    BlocProvider.of<AppCubit>(context)
        .setAddLocationController(addLocationController);
    // log(widget.userData.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
        leading: leadingIconButton(onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: BlocBuilder<AuthCubit, AuthStates>(
        builder: (context, state) {
          var authCubit = BlocProvider.of<AuthCubit>(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      labelText: "الاسم",
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      hintText: "أدخل اسمك",
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      suffixIcon: const Icon(Icons.person_3_outlined),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذه الخانة مطلوبه";
                        } else if (value.length < 3) {
                          return "يجب أن يتكون هذا الحقل من 3 أحرف على الأقل";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      labelText: "البريد الإلكتروني",
                      labelStyle: const TextStyle(
                        fontSize: 16,
                      ),
                      hintText: "أدخل بريدك الإلكتروني",
                      controller: emailController,
                      suffixIcon: const Icon(Icons.email_outlined),
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "هذه الخانة مطلوبه";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomSetLocationWidget(
                      addLocationController: addLocationController,
                      regions: beniSuefRegions,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: CustomMaterialButton(
                        color: Colors.teal,
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await authCubit.updateUserData(
                              context,
                              uid: widget.userData.id,
                              name: nameController.text,
                              email: emailController.text,
                              location: addLocationController.text,
                            );
                          }
                        },
                        widget:
                            context.watch<AuthCubit>().state is LoadingAuthState
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                                : const CustomText(
                                    text: "حفظ التغييرات",
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
