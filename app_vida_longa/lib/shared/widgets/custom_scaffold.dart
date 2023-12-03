import "package:app_vida_longa/domain/contants/app_colors.dart";
import "package:flutter/material.dart";

class CustomAppScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final PreferredSizeWidget? appBar;
  final Future<bool> Function()? onBack;
  final Color backgroundColor;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final bool hasScrollView;
  final EdgeInsets contentPadding;
  final bool hasSafeArea;
  final bool defaultBottomBar;

  const CustomAppScaffold({
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.appBar,
    this.onBack,
    this.backgroundColor = AppColors.white,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = false,
    this.hasScrollView = true,
    this.hasSafeArea = true,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
    super.key,
    this.defaultBottomBar = true,
  });

  @override
  State<CustomAppScaffold> createState() => _CustomAppScaffoldState();
}

class _CustomAppScaffoldState extends State<CustomAppScaffold> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SafeArea(
        top: widget.hasSafeArea,
        bottom: widget.hasSafeArea,
        left: widget.hasSafeArea,
        right: widget.hasSafeArea,
        maintainBottomViewPadding: true,
        child: Scaffold(
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          body: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: widget.backgroundColor,
              child: widget.hasScrollView
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: widget.contentPadding,
                        child: widget.body,
                      ),
                    )
                  : Padding(
                      padding: widget.contentPadding,
                      child: widget.body,
                    ),
            ),
          ),
          appBar: widget.appBar,
          // bottomNavigationBar: widget.defaultBottomBar
          //   ? const CustomBottomNavigationBar()
          //   : ColoredBox(
          //       color: widget.backgroundColor,
          //       child: widget.bottomNavigationBar,
          //     ),
          bottomNavigationBar: ColoredBox(
            color: widget.backgroundColor,
            child: widget.bottomNavigationBar,
          ),
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
        ),
      ),
    );
  }
}