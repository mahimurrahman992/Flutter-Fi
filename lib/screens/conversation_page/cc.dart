import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Main page with two tabs
class ChatPages extends StatefulWidget {
  @override
  _ChatPagesState createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
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
            _buildChatTab(), // Chat Tab
            _buildContactsTab(), // Contacts Tab
          ],
        ),
      ),
    );
  }
 // Tab 1: Chat Tab - Displays all conversations with friends
  Widget _buildChatTab() {
    return StreamBuilder<QuerySnapshot>(
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
          return Center(child: Text('No conversations available.'));
        }

        var acceptedRequests = snapshot.data!.docs;

        return ListView.builder(
          itemCount: acceptedRequests.length,
          itemBuilder: (context, index) {
            var request = acceptedRequests[index].data() as Map<String, dynamic>;
            var senderId = request['sender_id'];
            var receiverId = request['receiver_id'];
            var receiverName = request['receiver_id'] == currentUserId
                ? request['sender_email'] ?? 'Unknown User'
                : request['receiver_email'] ?? 'Unknown User'; // Fetch receiver's name

            return ListTile(
              title: Text(receiverName),
              subtitle: _buildRecentMessage(senderId, receiverId), // Display the most recent message
              onTap: () {
                // Start conversation with the receiver
                _startConversation(context, senderId, receiverId, receiverName);
              },
            );
          },
        );
      },
    );
  }

  // Display the most recent message between the sender and receiver
  Widget _buildRecentMessage(String senderId, String receiverId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('sender_id', isEqualTo: senderId)
          .where('receiver_id', isEqualTo: receiverId)
          .orderBy('timestamp', descending: true) // Get most recent message
          .limit(1) // Limit to 1 message
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading...");
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No messages yet.');
        }

        var messageData = snapshot.data!.docs[0].data() as Map<String, dynamic>;
        var messageContent = messageData['message'];
        return Text(messageContent); // Display the most recent message
      },
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

          if (requestData['sender_id'] == currentUserId || requestData['receiver_id'] == currentUserId) {
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
              future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
              builder: (context, senderSnapshot) {
                if (!senderSnapshot.hasData) {
                  return ListTile(title: Text("Loading..."));
                }

                var senderName = senderSnapshot.data!['fullName'] ?? 'Unknown User';
                var senderEmail = senderSnapshot.data!['email'] ?? 'No Email';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                  builder: (context, receiverSnapshot) {
                    if (!receiverSnapshot.hasData) {
                      return ListTile(title: Text("Loading..."));
                    }

                    var receiverName = receiverSnapshot.data!['fullName'] ?? 'Unknown User';
                    var receiverEmail = receiverSnapshot.data!['email'] ?? 'No Email';

                    // Display the opposite user's information based on whether the current user is the sender or receiver
                    return ListTile(
                      title: Text(currentUserId == senderId ? receiverName : senderName), // Show receiver's name if sender, else sender's name
                      subtitle: Text(currentUserId == senderId ? receiverEmail : senderEmail), // Show receiver's email if sender, else sender's email
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

  // Start the conversation by navigating to the chat detail page
  void _startConversation(BuildContext context, String receiverId, String senderId, String receiverName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailPage(
          receiverId: receiverId,
          senderId: senderId,
          receiverName: receiverName,
        ),
      ),
    );
  }
}


// Chat details page where messages will be displayed
class ChatDetailPage extends StatefulWidget {
  final String receiverId;
  final String senderId;
  final String receiverName;

  ChatDetailPage({
    required this.receiverId,
    required this.senderId,
    required this.receiverName,
  });

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.receiverName}"),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()), // Display messages in real-time
          _buildMessageInput(), // Text input field for sending messages
        ],
      ),
    );
  }

  // Fetch and display messages between the sender and receiver
  Widget _buildMessagesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .where('sender_id', isEqualTo: currentUserId)
          .where('receiver_id', isEqualTo: widget.receiverId)
          .orderBy('timestamp', descending: true) // Order by timestamp to show messages chronologically
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet.'));
        }

        var messages = snapshot.data!.docs;

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            var message = messages[index].data() as Map<String, dynamic>;
            var messageContent = message['message'];
            var senderId = message['sender_id'];
            var timestamp = message['timestamp'].toDate();

            return ListTile(
              title: Text(senderId == currentUserId ? 'You' : widget.receiverName),
              subtitle: Text(messageContent),
              trailing: Text(timestamp.toString()),
            );
          },
        );
      },
    );
  }

  // Build the input field for sending messages
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  // Send a message to the receiver
  void _sendMessage() {
    if (_messageController.text.isEmpty) return;

    FirebaseFirestore.instance.collection('chats').add({
      'sender_id': currentUserId,
      'receiver_id': widget.receiverId,
      'message': _messageController.text,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _messageController.clear(); // Clear the message input
  }
}

/*  // Build the second tab with the list of users/admins (friends)
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

          if (requestData['sender_id'] == currentUserId || requestData['receiver_id'] == currentUserId) {
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
              future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
              builder: (context, senderSnapshot) {
                if (!senderSnapshot.hasData) {
                  return ListTile(title: Text("Loading..."));
                }

                var senderName = senderSnapshot.data!['fullName'] ?? 'Unknown User';
                var senderEmail = senderSnapshot.data!['email'] ?? 'No Email';

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(receiverId).get(),
                  builder: (context, receiverSnapshot) {
                    if (!receiverSnapshot.hasData) {
                      return ListTile(title: Text("Loading..."));
                    }

                    var receiverName = receiverSnapshot.data!['fullName'] ?? 'Unknown User';
                    var receiverEmail = receiverSnapshot.data!['email'] ?? 'No Email';

                    // Display the opposite user's information based on whether the current user is the sender or receiver
                    return ListTile(
                      title: Text(currentUserId == senderId ? receiverName : senderName), // Show receiver's name if sender, else sender's name
                      subtitle: Text(currentUserId == senderId ? receiverEmail : senderEmail), // Show receiver's email if sender, else sender's email
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
  } */