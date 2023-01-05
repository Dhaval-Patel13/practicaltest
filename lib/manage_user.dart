import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practicaltest/db/database_helper.dart';
import 'package:practicaltest/model/model_user.dart';

class ManageUser extends StatefulWidget {
  final ModelUser? modelUser;
  const ManageUser({Key? key,this.modelUser,}) : super(key: key);

  @override
  State<ManageUser> createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {


  TextEditingController textEditingControllerName = TextEditingController(text: "User 1");
  TextEditingController textEditingControllerEmail = TextEditingController(text: "email@gmail.com");
  TextEditingController textEditingControllerPhone = TextEditingController(text: "9876543110");
  TextEditingController textEditingControllerAddress = TextEditingController(text: "Surat");
  TextEditingController textEditingControllerDob = TextEditingController(text: "Select DOB");
  TextEditingController textEditingControllerGender = TextEditingController(text: "M");

  @override
  void initState() {
    if(widget.modelUser != null){
      textEditingControllerName = TextEditingController(text: widget.modelUser!.name??"");
      textEditingControllerEmail = TextEditingController(text: widget.modelUser!.email??"");
      textEditingControllerPhone = TextEditingController(text: widget.modelUser!.phone??"");
      textEditingControllerAddress = TextEditingController(text: widget.modelUser!.address??"");
      textEditingControllerDob = TextEditingController(text: widget.modelUser!.dob.toString()??"");
      textEditingControllerGender = TextEditingController(text: widget.modelUser!.gender??"");
      selectedDate = widget.modelUser!.dob;
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage User")
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 1,color: Colors.grey)
            ),
            child:   TextField(
              controller: textEditingControllerName,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Name",
                contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8,)
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1,color: Colors.grey)
            ),
            child:   TextField(
              controller: textEditingControllerEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8,)
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1,color: Colors.grey)
            ),
            child:   TextField(
              controller: textEditingControllerPhone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Phone",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8,)
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1,color: Colors.grey)
            ),
            child:   TextField(
              controller: textEditingControllerAddress,
              minLines: 5,
              maxLines: 7,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Address",
                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 8,)
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
             Radio(value: "M", groupValue: textEditingControllerGender.text, onChanged: (value){
               textEditingControllerGender.text = value.toString();
               setState(() {});
             },

             ),
              const Text("Male"),
              const SizedBox(
                width: 16,
              ),
              Radio(value: "F", groupValue: textEditingControllerGender.text, onChanged: (value){
                textEditingControllerGender.text = value.toString();
                setState(() {});
              }),
              const Text("Female"),
              const SizedBox(
                width: 16,
              ),
              Radio(value: "O", groupValue: textEditingControllerGender.text, onChanged: (value){
                textEditingControllerGender.text = value.toString();
                setState(() {});
              }),
              const Text("Other"),
            ],
          ),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: Text(textEditingControllerDob.text.isEmpty?"Select DOB":textEditingControllerDob.text),
          ),
        ],
      ),
      bottomNavigationBar:  ElevatedButton(
        onPressed: (){
          if(widget.modelUser == null){
            _insert();
          }else{
            updateUser();

          }
        },
        child:   Text(widget.modelUser == null?"Add":"Update"),
      ),
    );
  }


  final dbHelper = DatabaseHelper.instance;
  void _insert() async {
    ModelUser modelUser = ModelUser();
    modelUser.name = textEditingControllerName.text;
    modelUser.email = textEditingControllerEmail.text;
    modelUser.phone = textEditingControllerPhone.text;
    modelUser.dob =selectedDate;
    modelUser.gender = textEditingControllerGender.text;
    modelUser.address = textEditingControllerAddress.text;
    final id = await dbHelper.insert(modelUser);
    if(id>0){
      debugPrint("Success");
    }else{
      debugPrint("Failed");
    }
  }

  void updateUser() async {
    widget.modelUser?.name = textEditingControllerName.text;
    widget.modelUser?.email = textEditingControllerEmail.text;
    widget.modelUser?.phone = textEditingControllerPhone.text;
    widget.modelUser?.dob =selectedDate;
    widget.modelUser?.gender = textEditingControllerGender.text;
    widget.modelUser?.address = textEditingControllerAddress.text;
    final id = await dbHelper.update(widget.modelUser!);
    if(id>0){
      debugPrint("Success");
    }else{
      debugPrint("Failed");
    }
  }

  DateTime currentDate = DateTime.now();
  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1980),
        lastDate: DateTime(2025));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        selectedDate = pickedDate;
        String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate!); //
        textEditingControllerDob.text = formattedDate.toString();
      });
    }
  }
}
