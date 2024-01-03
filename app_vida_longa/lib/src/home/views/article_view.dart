import 'dart:async';

import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class ArticleView extends StatefulWidget {
  final ArticleModel article;
  const ArticleView({super.key, required this.article});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  double fontSize = 16.0;
  List<Widget> widgets = [];

  final StreamController<double> _streamControllerFontSize =
      StreamController.broadcast();

  @override
  void dispose() {
    _streamControllerFontSize.close();
    super.dispose();
  }

  @override
  void initState() {
    for (var item in widget.article.contents) {
      if (item.type == "text") {
        widgets.add(
          StreamBuilder<double>(
            initialData: fontSize,
            stream: _streamControllerFontSize.stream,
            builder: ((context, snapshot) {
              return Html(
                  style: {"body": Style(fontSize: FontSize(snapshot.data!))},
                  data: item.content);
            }),
          ),
        );
      } else {
        widgets.add(
          Html(extensions: const [
            IframeHtmlExtension(),
          ], data: item.content),
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          "Artigo",
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      hasScrollView: true,
      body: Column(
        children: widgets,
      ),
      bottomNavigationBar: optionsBottomBar(),
    );
  }

  Widget optionsBottomBar() {
    return BottomAppBar(
      clipBehavior: Clip.antiAlias,
      height: 60,
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconButton(
              onPressed: () {
                NavigationController.push("/app/home/comments");
              },
              icon: const Icon(
                Icons.comment_rounded,
                size: 30,
              )),
          IconButton(
            icon: const Icon(
              Icons.zoom_out,
              size: 30,
            ),
            onPressed: () => _handleFontSize(-2),
          ),
          IconButton(
            icon: const Icon(
              Icons.zoom_in,
              size: 30,
            ),
            onPressed: () => _handleFontSize(2),
          ),
        ],
      ),
    );
  }

  void _handleFontSize(double size) {
    fontSize = fontSize + size;
    _streamControllerFontSize.add(fontSize);
  }
}
