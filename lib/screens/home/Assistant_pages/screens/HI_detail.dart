import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/utils.dart';
import '../../../../model/User.dart' as model;
import 'package:provider/provider.dart';
import '../styles/colors.dart';
import '../styles/styles.dart';

class SliverAssistantDetail extends StatelessWidget {
  final String name;
  final String pid;
  final bool accept;
  final String address;
  final ImageProvider<Object> img;

  const SliverAssistantDetail(
      {Key? key,
      required this.name,
      required this.address,
      required this.img,
      required this.pid,
      required this.accept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text('Detail Information'),
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
            child: DetailBody(
              name: name,
              address: address,
              img: img,
              pid: pid,
              accepted: accept,
            ),
          )
        ],
      ),
    );
  }
}

class DetailBody extends StatelessWidget {
  final String name;
  final String pid;
  final bool accepted;
  final String address;
  final ImageProvider<Object> img;
  const DetailBody({
    Key? key,
    required this.name,
    required this.address,
    required this.img,
    required this.pid,
    required this.accepted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserProvider userp = Provider.of(context, listen: false);
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DetailAssistantCard(name: name, address: address, img: img),
          SizedBox(height: 15),
          SizedBox(height: 30),
          Text(
            'About ',
            style: kTitleStyle,
          ),
          SizedBox(height: 15),
          Text(
            'A 19 years old with hard of hearing. I want a sign language translator for free for my upcoming event on job skill training',
            style: TextStyle(
              color: Color(MyColors.purple01),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          SizedBox(height: 25),
          Text(
            'Location',
            style: kTitleStyle,
          ),
          SizedBox(height: 25),
          AssistantLocation(),
          SizedBox(height: 25),
          accepted
              ? Align(
                  alignment: Alignment.center,
                  child: UnconstrainedBox(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 19),
                      decoration: BoxDecoration(
                          color: Colors.green[400],
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Request Accepted",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Color(MyColors.primary),
                          ),
                        ),
                        child: Text('Accept'),
                        onPressed: () async {
                          String res =
                              await AuthService().acceptRequest(user!.uid, pid);
                          if (res == 'success') {
                            showSnackBar(
                                "The request has been accepted! ", context);
                            await userp.refreshUser();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            (Colors.red),
                          ),
                        ),
                        child: Text('Reject'),
                        onPressed: () async {
                          String res = await AuthService()
                              .declineRequest(user!.uid, pid);
                          if (res == 'success') {
                            showSnackBar(
                                "The request has been declined! ", context);
                            await userp.refreshUser();
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
