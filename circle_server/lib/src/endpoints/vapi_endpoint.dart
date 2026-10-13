import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class VapiEndpoint extends Endpoint {
  /// Initiates a Vapi call
  Future<bool> initiateCall(Session session, String phoneNumber, String habitName) async {
    // Load API key from environment
    final vapiKey = Platform.environment['VAPI_PRIVATE_KEY'] ?? 'YOUR_VAPI_PRIVATE_KEY';
    
    // Call Vapi to initiate the AI call
    final url = Uri.parse('https://api.vapi.ai/call/phone');
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $vapiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'assistant': {
            'firstMessage': 'Hey! Time for your $habitName. Let\'s get it done!',
            'model': {
              'provider': 'openai',
              'model': 'gpt-4o-mini',
            },
            'voice': {
              'provider': '11labs',
              'voiceId': 'drill_sergeant_voice_id',
            },
          },
          'customer': {
            'number': phoneNumber,
          },
        }),
      );

      if (response.statusCode == 201) {
        session.log('Vapi call initiated for $phoneNumber (habit: $habitName)');
        return true;
      } else {
        session.log('Failed to initiate Vapi call: ${response.body}');
        return false;
      }
    } catch (e) {
      session.log('Error triggering Vapi call: $e');
      return false;
    }
  }
}
