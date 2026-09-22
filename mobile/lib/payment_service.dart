import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class TajPaymentService {
  static Future<void> startTopUp({
    required int amountMinor,
    required int coins,
    required String email,
    required String phone,
  }) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.functions.invoke('paymob-create-intention', body: {
      'amount_minor': amountMinor,
      'coins': coins,
      'email': email,
      'phone': phone,
    });
    final data = Map<String, dynamic>.from(response.data as Map);
    final checkoutUrl = data['checkout_url'] as String?;
    if (checkoutUrl == null || checkoutUrl.isEmpty) {
      throw StateError('payment_checkout_missing');
    }
    final ok = await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
    if (!ok) throw StateError('payment_checkout_open_failed');
  }
}
