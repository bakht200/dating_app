import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/controller/profile_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/app_theme.dart';
import '../constants/secure_storage.dart';
import '../widgets/primary_button_widget.dart';
import '../widgets/profile_avatar.dart';

class DescriptionPostScreen extends StatefulWidget {
  const DescriptionPostScreen({Key? key}) : super(key: key);

  @override
  State<DescriptionPostScreen> createState() => _DescriptionPostScreenState();
}

class _DescriptionPostScreenState extends State<DescriptionPostScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final profileController = Get.put(ProfileController());

  var imagePath;
  String? userName;
  final List<String> postItems = [
    'GBV',
    'Mens health',
    'Womens health',
    'Crime',
    'General',
    'Kids',
    'Religion',
    'Tradition',
    'Entrepreneurship',
    'Business Law',
    'Education',
    'Sports',
    'Domestic',
    'Ads',
    'Teen Pregnancy',
    'Health',
    'Depression',
    'Anxiety'
  ];
  String? postType;
  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
  }

  fetchCurrentUserName() async {
    userName = await UserSecureStorage.fetchUserName();
    await profileController.getUserData();
    imagePath = profileController.userInformation.first['profileImage'][0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              flex: 2,
              child: SizedBox(
                  width: double.infinity / 2,
                  height: 40.h,
                  child: theme_primary_button_widget(
                      primaryColor: Color(AppTheme.primaryColor),
                      textColor: Color(0xFFFAFAFA),
                      onpressFunction: () async {},
                      title: 'Write a text'))),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.all(12.r),
              height: 200.h,
              child: TextField(
                controller: descriptionController,
                maxLines: 15,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8.0.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0.r),
                  ),
                  hintText: "Enter a description",
                  fillColor: Colors.grey[200],
                  filled: true,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
              width: 200.w,
              height: 40.h,
              child: theme_primary_button_widget(
                  primaryColor: Color(AppTheme.primaryColor),
                  textColor: Color(0xFFFAFAFA),
                  onpressFunction: () {
                    if (descriptionController.text.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                  title: Text(
                                    "Information",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Color(AppTheme.primaryColor),
                                    ),
                                  ),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          "Post type",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Color(AppTheme.primaryColor),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection('category')
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData)
                                                return Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                );
                                              var length =
                                                  snapshot.data!.docs.length;
                                              DocumentSnapshot ds = snapshot
                                                  .data!.docs[length - 1];

                                              return Container(
                                                padding: EdgeInsets.only(
                                                    bottom: 16.0.h),
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 4,
                                                      child: InputDecorator(
                                                        decoration: InputDecoration(
                                                            labelText:
                                                                'e.g Funny',
                                                            labelStyle: TextStyle(
                                                                fontSize: 13.sp,
                                                                color:
                                                                    Colors.grey[
                                                                        400])),
                                                        isEmpty:
                                                            postType == null,
                                                        child:
                                                            DropdownButtonHideUnderline(
                                                          child:
                                                              DropdownButton2(
                                                            value: postType,
                                                            isDense: true,
                                                            onChanged: (String?
                                                                newValue) {
                                                              setState(() {
                                                                postType =
                                                                    newValue;
                                                              });
                                                            },
                                                            items: snapshot
                                                                .data!.docs
                                                                .map((DocumentSnapshot
                                                                    document) {
                                                              return DropdownMenuItem<
                                                                      String>(
                                                                  value: document[
                                                                      'categoryName'],
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5.0)),
                                                                    height:
                                                                        100.0,
                                                                    child: Text(
                                                                        document[
                                                                            'categoryName']),
                                                                  ));
                                                            }).toList(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ]),
                                  actions: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.only(top: 3.h, left: 3.w),
                                      child: MaterialButton(
                                        minWidth: 40.w,
                                        height: 40.h,
                                        onPressed: () async {
                                          if (postType == null) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please Select the values.");
                                          } else {
                                            await profileController.insertPost(
                                                null,
                                                descriptionController.text,
                                                context,
                                                postType,
                                                imagePath,
                                                'descriptionPost');
                                          }
                                        },
                                        color: Color(AppTheme.primaryColor),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7.r),
                                        ),
                                        child: Text(
                                          "Post",
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]);
                            },
                          );
                        },
                      );
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please write some description");
                    }
                  },
                  title: 'Submit Post')),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }
}
