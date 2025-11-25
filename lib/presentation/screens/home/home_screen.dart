import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/widgets/supabase/cached_query_flutter.dart';
import 'package:janus/data/controller/categories_controller.dart';
import 'package:janus/data/models/category_model.dart';
import 'package:janus/widgets/animations/confetti_overlay.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return ConfettiOverlay(
      particleCount: 50,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple,
      ],
      duration: const Duration(seconds: 3),
      gravity: 0.1,
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push(AppRoutes.goals);
                },
                child: const Text('Go to Goals'),
              ),
              Expanded(
                child: CachedQueryFlutter<CategoryModel>(
                  queryKey: 'category_list',
                  queryFn: () async {
                    final service = CategoriesService();
                    final categoriesData = await service.getCategories();
                    return categoriesData
                        .map((json) => CategoryModel.fromJson(json))
                        .toList();
                  },
                  enableRealtime: true,
                  table: 'categories',
                  emptyWidget: const Center(child: Text('No categories found')),
                  loadingWidget: Container(
                    padding: const EdgeInsets.all(24.0),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 12),
                        Text(
                          'Loading categories...',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  builder: (context, data, isLoading, error) {
                    if (error != null) {
                      return Center(child: Text('Error: $error'));
                    }
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final category = data[index];
                        return ListTile(
                          title: Text(category.name),
                          subtitle: Text(
                            category.description ?? 'No description',
                          ),
                          trailing: category.createdAt != null
                              ? Text(
                                  'Created: ${category.createdAt!.day}/${category.createdAt!.month}/${category.createdAt!.year}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey),
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                GlobalConfettiController.show(
                  duration: const Duration(seconds: 3),
                );
              },
              tooltip: 'Show Confetti',
              heroTag: 'confetti',
              child: const Icon(Icons.celebration),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
