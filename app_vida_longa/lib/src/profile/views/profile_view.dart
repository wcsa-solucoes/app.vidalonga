import 'dart:io';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/open_button_page.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:app_vida_longa/src/profile/views/contacts_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthBloc _authBloc = AuthBloc();

  final UserService _userService = UserService.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(title: "Perfil"),
      hasSafeArea: true,
      body: Builder(builder: (context) {
        return _body();
      }),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      hasScrollView: true,
    );
  }

  Widget _body() {
    return Column(
      children: [
        _userCard(),
        const SizedBox(
          height: 10,
        ),

        OpenPageButtonWiget(
          "Meu perfil",
          onPressed: () =>
              NavigationController.push(routes.app.profile.edit.path),
        ), //
        OpenPageButtonWiget(
          "Assinaturas",
          onPressed: () {
            NavigationController.push(routes.app.profile.subscriptions.path);
          },
        ),
        OpenPageButtonWiget("Meus favoritos", onPressed: () {
          NavigationController.push(routes.app.profile.favorites.path);
        }),
        OpenPageButtonWiget("Contatos", onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ContactsView(),
            ),
          );
        }),
        StreamBuilder<UserModel>(
          initialData: _userService.user,
          stream: _userService.userStream,
          builder: (context, snapshot) {
            return OpenPageButtonWiget(
              "Abrir QRCode",
              onPressed: () {
                if (snapshot.data!.subscriptionLevel ==
                    SubscriptionEnum.paying) {
                  NavigationController.push(routes.app.profile.qrcode.path);
                } else {
                  AppHelper.displayAlertInfo(
                    "Para acessar o QRCode é necessário ter uma assinatura ativa.",
                  );
                }
              },
            );
          },
        ),

        OpenPageButtonWiget(
          "Dúvidas e sugestões",
          onPressed: () {
            final Uri url = Uri.parse(
                'mailto:contato@vidalongaapp.com?subject=Dúvidas e Sugestões');
            _launchUrl(url);
          },
        ),

        OpenPageButtonWiget(
          "Contate o suporte",
          onPressed: () {
            final Uri url = Uri.parse(
                'mailto:contato@vidalongaapp.com?subject=Support Vida Longa&body=Preencha abaixo os detalhes da sua solicitação:%0D%0A%0D%0A');
            _launchUrl(url);
          },
        ),
        OpenPageButtonWiget("Recomendar o app", onPressed: () {
          if (Platform.isAndroid) {
            SharePlus.instance.share(
              ShareParams(
                text:
                    'https://play.google.com/store/apps/details?id=com.vidalongaapp.app&pcampaignid=web_share',
              ),
            );
          } else {
            SharePlus.instance.share(
              ShareParams(
                text: 'https://apps.apple.com/br/app/vida-longa/id6446136437?l',
              ),
            );
          }
        }),
        const SizedBox(
          height: 10,
        ),
        logout(),
        const SizedBox(
          height: 50,
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

  Widget logout() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
      onPressed: () {
        _authBloc.add(AuthSignOutEvent());
      },
      child: Text(
        'Sair',
        style: GoogleFonts.getFont(
          'Roboto Mono',
          color: AppColors.blackCard,
          fontSize: 15.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _userInfos(String name, String email) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            // color: const Color(0xBB0F65D8),
            color: Colors.transparent,
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(60.0),
                  child: UserService.instance.user.photoUrl.isEmpty
                      ? Image.asset(
                          'assets/images/longavida.png',
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          UserService.instance.user.photoUrl,
                          width: 70.0,
                          height: 70.0,
                          fit: BoxFit.cover,
                        )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8.0, 0.0, 0.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.getFont(
                      'Roboto Mono',
                      color: AppColors.blackCard,
                      fontSize: 19.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      email,
                      style: GoogleFonts.getFont(
                        'Roboto Mono',
                        color: AppColors.blackCard,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _userCard() {
    return StreamBuilder<UserModel>(
        initialData: UserService.instance.user,
        stream: UserService.instance.userStream,
        builder: (context, snapshot) {
          return Column(
            children: [
              _userInfos(snapshot.data?.name ?? "Nome",
                  snapshot.data?.email ?? "email"),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Exibe o hint apenas fora do modo tela cheia
                    Text(
                      "Clique no cartão para ver em tela cheia!",
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        // show the card in full screen
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            insetPadding: EdgeInsets.zero,
                            backgroundColor: Colors.transparent,
                            child: Center(
                              child: RotatedBox(
                                quarterTurns: 1,
                                child: _buildCard(context,
                                    snapshot: snapshot, isFullScreen: true),
                              ),
                            ),
                          ),
                        );
                      },
                      child: _buildCard(context,
                          snapshot: snapshot, isFullScreen: false),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget _buildCard(BuildContext context,
      {required snapshot, required bool isFullScreen}) {
    final cardWidth = isFullScreen
        ? MediaQuery.sizeOf(context).height
        : MediaQuery.sizeOf(context).width * 0.88;
    final cardHeight = isFullScreen ? MediaQuery.sizeOf(context).width : null;
    final double leftPadding = isFullScreen ? 20 : 2;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 6.0,
            color: Color(0x4B1A1F24),
            offset: Offset(0.0, 2.0),
          )
        ],
        gradient: LinearGradient(
          colors: [
            Colors.white,
            snapshot.data!.subscriptionLevel == SubscriptionEnum.paying
                ? const Color(0xBB0F65D8)
                : Colors.orange,
          ],
          stops: const [0.0, 1.0],
          begin: const AlignmentDirectional(0.94, -1.0),
          end: const AlignmentDirectional(-0.94, 1.0),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Image.asset(
                  'assets/images/thumbnail_vidalonga4.png',
                  width: isFullScreen ? 288.4 : 206.0,
                  height: isFullScreen ? 123.0 : 80.0,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20.0, 0, 20.0, 0.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                  child: SizedBox(
                    width: isFullScreen
                        ? MediaQuery.sizeOf(context).width * 1.7
                        : MediaQuery.sizeOf(context).width * 0.76,
                    child: Text(
                      snapshot.data?.name ?? "Vida Longa",
                      style: GoogleFonts.getFont(
                        'Roboto Mono',
                        color: AppColors.blackCard,
                        fontSize: isFullScreen ? 30.8 : 22.0,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: isFullScreen
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsetsDirectional.fromSTEB(20.0, 12.0, 20.0, 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  snapshot.data!.subscriptionLevel.value,
                  style: GoogleFonts.getFont(
                    'Roboto Mono',
                    color: snapshot.data!.subscriptionLevel ==
                            SubscriptionEnum.paying
                        ? AppColors.blackCard
                        : Colors.red,
                    fontSize: isFullScreen ? 19.6 : 14.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
