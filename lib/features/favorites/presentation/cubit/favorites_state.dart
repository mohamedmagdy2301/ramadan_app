import 'package:equatable/equatable.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteItem> favorites;
  final FavoriteType? filterType;

  const FavoritesLoaded({
    required this.favorites,
    this.filterType,
  });

  List<FavoriteItem> get filteredFavorites {
    if (filterType == null) return favorites;
    return favorites.where((item) => item.type == filterType).toList();
  }

  @override
  List<Object?> get props => [favorites, filterType];

  FavoritesLoaded copyWith({
    List<FavoriteItem>? favorites,
    FavoriteType? filterType,
    bool clearFilter = false,
  }) {
    return FavoritesLoaded(
      favorites: favorites ?? this.favorites,
      filterType: clearFilter ? null : (filterType ?? this.filterType),
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
