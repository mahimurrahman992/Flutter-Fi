class FriendRequest {
  String senderId;
  String receiverId;
  String status;  // Pending, Accepted, Declined

  FriendRequest({
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  // Convert to map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
    };
  }

  // Convert from map to FriendRequest
  static FriendRequest fromMap(Map<String, dynamic> map) {
    return FriendRequest(
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      status: map['status'],
    );
  }
}
