import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

class EscalationCall extends FutureCall<String> {
  @override
  Future<void> invoke(Session session, String? phoneNumber) async {
    if (phoneNumber == null) return;
    
    // In a real app, ensure you load this from a .env file or server config
    const vapiKey = 'YOUR_VAPI_PRIVATE_KEY';
    
    // Call Vapi to initiate the AI drill sergeant
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
            'firstMessage': 'Where is your proof? Why haven\'t you finished your habit?!',
            'model': {
              'provider': 'openai',
              'model': 'gpt-4o-mini',
            },
            'voice': {
              'provider': '11labs',
              'voiceId': 'drill_sergeant_voice_id'
            }
          },
          'customer': {
            'number': phoneNumber,
          },
        }),
      );
      
      if (response.statusCode == 201) {
        session.log('Vapi escalation call initiated for $phoneNumber');
      } else {
        session.log('Failed to initiate Vapi call: ${response.body}');
      }
    } catch (e) {
      session.log('Error triggering Vapi call: $e');
    }
  }
}
