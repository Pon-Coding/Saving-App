import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  double planSaving = 0.0;
  final List<String> items = ["Apple", "Orange", "Mango"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: const Color(0xFFFFD700),
                              child: const Text(
                                "Create New Saving Plan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildTextField(
                            label: 'Saving For',
                            hint: 'Enter Purpose',
                            icon: Icons.title,
                            onChanged: (value) => setState(() {
                              title = value;
                            }),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              _selectDate(context).then((_) {
                                setState(() {});
                              });
                            },
                            child: AbsorbPointer(
                              child: _buildTextField(
                                label:
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                hint: 'Pick a date',
                                icon: Icons.calendar_today,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Amount in USD per month',
                            hint: 'Enter amount',
                            icon: Icons.attach_money,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(() {
                              amount = double.tryParse(value) ?? 0.0;
                            }),
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            label: 'Plan Saving in USD',
                            hint: 'Enter amount',
                            icon: Icons.savings,
                            keyboardType: TextInputType.number,
                            onChanged: (value) => setState(() {
                              planSaving = double.tryParse(value) ?? 0.0;
                            }),
                          ),
                          const SizedBox(height: 20),
                          _buildBottomSheetButtons(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget _buildBottomSheetButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          _buildBottomSheetButton(
            context: context,
            color: Colors.red,
            text: 'CLOSE',
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: _buildBottomSheetButton(
              context: context,
              color: const Color(0xFF383fa5),
              text: 'ADD TO CART',
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheetButton({
    required BuildContext context,
    required Color color,
    required String text,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              offset: Offset(0.1, 0.1),
              blurRadius: 5,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showBottomSheet(context),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        'Offline Mode',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      backgroundColor: Colors.blue,
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildListItem(data: items[index], index: index);
      },
    );
  }

  Widget _buildListItem({required String data, required int index}) {
    return InkWell(
      onLongPress: () {
        setState(() {
          items.removeAt(index);
        });
      },
      child: Card(
        child: ListTile(
          title: Text(data),
        ),
      ),
    );
  }
}
