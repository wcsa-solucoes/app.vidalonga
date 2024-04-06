import 'dart:io';

import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/launch_util.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:app_vida_longa/shared/widgets/policy_widget.dart';
import 'package:app_vida_longa/shared/widgets/terms_widget.dart';
import 'package:app_vida_longa/src/profile/views/subscriptions/bloc/subscriptions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  final SubscriptionsBloc _subscriptionsBloc = SubscriptionsBloc();
  final TextEditingController _couponTxtEdtCtrl = TextEditingController();

  final IPlansService _plansService = PlansServiceImpl.instance;

  @override
  void initState() {
    // _couponTxtEdtCtrl.text = 'CUPOM1';
    super.initState();
  }

  @override
  void dispose() {
    _subscriptionsBloc.handleDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          'Assinatura',
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
      body: body(),
    );
  }

  Widget body() {
    return StreamBuilder<UserModel>(
        initialData: UserService.instance.user,
        stream: UserService.instance.userStream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (Platform.isIOS) {
            PrintColoredHelper.printWhite(
                "snapshot.data!.subscriptionLevel: ${snapshot.data!.subscriptionLevel}");
          } else if (Platform.isAndroid) {
            PrintColoredHelper.printWhite(
                "snapshot.data!.subscriptionLevel: ${snapshot.data!.subscriptionLevel}");
          }

          if (snapshot.data!.subscriptionLevel == SubscriptionEnum.paying) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: DefaultText(
                        'Parábens, você é um assinante!',
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FlatButton(
                      textLabel: "Mais informações",
                      onPressed: () {
                        if (Platform.isAndroid) {
                          LaunchUtil.call(
                              "https://play.google.com/store/account/subscriptions");
                        } else if (Platform.isIOS) {
                          LaunchUtil.call(
                              "https://apps.apple.com/account/subscriptions");
                        }
                      },
                    ),
                  ],
                ));
          }

          return BlocConsumer<SubscriptionsBloc, SubscriptionsState>(
            bloc: _subscriptionsBloc,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SubscriptionsLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state is SubscriptionPurchased &&
                  snapshot.data!.subscriptionLevel == SubscriptionEnum.paying) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: const Center(
                    child: DefaultText(
                      'Assinatura adquirida!',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                );
              }
              if (state is ProductSelectedState) {
                return const Column(
                  children: [
                    DefaultText(
                      'Plano  selecionado',
                      fontSize: 20,
                    ),
                    DefaultText(
                      'Aguarde o processo de compra!',
                      fontSize: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(),
                  ],
                );
              }

              if (state is CouponAddedState) {
                return _couponPresentation(state.productDetails, state.coupon);
              }

              if (state is ProductsLoadedState) {
                return Column(
                  children: [
                    productPresentation(
                        state.defaultProductDetails, _plansService.defaultPlan),
                  ],
                );
              }

              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const DefaultText(
                      'Para saber mais sobre assinaturas acesse o nosso site',
                      fontSize: 20,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                    ),
                    FlatButton(
                      textLabel: "Saiba mais",
                      isWithContrastColor: true,
                      onPressed: () =>
                          LaunchUtil.call('https://vidalongaapp.com/'),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  Widget productPresentation(ProductDetails productDetails, PlanModel plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const DefaultText(
                      "Torne-se um membro",
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: AppColors.secondary,
                    ),
                    const DefaultText(
                      'Para acessar todo o nosso conteúdo ilimitado, assine agora.',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    DefaultText(
                      'R\$ ${productDetails.rawPrice}/mês',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: FlatButton(
                        isWithContrastColor: true,
                        onPressed: () {
                          _subscriptionsBloc
                              .add(SelectedProductEvent(productDetails));
                        },
                        textLabel: 'Assinar',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //restore purchases
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: FlatButton(
                      isWithContrastColor: true,
                      onPressed: () {
                        _subscriptionsBloc.add(RestorePurchasesEvent());
                      },
                      textLabel: 'Restaurar compras',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const DefaultText(
                      'Possui cupom para plano com desconto?',
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DecoratedTextFieldWidget(
                      controller: _couponTxtEdtCtrl,
                      labelText: 'Cupom',
                      hintText: 'Digite o cupom',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: FlatButton(
                        isWithContrastColor: true,
                        onPressed: () {
                          _subscriptionsBloc
                              .add(AddedCouponEvent(_couponTxtEdtCtrl.text));
                        },
                        textLabel: 'Buscar plano!',
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const PolicyWidget());
                    },
                    child: const Text("Política de Privacidade"),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const TermsWiget());
                    },
                    child: const Text("Termos e condições"),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _couponPresentation(
      ProductDetails productDetails, CouponModel coupon) {
    final int discountAdded = (100 -
            (productDetails.rawPrice / _plansService.defaultPlan.price) * 100)
        .truncate();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        // color: AppColors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DefaultText(
                    '${coupon.name} adicionado!',
                    color: AppColors.secondary,
                    fontSize: 20,
                  ),
                  DefaultText(
                    'Desconto de ${(discountAdded)}%',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                  DefaultText(
                    'R\$ ${productDetails.rawPrice}/mês',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  FlatButton(
                    isWithContrastColor: true,
                    onPressed: () {
                      _subscriptionsBloc.add(
                        SelectedProductEvent(
                          productDetails,
                          couponAdded: coupon,
                        ),
                      );
                    },
                    textLabel: 'Assinar',
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: Material(
                      child: InkWell(
                        splashColor: AppColors.secondary.withOpacity(0.2),
                        // hoverColor: AppColors.secondary.withOpacity(0.2),
                        overlayColor: MaterialStateProperty.all(
                          AppColors.secondary.withOpacity(0.2),
                        ),
                        // focusColor: Colors.blue,
                        // highlightColor: AppColors.secondary.withOpacity(0.2),
                        onTap: () {
                          _subscriptionsBloc.add(RestartEvent());
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.gray600.withOpacity(0.8),
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: DefaultText(
                              'Voltar',
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
