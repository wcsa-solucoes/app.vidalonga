import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isWithBackButton;
  final PreferredSizeWidget? bottom;
  const DefaultAppBar({
    super.key,
    required this.title,
    this.isWithBackButton = false,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      bottom: bottom,
      leading: isWithBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          : null,
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isWithBackButton
                  ? const SizedBox(
                      width: 60,
                    )
                  : Image.asset(
                      "assets/images/AVATAR_(1).png",
                      width: 60,
                    ),
              DefaultText(
                title,
                color: AppColors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
