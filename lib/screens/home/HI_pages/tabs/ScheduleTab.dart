import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../styles/colors.dart';
import 'package:let_com/components/coustom_bottom_nav_bar.dart';
import 'package:let_com/enums.dart';
import '../../../../model/User.dart' as model;
import '../styles/styles.dart';

class ScheduleTab extends StatefulWidget {
  static String routeName = "/ScheduleTab";
  const ScheduleTab({Key? key}) : super(key: key);

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

enum FilterStatus { Upcoming, Complete, Cancel }

List<Map> schedules = [
  {
    'img': 'assets/images/assistant01.jpeg',
    'assistantName': 'Ms. Selam Wagaye',
    'assistantLocation': 'Debre-Markos',
    'reservedDate': 'Monday, Aug 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/images/person.png',
    'assistantName': 'Mr. Kebede Abebe',
    'assistantLocation': 'Bahirdar',
    'reservedDate': 'Monday, Sep 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/images/assistant03.jpeg',
    'assistantName': 'Ms. Azeb Mesfen',
    'assistantLocation': 'Kebridehar',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Upcoming
  },
  {
    'img': 'assets/images/assistant04.jpeg',
    'assistantName': 'Mr. Ayana Demamu',
    'assistantLocation': 'Benishangulgumuz',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Complete
  },
  {
    'img': 'assets/images/assistant05.jpeg',
    'assistantName': 'Ms. Almaz Nadew',
    'assistantLocation': 'Hosaina',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Cancel
  },
  {
    'img': 'assets/images/assistant05.jpeg',
    'assistantName': 'Mr. Abebe Kebede',
    'assistantLocation': 'Sheno',
    'reservedDate': 'Monday, Jul 29',
    'reservedTime': '11:00 - 12:00',
    'status': FilterStatus.Cancel
  },
];

class _ScheduleTabState extends State<ScheduleTab> {
  FilterStatus status = FilterStatus.Upcoming;
  Alignment _alignment = Alignment.centerLeft;

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Schedule',
              textAlign: TextAlign.center,
              style: kTitleStyle,
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(MyColors.bg),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (FilterStatus filterStatus in FilterStatus.values)
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (filterStatus == FilterStatus.Upcoming) {
                                  status = FilterStatus.Upcoming;
                                  _alignment = Alignment.centerLeft;
                                } else if (filterStatus ==
                                    FilterStatus.Complete) {
                                  status = FilterStatus.Complete;
                                  _alignment = Alignment.center;
                                } else if (filterStatus ==
                                    FilterStatus.Cancel) {
                                  status = FilterStatus.Cancel;
                                  _alignment = Alignment.centerRight;
                                }
                              });
                            },
                            child: Center(
                              child: Text(
                                filterStatus.name,
                                style: kFilterStyle,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedAlign(
                  duration: Duration(milliseconds: 200),
                  alignment: _alignment,
                  child: Container(
                    width: 100,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(MyColors.primary),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        status.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('request')
                    .where('declined',
                        isEqualTo: status == FilterStatus.Cancel ? true : false)
                    .where('accepted',
                        isEqualTo:
                            status == FilterStatus.Complete ? true : false)
                    .where('impairedId', isEqualTo: user!.uid)
                    .get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.length == 0) {
                    return SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          "oooops.... no  data",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 15),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        bool isLastElement =
                            snapshot.data!.docs.length - 1 == index;
                        return Card(
                          margin: !isLastElement
                              ? EdgeInsets.only(bottom: 20)
                              : EdgeInsets.zero,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: snapshot.data!
                                                  .docs[index]['photoUrl'] ==
                                              ''
                                          ? AssetImage(schedules[Random()
                                                  .nextInt(schedules.length)]
                                              ['img'])
                                          : NetworkImage(snapshot.data!
                                                  .docs[index]['photoUrl'])
                                              as ImageProvider<Object>,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.docs[index]
                                                  ['firstName'] +
                                              " " +
                                              snapshot.data!.docs[index]
                                                  ['lastName'],
                                          style: TextStyle(
                                            color: Color(MyColors.header01),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          snapshot.data!.docs[index]['address'],
                                          style: TextStyle(
                                            color: Color(MyColors.grey02),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DateTimeCard(
                                    time: snapshot.data!.docs[index]['Time'],
                                    date: snapshot.data!.docs[index]
                                        ['scheduledDate']),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color: Color(MyColors
                                                .primary), // Replace Colors.red with your desired color
                                          ),
                                        ),
                                        onPressed: () {
                                          ;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        child: Text('Reschedule'),
                                        style: ElevatedButton.styleFrom(
                                          primary: Color(MyColors
                                              .primary), // Replace Colors.blue with your desired color
                                        ),
                                        onPressed: () => {},
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } //expanded
                )
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: filteredSchedules.length,
            //     itemBuilder: (context, index) {
            //       var _schedule = filteredSchedules[index];
            //       bool isLastElement = filteredSchedules.length + 1 == index;
            //       return Card(
            //         margin: !isLastElement
            //             ? EdgeInsets.only(bottom: 20)
            //             : EdgeInsets.zero,
            //         child: Padding(
            //           padding: EdgeInsets.all(15),
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.stretch,
            //             children: [
            //               Row(
            //                 children: [
            //                   CircleAvatar(
            //                     backgroundImage: AssetImage(_schedule['img']),
            //                   ),
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Column(
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       Text(
            //                         _schedule['assistantName'],
            //                         style: TextStyle(
            //                           color: Color(MyColors.header01),
            //                           fontWeight: FontWeight.w700,
            //                         ),
            //                       ),
            //                       SizedBox(
            //                         height: 5,
            //                       ),
            //                       Text(
            //                         _schedule['assistantLocation'],
            //                         style: TextStyle(
            //                           color: Color(MyColors.grey02),
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                     ],
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(
            //                 height: 15,
            //               ),
            //               DateTimeCard(),
            //               SizedBox(
            //                 height: 15,
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Expanded(
            //                     child: OutlinedButton(
            //                       child: Text(
            //                         'Cancel',
            //                         style: TextStyle(
            //                           color: Color(MyColors
            //                               .primary), // Replace Colors.red with your desired color
            //                         ),
            //                       ),
            //                       onPressed: () {},
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     width: 20,
            //                   ),
            //                   Expanded(
            //                     child: ElevatedButton(
            //                       child: Text('Reschedule'),
            //                       style: ElevatedButton.styleFrom(
            //                         primary: Color(MyColors
            //                             .primary), // Replace Colors.blue with your desired color
            //                       ),
            //                       onPressed: () => {},
            //                     ),
            //                   )
            //                 ],
            //               )
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}

class DateTimeCard extends StatelessWidget {
  final String time;
  final String date;
  const DateTimeCard({
    Key? key,
    required this.time,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(MyColors.bg03),
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                color: Color(MyColors.primary),
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.access_alarm,
                color: Color(MyColors.primary),
                size: 17,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                time,
                style: TextStyle(
                  color: Color(MyColors.primary),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
