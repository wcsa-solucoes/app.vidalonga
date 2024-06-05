import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:flutter/material.dart';

class WrapperDialog extends StatelessWidget {
  final Widget child;
  const WrapperDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateLocal) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        contentPadding: const EdgeInsets.all(2),
        insetPadding: const EdgeInsets.all(2),
        content: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.all(5),
          height: 800,
          width: double.maxFinite,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    height: double.maxFinite,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
