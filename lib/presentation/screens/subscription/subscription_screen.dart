import 'package:flutter/material.dart';
import 'package:janus/core/constants/dimensions.dart';
import 'package:janus/core/constants/gaps.dart';
import 'package:janus/core/extensions/state_extensions.dart';
import 'package:janus/data/controller/subscription_controller.dart';
import 'package:janus/widgets/supabase/supabase_widgets.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen>
    with SafeStateMixin {
  String selectedPlan = '';
  String selectedPlanid = '';

  late final SubscriptionController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SubscriptionController();
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
            Text(
              'Upgrade to Premium',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Gaps.v8,
            ElevatedButton(
              onPressed: () {
                _controller.createCustomerId();
              },
              child: Text('create customer id'),
            ),
            CachedQueryFlutter(
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
                ? ElevatedButton(
                    onPressed: () {
                      _controller.buySubscription(selectedPlanid);
                    },
                    child: Text('Buy Subscription'),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "\$${price}",
              style: TextStyle(
                fontSize: 16,
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
                            style: TextStyle(
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
