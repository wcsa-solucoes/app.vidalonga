import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    super.key,
    required this.article,
  });

  final ArticleModel article;

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
                article.subscriptionType == SubscriptionTypeArticleEnum.paid
                    ? const CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 12,
                        child: Icon(
                          Icons.lock_outlined,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Tooltip(
                    message: article.title,
                    preferBelow: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          article.title,
                          maxLines: 1,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
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
            StreamBuilder<UserModel>(
                initialData: UserService.instance.user,
                stream: UserService.instance.userStream,
                builder: (context, AsyncSnapshot<UserModel> snapshot) {
                  return InkWell(
                    onTap: () {
                      var user = AuthService.instance.getCurrentUser;

                      ArticleService.setCurrentlyArticleId(
                        article.uuid,
                        article,
                      );
                      //verify if the article is paid if not go to the article
                      if (article.subscriptionType ==
                          SubscriptionTypeArticleEnum.free) {
                        var path = routes.app.home.article.path;
                        NavigationController.push(path, arguments: {
                          "articleId": article.uuid,
                          "article": article
                        });
                        return;
                      }

                      if (user == null) {
                        NavigationController.to(routes.app.auth.login.path);
                        return;
                      }
                      if (article.subscriptionType ==
                              SubscriptionTypeArticleEnum.paid &&
                          snapshot.data?.subscriptionLevel !=
                              SubscriptionEnum.paying) {
                        NavigationController.push(
                            routes.app.profile.subscriptions.path);
                        return;
                      }

                      var path = routes.app.home.article.path;
                      NavigationController.push(path, arguments: {
                        "articleId": article.uuid,
                        "article": article
                      });
                    },
                    child: Container(
                      height: 190,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          color: AppColors.white,
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(article.image),
                              fit: BoxFit.fill)),
                      width: MediaQuery.of(context).size.width,
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
