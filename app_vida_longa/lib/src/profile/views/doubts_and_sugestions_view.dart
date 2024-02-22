import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoubtsAndSugestions extends StatefulWidget {
  const DoubtsAndSugestions({super.key});

  @override
  State<DoubtsAndSugestions> createState() => _DoubtsAndSugestionsState();
}

class _DoubtsAndSugestionsState extends State<DoubtsAndSugestions> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: const DefaultText(
            "Dúvidas e Sugestões",
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          //back button syle
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: _body());
  }

  Widget _body() {
    return Column(
      children: [
        const DefaultText(
          "Envie um e-mail para",
        ),
        FlatButton(
          textLabel: "Enviar",
          onPressed: () {
            final Uri url = Uri.parse(
                'mailto:contato@vidalongaapp.com?subject=Dúvidas e Sugestões');
            _launchUrl(url);
          },
        ),
      ],
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    return;
  }
}
