import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/core/utils/timezone_utils.dart';
import 'package:janus/data/services/api/rest_api.dart';
import 'package:janus/widgets/supabase/cached_query_flutter.dart';
import 'package:janus/data/controller/categories_controller.dart';
import 'package:janus/data/models/categorymodel/category_model.dart';
import 'package:janus/widgets/animations/confetti_overlay.dart';
import 'package:janus/presentation/providers/user_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userDataAsync = ref.watch(userDataProvider);

    return ConfettiOverlay(
      particleCount: 50,
      colors: const [
        AppColors.green,
        AppColors.blue,
        AppColors.coral,
        AppColors.orange,
        AppColors.purple,
      ],
      duration: const Duration(seconds: 3),
      gravity: 0.1,
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              userDataAsync.when(
                data: (user) {
                  final email = user?.email;
                  final greeting = email == null
                      ? 'Welcome!'
                      : 'Welcome, $email';
                  return Text(greeting);
                },
                loading: () => const CircularProgressIndicator(),
                error: (_, __) =>
                    const Text('Unable to load your profile right now'),
              ),
              ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).push(AppRoutes.subscription);
                },
                child: const Text('Go to Subscription'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var result = await JanusApiGroup.hellofun.call(
                    useFunctionApi: true,
                  );
                  if (result.success) {
                    String dataString;
                    if (result.data is String) {
                      dataString = result.data as String;
                    } else if (result.data is Map) {
                      dataString = jsonEncode(result.data);
                    } else {
                      dataString = result.data?.toString() ?? 'Success';
                    }
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(dataString)));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.message ?? '')),
                    );
                  }
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
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.secondaryText,
                          ),
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
                                  'Created: ${TimezoneUtils.formatDateTime(category.createdAt, format: 'dd/MM/yyyy') ?? 'N/A'}',
                                  style: AppTextStyle.bodySmall.copyWith(
                                    color: AppColors.secondaryText,
                                  ),
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
