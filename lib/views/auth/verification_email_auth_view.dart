import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_states.dart';
import '../../../helper/helper.dart';
import '../../../cubits/timer_cubit/timer_cubit.dart';
import '../../../cubits/timer_cubit/timer_states.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/cutom_material_button.dart';

class VerficationEmailAuthView extends StatefulWidget {
  const VerficationEmailAuthView({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<VerficationEmailAuthView> createState() =>
      _VerficationEmailAuthViewState();
}

class _VerficationEmailAuthViewState extends State<VerficationEmailAuthView> {
  late TimerCubit
      _timerCubit; // Declare a variable to hold the TimerCubit reference

  @override
  void initState() {
    super.initState();
    const timeout = 120;
    _timerCubit =
        context.read<TimerCubit>(); // Get the TimerCubit reference in initState
    _timerCubit.resetTimer(timeout);
  }

  @override
  void dispose() {
    // Safely cancel the timer but don't close the cubit manually
    _timerCubit.cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: leadingIconButton(
              onPressed: () {
                _timerCubit.cancelTimer();
                Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white60,
                      child: Icon(
                        Icons.mark_email_unread_outlined,
                        size: 100,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: RichText(
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            const TextSpan(
                                text:
                                    "لقد أرسلنا لك رابطًا للتحقق من بريدك الإلكتروني.\n إلى ",
                                style: TextStyle(
                                  color: Colors.black54,
                                )),
                            TextSpan(
                                text: ' ${widget.email}',
                                style: const TextStyle(
                                    color: Colors.blue, height: 1.7)),
                          ])),
                    ),
                    CustomMaterialButton(
                        color: kMainColor,
                        onPressed: () async {
                          BlocProvider.of<AuthCubit>(context)
                              .afterVerifySuccessful(context);
                          // if (BlocProvider.of<AuthCubit>(context)
                          //     .firebaseAuth
                          //     .currentUser!
                          //     .emailVerified) {
                          //   naviPushAndRemoveUntil(context,
                          //       widgetName: MainHomeView());
                          //   _timerCubit
                          //       .cancelTimer(); // Use the stored reference
                          // }
                        },
                        minWidth: MediaQuery.of(context).size.width,
                        widget: BlocProvider.of<AuthCubit>(context)
                                .firebaseAuth
                                .currentUser!
                                .emailVerified
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : const CustomText(
                                textColor: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w300,
                                text: "متابعة",
                              )),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        BlocBuilder<TimerCubit, TimerStates>(
                          builder: (context, state) {
                            if (state is TimerTickingState) {
                              return RichText(
                                maxLines: 3,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: "إعادة إرسال التحقق في ",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          ' ${_timerCubit.start}', // Use the stored reference
                                      style: const TextStyle(
                                        color: Colors.black,
                                        height: 1.7,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " ثواني",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (state is TimerFinishedState) {
                              return TextButton(
                                onPressed: () {
                                  BlocProvider.of<AuthCubit>(context)
                                      .sendVerification(context);
                                  const timeout = 120;
                                  _timerCubit.resetTimer(
                                      timeout); // Use the stored reference
                                },
                                child: const Text(
                                  "إرسال التحقق مرة أخرى؟",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff002DE3),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
