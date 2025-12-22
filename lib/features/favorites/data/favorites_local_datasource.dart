import 'dart:convert';

import 'package:ramadan_app/core/local_storage/shared_preferences_manager.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_item.dart';
import 'package:ramadan_app/features/favorites/domain/entities/favorite_type.dart';

/// Local datasource for favorites using SharedPreferences
abstract class IFavoritesLocalDatasource {
  Future<List<FavoriteItem>> getFavorites();
  Future<List<FavoriteItem>> getFavoritesByType(FavoriteType type);
  Future<void> addFavorite(FavoriteItem item);
  Future<void> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<void> clearAllFavorites();
}

class FavoritesLocalDatasource implements IFavoritesLocalDatasource {
  static const String _favoritesKey = 'favorites_list';

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    final jsonString = SharedPreferencesManager.getData(key: _favoritesKey);
    if (jsonString == null || jsonString is! String) {
      return [];
    }

    try {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList
          .map((item) => FavoriteItem.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<FavoriteItem>> getFavoritesByType(FavoriteType type) async {
    final allFavorites = await getFavorites();
    return allFavorites.where((item) => item.type == type).toList();
  }

  @override
  Future<void> addFavorite(FavoriteItem item) async {
    final favorites = await getFavorites();

    // Check if already exists
    if (favorites.any((f) => f.id == item.id)) {
      return;
    }

    favorites.add(item);
    await _saveFavorites(favorites);
  }

  @override
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((item) => item.id == id);
    await _saveFavorites(favorites);
  }

  @override
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((item) => item.id == id);
  }

  @override
  Future<void> clearAllFavorites() async {
    await SharedPreferencesManager.removeData(key: _favoritesKey);
  }

  Future<void> _saveFavorites(List<FavoriteItem> favorites) async {
    final jsonString = json.encode(favorites.map((e) => e.toJson()).toList());
    await SharedPreferencesManager.setData(
      key: _favoritesKey,
      value: jsonString,
    );
  }
}
