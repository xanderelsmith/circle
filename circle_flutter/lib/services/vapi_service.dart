import 'package:circle_flutter/client.dart';

class VapiService {
  static final VapiService _instance = VapiService._internal();
  factory VapiService() => _instance;
  VapiService._internal();

  /// Initiate a Vapi call for a habit
  Future<bool> initiateCall({
    required String phoneNumber,
    required String habitName,
  }) async {
    try {
      final result = await client.vapi.initiateCall(
        phoneNumber,
        habitName,
      );
      return result;
    } catch (e) {
      print('Error initiating Vapi call: $e');
      return false;
    }
  }
}