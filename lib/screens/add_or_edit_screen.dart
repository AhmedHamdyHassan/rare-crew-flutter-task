import 'package:flutter/material.dart';
import 'package:rare_crew_task/screens/dashboard_screen.dart';
import 'package:rare_crew_task/view_model/items_view_model.dart';

// ignore: must_be_immutable
class AddOrEditScreen extends StatefulWidget {
  final String buttonTitle;
  final String accessToken, refreshToken;
  final int id;
  const AddOrEditScreen(
      {Key? key,
      required this.buttonTitle,
      required this.accessToken,
      required this.refreshToken,
      this.id = -1})
      : super(key: key);

  @override
  State<AddOrEditScreen> createState() => _AddOrEditScreenState();
}

class _AddOrEditScreenState extends State<AddOrEditScreen> {
  final _itemNameController = TextEditingController();

  final _itemCostController = TextEditingController();

  void _submitData(BuildContext context) async {
    int id = (await ItemsViewModel.instance.getAll()).length + 1;
    if (widget.id != -1) {
      await ItemsViewModel.instance.update({
        '_id': widget.id,
        'name': _itemNameController.text,
        'cost': _itemCostController.text
      });
    } else {
      await ItemsViewModel.instance.insert({
        '_id': id,
        'name': _itemNameController.text,
        'cost': _itemCostController.text,
      });
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => DashboardScreen(
              accessToken: widget.accessToken,
              refreshToken: widget.refreshToken)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _itemNameController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                fillColor: const Color(0xff10ADBC),
                border: const OutlineInputBorder(),
                hintText: widget.id != -1
                    ? 'Enter Your Item New Name'
                    : 'Enter Your Item Name',
                labelText: 'Item',
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: TextField(
              controller: _itemCostController,
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                _submitData(context);
              },
              decoration: InputDecoration(
                fillColor: const Color(0xff10ADBC),
                border: const OutlineInputBorder(),
                hintText: widget.id != -1
                    ? 'Enter Your Item New Cost'
                    : 'Enter Your Item Cost',
                labelText: 'Cost',
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: ElevatedButton(
              onPressed: () => _submitData(context),
              child: Text(widget.buttonTitle),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xff10ADBC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
