part of 'home_bloc.dart';

class HomeState {
  final List<List<BriefArticleModel>>? articlesByCategory;
  final List<ChipCategorieModel>? chipsCategorie;
  final bool? isLoading;
  HomeState({
    this.articlesByCategory,
    this.isLoading,
    this.chipsCategorie = const [],
  });

  T when<T>({
    required T Function() initial,
    T Function(HomeLoadingState state)? loading,
    T Function(HomeLoadedState state)? loaded,
    T Function(HomeErrorState state)? error,
    T Function(HomeCategoriesSelectedState state)? categoriesSelected,
    T Function(ArticlesSearchedState state)? articlesSearched,
  }) {
    return switch (this) {
      HomeLoadingState s => loading?.call(s) ?? initial(),
      HomeLoadedState s => loaded?.call(s) ?? initial(),
      ArticlesSearchedState s => articlesSearched?.call(s) ?? initial(),
      HomeErrorState s => error?.call(s) ?? initial(),
      HomeCategoriesSelectedState s => categoriesSelected?.call(s) ?? initial(),
      _ => initial(),
    };
  }
}

final class InitialHomeState extends HomeState {
  InitialHomeState({
    super.articlesByCategory,
    super.isLoading,
  });
}

final class HomeLoadedState extends HomeState {
  HomeLoadedState({
    super.articlesByCategory,
    super.isLoading,
    super.chipsCategorie,
  });
}

class HomeLoadingState extends HomeState {
  HomeLoadingState();
}

class HomeErrorState extends HomeState {
  final String? message;
  HomeErrorState({
    this.message,
    super.articlesByCategory,
    super.isLoading,
  });
}

class HomeCategoriesSelectedState extends HomeState {
  final List<List<BriefArticleModel>>? articlesByCategorySelected;
  HomeCategoriesSelectedState({
    required this.articlesByCategorySelected,
    super.isLoading,
    super.chipsCategorie,
    super.articlesByCategory,
  });
}

class ArticlesSearchedState extends HomeState {
  ArticlesSearchedState({
    super.articlesByCategory,
    super.chipsCategorie,
    super.isLoading,
  });
}
