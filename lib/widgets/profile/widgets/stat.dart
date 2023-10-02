import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usersms/utils/colors.dart';

class Stat extends StatelessWidget {
  const Stat({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(color: LightColor.subTitleTextColor),
        ),
        Text(
          NumberFormat.decimalPattern().format(value),
          style: const TextStyle(
            color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }
}
