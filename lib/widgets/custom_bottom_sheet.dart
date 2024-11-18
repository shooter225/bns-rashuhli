import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/colors.dart';
import '../cubits/app_cubit/app_cubit.dart';
import 'custom_text.dart';

Future customShowBottomSheet(context, {required List regions}) =>
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button and title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: kMainColor,
                    ),
                  ),
                  const Center(
                    child: CustomText(
                      text: "اختر المكان القريب منك",
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                      width: 40), // To balance the close button space
                ],
              ),
              const SizedBox(height: 10),

              // Display list of regions
              Expanded(
                child: ListView.builder(
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    final region = regions[index];
                    return ListTile(
                      title: Text(
                        region,
                        style: const TextStyle(
                            color: Colors.black87, fontSize: 16),
                      ),
                      onTap: () {
                        BlocProvider.of<AppCubit>(context)
                            .setPlaceLocation(region);
                        Navigator.pop(context);
                        // showSnakBar(context, message: "تم اختيار $region");
                      },
                      leading: const Icon(Icons.place, color: kMainColor),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: kMainColor),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
