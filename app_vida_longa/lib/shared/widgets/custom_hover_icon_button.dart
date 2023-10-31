import "package:app_vida_longa/core/helpers/icon_helper.dart";
import "package:flutter/material.dart";

class CustomHoverIconButton extends StatefulWidget {
  final String image;
  final Function? onTap;
  final String? imageHover;
  final double imageSize;
  final double forceSize;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry iconPadding;
  final Color? iconColor;
  final Color backgroundColor;
  final double borderRadius;

  const CustomHoverIconButton({
    required this.image,
    required this.onTap,
    super.key,
    this.imageHover,
    this.imageSize = IconHelper.x64,
    this.forceSize = 20,
    this.padding = EdgeInsets.zero,
    this.iconPadding = EdgeInsets.zero,
    this.iconColor,
    this.backgroundColor = Colors.transparent,
    this.borderRadius = 4,
  });

  @override
  State<CustomHoverIconButton> createState() => _CustomHoverIconButtonState();
}

class _CustomHoverIconButtonState extends State<CustomHoverIconButton> {
  late bool onHover = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: widget.padding,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.backgroundColor,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            onTap: widget.onTap != null
                ? () {
                    widget.onTap!.call();
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                : null,
            hoverColor: Colors.white.withOpacity(0.1),
            onHover: (value) {
              setState(() {
                onHover = value;
              });
            },
            child: Padding(
              padding: widget.iconPadding,
              child: IconHelper.build(
                color: widget.iconColor,
                iconName: onHover
                    ? (widget.imageHover ?? widget.image)
                    : widget.image,
                size: widget.imageSize,
                forceSize: widget.forceSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
