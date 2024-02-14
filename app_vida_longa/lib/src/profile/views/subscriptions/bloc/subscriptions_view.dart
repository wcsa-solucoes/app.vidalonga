import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
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

  @override
  void initState() {
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
                    'Parábens, você já é assinante',
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
                    DefaultText('${state.productDetails.title} selecionado'),
                    const DefaultText('Aguarde a confirmação da compra'),
                    const CircularProgressIndicator(),
                  ],
                );
              }

              if (state is ProductsLoadedState) {
                return Column(
                  children: [
                    const DefaultText(
                      'Escolha um plano',
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                    ),
                    TextButton(
                      onPressed: () {
                        // paymentService.restorePurchase();
                        _subscriptionsBloc.add(RestorePurchasesEvent());
                      },
                      child: const DefaultText('restorePurchase'),
                    ),
                    TextButton(
                      onPressed: () {
                        // paymentService.getTransactions();
                        _subscriptionsBloc.add(RestoresTransactionsEvent());
                      },
                      child: const DefaultText('getTransactions'),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final ProductDetails prod = state.products[index];
                        return ListTile(
                          title: Text(prod.title),
                          trailing: Text(prod.price.toString()),
                          onTap: () async {
                            _subscriptionsBloc.add(SelectedProductEvent(prod));
                            // paymentService.purchase(prod);
                          },
                        );
                      },
                    ),
                  ],
                );
              }
              return const Center(
                  child: DefaultText('Erro ao carregar os produtos'));
            },
          );
        });
  }
}
