import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/invite_firends_provider.dart';

class InviteFriendsRepository {
  InviteFriendsProvider inviteFriendsProvider = InviteFriendsProvider();

  Future<ShareCode> fetchShareCode() => inviteFriendsProvider.fetchShareCode();

}