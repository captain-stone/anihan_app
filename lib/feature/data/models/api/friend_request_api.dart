import 'package:anihan_app/common/api_result.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class FriendRequestService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();
  final logger = Logger();

  Future<ApiResult<Map<String, dynamic>>> sendFriendRequest(
      String fromUserId, String toUserId) async {
    try {
      // Reference to the friend requests of the recipient
      final requestRef = _db.child('friend_requests').child(toUserId);
      // final requestRef = _db.child('friend_requests/get').child(fromUserId);

      final snapshot =
          await requestRef.orderByChild('fromUser').equalTo(fromUserId).get();
      if (!snapshot.exists) {
        // If no request exists, add a new friend request
        await requestRef.push().set({
          'fromUser': fromUserId,
          'status': 'pending',
          'timestamp': ServerValue.timestamp,
        });
        logger.d("Friend request sent successfully.");
        return const ApiResult.success(
            {"message": "Friend request sent successfully."});
      } else {
        return const ApiResult.error("Friend request already exists.");
      }
    } catch (e) {
      logger.e("Error sending friend request: $e");
      return ApiResult.error("Error sending friend request: $e");
    }
  }

  Future<void> respondToFriendRequest(
      String toUserId, String requestId, bool isAccepted) async {
    final requestRef =
        _db.child('friend_requests').child(toUserId).child(requestId);

    try {
      if (isAccepted) {
        // Update the status of the request to "accepted"
        await requestRef.update({'status': 'accepted'});

        // Add both users to each other's friends list
        final fromUserId =
            (await requestRef.child('fromUser').get()).value as String;
        await _db.child('friends').child(toUserId).child(fromUserId).set(true);
        await _db.child('friends').child(fromUserId).child(toUserId).set(true);

        logger.d("Friend request accepted and friends added.");
      } else {
        // Update the status of the request to "rejected"
        await requestRef.update({'status': 'rejected'});
        logger.d("Friend request rejected.");
      }
    } catch (e) {
      logger.e("Error responding to friend request: $e");
    }
  }

  Stream<ApiResult<List<Map<String, dynamic>>>> getFriendRequests(
      String userId) {
    return _db.child('friend_requests').child(userId).onValue.map((event) {
      final requests = <Map<String, dynamic>>[];
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        data.forEach((key, value) {
          if (value['status'] == 'pending') {
            requests.add({
              'requestId': key,
              'fromUser': value['fromUser'],
              'status': value['status'],
              'timestamp': value['timestamp'],
            });
          }
        });
      }
      return ApiResult.success(requests);
    });
  }

  Future<List<Map<String, dynamic>>> getFriendRequestsWithUserInfo(
      String userId) async {
    try {
      // Fetch friend requests for the user
      final requestSnapshot =
          await _db.child('friend_requests').child(userId).get();
      if (!requestSnapshot.exists) return [];

      final requestList = <Map<String, dynamic>>[];
      final requestData =
          Map<String, dynamic>.from(requestSnapshot.value as Map);

      // For each friend request, fetch user info from the users node
      for (final entry in requestData.entries) {
        final requestId = entry.key;
        final requestDetails = Map<String, dynamic>.from(entry.value);

        if (requestDetails['status'] == 'pending') {
          final fromUserId = requestDetails['fromUser'];

          // Fetch user info
          final userSnapshot = await _db.child('users').child(fromUserId).get();
          if (userSnapshot.exists) {
            final userInfo =
                Map<String, dynamic>.from(userSnapshot.value as Map);
            requestList.add({
              'requestId': requestId,
              'fromUserId': fromUserId,
              'status': requestDetails['status'],
              'timestamp': requestDetails['timestamp'],
              'userInfo': userInfo, // Include sender's user info
            });
          }
        }
      }

      return requestList;
    } catch (e) {
      logger.e("Error fetching friend requests: $e");
      return [];
    }
  }
}
