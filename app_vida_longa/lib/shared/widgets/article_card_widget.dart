import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard(
      {super.key, required this.article, required this.containerHeight});

  final BriefArticleModel article;
  final double containerHeight;

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  final ArticleService _articleService = ArticleService.instance;

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
                widget.article.subscriptionType ==
                        SubscriptionTypeArticleEnum.paid
                    ? const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 12,
                          child: Icon(
                            Icons.lock_outlined,
                            color: Colors.white,
                            size: 16.0,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                Expanded(
                  child: Tooltip(
                    message: widget.article.title,
                    preferBelow: false,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 6.0, right: 6.0, top: 6.0, bottom: 6.0),
                        child: Text(
                          widget.article.title,
                          maxLines: 1,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 19.0,
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
                    onTap: () async {
                      var user = AuthService.instance.getCurrentUser;

                      await _articleService
                          .setCurrentlyArticleId(widget.article.uuid);
                      //verify if the article is paid if not go to the article
                      if (widget.article.subscriptionType ==
                          SubscriptionTypeArticleEnum.free) {
                        var path = routes.app.home.article.path;
                        NavigationController.push(path, arguments: {
                          "articleId": widget.article.uuid,
                          "article": widget.article
                        });
                        return;
                      }

                      if (user == null) {
                        NavigationController.to(routes.app.auth.login.path);
                        return;
                      }
                      if (widget.article.subscriptionType ==
                              SubscriptionTypeArticleEnum.paid &&
                          snapshot.data?.subscriptionLevel !=
                              SubscriptionEnum.paying) {
                        NavigationController.push(
                            routes.app.profile.subscriptions.path);
                        return;
                      }

                      var path = routes.app.home.article.path;
                      NavigationController.push(path, arguments: {
                        "articleId": widget.article.uuid,
                        "article": widget.article
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Container(
                        height: widget.containerHeight,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                            color: AppColors.white,
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                    widget.article.image),
                                fit: BoxFit.fill)),
                        width: MediaQuery.of(context).size.width,
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
