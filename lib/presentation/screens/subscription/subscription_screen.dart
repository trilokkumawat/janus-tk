import 'package:flutter/material.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/gaps.dart';
import 'package:janus/core/extensions/state_extensions.dart';
import 'package:janus/data/controller/subscription_controller.dart';
import 'package:janus/widgets/supabase/supabase_widgets.dart';

class SubscriptionScreen extends StatefulWidget {
  final bool showCancelled;

  const SubscriptionScreen({super.key, this.showCancelled = false});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SafeStateMixin {
  String selectedPlan = '';
  String selectedPlanid = '';
  bool showCancelledMessage = false;

  late final SubscriptionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubscriptionController();

    // Set cancelled message if widget was created with showCancelled flag
    if (widget.showCancelled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        safeSetState(() {
          showCancelledMessage = true;
        });
        // Clear the cancelled state after 5 seconds
        Future.delayed(const Duration(seconds: 5), () {
          safeSetState(() {
            showCancelledMessage = false;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose your plan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Upgrade to Premium', style: AppTextStyle.h4),
            Gaps.h10,
            // Show cancelled message if payment was cancelled
            if (showCancelledMessage)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Payment Cancelled',
                        style: AppTextStyle.warning.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _controller.createCustomerId();
              },
              child: Text('create customer id'),
            ),
            CachedQueryFlutter(
              cacheDuration: const Duration(seconds: 5),
              queryKey: 'subscription_plans',
              queryFn: () async {
                return await _controller.getSubscriptionPlans();
              },
              builder: (context, data, isLoading, error) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final plan = data[index];
                    return _buildPlanCard(
                      planName: plan.planname.toString(),
                      price: plan.price.toString(),
                      features: plan.features?.split(',') ?? [],
                      isSelected: selectedPlan == data[index].planname,
                      onTap: () {
                        safeSetState(() {
                          selectedPlan = plan.planname.toString();
                          selectedPlanid = plan.stripePriceId.toString();
                        });
                      },
                    );
                  },
                );
              },
            ),
            selectedPlanid.isNotEmpty
                ? Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _controller.buySubscription(selectedPlanid);
                        },
                        child: Text('Buy Subscription'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Note: If Safari shows an error after payment, just open the Janus app - it will automatically detect the payment status.',
                        style: AppTextStyle.caption.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String planName,
    required String price,
    required List<String> features,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
          ],
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  planName,
                  style: AppTextStyle.h5.copyWith(
                    color: isSelected ? Colors.blue : Colors.black87,
                  ),
                ),
                if (planName == 'Yearly')
                  Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Best value',
                      style: AppTextStyle.caption.copyWith(color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "\$${price}",
              style: AppTextStyle.bodyLarge.copyWith(
                color: isSelected ? Colors.blue : Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map(
                    (feature) => Row(
                      children: [
                        Expanded(
                          child: Text(
                            feature,
                            style: AppTextStyle.bodyMedium.copyWith(
                              color: isSelected ? Colors.blue : Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
