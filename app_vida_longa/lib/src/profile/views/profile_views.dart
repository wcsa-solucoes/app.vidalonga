import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/button_list.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:app_vida_longa/src/profile/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final AuthBloc _authBloc = AuthBloc();
  late final ProfileBloc _profileBloc;
  final String _userEmail = UserService.instance.user.email;
  final String _userName = UserService.instance.user.name;
  @override
  void initState() {
    _profileBloc = context.read<ProfileBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return CustomAppScaffold(
          appBar: AppBar(title: const Text("Perfil")),
          hasSafeArea: true,
          body: Builder(builder: (context) {
            return _body();
          }),
          bottomNavigationBar: const CustomBottomNavigationBar(),
          hasScrollView: true,
        );
      },
    );
  }

  Widget _body() {
    return Column(
      children: [
        _userInfos(),
        _userCard(UserService.instance.user.subscriptionLevel),
        _userCard(SubscriptionLevelEnum.premium),
        const SizedBox(height: 10,),
        button("Editar perfil"), //
        button("Informações de pagamento"), //
        button("Alterar senha"), //
        button("Meus favoritos"), //
        const SizedBox(height: 10,),
        logout(),
      ],
    );
  }

  Widget logout(){
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
      child: const Text('Sair',  style:  TextStyle(
          fontFamily: 'Lexend Deca',
          color: AppColors.blackCard,
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
        ),),
    );
  }

  Widget _userInfos() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20.0, 15.0, 20.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: const Color(0xBB0F65D8),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(2.0, 2.0, 2.0, 2.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Image.asset(
                  'assets/images/longavida.png',
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.fill,
                ),
              ),
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
                    _userName,
                    style: const TextStyle(
                      fontFamily: 'Lexend Deca',
                      color: AppColors.blackCard,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 4.0, 0.0, 0.0),
                    child: Text(
                      _userEmail,
                      style: const TextStyle(
                        fontFamily: 'Lexend Deca',
                        color: AppColors.blackCard,
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
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

  Widget _userCard(SubscriptionLevelEnum status) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 15.0, 10.0, 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width * 0.9,
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  blurRadius: 6.0,
                  color: Color(0x4B1A1F24),
                  offset: Offset(0.0, 2.0),
                )
              ],
              gradient:  LinearGradient(
                colors: [
                 status == SubscriptionLevelEnum.premium? AppColors.turquoise: AppColors.secondaryBackground,
                  const Color(0xFF438EC2),
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
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 20.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        'assets/images/LOGO_VIDA_HORIZ_white-2048x370.png',
                        width: 146.0,
                        height: 25.0,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 8.0, 20.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 30.0, 0.0, 0.0),
                        child: Text(
                          _userName,
                          style: GoogleFonts.getFont(
                            'Roboto Mono',
                            color: AppColors.blackCard,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20.0, 12.0, 20.0, 16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        status.name,
                        style: GoogleFonts.getFont(
                          'Roboto Mono',
                          color: AppColors.blackCard,//const Color.fromRGBO(87, 99, 108, 1),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '11/24',
                        style: GoogleFonts.getFont(
                          'Roboto Mono',
                          color: AppColors.blackCard,//const Color.fromRGBO(87, 99, 108, 1),
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget button(String text, {Function()? onPressed}) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 1.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: AppColors.secondaryBackground,
          boxShadow: const [
            BoxShadow(
              blurRadius: 0.0,
              color: AppColors.lightGray,
              offset: Offset(0.0, 2.0),
            )
          ],
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(
            color: AppColors.lineGray,
            width: 0.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 4.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: GoogleFonts.getFont(
                  'Urbanist',
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              ButtonList(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                buttonSize: 46.0,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF95A1AC),
                  size: 20.0,
                ),
                onPressed: () {
                  AppHelper.displayAlertInfo("Funcionalidade em breve!");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
