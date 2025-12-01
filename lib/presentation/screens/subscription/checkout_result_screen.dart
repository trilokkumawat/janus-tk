import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/routes.dart';

class CheckoutResultScreen extends StatelessWidget {
  final bool isSuccess;
  final String? sessionId;

  const CheckoutResultScreen({
    super.key,
    required this.isSuccess,
    this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSuccess ? 'Payment Success' : 'Payment Cancelled'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.cancel,
                size: 80,
                color: isSuccess ? Colors.green : Colors.red,
              ),
              const SizedBox(height: 24),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Cancelled',
                style: AppTextStyle.h3,
              ),
              const SizedBox(height: 16),
              Text(
                isSuccess
                    ? 'Your subscription has been activated successfully!'
                    : 'Your payment was cancelled. No charges were made.',
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyLarge.copyWith(
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              if (sessionId != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Session ID:',
                        style: AppTextStyle.caption.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sessionId!,
                        style: AppTextStyle.caption.copyWith(
                          color: Colors.grey[800],
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  // Use replace to prevent going back to this screen
                  context.pushReplacement(AppRoutes.appState);
                },
                child: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
