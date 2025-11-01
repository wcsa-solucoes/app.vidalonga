import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
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

class PartnersByBranchView extends StatefulWidget {
  const PartnersByBranchView({super.key});

  @override
  State<PartnersByBranchView> createState() => _PartnersByBranchViewState();
}

class _PartnersByBranchViewState extends State<PartnersByBranchView> {
  final PartnersByBranchBloc _partnersByBranchBloc = PartnersByBranchBloc();
  final PartnersBloc _partnersBloc = PartnersBloc();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    final text = _searchController.text;
    if (text != "") {
      _partnersByBranchBloc.add(PartnersByBranchSearchEvent(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(
          title: "Parceiros por Categoria", isWithBackButton: true),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: BlocBuilder<PartnersByBranchBloc, PartnersByBranchState>(
            bloc: _partnersByBranchBloc,
            builder: (context, state) {
              return Builder(builder: (context) {
                if (state is PartnersByBranchLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is PartnersByBranchEmptyState) {
                  return const Center(
                    child:
                        DefaultText("Essa categoria ainda não tem parceiros!"),
                  );
                }

                if (state is PartnersByBranchLoadedState) {
                  return _loadedState(state);
                }

                if (state is PartnersByBranchSearchedState) {
                  return _searchedState(state);
                }

                if (state is PartnersByBranchErrorState) {
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

  Widget _loadedState(PartnersByBranchLoadedState state) {
    return Column(
      children: [
        _handleSearchWidget(),
        _handleHighlightedPartners(state.partners
            .where((element) => element.isHighlighted == true)
            .toList()),
        _handlePartners(state.partners
            .where((element) => element.isHighlighted == false)
            .toList()),
      ],
    );
  }

  Widget _searchedState(PartnersByBranchSearchedState state) {
    return Column(
      children: [
        _handleSearchWidget(),
        _handlePartners(state.partners),
      ],
    );
  }

  void _onRestart() {
    _searchController.clear();
    _partnersByBranchBloc.add(RestartPartnersByBranchEvent());
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
            _partnersByBranchBloc.add(RestartPartnersByBranchEvent());
          } else {
            _partnersByBranchBloc.add(PartnersByBranchSearchEvent(value));
          }
        },
      ),
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
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "Destaques",
              style: GoogleFonts.getFont(
                'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18,
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

  Widget _handleEmptyPartners() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.8,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
          ],
        ),
      ),
    );
  }

  Widget _handlePartners(List<PartnerCompanyModel> partners) {
    if (partners.isEmpty) {
      return _handleEmptyPartners();
    }

    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
      shrinkWrap: true,
      itemCount: 1,
      padding: const EdgeInsets.only(bottom: 50),

      itemBuilder: (BuildContext context, int categoryIndex) {
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
                  _partnersBloc.getBranchName(partners.first.branchesId.first),
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              _handlePartnerCard(partners),
            ],
          ),
        );
      },
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
              color: Colors.grey.withValues(alpha: 0.9),
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
                      const EdgeInsets.only(top: 7.0, left: 8.0, right: 8.0),
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
                        color: const Color(0xFF3B81DC),
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
