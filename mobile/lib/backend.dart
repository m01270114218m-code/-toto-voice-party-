export 'package:supabase_flutter/supabase_flutter.dart' show AuthState, AuthException;
import 'package:supabase_flutter/supabase_flutter.dart';

const tajSupabaseUrl = 'https://hgsfdkopbbwbtvsrbpoi.supabase.co';
const tajSupabasePublishableKey = 'sb_publishable_-4jjp6J2GLVPkv8AW95TZQ_DLOEIWOm';

class TajBackend {
  static SupabaseClient get client => Supabase.instance.client;
  static User? get user => client.auth.currentUser;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: tajSupabaseUrl,
      publishableKey: tajSupabasePublishableKey,
    );
  }

  static Stream<AuthState> get authChanges => client.auth.onAuthStateChange;

  static Future<AuthResponse> signInWithEmail(
    String email,
    String password,
  ) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
    String? username,
  }) {
    return client.auth.signUp(
      email: email,
      password: password,
      data: {
        'display_name': displayName,
        if (username != null && username.isNotEmpty) 'username': username,
      },
    );
  }

  static Future<void> signOut() => client.auth.signOut();

  static Future<List<Map<String, dynamic>>> liveRooms() async {
    final result = await client
        .from('rooms')
        .select('*, profiles:owner_id(display_name,avatar_url,public_id)')
        .eq('is_live', true)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<Map<String, dynamic>?> myProfile() async {
    final id = user?.id;
    if (id == null) return null;
    final result = await client.from('profiles').select().eq('id', id).maybeSingle();
    return result;
  }

  static Future<String> createRoom({
    required String name,
    String? description,
    String category = 'general',
    int seatCount = 8,
  }) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    final room = await client.from('rooms').insert({
      'owner_id': id,
      'name': name,
      'description': description,
      'category': category,
      'seat_count': seatCount,
    }).select('id').single();
    final roomId = room['id'] as String;
    await client.from('room_roles').insert({
      'room_id': roomId,
      'user_id': id,
      'role': 'owner',
    });
    await client.from('room_seats').insert(
      List.generate(seatCount, (i) => {
        'room_id': roomId,
        'seat_number': i + 1,
      }),
    );
    return roomId;
  }

  static Future<void> joinRoom(String roomId) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.from('room_members').upsert({
      'room_id': roomId,
      'user_id': id,
      'last_seen_at': DateTime.now().toIso8601String(),
    });
  }

  static Future<void> leaveRoom(String roomId) async {
    final id = user?.id;
    if (id == null) return;
    await client.from('room_members').delete().eq('room_id', roomId).eq('user_id', id);
  }

  static Future<void> sendRoomMessage(String roomId, String body) async {
    final id = user?.id;
    if (id == null || body.trim().isEmpty) return;
    await client.from('messages').insert({
      'room_id': roomId,
      'sender_id': id,
      'body': body.trim(),
    });
  }

  static Stream<List<Map<String, dynamic>>> roomMessages(String roomId) {
    return client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at');
  }

  static Future<void> requestSeat(String roomId, int seatNumber) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.rpc('assign_seat', params: {
      'p_room': roomId,
      'p_seat': seatNumber,
    });
  }

  static Future<void> releaseSeat(String roomId, int seatNumber) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.rpc('release_seat', params: {
      'p_room': roomId,
      'p_seat': seatNumber,
    });
  }

  static Future<void> setMic(String roomId, int seatNumber, bool enabled) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.from('room_seats').update({
      'is_muted': !enabled,
    }).eq('room_id', roomId).eq('seat_number', seatNumber).eq('user_id', id);
  }

  static Stream<List<Map<String, dynamic>>> roomSeats(String roomId) {
    return client
        .from('room_seats')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('seat_number');
  }

  static Future<List<Map<String, dynamic>>> myNotifications() async {
    final id = user?.id;
    if (id == null) return [];
    final result = await client.from('notifications').select().eq('user_id', id).order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<Map<String, dynamic>?> myWallet() async {
    final id = user?.id;
    if (id == null) return null;
    return client.from('profiles').select('coins,diamonds,level,experience,vip_level').eq('id', id).maybeSingle();
  }

  static Future<List<Map<String, dynamic>>> walletLedger() async {
    final id = user?.id;
    if (id == null) return [];
    final result = await client.from('wallet_ledger').select().eq('user_id', id).order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<void> createMoment(String text, {String? mediaUrl}) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.from('moments').insert({
      'author_id': id,
      'text': text.trim(),
      if (mediaUrl != null && mediaUrl.isNotEmpty) 'media_url': mediaUrl,
    });
  }

  static Future<List<Map<String, dynamic>>> moments() async {
    final result = await client.from('moments').select('*, profiles:author_id(display_name,avatar_url,public_id)').order('created_at', ascending: false).limit(50);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<void> markNotificationRead(String id) async {
    await client.from('notifications').update({'read_at': DateTime.now().toIso8601String()}).eq('id', id);
  }

  static Future<void> updateProfile({
    String? displayName,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    final data = <String, dynamic>{};
    if (displayName != null) data['display_name'] = displayName;
    if (username != null) data['username'] = username;
    if (bio != null) data['bio'] = bio;
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    if (data.isNotEmpty) await client.from('profiles').update(data).eq('id', id);
  }

  static Future<void> moderateUser({
    required String roomId,
    required String targetUserId,
    required String action,
    String? reason,
  }) async {
    await client.rpc('moderate_user', params: {
      'p_room': roomId,
      'p_target': targetUserId,
      'p_action': action,
      'p_reason': reason,
    });
  }

  static Future<void> updateRoomSeats(String roomId, int seatCount) async {
    await client.from('rooms').update({'seat_count': seatCount}).eq('id', roomId);
  }

  static Future<void> setRoomLocked(String roomId, bool locked) async {
    await client.from('rooms').update({'is_locked': locked}).eq('id', roomId);
  }

  static Future<void> updateRoom(String roomId, Map<String, dynamic> data) async {
    if (data.isNotEmpty) await client.from('rooms').update(data).eq('id', roomId);
  }

  static Future<void> followUser(String targetId) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    if (id == targetId) return;
    await client.from('follows').upsert({'follower_id': id, 'following_id': targetId});
  }

  static Future<void> unfollowUser(String targetId) async {
    final id = user?.id;
    if (id == null) throw StateError('not_authenticated');
    await client.from('follows').delete().eq('follower_id', id).eq('following_id', targetId);
  }

  static Future<List<Map<String, dynamic>>> following() async {
    final id = user?.id;
    if (id == null) return [];
    final result = await client.from('follows').select('following_id, profiles:following_id(display_name,username,public_id,avatar_url)').eq('follower_id', id);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<void> sendPrivateMessage(String recipientId, String body) async {
    final id = user?.id;
    final text = body.trim();
    if (id == null) throw StateError('not_authenticated');
    if (recipientId == id || text.isEmpty) return;
    await client.from('messages').insert({'sender_id': id, 'recipient_id': recipientId, 'body': text});
  }

  static Stream<List<Map<String, dynamic>>> privateMessages(String otherUserId) {
    final id = user?.id;
    if (id == null) return const Stream.empty();
    return client.from('messages')
      .stream(primaryKey: ['id'])
      .or('and(sender_id.eq.$id,recipient_id.eq.$otherUserId),and(sender_id.eq.$otherUserId,recipient_id.eq.$id)')
      .order('created_at');
  }

  static Future<List<Map<String, dynamic>>> conversations() async {
    final id = user?.id;
    if (id == null) return [];
    final result = await client.from('messages')
      .select('id,sender_id,recipient_id,body,created_at')
      .or('sender_id.eq.$id,recipient_id.eq.$id')
      .order('created_at', ascending: false)
      .limit(100);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> searchProfiles(String query) async {
    final q = query.trim();
    if (q.isEmpty) return [];
    final result = await client.from('profiles')
        .select('id,display_name,username,public_id,avatar_url,country,level,vip_level')
        .or('display_name.ilike.%$q%,username.ilike.%$q%,public_id.ilike.%$q%')
        .limit(30);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> vipLevels() async {
    final result = await client.from('vip_levels').select().order('level');
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> levelRewards() async {
    final result = await client.from('level_rewards').select().order('level');
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> adminReports() async {
    final result = await client.from('reports').select().order('created_at', ascending: false).limit(100);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> adminUsers({String query = ''}) async {
    final q = query.trim();
    var request = client.from('profiles').select('id,display_name,username,public_id,level,vip_level,coins,diamonds,is_admin,is_banned,created_at');
    if (q.isNotEmpty) request = request.or('display_name.ilike.%$q%,username.ilike.%$q%,public_id.eq.$q');
    final result = await request.order('created_at', ascending: false).limit(100);
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<List<Map<String, dynamic>>> gifts() async {
    final result = await client
        .from('gifts')
        .select()
        .eq('is_active', true)
        .order('sort_order');
    return List<Map<String, dynamic>>.from(result);
  }

  static Future<String> sendGift({
    required String receiverId,
    required String giftId,
    required int quantity,
    String? roomId,
  }) async {
    final result = await client.rpc('send_gift', params: {
      'p_receiver': receiverId,
      'p_gift': giftId,
      'p_quantity': quantity,
      'p_room': roomId,
    });
    return result as String;
  }
}
