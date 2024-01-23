part of 'home_bloc.dart';

class ChipCategorie {
  late String label;
  late bool selected;
  late String uuid;
  ChipCategorie({
    this.label = "",
    this.selected = false,
    this.uuid = "",
  });
}

class HomeState {
  final List<List<ArticleModel>>? articlesByCategory;
  final List<ChipCategorie>? chipsCategorie;
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
  }) {
    return switch (this) {
      HomeLoadingState s => loading?.call(s) ?? initial(),
      HomeLoadedState s => loaded?.call(s) ?? initial(),
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
  final List<List<ArticleModel>>? articlesByCategorySelected;
  HomeCategoriesSelectedState({
    required this.articlesByCategorySelected,
    super.isLoading,
    super.chipsCategorie,
    super.articlesByCategory,
  });
}
