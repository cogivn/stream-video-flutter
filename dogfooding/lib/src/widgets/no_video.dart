import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class NoVideoWidget extends StatelessWidget {
  const NoVideoWidget({
    Key? key,
    required this.participant,
  }) : super(key: key);

  final Participant participant;

  @override
  Widget build(BuildContext context) {
    var userId = participant.userId;

    return Center(
      child: StreamUserAvatar(
        user: UserInfo(
          id: userId,
          role: "admin",
          name: userId,
        ),
        avatarTheme: StreamAvatarTheme(
          initialsTextStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          constraints: const BoxConstraints.tightFor(
            height: 96,
            width: 96,
          ),
          borderRadius: BorderRadius.circular(48),
        ),
      ),
    );
  }
}
