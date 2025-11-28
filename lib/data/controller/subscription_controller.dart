import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:janus/data/services/database_function_service.dart';
import 'package:janus/data/models/subscriptionmodel/subscription_model.dart';
import 'package:janus/data/services/edge_function.dart';
import 'package:janus/data/services/supabase_service.dart';
import 'package:janus/presentation/screens/subscription/subscription_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionController extends StateNotifier<SubscriptionScreen> {
  SubscriptionController() : super(SubscriptionScreen());

  Future<List<SubscriptionPlanModel>> getSubscriptionPlans() async {
    try {
      final plansData = await SupabaseFunctionService.callAsList(
        "get_my_subscription_plans",
      );
      final plans = plansData
          .map((json) => SubscriptionPlanModel.fromJson(json))
          .toList();
      print(plans);
      return plans;
    } catch (e) {
      print(e);
      throw Exception('Failed to get subscription plans: $e');
    }
  }

  // Future<String>
  createCustomerId() async {
    try {
      final user = SupabaseService.instance.currentUser;
      final customerId = await SupabaseEdgeFunctionService.create(
        "smooth-function",
        body: {"email": user?.email, "user_id": user?.id},
      );
      print(customerId);
      // return customerId;
    } catch (e) {
      throw Exception('Failed to create customer id: $e');
    }
  }

  buySubscription(priceid) async {
    try {
      final user = SupabaseService.instance.currentUser;
      final response = await SupabaseEdgeFunctionService.create(
        "bright-worker",
        body: {"price_id": priceid, "user_id": user?.id},
      );
      print(response);

      // Handle different response types
      Map<String, dynamic> responseMap;
      if (response is Map) {
        responseMap = Map<String, dynamic>.from(response);
      } else if (response is String) {
        responseMap = Map<String, dynamic>.from(jsonDecode(response));
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      final url = responseMap['url'];
      if (url == null) {
        throw Exception('Response does not contain "url" field');
      }

      // Convert to Uri if it's a String
      final uri = url is String ? Uri.parse(url) : url as Uri;
      _launchUrl(uri);
    } catch (e) {
      throw Exception('Failed to buy subscription: $e');
    }
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  // createCustomerId2() async {
  //   try {
  //     final user = SupabaseService.instance.currentUser;
  //     print(user?.id);
  //     print(user?.email);

  //     var response = await JanusApiGroup.stripecustomeridcreate.call(
  //       user_id: user?.id,
  //       email: user?.email,
  //       useFunctionApi: true,
  //     );

  //     print(response.data);
  //     // return customerId;
  //   } catch (e) {
  //     throw Exception('Failed to create customer id: $e');
  //   }
  // }
}
