import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
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
  // PaymentServiceTest paymentService = PaymentServiceTest.instance;
  // PaymentService paymentService = PaymentService.instance;

  final SubscriptionsBloc _subscriptionsBloc = SubscriptionsBloc();
  final TextEditingController _couponTxtEdtCtrl = TextEditingController();

  final IPlansService _plansService = PlansServiceImpl.instance;

  @override
  void initState() {
    _couponTxtEdtCtrl.text = 'CUPOM1';
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
      hasScrollView: true,
      body: body(),
    );
  }

  Widget body() {
    return StreamBuilder<UserModel>(
        initialData: UserService.instance.user,
        stream: UserService.instance.userStream,
        builder: (context, snapshot) {
          PrintColoredHelper.printGreen(
              UserService.instance.user.subscriptionLevel.toString());
          if (snapshot.data == null) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data!.subscriptionLevel == SubscriptionEnum.paying) {
            return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.7,
                child: const Center(
                  child: DefaultText(
                    'Parábens, você é um assinante!',
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                  ),
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
                return Column(
                  children: [
                    DefaultText(
                      '${state.productDetails.title} selecionado',
                      fontSize: 20,
                    ),
                    const DefaultText(
                      'Aguarde a confirmação da compra',
                      fontSize: 20,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                  ],
                );
              }

              if (state is CouponAddedState) {
                return _couponPresentation(state.productDetails, state.coupon);
              }

              if (state is ProductsLoadedState) {
                return Column(
                  children: [
                    //
                    productPresentation(
                        state.defaultProductDetails, _plansService.defaultPlan),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemCount: state.products.length,
                    //   itemBuilder: (context, index) {
                    //     final ProductDetails prod = state.products[index];
                    //     return ListTile(
                    //       title: Text(prod.title),
                    //       trailing: Text(prod.price.toString()),
                    //       onTap: () async {
                    //         _subscriptionsBloc.add(SelectedProductEvent(prod));
                    //         // paymentService.purchase(prod);
                    //       },
                    //     );
                    //   },
                    // ),
                  ],
                );
              }
              return const Center(
                  child: DefaultText('Erro ao carregar os produtos'));
            },
          );
        });
  }

  Widget productPresentation(ProductDetails productDetails, PlanModel plan) {
    return Container(
      // color: AppColors.redError,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          FlatButton(
            onPressed: () {
              _subscriptionsBloc.add(SelectedProductEvent(productDetails));
            },
            textLabel: 'Assinar',
          ),
          const SizedBox(
            height: 80,
          ),
          const DefaultText(
            'Possui cupom para plano com desconto?',
            fontSize: 16,
            fontWeight: FontWeight.w300,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
          DecoratedTextFieldWidget(
            controller: _couponTxtEdtCtrl,
            labelText: 'Cupom',
            hintText: 'Digite o cupom',
          ),
          TextButton(
            onPressed: () {
              _subscriptionsBloc.add(AddedCouponEvent(_couponTxtEdtCtrl.text));
            },
            child: FlatButton(
              onPressed: () {
                _subscriptionsBloc
                    .add(AddedCouponEvent(_couponTxtEdtCtrl.text));
              },
              textLabel: 'Buscar plano!',
            ),
          ),
        ],
      ),
    );
  }

  Widget _couponPresentation(
      ProductDetails productDetails, CouponModel coupon) {
    final int discountAdded = (100 -
            (productDetails.rawPrice / _plansService.defaultPlan.price) * 100)
        .truncate();
    return Container(
      // color: AppColors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
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
              onPressed: () {
                _subscriptionsBloc.add(SelectedProductEvent(productDetails));
              },
              textLabel: 'Assinar',
            ),
          ],
        ),
      ),
    );
  }
}
