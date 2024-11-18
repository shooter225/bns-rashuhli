import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bs_rashhuli/constants/colors.dart';
import '../../cubits/image_cubit/image_cubit.dart';
import '../../cubits/image_cubit/image_states.dart';
import '../../helper/helper.dart';
import 'custom_text.dart';

class ImageBuilderView extends StatefulWidget {
  const ImageBuilderView({super.key});

  @override
  _ImageBuilderViewState createState() => _ImageBuilderViewState();
}

class _ImageBuilderViewState extends State<ImageBuilderView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageCubit, ImageStates>(builder: (context, state) {
      final imageCubit = context.read<ImageCubit>();

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            onPressed: () {
              customShowDialog(
                context,
                title: "اضف صورة للمكان من",
                widgets: [
                  ListTile(
                    onTap: () {
                      imageCubit.uploadImage(context, source: ImageSource.camera);
                      Navigator.pop(context);
                    },
                    title: const CustomText(
                      text: " الكاميرا",
                      textColor: Colors.teal,
                      fontSize: 14,
                    ),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.teal,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      imageCubit.uploadImage(context, source: ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    title: const CustomText(
                      text: " المعرض",
                      textColor: Colors.teal,
                      fontSize: 14,
                    ),
                    leading: const Icon(
                      Icons.image,
                      color: Colors.teal,
                    ),
                  ),
                ],
              );
            },
            child: state is LoadingImageState
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(
                      color: kMainColor,
                    ),
                  )
                : Column(children: [
                    const Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                      text: imageCubit.images.isNotEmpty ? "اضف صورة اخري" : "اضف صورة",
                      textColor: Colors.teal,
                      fontSize: 15,
                    ),
                  ]),
          ),
        ],
      );
    });
  }
}
