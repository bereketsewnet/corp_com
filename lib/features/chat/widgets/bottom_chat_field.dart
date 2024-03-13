import 'dart:io';

import 'package:corp_com/common/enums/message_enum.dart';
import 'package:corp_com/common/utils/utils.dart';
import 'package:corp_com/features/chat/controller/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;

  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isNotShowSendButton = true;
  final _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isNotShowSendButton = false;
                    });
                  } else {
                    setState(() {
                      isNotShowSendButton = true;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: mobileChatBoxColor,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.gif,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: Visibility(
                    visible: isNotShowSendButton,
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: selectVoid,
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 2,
                right: 3,
              ),
              child: CircleAvatar(
                backgroundColor: greenColor,
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isNotShowSendButton
                        ? Icons.keyboard_voice_rounded
                        : Icons.send_rounded,
                    color: whiteColor,
                  ),
                ),
              ),
            )
          ],
        ),
       isShowEmojiContainer ? SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _messageController.text = _messageController.text+emoji.emoji;
            },
          ),
        ): const SizedBox(),
      ],
    );
  }

  void sendTextMessage() async {
    if (!isNotShowSendButton) {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVoid() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void showEmojiContainer(){
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void hideEmojiContainer(){
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void toggleEmojiKeyboardContainer(){
    if(isShowEmojiContainer){
      showKeyboard();
      hideEmojiContainer();
    }else{
      hideKeyboard();
      showEmojiContainer();
    }
  }
  // show keyboard in chat activity
  void showKeyboard () => focusNode.requestFocus();
  // hide keyboard in chat activity
  void hideKeyboard () => focusNode.unfocus();
}
