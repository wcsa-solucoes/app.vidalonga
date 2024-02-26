part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {
  final List<List<ArticleModel>>? articles;

  HomeInitialEvent({
    this.articles,
  });
}

class HomeLoadingEvent extends HomeEvent {
  HomeLoadingEvent();
}

class HomeSearchEvent extends HomeEvent {
  final String searchTerm;

  HomeSearchEvent({
    required this.searchTerm,
  });
}

class RestartHomeEvent extends HomeEvent {
  RestartHomeEvent();
}

class HomeLoadedEvent extends HomeEvent {
  final List<List<ArticleModel>>? articles;
  final List<ChipCategorie>? chipsCategorie;

  HomeLoadedEvent({
    this.articles,
    this.chipsCategorie,
  });
}

class HomeCategoriesSelectedEvent extends HomeEvent {
  final List<List<ArticleModel>>? articles;
  final List<ChipCategorie>? chipsCategorie;

  HomeCategoriesSelectedEvent({this.articles, this.chipsCategorie});
}
