import "package:app_vida_longa/domain/contants/app_colors.dart";
import "package:flutter/cupertino.dart";
import "package:google_fonts/google_fonts.dart";

class DefaultText extends StatelessWidget {
  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;

  const DefaultText(
    this.text, {
    this.fontWeight = FontWeight.w400,
    this.fontSize,
    this.textAlign,
    this.color,
    super.key,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines ?? 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: GoogleFonts.getFont(
        'Urbanist',
        color: AppColors.dimGray,
        fontWeight: FontWeight.w500,
        fontSize: 14.0,
      ).copyWith(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: color ?? AppColors.blackCard,
        overflow: TextOverflow.ellipsis,
      ),
      // AppTextStyles.white14w400.copyWith(
      //   fontWeight: fontWeight,
      //   fontSize: fontSize,
      //   color: color ?? AppColors.blackCard,
      //   overflow: TextOverflow.ellipsis,
      // ),
    );
  }
}
