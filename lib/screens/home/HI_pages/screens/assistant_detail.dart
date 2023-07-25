import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import "package:latlong2/latlong.dart" as latLng;
import 'package:let_com/provider/user_provider.dart';
import 'package:provider/provider.dart';
import '../styles/colors.dart';
import '../../../../model/User.dart' as model;
import '../styles/styles.dart';
import '../screens/appointment.dart';

class SliverAssistantDetail extends StatelessWidget {
  final String uid;
  final String name;
  final ImageProvider<Object> img;
  final model.User assUser;
  const SliverAssistantDetail(
      {Key? key,
      required this.uid,
      required this.name,
      required this.assUser,
      required this.img})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(assUser.toJson());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Assistant Details'),
            backgroundColor: Color(MyColors.primary),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage('assets/images/header.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:
                DetailBody(uid: uid, name: name, assiuser: assUser, img: img),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final String uid;

  final ImageProvider<Object> img;
  final String name;
  final model.User assiuser;
  const DetailBody({
    Key? key,
    required this.uid,
    required this.name,
    required this.assiuser,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailAssistantCard(address: assiuser.address, img: img, name: name),
          SizedBox(
            height: 15,
          ),
          AssistantInfo(),
          SizedBox(
            height: 30,
          ),
          Text(
            'About Assistant',
            style: kTitleStyle,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Mr. Abebe Kebede is a freelancer assistant who is willing to assist hearing impaired people .....',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Text(
            'Location',
            style: kTitleStyle,
          ),
          SizedBox(
            height: 25,
          ),
          AssistantLocation(),
          SizedBox(
            height: 25,
          ),
          user!.assistants.contains(uid)
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 23,
                      color: Colors.green[600],
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Text(
                      "You have booked an appoitment \n with $name ",
                      softWrap: false,
                      style: TextStyle(
                          color: Colors.green[200],
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ],
                )
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color(MyColors.primary),
                    ),
                  ),
                  child: Text('Book Appointment'),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentSchedulerPage(
                                assisUer: assiuser,
                                apointedid: uid,
                              )),
                    )
                  },
                )
        ],
      ),
    );
  }
}

class AssistantLocation extends StatelessWidget {
  const AssistantLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}

class AssistantInfo extends StatelessWidget {
  const AssistantInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        NumberCard(
          label: 'Persons',
          value: '100+',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Experiences',
          value: '10 years',
        ),
        SizedBox(width: 15),
        NumberCard(
          label: 'Rating',
          value: '4.0',
        ),
      ],
    );
  }
}

class AboutAssistant extends StatelessWidget {
  final String title;
  final String desc;
  const AboutAssistant({
    Key? key,
    required this.title,
    required this.desc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class NumberCard extends StatelessWidget {
  final String label;
  final String value;

  const NumberCard({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(MyColors.bg03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(MyColors.grey02),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              value,
              style: TextStyle(
                color: Color(MyColors.header01),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailAssistantCard extends StatelessWidget {
  final String name;
  final String address;
  final ImageProvider<Object> img;
  const DetailAssistantCard({
    Key? key,
    required this.name,
    required this.address,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: Color(MyColors.header01),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      address,
                      style: TextStyle(
                        color: Color(MyColors.grey02),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: 100,
                child: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: img,
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
