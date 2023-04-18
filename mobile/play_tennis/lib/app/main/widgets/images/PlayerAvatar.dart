import 'package:flutter/material.dart';
import 'package:play_tennis/main-settings.dart';
import 'CrocoAppImage.dart';

class PlayerAvatar extends StatelessWidget {
  final int? avatarFileId;

  const PlayerAvatar({
    super.key,
    required this.avatarFileId,
  });

  @override
  Widget build(BuildContext context) {
    return avatarFileId != null
        ? CrocoAppImage(
            imageFileId: avatarFileId!,
          )
        : const Image(
            image: NetworkImage(
              MainSettings.defaultAvatarPath,
            ),
          );
  }
}
