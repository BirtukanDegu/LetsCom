import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../model/User.dart' as model;
import 'package:flutter/material.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/screens/chat/chat_screen.dart';
import 'package:provider/provider.dart';
import '../../HI_pages/styles/colors.dart';
import '../../HI_pages/styles/styles.dart';
import '../screens/appointment.dart';
import '../../../Services/sound_to_text.dart';
import '../../../Services/text_to_speech.dart';
import 'package:let_com/screens/profile/profile_screen.dart';

import '../../HI_pages/screens/assistant_detail.dart';

List<Map> Assistants = [
  {
    'img': 'assets/images/assistant02.jpeg',
    'assistantName': 'Mr. Abebe Kebede',
    'assistantLocation': 'Debrebirihan'
  },
  {
    'img': 'assets/images/assistant03.jpeg',
    'assistantName': 'Ms. Almaz Nadew',
    'assistantLocation': 'Wolayta'
  },
  {
    'img': 'assets/images/assistant02.jpeg',
    'assistantName': 'Mr. Kebede Abebe',
    'assistantLocation': 'Fiche'
  },
  {
    'img': 'assets/images/assistant03.jpeg',
    'assistantName': 'Ms. Azeb Mesfen',
    'assistantLocation': 'Arat Kilo'
  }
];

class HomeTab extends StatefulWidget {
  final void Function() onPressedScheduleCard;

  const HomeTab({
    Key? key,
    required this.onPressedScheduleCard,
  }) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            UserIntro(),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      onFieldSubmitted: (String _) {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search,
                              color: Color(MyColors.purple02)),
                          onPressed: () {
                            setState(() {
                              isSearching = true;
                            });
                          },
                        ),
                        border: InputBorder.none,
                        // Remove the border
                        //   border: OutlineInputBorder(
                        //     borderSide: BorderSide.none,
                        //     borderRadius: BorderRadius.zero,
                        //  ),
                        hintText: 'Search assistant ...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Color(MyColors.purple01),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CategoryIcons(),
            SizedBox(
              height: 40,
            ),
            isSearching
                ? Column(
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'assistant')
                            .where('firstName',
                                isGreaterThanOrEqualTo: searchController.text)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return TopAssistantCard(
                                documentSnapshot: snapshot.data!.docs[index],
                                uid: snapshot.data!.docs[index]['uid'],
                                img: snapshot.data!.docs[index]['photoUrl'] ==
                                        ''
                                    ? AssetImage(Assistants[Random()
                                        .nextInt(Assistants.length)]['img'])
                                    : NetworkImage(snapshot.data!.docs[index]
                                        ['photoUrl']) as ImageProvider<Object>,
                                AssistantName: snapshot.data!.docs[index]
                                        ['firstName'] +
                                    " " +
                                    snapshot.data!.docs[index]['lastName'],
                                assistantLocation: snapshot.data!.docs[index]
                                    ['address'],
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                          onPressed: () {
                            isSearching = false;
                            setState(() {});
                          },
                          child: Text('Go Back'))
                    ],
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Your today\'s appointment',
                            style: kTitleStyle,
                          ),
                          TextButton(
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: Color(MyColors.yellow01),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {},
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppointmentCard(
                        onTap: widget.onPressedScheduleCard,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Top Assistants',
                        style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .where('role', isEqualTo: 'assistant')
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return TopAssistantCard(
                                documentSnapshot: snapshot.data!.docs[index],
                                uid: snapshot.data!.docs[index]['uid'],
                                img: snapshot.data!.docs[index]['photoUrl'] ==
                                        ''
                                    ? AssetImage(Assistants[Random()
                                        .nextInt(Assistants.length)]['img'])
                                    : NetworkImage(snapshot.data!.docs[index]
                                        ['photoUrl']) as ImageProvider<Object>,
                                AssistantName: snapshot.data!.docs[index]
                                        ['firstName'] +
                                    " " +
                                    snapshot.data!.docs[index]['lastName'],
                                assistantLocation: snapshot.data!.docs[index]
                                    ['address'],
                              );
                            },
                          );
                        },
                      )
                    ],
                  )
            // for (var Assistant in Assistants)
            //   TopAssistantCard(
            //     img: Assistant['img'],
            //     AssistantName: Assistant['assistantName'],
            //     assistantLocation: Assistant['assistantLocation'],
            //   )
          ],
        ),
      ),
    );
  }
}

class TopAssistantCard extends StatelessWidget {
  String uid;
  ImageProvider<Object> img;
  DocumentSnapshot documentSnapshot;
  String AssistantName;
  String assistantLocation;

  TopAssistantCard({
    required this.documentSnapshot,
    required this.uid,
    required this.img,
    required this.AssistantName,
    required this.assistantLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SliverAssistantDetail(
                      img: img,
                      assUser: model.User.fromSnap(documentSnapshot, uid),
                      uid: uid,
                      name: AssistantName,
                    )),
          );
        },
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: 100,
              child: CircleAvatar(
                radius: 30.0,
                backgroundImage: img,
                backgroundColor: Colors.transparent,
              ),
            ),
            // Container(
            //   color: Color(MyColors.grey01),
            //   child: Image(
            //     width: 100,
            //     image: img,
            //   ),
            // ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AssistantName,
                  style: TextStyle(
                    color: Color(MyColors.header01),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  assistantLocation,
                  style: TextStyle(
                    color: Color(MyColors.grey02),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      color: Color(MyColors.yellow02),
                      size: 18,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '4.0 - 50 Reviews',
                      style: TextStyle(color: Color(MyColors.grey02)),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final void Function() onTap;

  const AppointmentCard({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(MyColors.primary),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/assistant01.jpeg'),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mr. Abebe Kebede',
                                style: TextStyle(color: Colors.white)),
                            SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Arbaminch',
                              style: TextStyle(color: Color(MyColors.text01)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ScheduleCard(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg02),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Color(MyColors.bg03),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

List<Map> categories = [
  {'icon': Icons.record_voice_over, 'text': 'TTS'},
  {'icon': Icons.keyboard_voice, 'text': 'STT'},
  {'icon': Icons.calendar_month, 'text': 'Scedule Now'},
  {'icon': Icons.chat_bubble_outline, 'text': 'Chat'},
];

class CategoryIcons extends StatelessWidget {
  const CategoryIcons({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var category in categories)
          CategoryIcon(
            icon: category['icon'],
            text: category['text'],
          ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg01),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.calendar_today,
            color: Colors.white,
            size: 15,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Mon, July 29',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.access_alarm,
            color: Colors.white,
            size: 17,
          ),
          SizedBox(
            width: 5,
          ),
          Flexible(
            child: Text(
              '11:00 ~ 12:10',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  IconData icon;
  String text;

  CategoryIcon({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Color(MyColors.bg01),
      onTap: () {
        if (icon == Icons.record_voice_over) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TextToSpeechScreen(mode: SpeechMode.TTS)),
          );
        } else if (icon == Icons.keyboard_voice) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SpeechToText()),
          );
        } else if (icon == Icons.chat_bubble_outline) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        } else {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => AppointmentSchedulerPage(assisUer: ,
          //             apointedid: "",
          //           )),
          // );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Color(MyColors.bg),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                icon,
                color: Color(MyColors.primary),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: TextStyle(
                color: Color(MyColors.primary),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(MyColors.bg),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              onFieldSubmitted: (String _) {},
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Color(MyColors.purple02)),
                  onPressed: () {},
                ),
                border: InputBorder.none,
                // Remove the border
                //   border: OutlineInputBorder(
                //     borderSide: BorderSide.none,
                //     borderRadius: BorderRadius.zero,
                //  ),
                hintText: 'Search assistant ...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color(MyColors.purple01),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIntro extends StatefulWidget {
  const UserIntro({
    Key? key,
  }) : super(key: key);

  @override
  State<UserIntro> createState() => _UserIntroState();
}

class _UserIntroState extends State<UserIntro> {
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ${user!.fname}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Selam 👋',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                    backgroundImage: user.photoUrl == null
                        ? AssetImage('assets/images/person.jpeg')
                        : NetworkImage(user.photoUrl!)
                            as ImageProvider<Object>?),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
