import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';

class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.textLabel,
    this.onPressed,
  });
  final String textLabel;
  final void Function()? onPressed;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: AppColors.white,
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        height: 50.0,
        child: Center(
          child: DefaultText(
            widget.textLabel,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
