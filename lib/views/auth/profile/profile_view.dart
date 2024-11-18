import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/cubits/auth_cubit/auth_states.dart';
import 'package:bs_rashhuli/services/app_services.dart';
import 'package:bs_rashhuli/views/auth/login_view.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../helper/helper.dart';
import '../../../widgets/custom_loading_widget.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/cutom_material_button.dart';
import 'update_profile.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthCubit>(context).getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        var userData = BlocProvider.of<AuthCubit>(context).userModel;

        return Scaffold(
            appBar:
                AppBar(title: const CustomText(text: "ملفك الشخصي"), actions: [
              if (state is SuccessfulGetUserDataState)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    naviPush(context,
                        widgetName: UpdateProfile(userData: userData!));
                  },
                )
            ]),
            body: Stack(
              children: [
                if (state is SuccessfulGetUserDataState)
                  Column(children: [
                    CustomProfileItem(
                      userData: userData!.name,
                      title: "اسمك",
                      icon: Icons.person_3_outlined,
                    ),
                    CustomProfileItem(
                      userData: userData.email,
                      title: "ايميلك",
                      icon: Icons.email_outlined,
                    ),
                    CustomProfileItem(
                      userData: userData.userRole,
                      title: "مستخدم ك",
                      icon: Icons.admin_panel_settings_outlined,
                    ),
                    CustomProfileItem(
                      userData: userData.location,
                      title: "موقعك",
                      icon: Icons.place_outlined,
                    ),
                    CustomProfileItem(
                      userData: AppServices().formatDateTime(userData.createdAt,
                          formatStyle: "d/M/y  hh:mm:s a"),
                      title: "تاريخ الانشاء",
                      icon: Icons.date_range,
                    ),
                    const Spacer(),
                    Center(
                      child: CustomMaterialButton(
                        color: Colors.red,
                        widget: const CustomText(
                          text: "حذف الحساب",
                          fontSize: 14,
                          textColor: Colors.white,
                        ),
                        onPressed: () {
                          customShowDialog(context,
                              title: "تحذير \n سوف تقوم بحذف حسابك نهائيا",
                              titleColor: Colors.amber,
                              widgets: [
                                const CustomText(
                                  text:
                                      "إذا قمت بتحديد حذف، فسوف نحذف حسابك على خادمنا.\nكما سيتم حذف بيانات التطبيق ولن تتمكن من استردادها.\nونظرًا لأن هذه عملية حساسة أمنيًا، فسوف يُطلب منك في النهاية تسجيل الدخول قبل حذف حسابك.",
                                  textColor: Colors.black,
                                  fontSize: 12,
                                ),
                              ],
                              actionsAlignment: MainAxisAlignment.spaceAround,
                              actionsPadding: const EdgeInsets.all(0),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const CustomText(
                                      text: "الغاء",
                                      textColor: Colors.blue,
                                      fontSize: 12,
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      await BlocProvider.of<AuthCubit>(context)
                                          .deleteUserAccount(context);
                                      Navigator.pop(context);
                                      showSnakBar(context,
                                          message:
                                              "You need to log in again to perform this action.");
                                      naviPushAndRemoveUntil(context,
                                          widgetName: const LoginView());
                                    },
                                    child: const CustomText(
                                      text: "حذف",
                                      textColor: Colors.red,
                                      fontSize: 12,
                                    ))
                              ]);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    )
                  ]),
                if (state is LoadingAuthState)
                  Container(
                      color: Colors.white, child: const CustomLoadingWidget())
              ],
            ));
      },
    );
  }
}

class CustomProfileItem extends StatelessWidget {
  const CustomProfileItem(
      {super.key,
      required this.userData,
      required this.title,
      required this.icon,
      this.trailing});
  final userData;
  final String title;
  final IconData icon;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: ListTile(
          leading: Icon(icon),
          trailing: trailing,
          title: CustomText(
            text: title,
            textColor: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          subtitle: CustomText(
            text: userData ?? '',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
