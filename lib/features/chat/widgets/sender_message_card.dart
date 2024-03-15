import 'package:corp_com/common/enums/message_enum.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../colors.dart';
import 'display_all_file.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.onRightSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
  }) : super(key: key);
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onRightSwipe: (details) {
        // print('Callback from Swipe To Left');
        onRightSwipe();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: senderMessageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 30,
                    top: 5,
                    bottom: 20,
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 10,
                  child: Padding(
                    padding: type == MessageEnum.text
                        ? const EdgeInsets.only(
                            left: 20,
                            right: 45,
                            top: 5,
                            bottom: 20,
                          )
                        : const EdgeInsets.only(
                            left: 5,
                            right: 5,
                            top: 5,
                            bottom: 25,
                          ),
                    child: Column(
                      children: [
                        if (isReplying) ...[
                          Text(
                            username,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: backgroundColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  5,
                                ),
                              ),
                            ),
                            child: DisplayAllFile(
                              message: repliedText,
                              type: repliedMessageType,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        DisplayAllFile(
                          message: message,
                          type: type,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
