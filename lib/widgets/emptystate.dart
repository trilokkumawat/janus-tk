import 'package:flutter/material.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String imageAsset;

  const EmptyState({Key? key, required this.title, required this.imageAsset})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(imageAsset, width: 120, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTextStyle.h5.copyWith(color: AppColors.darkText),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
