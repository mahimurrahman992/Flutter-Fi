/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Chat"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Chat"), // Tab 1 for chat
              Tab(text: "My Contacts"), // Tab 2 for contacts/friends list
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Tab(text: "Chat"), // Tab 1 for chat
            _buildContactsTab(), // Contacts Tab
          ],
        ),
      ),
    );
  }

  // Build the second tab with the list of users/admins (friends)
  Widget _buildContactsTab() {
    return StreamBuilder<QuerySnapshot>(
      // Query both sender_id and receiver_id for real-time updates
      stream: FirebaseFirestore.instance
          .collection('friend_requests')
          .where('status', isEqualTo: 'accepted') // Only accepted requests
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No contacts available.'));
        }

        var requests = snapshot.data!.docs;
        var acceptedRequests = [];

        // Filter out requests where either the current user is the sender or receiver
        for (var request in requests) {
          var requestData = request.data() as Map<String, dynamic>;

          if (requestData['sender_id'] == currentUserId ||
              requestData['receiver_id'] == currentUserId) {
            acceptedRequests.add(requestData);
          }
        }

        return ListView.builder(
          itemCount: acceptedRequests.length,
          itemBuilder: (context, index) {
            var request = acceptedRequests[index];
            var senderId = request['sender_id'];
            var receiverId = request['receiver_id'];
            var acceptedTime = request['accepted_time'].toDate();

            // Fetch the sender's full name and email
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(senderId)
                  .get(),
              builder: (context, senderSnapshot) {
                if (!senderSnapshot.hasData) {
                  return ListTile(title: Text("Loading..."));
                }

                var senderName =
                    senderSnapshot.data!['fullName'] ?? 'Unknown User';
                var senderEmail = senderSnapshot.data!['email'] ?? 'No Email';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(receiverId)
                      .get(),
                  builder: (context, receiverSnapshot) {
                    if (!receiverSnapshot.hasData) {
                      return ListTile(title: Text("Loading..."));
                    }

                    var receiverName =
                        receiverSnapshot.data!['fullName'] ?? 'Unknown User';
                    var receiverEmail =
                        receiverSnapshot.data!['email'] ?? 'No Email';

                    // Display the opposite user's information based on whether the current user is the sender or receiver
                    return ListTile(
                      title: Text(currentUserId == senderId
                          ? receiverName
                          : senderName), // Show receiver's name if sender, else sender's name
                      subtitle: Text(currentUserId == senderId
                          ? receiverEmail
                          : senderEmail), // Show receiver's email if sender, else sender's email
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('Sender ID: $senderId'),
                          Text('Receiver ID: $receiverId'),
                          Text('Accepted Time: ${acceptedTime.toString()}'),
                        ],
                      ),
                      onTap: () {
                        // Add functionality to start chat with selected contact
                        // (not implemented for now)
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
*/