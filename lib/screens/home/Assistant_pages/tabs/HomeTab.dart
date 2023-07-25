import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';
import '../../../Services/sound_to_text.dart';
import '../../../Services/text_to_speech.dart';

import '../../Assistant_pages/screens/HI_detail.dart';
import '../../../../model/User.dart' as model;

List<Map> HIs = [
  {
    'img': 'assets/images/assistant02.jpeg',
    'HIName': 'Mr. Abebe Kebede',
    'HILocation': 'Adama'
  },
  {
    'img': 'assets/images/assistant03.jpeg',
    'HIName': 'Ms. Almaz Nadew',
    'HILocation': 'Addis Ababa'
  },
  {
    'img': 'assets/images/assistant02.jpeg',
    'HIName': 'Mr. Kebede Abebe',
    'HILocation': 'Jimma'
  },
  {
    'img': 'assets/images/assistant03.jpeg',
    'HIName': 'Ms. Azeb Mesfen',
    'HILocation': 'Hawassa'
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

bool isSearching = false;

final TextEditingController searchController = TextEditingController();

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
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
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Icon(
                      Icons.search,
                      color: Color(MyColors.purple02),
                    ),
                  ),
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
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search,
                              color: Color(MyColors.purple02)),
                          onPressed: () {
                            setState(() {
                              isSearching = true;
                            });
                          },
                        ),
                        hintText: 'Search customers',
                        hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(MyColors.purple01),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            isSearching
                ? Column(
                    children: [
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('request')
                            .where('uid', isEqualTo: user!.uid)
                            .where('impairedFname',
                                isLessThanOrEqualTo: searchController.text)
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
                              return TopHICard(
                                accept: snapshot.data!.docs[index]['accepted'],
                                pid: snapshot.data!.docs[index]['impairedId'],
                                img: snapshot.data!.docs[index]
                                            ['impairedPhoto'] ==
                                        ''
                                    ? AssetImage(
                                        HIs[Random().nextInt(HIs.length)]
                                            ['img'])
                                    : NetworkImage(snapshot.data!.docs[index]
                                            ['impairedPhoto'])
                                        as ImageProvider<Object>,
                                HIName: snapshot.data!.docs[index]
                                        ['impairedFname'] +
                                    " " +
                                    snapshot.data!.docs[index]['impairedlname'],
                                HILocation: snapshot.data!.docs[index]
                                    ['impairedaddress'],
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
                : Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today\'s Appointment',
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
                      'People looking for help',
                      style: TextStyle(
                        color: Color(MyColors.header01),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('request')
                          .where('declined', isEqualTo: false)
                          .where('uid', isEqualTo: user!.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.data!.docs.length == 0) {
                          return SizedBox(
                            height: 90,
                            child: Center(
                              child: Text(
                                "oooops.... no requset has been found",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 15),
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return TopHICard(
                              accept: snapshot.data!.docs[index]['accepted'],
                              pid: snapshot.data!.docs[index]['impairedId'],
                              img: snapshot.data!.docs[index]
                                          ['impairedPhoto'] ==
                                      ''
                                  ? AssetImage(
                                      HIs[Random().nextInt(HIs.length)]['img'])
                                  : NetworkImage(snapshot.data!.docs[index]
                                          ['impairedPhoto'])
                                      as ImageProvider<Object>,
                              HIName: snapshot.data!.docs[index]
                                      ['impairedFname'] +
                                  " " +
                                  snapshot.data!.docs[index]['impairedlname'],
                              HILocation: snapshot.data!.docs[index]
                                  ['impairedaddress'],
                            );
                          },
                        );
                      },
                    )
                  ])
            // for (var person in HIs)
            //   TopHICard(
            //     img: person['img'],
            //     HIName: person['HIName'],
            //     HILocation: person['HILocation'],
            //   )
          ],
        ),
      ),
    );
  }
}

class TopHICard extends StatelessWidget {
  ImageProvider<Object> img;
  String HIName;
  String pid;
  bool accept;
  String HILocation;

  TopHICard({
    required this.accept,
    required this.pid,
    required this.img,
    required this.HIName,
    required this.HILocation,
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
                      accept: accept,
                      pid: pid,
                      address: HILocation,
                      name: HIName,
                      img: img,
                    )),
          );
        },
        child: Stack(children: [
          Row(
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
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    HIName,
                    style: TextStyle(
                      color: Color(MyColors.header01),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    HILocation,
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
                        Icons.currency_exchange,
                        color: Color(MyColors.yellow02),
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'ETB 400',
                        style: TextStyle(color: Color(MyColors.grey02)),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
          accept
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: Icon(
                    Icons.add_task_rounded,
                    color: Colors.green,
                    size: 26,
                  ))
              : Container()
        ]),
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
                              'Legetafo Legedadi',
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
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SpeechToText()),
          );
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
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.search,
              color: Color(MyColors.purple02),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search customers',
                hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color(MyColors.purple01),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserIntro extends StatelessWidget {
  const UserIntro({
    Key? key,
  }) : super(key: key);

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
              "hello ${user!.fname}",
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
          child: CircleAvatar(
              backgroundImage: user.photoUrl == null
                  ? AssetImage('assets/images/person.jpeg')
                  : NetworkImage(user.photoUrl!) as ImageProvider<Object>?),
        )
      ],
    );
  }
}
