import 'package:chat_room/pages/chatScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupTile extends StatefulWidget {
  const GroupTile({Key? key,required this.groupId}) : super(key: key);
  final String groupId;
  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  late final grpDetails;
  String name = "";
  String by = "";
  String grpIcon = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupDetails();
  }
  void getGroupDetails()async{
    final _fireStore = FirebaseFirestore.instance;
    final grpDetails = await _fireStore.collection("groups").doc(widget.groupId).get();
    setState(() {
      name = grpDetails["name"];
      by = grpDetails["createdBy"];
      grpIcon = grpDetails["groupIcon"];
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding:const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: (){
          Navigator.pushNamed(context, chatScreen.id,arguments: {"groupId":widget.groupId,"groupName":name,"createdBy":by});
        },
        child: ListTile(
          leading: grpIcon != "" ?CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(grpIcon)
          ):const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: CircularProgressIndicator(color: Colors.blue,strokeWidth: 15,),),
          title:Text(name,style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
          subtitle:Text("Created by: $by",style: GoogleFonts.poppins(color: Colors.white,fontSize: 12),),
        ),
      )
    );
  }
}