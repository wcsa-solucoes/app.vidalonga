import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/branch_model.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:app_vida_longa/src/partners/bloc/partners_bloc.dart';
import 'package:app_vida_longa/src/partners/partnersByBranch/bloc/partners_by_branch_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class PartnersView extends StatefulWidget {
  const PartnersView({super.key});

  @override
  State<PartnersView> createState() => _PartnersViewState();
}

class _PartnersViewState extends State<PartnersView> {
  late final PartnersBloc _partnersBloc;
  late final PartnersByBranchBloc _partnersByBranchBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _partnersBloc = PartnersBloc();
    _partnersByBranchBloc = PartnersByBranchBloc();
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _partnersBloc.close();
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    _partnersBloc.add(PartnersSearchEvent(text));
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(title: "Parceiros"),
      bottomNavigationBar: const CustomBottomNavigationBar(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: BlocBuilder<PartnersBloc, PartnersState>(
            bloc: _partnersBloc,
            builder: (context, state) {
              return Builder(builder: (context) {
                if (state is PartnersLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PartnersLoadedState) {
                  return _loadedState(state);
                }

                if (state is PartnersSearchedState) {
                  return _searchedState(state);
                }

                if (state is PartnersErrorState) {
                  return Center(
                    child: DefaultText(state.message),
                  );
                }

                return Container();
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _handleEmptyPartners() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DefaultText("Nenhum benefício encontrado :("),
            _handleReload(),
          ],
        ),
      ),
    );
  }

  Widget _handleReload() {
    return TextButton(
      onPressed: _onRestart,
      child: const Text(
        "Recarregar",
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  void _onRestart() {
    _searchController.clear();
    _partnersBloc.add(RestartPartnersEvent());
  }

  Widget _loadedState(PartnersLoadedState state) {
    return Column(
      children: [
        _handleSearchWidget(),
        _handleHighlightedPartners(state.highlightedPartners),
        _branchesTitle(),
        _buildBranches(state.branchs, state.partners),
      ],
    );
  }

  Widget _searchedState(PartnersSearchedState state) {
    return Column(
      children: [_handleSearchWidget(), _handlePartnersWidget(state.partners)],
    );
  }

  Widget _handleSearchWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DecoratedTextFieldWidget(
        controller: _searchController,
        hintText: "Buscar por ramo, endereço, cidade, estado...",
        labelText: "Buscar por ramo, endereço, cidade, estado...",
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: AppColors.dimGray),
          onPressed: () {
            _onRestart();
            return;
          },
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.isEmpty) {
            _partnersBloc.add(RestartPartnersEvent());
          } else {
            _partnersBloc.add(PartnersSearchEvent(value));
          }
        },
      ),
    );
  }

  Widget _handlePartnersWidget(List<List<PartnerCompanyModel>> partners) {
    if (partners.isEmpty) {
      return _handleEmptyPartners();
    }

    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
      shrinkWrap: true,
      itemCount: partners.length,
      padding: const EdgeInsets.only(bottom: 50),

      itemBuilder: (BuildContext context, int categoryIndex) {
        final partnersCompany = partners[categoryIndex];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.transparent,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  // partnersCompany.first.categoryTitle.toUpperCase(),
                  _partnersBloc
                      .getBranchName(partnersCompany.first.branchesId.first),
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              _handlePartnerCard(partnersCompany),
            ],
          ),
        );
      },
    );
  }

  Widget _handleHighlightedPartners(
      List<PartnerCompanyModel> partnersHighlighted) {
    if (partnersHighlighted.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 10, bottom: 2),
            child: Text(
              textAlign: TextAlign.left,
              "Parceiros em destaque",
              style: GoogleFonts.getFont(
                'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 17,
                color: AppColors.secondaryText,
              ),
            ),
          ),
          _handlePartnerCard(partnersHighlighted),
        ],
      ),
    );
  }

  Widget _handlePartnerCard(List<PartnerCompanyModel> partnersCompany) {
    return Container(
      color: Colors.transparent,
      height: 175,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: partnersCompany.length,
        padding: const EdgeInsets.only(right: 10),
        itemBuilder: (BuildContext context, int articleIndex) {
          final partner = partnersCompany[articleIndex];
          return Padding(
            padding:
                const EdgeInsets.only(left: 4, top: 4, bottom: 0, right: 15),
            child: StreamBuilder<UserModel>(
                initialData: UserService.instance.user,
                stream: UserService.instance.userStream,
                builder: (context, snapshot) {
                  return _PartnerCardWidget(
                      partner: partner,
                      onPressed: () {
                        var user = AuthService.instance.getCurrentUser;

                        if (user == null) {
                          NavigationController.to(routes.app.auth.login.path);
                          return;
                        }

                        if (UserService.instance.user.subscriptionLevel !=
                            SubscriptionEnum.paying) {
                          NavigationController.push(
                              routes.app.profile.subscriptions.path);
                          return;
                        }

                        _partnersBloc.add(SelectPartnerEvent(partner));
                        NavigationController.push(
                            routes.app.partners.benefitDetails.path,
                            arguments: partner);
                      });
                }),
          );
        },
      ),
    );
  }

  Widget _branchesTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 15, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Navegar por todas as categorias",
                textAlign: TextAlign.left,
                style: GoogleFonts.getFont(
                  'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: AppColors.secondaryText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBranches(List<BranchModel> branches,
      List<List<PartnerCompanyModel>> partnersByBranchSelectedAll) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Wrap(
        spacing: 10,
        runSpacing: 4,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        direction: Axis.horizontal,
        runAlignment: WrapAlignment.start,
        verticalDirection: VerticalDirection.down,
        clipBehavior: Clip.none,
        children: branches
            .map(
              (branch) => _BranchCard(
                branch: branch,
                onPressed: () {
                  var user = AuthService.instance.getCurrentUser;

                  if (user == null) {
                    NavigationController.to(routes.app.auth.login.path);
                    return;
                  }

                  _partnersByBranchBloc.add(
                    PartnersByBranchLoadingEvent(branch.id),
                  );
                  NavigationController.push(
                    routes.app.partners.partnersByBranch.path,
                  );
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _PartnerCardWidget extends StatelessWidget {
  final PartnerCompanyModel partner;
  final Function onPressed;

  const _PartnerCardWidget({
    required this.onPressed,
    required this.partner,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.84,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
                  child: SizedBox(
                    width: 290,
                    child: Center(
                      child: Text(
                        partner.name,
                        maxLines: 1,
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                          color: AppColors.titleColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  StreamBuilder<UserModel>(
                      initialData: UserService.instance.user,
                      stream: UserService.instance.userStream,
                      builder: (context, AsyncSnapshot<UserModel> snapshot) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(left: 8, top: 10),
                            height: 75,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(
                                color: AppColors.borderColor,
                              ),
                              color: AppColors.white,
                              image: partner.urlLogo != null
                                  ? DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        //any image from web
                                        partner.urlLogo!,
                                      ),
                                      fit: BoxFit.fill)
                                  : null,
                            ),
                          ),
                        );
                      }),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Telefone: ${partner.phoneNumber ?? "Sem telefone"}",
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: AppColors.backgroundDark,
                          ),
                        ),
                        Text(
                          partner.fullAddress != null
                              ? "Endereço: ${partner.fullAddress}"
                              : "Sem endereço",
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: AppColors.backgroundDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: TextButton(
                    onPressed: () => onPressed.call(),
                    child: Text(
                      "VER BENEFÍCIOS",
                      style: GoogleFonts.getFont(
                        'Urbanist',
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.blueHighlightedText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchModel branch;
  final Function onPressed;

  const _BranchCard({required this.onPressed, required this.branch});

  @override
  Widget build(BuildContext context) {
    Color color = _convertHexToColor(branch.titleColor);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
      child: GestureDetector(
        onTap: () => onPressed.call(),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.285,
          height: 127,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            image: branch.imageUrl != ""
                ? DecorationImage(
                    image: NetworkImage(branch.imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.23,
                          child: Text(
                            branch.name,
                            style: GoogleFonts.getFont(
                              'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: branch.titleSize ?? 15,
                              color: color,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.visible,
                            maxLines: null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                branch.haveLogo
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: branch.logoSize == "small"
                                ? const EdgeInsets.only(left: 75)
                                : const EdgeInsets.only(left: 60),
                            child: Center(
                              child: Transform.rotate(
                                angle: -0.6,
                                child: SizedBox(
                                  width: branch.logoSizeWidht,
                                  height: branch.logoSizeHeight,
                                  child: FittedBox(
                                    child: Image.asset(
                                        'assets/images/AVATAR_(1).png'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _convertHexToColor(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor"; // Opacidade total
    }

    return Color(int.parse(hexColor, radix: 16));
  }
}
