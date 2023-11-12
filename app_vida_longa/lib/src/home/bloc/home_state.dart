part of 'home_bloc.dart';

class ChipCategorie {
  late String label;
  late bool selected;
  ChipCategorie({
    this.label = "",
    this.selected = false,
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
}

final class HomeInitial extends HomeState {
  HomeInitial({
    super.articlesByCategory,
    super.isLoading,
  });
}

final class HomeLoaded extends HomeState {
  HomeLoaded({
    super.articlesByCategory,
    super.isLoading,
    super.chipsCategorie,
  });
}

class HomeLoading extends HomeState {
  HomeLoading();
}

class HomeError extends HomeState {
  final String? message;
  HomeError({
    this.message,
    super.articlesByCategory,
    super.isLoading,
  });
}

class HomeCategoriesSelected extends HomeState {
  final List<List<ArticleModel>>? articlesByCategorySelected;
  HomeCategoriesSelected({
    required this.articlesByCategorySelected,
    super.isLoading,
    super.chipsCategorie,
    super.articlesByCategory,
  });
}
