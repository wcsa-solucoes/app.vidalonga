import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
import 'package:app_vida_longa/domain/models/partner_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_chip.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:app_vida_longa/src/partners/bloc/partners_bloc.dart';
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
  @override
  void initState() {
    _partnersBloc = PartnersBloc();
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
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
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

              if (state is BranchsSelectedLoadedState) {
                return _branchsSelectedState(state);
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
    );
  }

  Widget _handleEmptyPartners() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _handleSearchWidget(),
          SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _handleChips(state.branchsChip, state.partners)),
          _handleHighlightedPartners(state.highlightedPartners),
          _handlePartnersWidget(state.partners),
        ],
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
              // partnersCompany.first.categoryTitle.toUpperCase(),
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

  Widget _branchsSelectedState(BranchsSelectedLoadedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: _handleChips(
              state.branchsChip,
              state.parntersByBranch,
            ),
          ),
          _handlePartnersWidget(state.partnersByBranchSelected),
        ],
      ),
    );
  }

  Widget _handleChips(List<ChipCategorieModel> chipsCategorie,
      List<List<PartnerCompanyModel>> partnersByBranchSelectedAll) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      scrollDirection: Axis.horizontal,
      itemCount: chipsCategorie.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? const EdgeInsets.only(left: 0)
              : const EdgeInsets.only(left: 5),
          child: IconChoiceChip(
            isSelected: chipsCategorie[index].selected,
            label: chipsCategorie[index].label,
            onSelected: (bool selected) {
              chipsCategorie[index] =
                  chipsCategorie[index].copyWith(selected: selected);

              var selectedChips =
                  chipsCategorie.where((chip) => chip.selected).toList();

              if (selectedChips.isEmpty) {
                _partnersBloc.add(RestartPartnersEvent());
              } else {
                var selectedPartners = partnersByBranchSelectedAll
                    .where((partners) => selectedChips.any((chip) =>
                        partners.first.branchesId.contains(chip.uuid)))
                    .toList();

                _partnersBloc.add(
                  PartnerBranchSelectedEvent(
                    partners: selectedPartners,
                    branchsChip: chipsCategorie,
                    highlightedPartners: const [],
                  ),
                );
              }
            },
          ),
        );
      },
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
            if (_searchController.text.isNotEmpty) {
              _onRestart();
              return;
            }
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
      padding: const EdgeInsets.only(bottom: 200),

      itemBuilder: (BuildContext context, int categoryIndex) {
        final partnersCompany = partners[categoryIndex];

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

  Widget _handlePartnerCard(List<PartnerCompanyModel> partnersCompany) {
    return Container(
      color: Colors.transparent,
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: partnersCompany.length,
        padding: const EdgeInsets.only(right: 20),
        itemBuilder: (BuildContext context, int articleIndex) {
          final partner = partnersCompany[articleIndex];
          return Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 4, bottom: 0, right: 15),
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
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(2.0, 3.0),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Tooltip(
                    message: partner.name,
                    preferBelow: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 5, bottom: 5, right: 5),
                        child: Text(
                          partner.name,
                          maxLines: 1,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 19,
                            color: AppColors.titleColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                StreamBuilder<UserModel>(
                    initialData: UserService.instance.user,
                    stream: UserService.instance.userStream,
                    builder: (context, AsyncSnapshot<UserModel> snapshot) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 15),
                          height: 80,
                          width: 100,
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
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Telefone: ${partner.phoneNumber ?? "Sem telefone"}",
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.backgroundDark,
                        ),
                      ),
                      Text(
                        partner.fullAddress ?? "Sem endereço",
                        style: GoogleFonts.getFont(
                          'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.backgroundDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //text button to see all benefits
                TextButton(
                  onPressed: () => onPressed.call(),
                  child: Text(
                    "Ver benefícios",
                    style: GoogleFonts.getFont(
                      'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: AppColors.selectedColor,
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
