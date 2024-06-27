import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/benefits_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/branchs_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/social_media_enum.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final IPartnerService _partnerService = PartnerServiceImpl.instance;
  final IBenefitsService _benefitsService = BenefitisServiceImpl.instance;
  final IBranchsService _branchsService = BranchsServiceImpl.instance;

  final ScrollController _scrollController = ScrollController();
  final ScrollController _photosScrollController = ScrollController();
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
        height: MediaQuery.sizeOf(context).height, //se tiver descrição aumenta
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  height: size.height,
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
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/longavida.png'),
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(15),
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
                                                .selectedPartner.phoneNumber!);
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
                                    // Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.selectedColor
                                    //         .withOpacity(0.1),
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: const Center(
                                    //     child: Icon(
                                    //       FontAwesomeIcons.phone,
                                    //       color: AppColors.selectedColor,
                                    //       size: 20,
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    // Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.selectedColor
                                    //         .withOpacity(0.1),
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: const Center(
                                    //     child: Icon(
                                    //       FontAwesomeIcons.facebook,
                                    //       color: AppColors.selectedColor,
                                    //       size: 20,
                                    //     ),
                                    //   ),
                                    // ),
                                    // const SizedBox(
                                    //   width: 15,
                                    // ),
                                    // // Container(
                                    // //   height: 40,
                                    // //   width: 40,
                                    // //   decoration: BoxDecoration(
                                    // //     color: AppColors.selectedColor
                                    // //         .withOpacity(0.1),
                                    // //     shape: BoxShape.circle,
                                    // //   ),
                                    // //   child: const Center(
                                    // //     child: Icon(
                                    // //       FontAwesomeIcons.twitter,
                                    // //       color: AppColors.selectedColor,
                                    // //       size: 20,
                                    // //     ),
                                    // //   ),
                                    // // ),
                                    // // const SizedBox(
                                    // //   width: 15,
                                    // // ),
                                    // Container(
                                    //   height: 40,
                                    //   width: 40,
                                    //   decoration: BoxDecoration(
                                    //     color: AppColors.selectedColor
                                    //         .withOpacity(0.1),
                                    //     shape: BoxShape.circle,
                                    //   ),
                                    //   child: const Center(
                                    //     child: Icon(
                                    //       FontAwesomeIcons.facebook,
                                    //       color: AppColors.selectedColor,
                                    //       size: 20,
                                    //     ),
                                    //   ),
                                    // ),
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
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
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
                          top: 20,
                          right: 24,
                          left: 15,
                          bottom: 5,
                        ),
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
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 20,
                            left: 25,
                            bottom: 20,
                          ),
                          child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     top: 20,
                      //     right: 24,
                      //     left: 15,
                      //     bottom: 5,
                      //   ),
                      //   child: Text(
                      //     "Benefícios",
                      //     style: GoogleFonts.getFont(
                      //       'Poppins',
                      //       fontWeight: FontWeight.w600,
                      //       fontSize: 18,
                      //       color: AppColors.backgroundDark,
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //     right: 20,
                      //     left: 25,
                      //     bottom: 20,
                      //   ),
                      //   child: Text(
                      //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                      //     style: GoogleFonts.getFont(
                      //       'Poppins',
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 14,
                      //       color: Colors.grey[500],
                      //     ),
                      //     textAlign: TextAlign.justify,
                      //   ),
                      // ),
                    ],
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
          icon: const FaIcon(FontAwesomeIcons.whatsapp),
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
