import 'package:rive_flutter/models/core.dart';
import 'package:rive_flutter/providers/core/share_code_provider.dart';

class ShareCodeRepository {
  ShareCodeProvider shareCodeProvider = ShareCodeProvider();

  Future<ShareCode> fetchShareCode() => shareCodeProvider.fetchShareCode();
}