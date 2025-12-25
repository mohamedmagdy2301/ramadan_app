import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ramadan_app/features/favorites/data/favorites_local_datasource.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';
import 'package:ramadan_app/features/favorites/presentation/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final IFavoritesLocalDatasource _datasource;

  FavoritesCubit({IFavoritesLocalDatasource? datasource})
      : _datasource = datasource ?? FavoritesLocalDatasource(),
        super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await _datasource.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError('فشل في تحميل المفضلة'));
    }
  }

  Future<void> addToFavorites(FavoriteItem item) async {
    try {
      await _datasource.addFavorite(item);

      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final updatedFavorites = [...currentState.favorites, item];
        emit(currentState.copyWith(favorites: updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesError('فشل في إضافة العنصر للمفضلة'));
    }
  }

  Future<void> removeFromFavorites(String id) async {
    try {
      await _datasource.removeFavorite(id);

      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final updatedFavorites =
            currentState.favorites.where((item) => item.id != id).toList();
        emit(currentState.copyWith(favorites: updatedFavorites));
      }
    } catch (e) {
      emit(FavoritesError('فشل في إزالة العنصر من المفضلة'));
    }
  }

  Future<void> toggleFavorite(FavoriteItem item) async {
    final isFav = await isFavorite(item.id);
    if (isFav) {
      await removeFromFavorites(item.id);
    } else {
      await addToFavorites(item);
    }
  }

  Future<bool> isFavorite(String id) async {
    return await _datasource.isFavorite(id);
  }

  void setFilter(FavoriteType? type) {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;
      emit(currentState.copyWith(filterType: type, clearFilter: type == null));
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await _datasource.clearAllFavorites();
      emit(const FavoritesLoaded(favorites: []));
    } catch (e) {
      emit(FavoritesError('فشل في مسح المفضلة'));
    }
  }
}
