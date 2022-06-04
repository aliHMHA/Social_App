import 'package:cloud_firestore/cloud_firestore.dart';

class SocialUser {
  String email;
  String uid;
  String name;
  String imageURL;
  String coverURL;
  List? likes;
  List? followers;
  List? following;
  List? posts;
  List? comments;
  List? sharesrecived;
  String bio;
  String phone;

  SocialUser(
      {required this.email,
      required this.uid,
      required this.phone,
      required this.bio,
      required this.imageURL,
      required this.coverURL,
      this.likes,
      this.followers,
      this.following,
      this.posts,
      this.comments,
      this.sharesrecived,
      required this.name});

  static SocialUser fromJeson(Map<String, dynamic> json) {
    return SocialUser(
      email: json['email'],
      uid: json['uid'],
      imageURL: json['imageURL'],
      coverURL: json['coverURL'],
      likes: json['likes'],
      followers: json['followers'],
      following: json['following'],
      posts: json['posts'],
      comments: json['comments'],
      sharesrecived: json['sharesrecived'],
      bio: json['bio'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  static SocialUser fromsnap(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return SocialUser(
      email: data['email'],
      uid: data['uid'],
      imageURL: data['imageURL'],
      coverURL: data['coverURL'],
      likes: data['likes'],
      followers: data['followers'],
      following: data['following'],
      posts: data['posts'],
      comments: data['comments'],
      sharesrecived: data['sharesrecived'],
      bio: data['bio'],
      name: data['name'],
      phone: data['phone'],
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'email': email,
      'uid': uid,
      'bio': bio,
      'imageURL': imageURL,
      'coverURL': coverURL,
      'likes': likes,
      'followers': followers,
      'following': following,
      'posts': posts,
      'comments': comments,
      'sharesrecived': sharesrecived,
      'name': name,
      'phone': phone,
    };
  }

  // Map<String, dynamic> tomapforedite() {
  //   return {
  //     'email': email,
  //     'uid': uid,
  //     'bio': bio,
  //     'imageURL': imageURL,
  //     'coverURL': coverURL,
  //     'name': name,
  //     'phone': phone,
  //   };
  // }
}
