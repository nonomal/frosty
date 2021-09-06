import 'dart:convert';
import 'package:frosty/models/badges.dart';
import 'package:frosty/models/emotes.dart';
import 'package:http/http.dart' as http;

// TODO: Notify user when a request for an asset has failed (and possibly an option to retry).

// A class for general requests.
class Request {
  /// Returns a map of global BTTV emotes to their URL.
  static Future<Map<String, String>?> getEmotesBTTVGlobal() async {
    final url = Uri.parse('https://api.betterttv.net/3/cached/emotes/global');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      final List<EmoteBTTVGlobal> emotes = decoded.map((emote) => EmoteBTTVGlobal.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.code] = 'https://cdn.betterttv.net/emote/${emote.id}/3x');

      return emoteToUrl;
    } else {
      print('Failed to get global BTTV emotes. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of a channel's BTTV emotes to their URL.
  static Future<Map<String, String>?> getEmotesBTTVChannel({required String id}) async {
    final url = Uri.parse('https://api.betterttv.net/3/cached/users/twitch/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final result = EmoteBTTVChannel.fromJson(decoded);

      final emoteToUrl = <String, String>{};
      result.channelEmotes.forEach((emote) => emoteToUrl[emote.code] = 'https://cdn.betterttv.net/emote/${emote.id}/3x');
      result.sharedEmotes.forEach((emote) => emoteToUrl[emote.code] = 'https://cdn.betterttv.net/emote/${emote.id}/3x');

      return emoteToUrl;
    } else {
      print('Failed to get BTTV emotes for id: $id. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of global FFZ emotes to their URL.
  static Future<Map<String, String>?> getEmotesFFZGlobal() async {
    final url = Uri.parse('https://api.betterttv.net/3/cached/frankerfacez/emotes/global');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      final List<EmoteFFZ> emotes = decoded.map((emote) => EmoteFFZ.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.code] = emote.images.url4x ?? emote.images.url1x);

      return emoteToUrl;
    } else {
      print('Failed to get global FFZ emotes. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of a channel's FFZ emotes to their URL.
  static Future<Map<String, String>?> getEmotesFFZChannel({required String id}) async {
    final url = Uri.parse('https://api.betterttv.net/3/cached/frankerfacez/users/twitch/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      final List<EmoteFFZ> emotes = decoded.map((emote) => EmoteFFZ.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.code] = emote.images.url4x ?? emote.images.url1x);

      return emoteToUrl;
    } else {
      print('Failed to get FFZ emotes for id: $id. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of global Twitch emotes to their URL.
  static Future<Map<String, String>?> getEmotesTwitchGlobal({required String token}) async {
    final url = Uri.parse('https://api.twitch.tv/helix/chat/emotes/global');
    final headers = {'Authorization': 'Bearer $token', 'Client-Id': const String.fromEnvironment('CLIENT_ID')};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)['data'] as List;
      final List<EmoteTwitch> emotes = decoded.map((emote) => EmoteTwitch.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.name] = 'https://static-cdn.jtvnw.net/emoticons/v2/${emote.id}/default/dark/3.0');

      return emoteToUrl;
    } else {
      print('Failed to get global Twitch emotes. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of a channel's Twitch emotes to their URL.
  static Future<Map<String, String>?> getEmotesTwitchChannel({required String token, required String id}) async {
    final url = Uri.parse('https://api.twitch.tv/helix/chat/emotes?broadcaster_id=$id');
    final headers = {'Authorization': 'Bearer $token', 'Client-Id': const String.fromEnvironment('CLIENT_ID')};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)['data'] as List;
      final List<EmoteTwitch> emotes = decoded.map((emote) => EmoteTwitch.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.name] = 'https://static-cdn.jtvnw.net/emoticons/v2/${emote.id}/default/dark/3.0');

      return emoteToUrl;
    } else {
      print('Failed to get Twitch emotes for id: $id. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of global Twitch badges to their URL.
  static Future<Map<String, String>?> getBadgesTwitchGlobal({required String token}) async {
    final url = Uri.parse('https://api.twitch.tv/helix/chat/badges/global');
    final headers = {'Authorization': 'Bearer $token', 'Client-Id': const String.fromEnvironment('CLIENT_ID')};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)['data'] as List;
      final List<BadgesTwitch> badges = decoded.map((emote) => BadgesTwitch.fromJson(emote)).toList();

      final badgeToUrl = <String, String>{};
      for (final badge in badges) {
        for (final badgeVersion in badge.versions) {
          badgeToUrl['${badge.setId}/${badgeVersion.id}'] = badgeVersion.imageUrl4x;
        }
      }

      return badgeToUrl;
    } else {
      print('Failed to get global Twitch badges. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of a channel's Twitch badges to their URL.
  static Future<Map<String, String>?> getBadgesTwitchChannel({required String token, required String id}) async {
    final url = Uri.parse('https://api.twitch.tv/helix/chat/badges?broadcaster_id=$id');
    final headers = {'Authorization': 'Bearer $token', 'Client-Id': const String.fromEnvironment('CLIENT_ID')};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body)['data'] as List;
      final List<BadgesTwitch> badges = decoded.map((emote) => BadgesTwitch.fromJson(emote)).toList();

      final badgeToUrl = <String, String>{};
      for (final badge in badges) {
        for (final badgeVersion in badge.versions) {
          badgeToUrl['${badge.setId}/${badgeVersion.id}'] = badgeVersion.imageUrl4x;
        }
      }

      return badgeToUrl;
    } else {
      print('Failed to get Twitch badges for id: $id. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of global 7TV emotes to their URL.
  static Future<Map<String, String>?> getEmotes7TVGlobal() async {
    final url = Uri.parse('https://api.7tv.app/v2/emotes/global');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      final List<Emote7TV> emotes = decoded.map((emote) => Emote7TV.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.name] = emote.urls[3][1]);
      return emoteToUrl;
    } else {
      print('Failed to get global 7TV emotes. Error code: ${response.statusCode}');
    }
  }

  /// Returns a map of a channel's 7TV emotes to their URL.
  static Future<Map<String, String>?> getEmotes7TVChannel({required String user}) async {
    final url = Uri.parse('https://api.7tv.app/v2/users/$user/emotes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      final List<Emote7TV> emotes = decoded.map((emote) => Emote7TV.fromJson(emote)).toList();

      final emoteToUrl = <String, String>{};
      emotes.forEach((emote) => emoteToUrl[emote.name] = emote.urls[3][1]);
      return emoteToUrl;
    } else {
      print('Failed to get channel 7TV emotes. Error code: ${response.statusCode}');
    }
  }
}