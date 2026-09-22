import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ToyoApi {
  static const baseUrl = String.fromEnvironment('TOYO_API_URL', defaultValue: 'http://10.0.2.2:8080');
  static Future<String?> token() async => (await SharedPreferences.getInstance()).getString('token');

  static Future<Map<String,dynamic>> request(String method,String path,{Map<String,dynamic>? body,bool auth=true}) async {
    final headers={'Content-Type':'application/json','Accept':'application/json'};
    if(auth){ final t=await token(); if(t!=null) headers['Authorization']='Bearer $t'; }
    final uri=Uri.parse('$baseUrl$path');
    final response=method=='GET'
      ? await http.get(uri,headers:headers)
      : method=='PATCH'
        ? await http.patch(uri,headers:headers,body:jsonEncode(body??{}))
        : await http.post(uri,headers:headers,body:jsonEncode(body??{}));
    Map<String,dynamic> data={};
    if(response.body.isNotEmpty){ final decoded=jsonDecode(response.body); if(decoded is Map) data=Map<String,dynamic>.from(decoded); }
    if(response.statusCode<200||response.statusCode>=300) throw ToyoApiException(data['error']?.toString()??'REQUEST_FAILED',response.statusCode);
    return data;
  }

  static Future<Map<String,dynamic>> login(String email,String password) async {
    final data=await request('POST','/api/auth/login',body:{'email':email,'password':password},auth:false);
    final p=await SharedPreferences.getInstance();
    await p.setString('token',data['token'] as String);
    await p.setBool('logged',true);
    return data;
  }

  static Future<Map<String,dynamic>> register(String email,String password,String displayName) async {
    final data=await request('POST','/api/auth/register',body:{'email':email,'password':password,'displayName':displayName},auth:false);
    final p=await SharedPreferences.getInstance();
    await p.setString('token',data['token'] as String);
    await p.setBool('logged',true);
    return data;
  }

  static Future<Map<String,dynamic>> me() => request('GET','/api/me');
  static Future<List<Map<String,dynamic>>> wallet() async {
    final t=await token();
    final headers={'Accept':'application/json',if(t!=null)'Authorization':'Bearer $t'};
    final response=await http.get(Uri.parse('$baseUrl/api/wallet'),headers:headers);
    if(response.statusCode<200||response.statusCode>=300) throw ToyoApiException('WALLET_FAILED',response.statusCode);
    return (jsonDecode(response.body) as List).map((e)=>Map<String,dynamic>.from(e as Map)).toList();
  }

  static Future<List<Map<String,dynamic>>> rooms() async {
    final t=await token();
    final headers={'Accept':'application/json',if(t!=null)'Authorization':'Bearer $t'};
    final response=await http.get(Uri.parse('$baseUrl/api/rooms'),headers:headers);
    if(response.statusCode<200||response.statusCode>=300) throw ToyoApiException('ROOMS_FAILED',response.statusCode);
    final decoded=jsonDecode(response.body);
    return (decoded as List).map((e)=>Map<String,dynamic>.from(e as Map)).toList();
  }

  static Future<Map<String,dynamic>> createRoom({required String name,String description='',String category='general',int maxSeats=8}) =>
    request('POST','/api/rooms',body:{'name':name,'description':description,'category':category,'maxSeats':maxSeats});

  static Future<Map<String,dynamic>> rtcToken(String roomId,{bool publisher=false}) =>
    request('POST','/api/rtc/token',body:{'roomId':roomId,'role':publisher?'publisher':'audience'});

  static Future<Map<String,dynamic>> roomState(String roomId)=>request('GET','/api/rooms/$roomId/state');

  static Future<void> joinRoom(String roomId)=>request('POST','/api/rooms/$roomId/join');
  static Future<void> leaveRoom(String roomId)=>request('POST','/api/rooms/$roomId/leave');

  static Future<Map<String,dynamic>> requestSeat(String roomId,int seatNo)=>
    request('POST','/api/rooms/$roomId/seats/$seatNo/request');
  static Future<Map<String,dynamic>> leaveSeat(String roomId,int seatNo)=>
    request('POST','/api/rooms/$roomId/seats/$seatNo/leave');

  static Future<Map<String,dynamic>> sendMessage(String roomId,String text)=>
    request('POST','/api/rooms/$roomId/messages',body:{'text':text});

  static Future<List<dynamic>> messages(String roomId) async {
    final data=await request('GET','/api/rooms/$roomId/messages');
    return data is List ? data : [];
  }
}

class ToyoApiException implements Exception {
  final String code; final int status;
  const ToyoApiException(this.code,this.status);
  @override String toString()=>code;
}
