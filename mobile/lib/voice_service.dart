import 'package:livekit_client/livekit_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TajVoiceService {
  Room? _room;
  Room? get room => _room;

  Future<void> connect(String roomId, {required String displayName}) async {
    final supabase = Supabase.instance.client;
    final response = await supabase.functions.invoke('livekit-token', body: {
      'room_name': roomId,
      'participant_name': displayName,
    });
    final data = Map<String, dynamic>.from(response.data as Map);
    final serverUrl = data['server_url'] as String?;
    final token = data['participant_token'] as String?;
    if (serverUrl == null || token == null) {
      throw StateError('livekit_token_missing');
    }

    final room = Room();
    await room.connect(
      serverUrl,
      token,
      roomOptions: const RoomOptions(
        adaptiveStream: true,
        dynacast: true,
      ),
    );
    _room = room;
  }

  Future<void> setMicrophone(bool enabled) async {
    final participant = _room?.localParticipant;
    if (participant == null) return;
    await participant.setMicrophoneEnabled(enabled);
  }

  Future<void> disconnect() async {
    final room = _room;
    _room = null;
    await room?.disconnect();
  }

  Future<void> dispose() => disconnect();
}
