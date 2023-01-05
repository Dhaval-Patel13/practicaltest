import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:practicaltest/db/database_helper.dart';
import 'package:practicaltest/manage_user.dart';
import 'package:practicaltest/model/model_user.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ModelUser> listOfUser = [];
  final dbHelper = DatabaseHelper.instance;

  String defualtGenderValue = 'All';
  var gender = [
    'All',
    'M',
    'F',
    'O',
  ];
  String defualtAgeRange = 'Any';
  var age = [
    'Any',
    '0-10',
    '10-20',
    '20-30',
    '30-40',
    '40-50',
  ];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    getUsers();

    return Scaffold(
        appBar: AppBar(
          title: const Text("User Details"),
          actions: [
            IconButton(
              onPressed: () {
                Get.to(const ManageUser());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Center(
              child: DropdownButton(
                iconSize: 30,
                value: defualtGenderValue,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: gender.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    defualtGenderValue = newValue!;
                    getUsers();
                  });
                },
              ),
            ),
            Center(
              child: DropdownButton(
                iconSize: 30,
                value: defualtAgeRange,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: age.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    defualtAgeRange = newValue!;
                  });
                },
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: listOfUser.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(listOfUser[index].name ?? ""),
                          Text(listOfUser[index].phone ?? ""),
                          Text(listOfUser[index].email ?? ""),
                          Text(listOfUser[index].dob.toString() ?? ""),
                          Text(listOfUser[index].address ?? ""),
                          Text(listOfUser[index].gender ?? ""),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(ManageUser(
                            modelUser: listOfUser[index],
                          ));
                        },
                        icon: const Icon(Icons.edit)),
                    IconButton(
                        onPressed: () {
                          dbHelper.delete(listOfUser[index].id!);
                        },
                        icon: const Icon(Icons.delete)),
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 16,
                );
              },
            ),
          ],
        ));
  }

  Future<void> getUsers() async {
    listOfUser = await dbHelper.getAllUser(genderFilter: defualtGenderValue);
    setState(() {});
  }

  Future<void> getAllUsersByGender() async {
    listOfUser = await dbHelper.getAllUser(genderFilter: defualtGenderValue);
    setState(() {});
  }
}
