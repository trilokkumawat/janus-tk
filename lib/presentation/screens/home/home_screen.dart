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
import 'package:janus/widgets/common/table_calendar_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Sample events for demonstration
  final Map<DateTime, List<dynamic>> _events = {
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
      {'title': 'Meeting', 'type': 'work'},
      {'title': 'Gym', 'type': 'personal'},
    ],
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 2,
    ): [
      {'title': 'Project Deadline', 'type': 'work'},
    ],
    DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day + 5,
    ): [
      {'title': 'Birthday Party', 'type': 'personal'},
      {'title': 'Shopping', 'type': 'personal'},
    ],
  };

  void _onDaySelected(DateTime selectedDay) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected date: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // User greeting
                userDataAsync.when(
                  data: (user) {
                    final email = user?.email;
                    final greeting = email == null
                        ? 'Welcome!'
                        : 'Welcome, ${email.split('@')[0]}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        greeting,
                        style: AppTextStyle.h4.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.lightText
                              : AppColors.darkText,
                        ),
                      ),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: CircularProgressIndicator(),
                  ),
                  error: (_, __) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Unable to load your profile right now',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).push(AppRoutes.subscription);
                        },
                        child: const Text('Subscription'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
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
                        child: const Text('Goals'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Categories section
                Text(
                  'Categories',
                  style: AppTextStyle.h5.copyWith(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.lightText
                        : AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),

                CachedQueryFlutter<CategoryModel>(
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
                  emptyWidget: Center(
                    child: Text(
                      'No categories found',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
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
                      return Center(
                        child: Text(
                          'Error: $error',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.highPriority,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final category = data[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
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
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
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
