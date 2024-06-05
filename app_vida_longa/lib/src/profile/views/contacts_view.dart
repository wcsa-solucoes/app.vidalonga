import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _DoubtsAndSugestionsState();
}

class _DoubtsAndSugestionsState extends State<ContactsView> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: const DefaultText(
            "Contatos",
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
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: InkWell(
              onTap: () {
                final Uri url = Uri.parse('mailto:contato@vidalongaapp.com');
                _launchUrl(url);
              },
              child: const Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                  ),
                  SizedBox(width: 20),
                  DefaultText(
                    "Email",
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.3,
            child: InkWell(
              onTap: () {
                final Uri url =
                    Uri.parse('https://www.instagram.com/vidalongaapp/');
                _launchUrl(url);
              },
              child: const Row(
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.instagram,
                      ),
                      SizedBox(width: 20),
                      DefaultText(
                        "Instagram",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {
              final Uri url =
                  Uri.parse('https://www.facebook.com/vidalongaapp');
              _launchUrl(url);
            },
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * 0.3,
              child: const Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.facebook,
                  ),
                  SizedBox(width: 20),
                  DefaultText(
                    "Facebook",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
    return;
  }
}
