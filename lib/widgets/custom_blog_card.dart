
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:myflutterfi/const/colors.dart';
import 'package:myflutterfi/const/styles.dart';
import 'package:myflutterfi/providers/like_provider.dart';
import 'package:myflutterfi/providers/theme_provider.dart';
import 'package:myflutterfi/screens/auth/auth_screen.dart';
import 'package:myflutterfi/screens/features_screeen/developers/user_profile_screen.dart';
import 'package:myflutterfi/widgets/comment_section.dart';
import 'package:myflutterfi/widgets/gradient_text.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CustomBlogCard extends StatefulWidget {
  final String blogId;
  final String title;
  final String content;
  final String category;
  final String adminEmail;
  final String fullName;
  final bool isLarge;
  final Timestamp createdAt;
  final List<String>? imageUrls;

  const CustomBlogCard({
    Key? key,
    required this.blogId,
    required this.title,
    required this.content,
    required this.category,
    required this.adminEmail,
    required this.fullName,
    this.isLarge = false,
    required this.createdAt,
    this.imageUrls,
  }) : super(key: key);

  @override
  _CustomBlogCardState createState() => _CustomBlogCardState();
}

class _CustomBlogCardState extends State<CustomBlogCard> {
  bool _showFullContent = false;
  int _currentImageIndex = 0;
  int _dialogImageIndex = 0;

  void _showBlogDetailsDialog(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context, listen: false);
    final isMobile = MediaQuery.of(context).size.width < 800;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 50,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Carousel
                if (widget.imageUrls != null && widget.imageUrls!.isNotEmpty)
                  Column(
                    children: [
                      SizedBox(
                        height: isMobile ? 250 : 400,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            height: isMobile ? 250 : 400,
                            viewportFraction: 1.0,
                            enlargeCenterPage: false,
                            autoPlay: widget.imageUrls!.length > 1,
                            autoPlayInterval: Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _dialogImageIndex = index;
                              });
                            },
                          ),
                          items:
                              widget.imageUrls!.map((url) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage(url),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                );
                              }).toList(),
                        ),
                      ),
                      if (widget.imageUrls!.length > 1)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                widget.imageUrls!.asMap().entries.map((entry) {
                                  return Container(
                                    width: 8.0,
                                    height: 8.0,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          _dialogImageIndex == entry.key
                                              ? Colors.deepPurple
                                              : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                    ],
                  )
                else
                  Container(
                    height: isMobile ? 250 : 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.grey[300],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.grey[600]),
                          SizedBox(height: 8),
                          Text(
                            'No images available',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Blog Content
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.isDarkTheme ? darkCardColor : lightCardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      GradientText(
                        text: widget.title,
                        fontSize: isMobile ? 20 : 24,
                        fw: FontWeight.bold,
                      ),
                      SizedBox(height: 15),

                      // Metadata
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              'Category: ${widget.category}',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'By: ${widget.fullName}',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                DateFormat(
                                  'MMMM dd, yyyy, h:mm a',
                                ).format(widget.createdAt.toDate()),
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),

                      // Content
                      SelectableText(
                        widget.content,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: isMobile ? 16 : 18,
                          color:
                              theme.isDarkTheme
                                  ? darkPrimaryTextColor
                                  : lightprimarytextColor,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Like Section
                      Row(
                        children: [
                          if (FirebaseAuth.instance.currentUser != null)
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () async {
                                var likeProvider = Provider.of<LikeProvider>(
                                  context,
                                  listen: false,
                                );
                                await likeProvider.likeBlog(widget.blogId);
                              },
                            ),
                          StreamBuilder<DocumentSnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('blogs')
                                    .doc(widget.blogId)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text('Loading likes...');
                              }
                              var blogData =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              List<dynamic> likes = blogData['likes'] ?? [];

                              return likes.isNotEmpty
                                  ? Text(
                                    '${likes.length} likes',
                                    style: TextStyle(
                                      fontSize: isMobile ? 14 : 16,
                                      color:
                                          theme.isDarkTheme
                                              ? darkPrimaryTextColor
                                              : lightprimarytextColor,
                                    ),
                                  )
                                  : SizedBox.shrink();
                            },
                          ),
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Close',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = FirebaseAuth.instance.currentUser;
    final theme = Provider.of<ThemeProvider>(context);

    String formattedDate = DateFormat(
      'MMMM dd, yyyy, h:mm a',
    ).format(widget.createdAt.toDate());

    return LayoutBuilder(
      builder: (context, constraints) {
        double screenWidth = MediaQuery.of(context).size.width;
       
        bool isMobile = screenWidth < 800;
        double padding = isMobile ? 10.0 : 20.0;
        double fontSize = isMobile ? 16.0 : 18.0;
        double cardElevation = widget.isLarge ? 8 : 4;
        double titleFontSize = isMobile ? fontSize + 4 : fontSize + 6;

        return GestureDetector(
          onTap: () => _showBlogDetailsDialog(context),
          child: Container(
            width:
                isMobile
                    ? double.infinity
                    : screenWidth * 0.7, // Adjust width for larger screens
            child: Card(
              margin: EdgeInsets.all(16),
              elevation: cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: theme.isDarkTheme ? darkCardColor : lightCardColor,
              shadowColor:
                  theme.isDarkTheme
                      ? darkCardShadowColor
                      : lightcardshadowColor,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Carousel
                    if (widget.imageUrls != null &&
                        widget.imageUrls!.isNotEmpty)
                      Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 1.0,
                              enlargeCenterPage: false,
                              autoPlay: widget.imageUrls!.length > 1,
                              autoPlayInterval: Duration(seconds: 3),
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentImageIndex = index;
                                });
                              },
                            ),
                            items:
                                widget.imageUrls!.map((url) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(horizontal: 4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(url),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  );
                                }).toList(),
                          ),
                          if (widget.imageUrls!.length > 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:
                                  widget.imageUrls!.asMap().entries.map((
                                    entry,
                                  ) {
                                    return Container(
                                      width: 8.0,
                                      height: 8.0,
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8.0,
                                        horizontal: 4.0,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            _currentImageIndex == entry.key
                                                ? Colors.deepPurple
                                                : Colors.grey,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          SizedBox(height: 10),
                        ],
                      )
                    else
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[300],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey[600],
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No images available',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GradientText(
                            text: widget.title,
                            fontSize: titleFontSize,
                            fw: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.save, color: Colors.deepPurple),
                          onPressed: () async {
                            var user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthScreen(),
                                ),
                              );
                            } else {
                              var userUid = user.uid;
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userUid)
                                  .update({
                                    'savedBlogs': FieldValue.arrayUnion([
                                      widget.blogId,
                                    ]),
                                  });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Blog saved successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),

                    SizedBox(height: 5),
                    // Metadata
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            'Category: ${widget.category}',
                            style: TextStyle(
                              fontSize: fontSize - 2,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'By: ${widget.fullName}',
                              style: TextStyle(
                                fontSize: fontSize - 4,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Published: $formattedDate',
                              style: TextStyle(
                                fontSize: fontSize - 4,
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Content Preview
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _showFullContent
                            ? SelectableText(
                              widget.content,
                              style: myStyle(
                                fontSize,
                                theme.isDarkTheme
                                    ? darkPrimaryTextColor
                                    : lightprimarytextColor,
                              ),
                            )
                            : Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: myStyle(
                                      fontSize,
                                      theme.isDarkTheme
                                          ? darkPrimaryTextColor
                                          : lightprimarytextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        if (widget.content.length > 50)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showFullContent = !_showFullContent;
                              });
                            },
                            child: Text(
                              _showFullContent ? 'See Less' : 'See More',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Like Section
                    Row(
                      children: [
                        if (currentUser != null)
                          IconButton(
                            icon: Icon(
                              Icons.thumb_up,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () async {
                              var likeProvider = Provider.of<LikeProvider>(
                                context,
                                listen: false,
                              );
                              await likeProvider.likeBlog(widget.blogId);
                            },
                          ),
                        if (currentUser == null)
                          Text(
                            'Login to like/comment',
                            style: myStyle(
                              16,
                              theme.isDarkTheme
                                  ? darkSecTextColor
                                  : lightsectextColor,
                            ),
                          ),
                        SizedBox(width: 10),
                        StreamBuilder<DocumentSnapshot>(
                          stream:
                              FirebaseFirestore.instance
                                  .collection('blogs')
                                  .doc(widget.blogId)
                                  .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text('Loading likes...');
                            }
                            var blogData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            List<dynamic> likes = blogData['likes'] ?? [];

                            return likes.isNotEmpty
                                ? InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text(
                                              'Liked By',
                                              style: myStyle(
                                                16,
                                                theme.isDarkTheme
                                                    ? darkPrimaryTextColor
                                                    : lightprimarytextColor,
                                                FontWeight.w600,
                                              ),
                                            ),
                                            content: Container(
                                              width: double.maxFinite,
                                              height: 200,
                                              child: ListView.builder(
                                                itemCount: likes.length,
                                                itemBuilder: (context, index) {
                                                  var like = likes[index];
                                                  var fullName =
                                                      like['fullName'];
                                                  var email = like['email'];
var image=like['avatarUrl'];
                                                  return InkWell(
                                                    onTap: () async {
                                                      try {
                                                        var userSnapshot =
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                  'users',
                                                                )
                                                                .where(
                                                                  'email',
                                                                  isEqualTo:
                                                                      email,
                                                                )
                                                                .limit(1)
                                                                .get();

                                                        if (userSnapshot
                                                            .docs
                                                            .isNotEmpty) {
                                                          var userId =
                                                              userSnapshot
                                                                  .docs
                                                                  .first
                                                                  .id;
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => UserProfilePage(
                                                                    userId:
                                                                        userId,
                                                                  ),
                                                            ),
                                                          );
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                            context,
                                                          ).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                'User not found',
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        print(
                                                          'Error fetching userId: $e',
                                                        );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Error fetching user data',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    child: ListTile(leading: ClipOval(child:Image.network(image),),
                                                      title: Text(fullName),
                                                      subtitle: SelectableText(
                                                        email,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  child: Text(
                                    '${likes.length} likes',
                                    style: myStyle(
                                      16,
                                      theme.isDarkTheme
                                          ? darkPrimaryTextColor
                                          : lightprimarytextColor,
                                    ),
                                  ),
                                )
                                : SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                    // Comment Section
                    CommentSection(blogId: widget.blogId),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
