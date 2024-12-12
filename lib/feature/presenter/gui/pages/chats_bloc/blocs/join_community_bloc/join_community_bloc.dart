import 'package:anihan_app/common/enum_files.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

part 'join_community_event.dart';
part 'join_community_state.dart';

@injectable
class JoinCommunityBloc extends Bloc<JoinCommunityEvent, JoinCommunityState> {
  JoinCommunityBloc() : super(JoinCommunityInitial()) {
    final logger = Logger();
    on<JoinCommunityByOwnerId>(
      (event, emit) async {
        emit(JoinCommunityLoadingState());

        var ownerId = event.ownerId;
        JoinCommunity isJoin = event.isJoin;
        try {
          DatabaseReference _ref = FirebaseDatabase.instance
              .ref("community/community-id-$ownerId/members");
          User? user = FirebaseAuth.instance.currentUser;

          DatabaseReference _updateRef = _ref.push();

          var value = {
            "id": user?.uid ?? "None",
            "status": isJoin.name,
            "createdAt": DateTime.now().toIso8601String(),
          };

          DatabaseEvent dataEvent = await _ref.once();

          var object = dataEvent.snapshot.value as Map<dynamic, dynamic>?;

          if (object != null) {
            if (object['id'] != user!.uid) {
              _ref.set(value);
            }
            if (object['status'] == isJoin.name) {
              // return {"ownerId": ownerId, "status": isJoin};

              emit(JoinCommunitySuccessState(
                  {"ownerId": ownerId, "status": isJoin.name}));
            }
            // return {
            //   "ownerId": ownerId,
            //   "status": JoinCommunity.pending,
            // };

            emit(JoinCommunitySuccessState({
              "ownerId": ownerId,
              "status": JoinCommunity.pending.name,
            }));
          } else {
            _updateRef.set(value);

            // return {"ownerId": ownerId, "status": isJoin};

            emit(JoinCommunitySuccessState(
                {"ownerId": ownerId, "status": isJoin.name}));
          }
        } catch (e) {
          emit(JoinCommunityErrorState("Cannot join the communit"));
        }
      },
    );

    on<GetAllJoinCommunityByOwnerId>((event, emit) async {
      emit(JoinCommunityInitial());

      var ownerId = event.ownerId;

      try {
        DatabaseReference _ref = FirebaseDatabase.instance
            .ref("community/community-id-$ownerId/members");
        User? user = FirebaseAuth.instance.currentUser;

        DatabaseEvent dataEvent = await _ref.once();

        var object = dataEvent.snapshot.value as Map<dynamic, dynamic>?;
        // logger.d("$ownerId\n$object");
        Map<String, dynamic>? data = {};
        if (object != null) {
          object.forEach((key, value) {
            if (user!.uid == value['id']) {
              data = {
                'createdAt': value['createdAt'],
                'id': value['id'],
                'status': value['status'],
                'ownerId': ownerId,
              };
            }
          });
        }

        if (data != null) {
          if (data!.isNotEmpty) {
            emit(GetAllJoinedCommunitySuccessState(data!));
          } else {
            emit(const GetAllJoinedCommunityErrorState(
                "No community data found"));
          }
        }
      } catch (e) {
        logger.e(e);
        emit(
            const GetAllJoinedCommunityErrorState("Cannot join the community"));
      }
    });
  }
}
