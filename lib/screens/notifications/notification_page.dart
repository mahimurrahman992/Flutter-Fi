/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_flutter_fi/services/firebase_services.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Friend Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('friend_requests')
            .where('status', isEqualTo: 'pending')
            .where('receiver_id', isEqualTo: userId)  // Pending requests for the receiver
            .snapshots(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Show loading spinner
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Display any error from the stream
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pending requests.'));  // Handle empty state
          }

          var requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              var request = requests[index].data() as Map<String, dynamic>;
              var senderId = request['sender_id'];
              var requestId = requests[index].id; // Access the document ID here

              // Fetch the sender's full name and email
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return ListTile(title: Text("Loading..."));
                  }

                  var senderName = userSnapshot.data!['fullName'] ?? 'Unknown User';
                  var senderEmail = userSnapshot.data!['email'] ?? 'No Email';

                  return ListTile(
                    title: Text('Request from $senderName'),
                    subtitle: Text(senderEmail),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () => FirebaseService.acceptRequest(requestId),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => FirebaseService.rejectRequest(requestId),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
*/