import 'dart:async';
import 'dart:ui' show FlutterView;

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/favorites_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_iframe/flutter_html_iframe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ArticleView extends StatefulWidget {
  final ArticleModel? article;
  const ArticleView({super.key, this.article});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class _ArticleViewState extends State<ArticleView> {
  double fontSize = 16.0;
  List<Widget> widgets = [];
  final IFavoritesService _favoritesService = FavoritesServiceImpl.instance;

  final StreamController<double> _streamControllerFontSize =
      StreamController.broadcast();
  late ArticleModel _currentlyArticle;

  @override
  void dispose() {
    _streamControllerFontSize.close();
    super.dispose();
  }

  String _extractYoutubeId(String html) {
    final patterns = [
      RegExp(r'youtube\.com\/embed\/([a-zA-Z0-9_-]+)'),
      RegExp(r'youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)'),
      RegExp(r'youtu\.be\/([a-zA-Z0-9_-]+)'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(html);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)!;
      }
    }
    return '';
  }

  bool isFavorited = false;

  @override
  void initState() {
    if (widget.article != null) {
      _currentlyArticle = widget.article!;
    } else {
      _currentlyArticle = ArticleService.currentlyArticle;
    }

    isFavorited = _favoritesService.favoritesIds.contains(
      _currentlyArticle.uuid,
    );

    for (var item in _currentlyArticle.contents) {
      if (item.type == "text") {
        widgets.add(
          StreamBuilder<double>(
            initialData: fontSize,
            stream: _streamControllerFontSize.stream,
            builder: ((context, snapshot) {
              return Html(
                style: {"body": Style(fontSize: FontSize(snapshot.data!))},
                data: item.content,
              );
            }),
          ),
        );
      } else if (item.type == "video") {
        final videoId = _extractYoutubeId(item.content);
        if (videoId.isNotEmpty) {
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 200,
                child: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videoId,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                ),
              ),
            ),
          );
        }
      } else {
        widgets.add(
          Html(extensions: const [IframeHtmlExtension()], data: item.content),
        );
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedOut =
        UserService.instance.status == UserServiceStatusEnum.loggedOut;
    final FlutterView view = View.of(context);
    final double devicePixelRatio = view.devicePixelRatio;
    final double bottomInset = view.padding.bottom / devicePixelRatio;

    return Scaffold(
      appBar: const DefaultAppBar(title: "Artigo", isWithBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 8),
            DefaultText(
              _currentlyArticle.title,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              maxLines: 4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ...widgets,
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: AppColors.white,
        padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 20.0),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () =>
                    NavigationController.push("/app/home/comments"),
                icon: const Icon(Icons.comment_rounded, size: 30),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_out, size: 30),
                onPressed: () => _handleFontSize(-2),
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in, size: 30),
                onPressed: () => _handleFontSize(2),
              ),
              isLoggedOut
                  ? IconButton(
                      onPressed: () => AppHelper.displayAlertInfo(
                        "Você precisa estar logado para favoritar um artigo!",
                      ),
                      icon: const FaIcon(FontAwesomeIcons.heartCircleXmark),
                    )
                  : IconButton(
                      icon: isFavorited
                          ? const FaIcon(
                              FontAwesomeIcons.solidHeart,
                              color: AppColors.secondary,
                            )
                          : const FaIcon(FontAwesomeIcons.heart),
                      onPressed: () {
                        if (isFavorited) {
                          _favoritesService.remove(_currentlyArticle.uuid);
                        } else {
                          _favoritesService.add(_currentlyArticle.uuid);
                        }
                        setState(() => isFavorited = !isFavorited);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFontSize(double size) {
    fontSize += size;
    _streamControllerFontSize.add(fontSize);
  }
}
