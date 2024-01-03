import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class DecoratedTextFieldWidget extends StatefulWidget {
  const DecoratedTextFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.textInputAction = TextInputAction.next,
    // this.inputFormatter,
    this.keyboardType,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputAction textInputAction;
  final bool isPassword;
  final TextInputType? keyboardType;

  @override
  State<DecoratedTextFieldWidget> createState() =>
      _DecoratedTextFieldWidgetState();
}

class _DecoratedTextFieldWidgetState extends State<DecoratedTextFieldWidget> {
  late bool isPasswordInvisible = widget.isPassword;
  Widget? obscureWidget;
  @override
  initState() {
    super.initState();
    obscureWidget = widget.isPassword
        ? const Icon(
            Icons.visibility_off,
            color: AppColors.dimGray,
          )
        : const Icon(
            Icons.visibility,
            color: AppColors.dimGray,
          );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: isPasswordInvisible,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.keyboardType != null
          ? [FilteringTextInputFormatter.digitsOnly]
          : null,
      textInputAction: widget.textInputAction,
      decoration: InputDecoration(
        suffixIcon: _handleSuffixIcon(),
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: GoogleFonts.getFont(
          'Urbanist',
          color: AppColors.dimGray,
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        hintStyle: GoogleFonts.getFont(
          'Urbanist',
          color: AppColors.dimGray,
          fontWeight: FontWeight.w500,
          fontSize: 14.0,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: AppColors.borderColor,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            color: AppColors.selectedColor,
          ),
        ),
      ),
    );
  }

  Widget? _handleSuffixIcon() {
    if (widget.isPassword) {
      return _handleWidgetPassword();
    } else {
      return null;
    }
  }

  Widget? _handleWidgetPassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          // widget.isPassword = !widget.isPassword;
          isPasswordInvisible = !isPasswordInvisible;
          obscureWidget = isPasswordInvisible
              ? const Icon(
                  Icons.visibility_off,
                  color: AppColors.dimGray,
                )
              : const Icon(
                  Icons.visibility,
                  color: AppColors.dimGray,
                );
        });
      },
      icon: obscureWidget!,
    );
  }
}
