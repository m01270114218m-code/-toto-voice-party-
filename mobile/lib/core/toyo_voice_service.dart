class ToyoVoiceService {
  bool joined=false;
  bool muted=true;
  String? channelId;

  Future<void> join({required String appId,required String token,required String channelId,required String account,required bool publish}) async {
    throw const ToyoVoiceException('VOICE_KEYS_REQUIRED');
  }

  Future<void> setMuted(bool value) async {
    if(!joined) throw const ToyoVoiceException('VOICE_NOT_CONNECTED');
    muted=value;
  }

  Future<void> leave() async {
    joined=false;
    channelId=null;
  }
}

class ToyoVoiceException implements Exception {
  final String code;
  const ToyoVoiceException(this.code);
  @override String toString()=>code;
}
