import 'package:flutter/material.dart';
import 'package:chat_room/pages/chatScreen.dart';
import 'package:chat_room/pages/loginScreen.dart';
import 'package:chat_room/pages/registrationScreen.dart';
import 'package:chat_room/pages/welcomeScreen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:chat_room/pages/profileCreate.dart';
import 'package:chat_room/pages/profileUser.dart';

void main()=>{runApp(
    ResponsiveSizer(
      builder: ((context, orientation, deviceType) {
        return   MaterialApp(
          theme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
          initialRoute: welcomeScreen.id,
          routes: {
            welcomeScreen.id : (context) => welcomeScreen(),
            loginScreen.id: (context) => loginScreen(),
            regScreen.id:(context)=>regScreen(),
            profileCreate.id:(context)=>profileCreate(),
            chatScreen.id:(context)=>chatScreen(),
            profileUser.id:(context)=>profileUser(),
          },
        );
      }),
    )
  )
};