import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class ToyoVoiceService {
  RtcEngine? _engine;
  bool joined=false;
  bool muted=true;
  String? channelId;

  Future<void> join({required String appId,required String token,required String channelId,required String account,bool publish}) async {
    await Permission.microphone.request();
    final engine=createAgoraRtcEngine();
    _engine=engine;
    await engine.initialize(RtcEngineContext(appId:appId,channelProfile:ChannelProfileType.channelProfileLiveBroadcasting));
    await engine.enableAudio();
    await engine.joinChannelWithUserAccount(
      token:token,
      channelId:channelId,
      userAccount:account,
      options:ChannelMediaOptions(
        clientRoleType: publish ? ClientRoleType.clientRoleBroadcaster : ClientRoleType.clientRoleAudience,
        publishMicrophoneTrack: publish,
        autoSubscribeAudio: true,
      ),
    );
    if(publish){ await engine.muteLocalAudioStream(muted); }
    this.channelId=channelId;
    joined=true;
  }

  Future<void> setMuted(bool value) async {
    muted=value;
    if(_engine!=null && joined) await _engine!.muteLocalAudioStream(value);
  }

  Future<void> leave() async {
    if(_engine!=null){
      await _engine!.leaveChannel();
      await _engine!.release();
    }
    _engine=null; joined=false; channelId=null;
  }
}
