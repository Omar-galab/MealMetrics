import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';

class MealSearchBar extends ConsumerStatefulWidget {
  const MealSearchBar({super.key});

  @override
  ConsumerState<MealSearchBar> createState() => _MealSearchBarState();
}

class _MealSearchBarState extends ConsumerState<MealSearchBar> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search for meals...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              ref.read(mealSearchQueryProvider.notifier).state = '';
              ref.read(selectedCategoryProvider.notifier).state = null;
            },
          )
              : null,
        ),
        onChanged: (query) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            ref.read(mealSearchQueryProvider.notifier).state = query;
            ref.read(selectedCategoryProvider.notifier).state = null;
          });
        },
      ),
    );
  }
}