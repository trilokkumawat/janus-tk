import 'package:flutter_riverpod/legacy.dart';
import '../services/supabase_service.dart';
import '../models/category_model.dart';

/// State class for categories
class CategoriesState {
  final List<CategoryModel> categories;
  final bool isLoading;
  final String? error;
  final CategoryModel? selectedCategory;

  const CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
    this.selectedCategory,
  });

  CategoriesState copyWith({
    List<CategoryModel>? categories,
    bool? isLoading,
    String? error,
    CategoryModel? selectedCategory,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

/// Controller for managing categories state
class CategoriesController extends StateNotifier<CategoriesState> {
  final CategoriesService _service;

  CategoriesController(this._service) : super(const CategoriesState()) {
    loadCategories();
  }

  /// Load all categories
  Future<void> loadCategories({String? orderBy, bool ascending = true}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categoriesData = await _service.getCategories(
        orderBy: orderBy,
        ascending: ascending,
      );
      final categories = categoriesData
          .map((json) => CategoryModel.fromJson(json))
          .toList();
      state = state.copyWith(
        categories: categories,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Load a single category by ID
  Future<void> loadCategoryById(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categoryData = await _service.getCategoryById(id);
      final category = categoryData != null
          ? CategoryModel.fromJson(categoryData)
          : null;
      state = state.copyWith(
        selectedCategory: category,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Create a new category
  Future<bool> createCategory(Map<String, dynamic> categoryData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final newCategoryData = await _service.createCategory(categoryData);
      final newCategory = CategoryModel.fromJson(newCategoryData);
      final updatedCategories = [newCategory, ...state.categories];
      state = state.copyWith(
        categories: updatedCategories,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Update a category
  Future<bool> updateCategory(
    String id,
    Map<String, dynamic> categoryData,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedCategoryData = await _service.updateCategory(
        id,
        categoryData,
      );
      final updatedCategory = CategoryModel.fromJson(updatedCategoryData);
      final updatedCategories = state.categories.map((category) {
        if (category.id == id) {
          return updatedCategory;
        }
        return category;
      }).toList();

      state = state.copyWith(
        categories: updatedCategories,
        selectedCategory: state.selectedCategory?.id == id
            ? updatedCategory
            : state.selectedCategory,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Delete a category
  Future<bool> deleteCategory(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.deleteCategory(id);
      final updatedCategories = state.categories
          .where((cat) => cat.id != id)
          .toList();

      state = state.copyWith(
        categories: updatedCategories,
        selectedCategory: state.selectedCategory?.id == id
            ? null
            : state.selectedCategory,
        isLoading: false,
        error: null,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  /// Refresh categories
  Future<void> refresh() async {
    await loadCategories();
  }

  /// Clear selected category
  void clearSelectedCategory() {
    state = state.copyWith(selectedCategory: null);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Service class for categories operations
class CategoriesService {
  /// Fetch all categories from Supabase
  Future<List<Map<String, dynamic>>> getCategories({
    String? orderBy,
    bool ascending = true,
  }) async {
    final client = SupabaseService.client;
    dynamic query = client.from('categories').select();

    if (orderBy != null) {
      query = query.order(orderBy, ascending: ascending);
    } else {
      query = query.order('id', ascending: true);
    }

    final response = await query;
    return List<Map<String, dynamic>>.from(response);
  }

  /// Fetch a single category by ID
  Future<Map<String, dynamic>?> getCategoryById(String id) async {
    try {
      final client = SupabaseService.client;
      final response = await client
          .from('categories')
          .select()
          .eq('id', id)
          .single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      return null;
    }
  }

  /// Create a new category
  Future<Map<String, dynamic>> createCategory(
    Map<String, dynamic> categoryData,
  ) async {
    final client = SupabaseService.client;
    final response = await client
        .from('categories')
        .insert(categoryData)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  /// Update a category
  Future<Map<String, dynamic>> updateCategory(
    String id,
    Map<String, dynamic> categoryData,
  ) async {
    final client = SupabaseService.client;
    final response = await client
        .from('categories')
        .update(categoryData)
        .eq('id', id)
        .select()
        .single();

    return Map<String, dynamic>.from(response);
  }

  /// Delete a category
  Future<void> deleteCategory(String id) async {
    final client = SupabaseService.client;
    await client.from('categories').delete().eq('id', id);
  }
}
