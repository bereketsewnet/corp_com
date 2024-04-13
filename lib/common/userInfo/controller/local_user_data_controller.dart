import 'package:corp_com/common/userInfo/repository/local_user_data_repository.dart';
import 'package:corp_com/models/chat_contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final localUserDataControllerProvider = Provider.autoDispose((ref) {
  final localUserDataRepository = ref.watch(localUserDataRepoProvider);
  return LocalUserDataController(
    localUserDataRepository: localUserDataRepository,
    ref: ref,
  );
});

class LocalUserDataController {
  final LocalUserDataRepository localUserDataRepository;
  final ProviderRef ref;

  LocalUserDataController({
    required this.localUserDataRepository,
    required this.ref,
  });
  saveStartChattingUserList(ChatContact contact) {
    ref.read(localUserDataRepoProvider).saveStartChattingUserList(contact);
  }

  Future<List<ChatContact>> getChattingUserList() {
    return ref.read(localUserDataRepoProvider).getChattingUserList();
  }

}
