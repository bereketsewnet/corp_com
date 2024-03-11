import 'package:corp_com/common/enums/message_enum.dart';
import 'package:corp_com/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DisplayAllFile extends StatelessWidget {
  final String message;
  final MessageEnum type;

  const DisplayAllFile({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(
              fontSize: 16,
            ),
          )
        : type == MessageEnum.video
            ? VideoPlayerItem(
                videoUrl: message,
              )
            : CachedNetworkImage(
                imageUrl: message,
              );
  }
}
