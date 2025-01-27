import 'package:chat_room/pages/profileUserShow.dart';
import 'package:chat_room/pages/settingsScreen.dart';
import 'package:chat_room/pages/welcome_screen.dart';
import 'package:chat_room/services/themeDataService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import '../consts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:ionicons/ionicons.dart';
import 'dart:io';

import '../services/cloudStorageService.dart';

class MainScreenDrawer extends StatefulWidget {
  const MainScreenDrawer(
      {Key? key,
      required this.imageUrl,
      required this.userName,
      required this.userUid})
      : super(key: key);
  final String imageUrl;
  final String userName;
  final String userUid;
  @override
  State<MainScreenDrawer> createState() => _MainScreenDrawerState();
}

class _MainScreenDrawerState extends State<MainScreenDrawer> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String userProfilePicturePath = "";
  MainScreenTheme themeData = MainScreenTheme();

  @override
  void initState() {
    super.initState();
    setState(() {});
    themeData.addListener(themeListener);
    checkLocalProfilePicture();
  }

  @override
  void dispose() {
    super.dispose();
    themeData.removeListener(themeListener);
  }

  Future checkLocalProfilePicture() async {
    bool isDirExist =
        await HelperFunctions.checkIfLocalDirExistsInStorage("userData");
    if (!isDirExist) {
      await HelperFunctions.createLocalDirInStorage("userData");
    }
    final appDocDir = await getExternalStorageDirectory();
    String imgName = "${widget.userUid}_${widget.userName}.jpg";
    String cloudImgName = "${widget.userUid}.jpg";
    String filePath = "${appDocDir?.path}/userData/$imgName";
    final file = File(filePath);
    bool doesFileExist = await file.exists();
    if (!doesFileExist) {
      String result = await CloudStorageService.downloadLocalImg(
          cloudImgName, filePath, "userProfilePictures");
      if (result != "error") {
        if (mounted) {
          setState(() {
            userProfilePicturePath = result;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          userProfilePicturePath = filePath;
        });
      }
    }
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  popOutOfContext() {
    Navigator.of(context).pop();
  }

  userLogOut() {
    _auth.signOut();
    Navigator.popAndPushNamed(context, WelcomeScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 10,
        width: MediaQuery.of(context).size.width * 0.8,
        backgroundColor: MainScreenTheme.mainScreenBg == Colors.black
            ? HexColor("111111")
            : MainScreenTheme.mainScreenBg,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              StreamBuilder(
                stream: _fireStore
                    .collection("users")
                    .doc(widget.userUid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    String userName = snapshot.data["userName"];
                    String userDpUrl = snapshot.data["profileImgLink"];
                    ImageProvider<Object>? dp() {
                      if (userProfilePicturePath != "") {
                        return FileImage(File(userProfilePicturePath));
                      } else if (snapshot.data["profileImgLink"] != "") {
                        return NetworkImage(snapshot.data["profileImgLink"]);
                      }
                      return null;
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            (userProfilePicturePath != "" &&
                                    snapshot.data["profileImgLink"] != "")
                                ? CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    backgroundImage: dp(),
                                  )
                                : const CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white,
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      strokeWidth: 8,
                                    ),
                                  ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.423,
                                      child: Text(
                                        userName,
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, profileUserShow.id,
                                          arguments: {
                                            "senderUid": widget.userUid,
                                            "isMe": true,
                                            "userProfilePicturePath":
                                                userProfilePicturePath,
                                          });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: MainScreenTheme.mainScreenBg ==
                                                Colors.black
                                            ? Colors.black
                                            : Colors.black26,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "View profile ",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                            ),
                                            const Icon(
                                              Ionicons.eye_outline,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  popOutOfContext();
                  HelperFunctions.popUpGrpCreateDialog(
                      context, widget.userName, widget.userUid);
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(
                  Icons.person_add_alt_1,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Create group",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, SettingsScreen.id);
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
              const Expanded(child: SizedBox()),
              const Divider(
                color: Colors.white12,
                indent: 20,
                endIndent: 20,
                height: 2,
              ),
              ListTile(
                onTap: () {
                  showDialogBox(
                      context,
                      'Log Out?',
                      "You can login again by entering your credentials.",
                      Colors.red,
                      userLogOut,
                      popOutOfContext);
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 30,
                ),
                title: Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          ),
        ));
  }
}
