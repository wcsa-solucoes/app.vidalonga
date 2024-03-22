import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/benefits_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/social_media_enum.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BenefitsDetailsView extends StatefulWidget {
  const BenefitsDetailsView({super.key});

  @override
  State<BenefitsDetailsView> createState() => _BenefitsDetailsViewState();
}

class _BenefitsDetailsViewState extends State<BenefitsDetailsView> {
  final IPartnerService _partnerService = PartnerServiceImpl.instance;
  final IBenefitsService _benefitsService = BenefitisServiceImpl.instance;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _photosScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _benefitsService.getAllBenefitsByPartner(
          _partnerService.selectedPartner.id,
          _partnerService.selectedPartner.benefitsId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: DefaultText(
          _partnerService.selectedPartner.name,
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
      // hasScrollView: true,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DefaultText(
                  _partnerService.selectedPartner.presentationText,
                  maxLines: 20,
                  fontSize: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: DefaultText(
                    "Endereço: ${_partnerService.selectedPartner.fullAddress}",
                    fontSize: 20,
                    maxLines: 4,
                  ),
                ),
                _partnerService
                            .selectedPartner.presentationImagesUrl?.isEmpty ??
                        false
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          const DefaultText("Fotos", fontSize: 20),
                          SizedBox(
                            height: 200,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: _photosScrollController,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: _photosScrollController,
                                itemCount: _partnerService.selectedPartner
                                    .presentationImagesUrl!.length,
                                itemBuilder: (context, index) {
                                  final image = _partnerService.selectedPartner
                                      .presentationImagesUrl![index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      image,
                                      width: 180,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const SizedBox(
                                          width: 80,
                                          child: Center(
                                            child: DefaultText(
                                              "Erro ao carregar imagem",
                                              fontSize: 18,
                                              maxLines: 4,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                StreamBuilder<List<BenefitModel>>(
                  initialData: const [],
                  stream: _benefitsService.benefitsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (snapshot.data!.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: DefaultText(
                            "Nenhum benefício encontrado.",
                            fontSize: 20,
                          ),
                        ),
                      );
                    }
                    return _handleBenefitsWidget(snapshot.data!);
                  },
                ),
                //social medias links
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: DefaultText(
                      "Redes sociais",
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _partnerService.selectedPartner.socialMedias.isEmpty
                    ? const DefaultText(
                        "Nenhum link encontrado.",
                        fontSize: 20,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _partnerService.selectedPartner.socialMedias
                            .map((e) {
                          //                final Uri url =
                          //     Uri.parse('https://www.instagram.com/vidalongaapp/');
                          // _launchUrl(url);

                          switch (e.type) {
                            case SocialMediaEnum.facebook:
                              return IconButton(
                                icon: const FaIcon(FontAwesomeIcons.facebook),
                                onPressed: () {
                                  var url = Uri.parse(e.url);
                                  _launchUrl(url);
                                },
                              );
                            case SocialMediaEnum.instagram:
                              return IconButton(
                                icon: const FaIcon(FontAwesomeIcons.instagram),
                                onPressed: () {
                                  var url = Uri.parse(e.url);
                                  _launchUrl(url);
                                },
                              );
                            case SocialMediaEnum.whatsapp:
                              return IconButton(
                                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                onPressed: () {
                                  var url = Uri.parse(e.url);
                                  _launchUrl(url);
                                },
                              );
                            default:
                              //others
                              return Tooltip(
                                message: e.url,
                                child: IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.link),
                                  onPressed: () {
                                    var url = Uri.parse(e.url);
                                    _launchUrl(url);
                                  },
                                ),
                              );
                          }
                        }).toList(),
                      ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      AppHelper.displayAlertError("Erro ao abrir link");
    }
    return;
  }

  Widget _handleBenefitsWidget(List<BenefitModel> benefitsFromSelectedPartner) {
    final List<BenefitModel> benefitsHighlighted = benefitsFromSelectedPartner
        .where((element) => element.isHighlighted)
        .toList();

    final List<BenefitModel> benefitsNotHighlighted =
        benefitsFromSelectedPartner
            .where((element) => !element.isHighlighted)
            .toList();
    return Column(
      children: [
        const SizedBox(height: 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: DefaultText("Benefícios", fontSize: 22),
          ),
        ),
        const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 20, left: 10),
              child: DefaultText("Em destaques:", fontSize: 20),
            )),
        benefitsHighlighted.isEmpty
            ? const DefaultText(
                "Nenhum benefício em destaque.",
                fontSize: 20,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: ListBenefitsWidget(
                  scrollController: _scrollController,
                  benefitsFromSelectedPartner: benefitsHighlighted,
                ),
              ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 10),
            child: DefaultText(
              "Outros benefícios",
              fontSize: 22,
            ),
          ),
        ),
        benefitsNotHighlighted.isEmpty
            ? const DefaultText(
                "Nenhum outro benefício.",
                fontSize: 20,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: ListBenefitsWidget(
                  scrollController: _scrollController,
                  benefitsFromSelectedPartner: benefitsNotHighlighted,
                ),
              ),
      ],
    );
  }
}

class ListBenefitsWidget extends StatelessWidget {
  final ScrollController _scrollController;
  final List<BenefitModel> _benefitsFromSelectedPartner;

  const ListBenefitsWidget({
    super.key,
    required ScrollController scrollController,
    required List<BenefitModel> benefitsFromSelectedPartner,
  })  : _scrollController = scrollController,
        _benefitsFromSelectedPartner = benefitsFromSelectedPartner;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      itemCount: _benefitsFromSelectedPartner.length,
      itemBuilder: (context, index) {
        final benefit = _benefitsFromSelectedPartner[index];
        return DefaultText(
          benefit.name,
          fontSize: 18,
          maxLines: 2,
        );
      },
    );
  }
}
