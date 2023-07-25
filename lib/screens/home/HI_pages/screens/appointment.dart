import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:let_com/backend_services/auth.dart';
import 'package:let_com/provider/user_provider.dart';
import 'package:let_com/utils.dart';
import 'package:provider/provider.dart';
import '../../../../model/User.dart' as model;

class AppointmentSchedulerPage extends StatefulWidget {
  final String apointedid;
  final model.User assisUer;

  const AppointmentSchedulerPage(
      {super.key, required this.apointedid, required this.assisUer});

  @override
  State<AppointmentSchedulerPage> createState() =>
      _AppointmentSchedulerPageState();
}

class _AppointmentSchedulerPageState extends State<AppointmentSchedulerPage> {
  TextEditingController datetime = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController desc = TextEditingController();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    DateTime now = DateTime.now();
    TimeOfDay ntime = TimeOfDay.now();
    print(ntime.format(context));

    UserProvider userp = Provider.of(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Scheduler',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Your convenient Date and Time',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime
                          .now(), //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    print(
                        pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                    String formattedDate =
                        DateFormat.yMMMEd().format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    //you can implement different kind of Date Format here according to your requirement

                    setState(() {
                      datetime.text = formattedDate;
                      //set output date to TextField value.
                    });
                  } else {
                    print("Date is not selected");
                  }
                },
                readOnly: true,
                controller: datetime,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                  hintText: "Click To select your date",
                  suffix: Icon(
                    color: Color.fromARGB(255, 16, 253, 35),
                    Icons.calendar_month_outlined,
                    size: 28,
                  ),
                  labelText: 'Date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                onTap: () async {
                  TimeOfDay? newTime = await showTimePicker(
                      context: context, initialTime: ntime);

                  final localizations = MaterialLocalizations.of(context);

                  if (newTime != null) {
                    setState(() {
                      time.text = localizations.formatTimeOfDay(newTime);
                      ;
                    });
                  }
                },
                controller: time,
                decoration: InputDecoration(
                  suffix: Icon(
                    Icons.timer,
                    size: 28,
                    color: Color.fromARGB(255, 16, 253, 35),
                  ),
                  hintText: "Click to select your time",
                  labelText: 'Time',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: phone,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: location,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: desc,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              isloading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.blue[600]),
                    )
                  : Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (datetime.text == '' || time.text == "") {
                            showSnackBar(
                                "Date and Time is Required Please complete Them before processing! ",
                                context);
                            return;
                          }
                          setState(() {
                            isloading = true;
                          });
                          String res = await AuthService().appointAssistance(
                              user!.uid,
                              widget.apointedid,
                              widget.assisUer,
                              user,
                              datetime.text,
                              time.text,
                              desc.text);
                          if (res == 'success') {
                            setState(() {
                              isloading = false;
                            });
                            showSnackBar(
                                "Your appointment request is sent successfully! ",
                                context);
                            await userp.refreshUser();
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isloading = false;
                            });
                          }
                        },
                        child: Text('Schedule Appointment'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
