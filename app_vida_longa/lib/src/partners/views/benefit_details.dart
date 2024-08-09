import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/benefits_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/branchs_service.dart';
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
  final IBranchsService _branchsService = BranchsServiceImpl.instance;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _socialMediaScrollController = ScrollController();

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
    Size size = MediaQuery.of(context).size;

    return CustomAppScaffold(
      appBar: const DefaultAppBar(
          title: "Detalhes do Benefício", isWithBackButton: true),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SingleChildScrollView(
                  child: Container(
                    height: size.height * 1.5,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                          _partnerService
                                              .selectedPartner.urlLogo!),
                                      fit: BoxFit.fill),
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.grey.withOpacity(0.9),
                                      offset: const Offset(2.0, 3.0),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 14,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: size.width * 0.6,
                                      child: RichText(
                                        overflow: TextOverflow.visible,
                                        softWrap: true,
                                        text: TextSpan(
                                          text: _partnerService
                                              .selectedPartner.name,
                                          style: GoogleFonts.getFont(
                                            'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            color: AppColors.backgroundDark,
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text:
                                                  " - ${_branchsService.branchs.firstWhere((element) => element.id == _partnerService.selectedPartner.branchesId[0]).name}",
                                              style: GoogleFonts.getFont(
                                                'Poppins',
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 40,
                                        width: 40,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          color: AppColors.selectedColor
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            color: AppColors.selectedColor,
                                            icon: const FaIcon(
                                                FontAwesomeIcons.phone),
                                            onPressed: () {
                                              _launchCaller(_partnerService
                                                  .selectedPartner
                                                  .phoneNumber!);
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 45,
                                        width: 180,
                                        child: Scrollbar(
                                          thumbVisibility: false,
                                          controller:
                                              _socialMediaScrollController,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            controller:
                                                _socialMediaScrollController,
                                            itemCount: _partnerService
                                                .selectedPartner
                                                .socialMedias
                                                .length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: 40,
                                                width: 40,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                decoration: BoxDecoration(
                                                  color: AppColors.selectedColor
                                                      .withOpacity(0.1),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: SocialMediaIconWidget(
                                                    type: _partnerService
                                                        .selectedPartner
                                                        .socialMedias[index]
                                                        .type,
                                                    url: _partnerService
                                                        .selectedPartner
                                                        .socialMedias[index]
                                                        .url,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                            left: 15,
                            bottom: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.selectedColor,
                                size: 25,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              SizedBox(
                                width: size.width * 0.7,
                                child: Text(
                                  "Endereço: ${_partnerService.selectedPartner.fullAddress}",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.justify,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _partnerService.selectedPartner.presentationText != ""
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  right: 24,
                                  left: 15,
                                  bottom: 5,
                                ),
                                child: Text(
                                  "Descrição",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: AppColors.backgroundDark,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                        _partnerService.selectedPartner.presentationText != ""
                            ? Padding(
                                padding: const EdgeInsets.only(
                                  right: 20,
                                  left: 25,
                                  bottom: 20,
                                ),
                                child: Text(
                                  _partnerService
                                      .selectedPartner.presentationText,
                                  style: GoogleFonts.getFont('Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: Colors.grey[600]),
                                  textAlign: TextAlign.justify,
                                ),
                              )
                            : const SizedBox.shrink(),
                        _partnerService.selectedPartner.presentationImagesUrl
                                    ?.isEmpty ??
                                false
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.only(
                                  right: 24,
                                  left: 15,
                                  bottom: 16,
                                ),
                                child: Text(
                                  "Fotos",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: AppColors.backgroundDark,
                                  ),
                                ),
                              ),
                        _partnerService.selectedPartner.presentationImagesUrl
                                    ?.isEmpty ??
                                false
                            ? const SizedBox.shrink()
                            : Flexible(
                                child: SizedBox(
                                  height: 130,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: ListView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      children: buildPhotos(
                                          context,
                                          _partnerService.selectedPartner
                                              .presentationImagesUrl!
                                              .toList()),
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 24,
                            left: 15,
                          ),
                          child: StreamBuilder<List<BenefitModel>>(
                            initialData: const [],
                            stream: _benefitsService.benefitsStream,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              return _handleBenefitsWidget(snapshot.data!);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPhotos(BuildContext context, List<String> images) {
    List<Widget> list = [];
    list.add(const SizedBox(
      width: 10,
    ));
    for (var i = 0; i < images.length; i++) {
      list.add(buildPhoto(context, images[i]));
    }
    return list;
  }

  Widget buildPhoto(BuildContext context, String url) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withOpacity(0.9),
              offset: const Offset(2.0, 3.0),
            )
          ],
        ),
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageZoomScreen(
                    imagePath: url,
                  ),
                ),
              );
            },
            child: Image.network(
              url,
              width: 180,
              errorBuilder: (context, error, stackTrace) {
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
          ),
        ));
  }

  Future<void> _launchCaller(String phoneNumber) async {
    var url = "tel:$phoneNumber";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
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
        const SizedBox(height: 5),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Benefícios",
              style: GoogleFonts.getFont(
                'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18,
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
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      "Em destaque:",
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  )),
        benefitsHighlighted.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 10, left: 10),
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
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
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

class SocialMediaIconWidget extends StatelessWidget {
  final SocialMediaEnum _type;
  final String _url;

  const SocialMediaIconWidget({super.key, required type, required url})
      : _type = type,
        _url = url;

  Widget _buildChild() {
    switch (_type) {
      case SocialMediaEnum.facebook:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.facebook),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      case SocialMediaEnum.instagram:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.instagram),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      case SocialMediaEnum.twitter:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.twitter),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      case SocialMediaEnum.linkedin:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.linkedin),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      case SocialMediaEnum.tiktok:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.tiktok),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      case SocialMediaEnum.whatsapp:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.whatsapp),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
      default:
        return IconButton(
          color: AppColors.selectedColor,
          icon: const FaIcon(FontAwesomeIcons.globe),
          onPressed: () {
            var url = Uri.parse(_url);
            _launchUrl(url);
          },
        );
    }
  }

  Future<void> _launchUrl(Uri uri) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      AppHelper.displayAlertError("Erro ao abrir link");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _buildChild(),
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
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}

class ImageZoomScreen extends StatelessWidget {
  final String imagePath;

  const ImageZoomScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(
          title: "Zoom na Imagem", isWithBackButton: true),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imagePath,
            errorBuilder: (context, error, stackTrace) {
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
        ),
      ),
    );
  }
}
