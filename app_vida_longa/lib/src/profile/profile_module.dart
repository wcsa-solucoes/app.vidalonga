import 'package:app_vida_longa/src/profile/profile_page.dart';
import 'package:app_vida_longa/src/profile/views/my_profile_view.dart';
import 'package:app_vida_longa/src/profile/views/subscriptions/bloc/subscriptions_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child("/", child: (context) => const ProfilePage());
    r.child("/edit", child: (context) => const MyProfileView());
    r.child("/subscriptions", child: (context) => const SubscriptionsView());
  }
}
