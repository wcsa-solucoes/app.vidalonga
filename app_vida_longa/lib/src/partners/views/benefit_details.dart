import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/benefits_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/social_media_enum.dart';
import 'package:app_vida_longa/domain/models/benefit_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
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
      appBar: const DefaultAppBar(title: "Benefícios", isWithBackButton: true),
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
                Row(
                  children: [
                    _partnerService.selectedPartner.urlLogo != null
                        ? Container(
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                color: AppColors.white,
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        _partnerService
                                            .selectedPartner.urlLogo!),
                                    fit: BoxFit.fill)),
                            width: MediaQuery.of(context).size.width / 3.5,
                          )
                        : Container(),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        _partnerService.selectedPartner.name,
                        maxLines: 5,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                          color: AppColors.backgroundDark,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
                _partnerService.selectedPartner.presentationText != ""
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _partnerService
                                    .selectedPartner.presentationText,
                                maxLines: 20,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: AppColors.backgroundDark,
                                ),
                                textAlign: TextAlign.justify,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 20,
                      ),
                _partnerService
                            .selectedPartner.presentationImagesUrl?.isEmpty ??
                        false
                    ? const SizedBox.shrink()
                    : Column(
                        children: [
                          Text(
                            "Fotos",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 19,
                              color: AppColors.backgroundDark,
                            ),
                          ),
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
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Endereço: ${_partnerService.selectedPartner.fullAddress}",
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: AppColors.backgroundDark,
                  ),
                  textAlign: TextAlign.justify,
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

                    return _handleBenefitsWidget(snapshot.data!);
                  },
                ),
                //social medias links
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Redes Sociais",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 19,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _partnerService.selectedPartner.socialMedias.isEmpty
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _partnerService.selectedPartner.socialMedias
                            .map((e) {
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
                const SizedBox(height: 180),
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Benefícios",
              style: GoogleFonts.getFont(
                'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 19,
                color: AppColors.backgroundDark,
              ),
            ),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: benefitsHighlighted.isEmpty
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Text(
                      "Em destaque:",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  )),
        benefitsHighlighted.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: ListBenefitsWidget(
                  scrollController: _scrollController,
                  benefitsFromSelectedPartner: benefitsHighlighted,
                ),
              ),
        Align(
          alignment: Alignment.centerLeft,
          child: benefitsNotHighlighted.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Text(
                    "Outros benefícios:",
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: AppColors.backgroundDark,
                    ),
                  ),
                ),
        ),
        benefitsNotHighlighted.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 15, top: 10),
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
        return Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            "${benefit.name};",
            style: GoogleFonts.getFont(
              'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: AppColors.backgroundDark,
            ),
          ),
        );
      },
    );
  }
}
