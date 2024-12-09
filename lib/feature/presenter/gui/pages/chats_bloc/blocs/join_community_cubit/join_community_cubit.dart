import 'package:anihan_app/common/enum_files.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';

part 'join_community_state.dart';

@injectable
class JoinCommunityCubit extends Cubit<JoinCommunityState> {
  JoinCommunityCubit() : super(JoinCommunityInitial());

  Future<JoinCommunity> joinCommunity(
      String ownerId, JoinCommunity isJoin) async {
    DatabaseReference _ref = FirebaseDatabase.instance
        .ref("community/community-id-$ownerId/members");
    User? user = FirebaseAuth.instance.currentUser;

    DatabaseReference _updateRef = _ref.push();

    var value = {
      "id": user?.uid ?? "None",
      "status": isJoin.name,
    };

    DatabaseEvent dataEvent = await _ref.once();

    var object = dataEvent.snapshot.value as Map<dynamic, dynamic>?;

    if (object != null) {
      if (object['id'] != user!.uid) {
        _updateRef.set(value);
      }
      if (object['status'].name == isJoin.name) {
        return isJoin;
      }
      return JoinCommunity.pending;
    } else {
      _updateRef.set(value);

      return isJoin;
    }
  }
}
