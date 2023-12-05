import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  double fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(title: const Text("Article")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Html(
              style: {"body": Style(fontSize: FontSize(fontSize))},
              data: "<h1>Meu Artigo</h1><p>Introdução do artigo...</p>",
            ),
            Html(
              extensions: const [
                IframeHtmlExtension(),
              ],
              data:
                  '<iframe width="560" height="315" src="https://www.youtube.com/embed/tgbNymZ7vqY" frameborder="0" allowfullscreen></iframe>',
            ),
            Html(
              style: {"body": Style(fontSize: FontSize(fontSize))},
              data:
                  "<p>Mais conteúdo interessante sobre o tópico do artigo.</p>",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  NavigationController.push("/app/home/comments");
                },
                icon: const Icon(Icons.comment_rounded)),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () => setState(() {
                fontSize = fontSize > 10 ? fontSize - 2 : 10;
              }),
            ),
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () => setState(() {
                fontSize += 2;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
