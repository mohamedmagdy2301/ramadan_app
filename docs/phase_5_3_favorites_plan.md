# Phase 5.3: Favorites Feature Plan

## Overview
إضافة ميزة المفضلة للسماح للمستخدمين بحفظ الأذكار والأدعية المفضلة للوصول السريع.

## Technical Requirements

### Storage
استخدام SharedPreferences لحفظ قائمة المفضلة محلياً.

### Data Model
```dart
class FavoriteItem {
  final String id;
  final FavoriteType type;  // azkar, dua, surah
  final String title;
  final DateTime addedAt;
}
```

## File Structure
```
lib/features/favorites/
├── data/
│   ├── favorites_local_datasource.dart    # حفظ واسترجاع المفضلة
│   └── models/
│       └── favorite_item_model.dart       # موديل المفضلة
├── domain/
│   └── entities/
│       ├── favorite_item.dart             # كيان المفضلة
│       └── favorite_type.dart             # نوع المفضلة
├── presentation/
│   ├── cubit/
│   │   ├── favorites_cubit.dart           # إدارة الحالة
│   │   └── favorites_state.dart
│   ├── view/
│   │   └── screens/
│   │       └── favorites_screen.dart      # شاشة المفضلة
│   └── widgets/
│       ├── favorite_button.dart           # زر الإضافة للمفضلة
│       ├── favorite_list_tile.dart        # عنصر في القائمة
│       └── empty_favorites_widget.dart    # عندما تكون القائمة فارغة
└── services/
    └── favorites_service.dart             # خدمة المفضلة
```

## Implementation Steps

### Step 1: Create Domain Entities
- FavoriteType enum (azkar, dua, surah)
- FavoriteItem entity

### Step 2: Create Data Layer
- FavoriteItemModel with JSON serialization
- FavoritesLocalDatasource for SharedPreferences

### Step 3: Create Favorites Service
- Add/remove favorites
- Get all favorites
- Check if item is favorited

### Step 4: Create Cubit for State Management
- FavoritesCubit
- FavoritesState (initial, loaded, error)

### Step 5: Create UI Widgets
- FavoriteButton (heart icon to toggle)
- FavoriteListTile
- EmptyFavoritesWidget

### Step 6: Create Favorites Screen
- عرض قائمة المفضلة
- تصفية حسب النوع
- حذف من المفضلة

### Step 7: Add Navigation
- إضافة Route للشاشة
- إضافة الوصول من الشاشة الرئيسية

### Step 8: Integrate with Existing Screens
- إضافة زر المفضلة لشاشة الأذكار
- إضافة زر المفضلة لشاشة الأدعية

## UI Design

```
┌─────────────────────────────┐
│         المفضلة             │
├─────────────────────────────┤
│ [الكل] [أذكار] [أدعية] [قرآن]│
├─────────────────────────────┤
│ ❤️ دعاء الصباح              │
│    أذكار                    │
├─────────────────────────────┤
│ ❤️ سورة الكهف               │
│    قرآن                     │
├─────────────────────────────┤
│ ❤️ دعاء السفر               │
│    أدعية                    │
└─────────────────────────────┘
```

## Storage Format (SharedPreferences)
```json
{
  "favorites": [
    {
      "id": "azkar_sabah",
      "type": "azkar",
      "title": "أذكار الصباح",
      "addedAt": "2024-01-01T12:00:00.000Z"
    }
  ]
}
```

## Testing Plan
1. Unit tests للـ FavoritesLocalDatasource
2. Unit tests للـ FavoritesCubit
3. Widget tests للـ FavoriteButton

## Post-Implementation
1. تشغيل جميع الاختبارات
2. التأكد من عدم وجود أخطاء
3. Commit و Push التغييرات
