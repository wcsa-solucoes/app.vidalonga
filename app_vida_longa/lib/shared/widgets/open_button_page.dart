import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenPageButtonWiget extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const OpenPageButtonWiget(this.text, {super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.0,
              color: AppColors.lightGray,
              offset: Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(
            color: AppColors.lineGray,
            width: 0.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 4.0, 0.0),
          child: InkWell(
            onTap: onPressed,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: GoogleFonts.getFont(
                      'Urbanist',
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.unselectedTextStyleColor,
                  size: 30.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
