import 'package:booktoplay_app/screen/bookingGround/grounddetails.dart';
import 'package:flutter/material.dart';

// const List<String> list = <String>[
//   'All Area',
//   'Kadri',
//   'Baikampady',
//   'Hampankatta',
//   'Kankanady',
//   'Ullal',
// ];

class Sportsformpage extends StatefulWidget {
  final String Sportsname;
  const Sportsformpage({super.key, required this.Sportsname});

  @override
  State<Sportsformpage> createState() => _SportsformpageState();
}

class _SportsformpageState extends State<Sportsformpage> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController timeoutController = TextEditingController();
  String selectedHour = '1 hour';
 // String selectedArea = list.first;

  bool isNowSelected = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      backgroundColor: Colors.black,

        leading: Icon(Icons.arrow_back),
        title: Column(children: [Text(widget.Sportsname,style: TextStyle(color: Colors.white),)]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100,width: 1)
                ),
                
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "When are you booking?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white
                      ),
                    ),
                    SizedBox(height: 15),

                    // CUSTOM TAB SELECTOR
                    Row(
                      children: [
                        Expanded(
                          child: _buildTabButton(
                            "Now",
                            isNowSelected,
                            () => setState(() => isNowSelected = true),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: _buildTabButton(
                            "Custom Time",
                            !isNowSelected,
                            () => setState(() => isNowSelected = false),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // CONDITIONAL CONTENT
                    if (isNowSelected)
                      _buildNowContent() // This shows the "Duration" row
                    else
                      _buildCustomContent(), // This shows the Date/Time fields

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Helper Function

  // The Tab Button Toggle
  Widget _buildTabButton(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.green : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Content for the "Now" Tab
  Widget _buildNowContent() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Duration", style: TextStyle(fontSize: 18,color: Colors.white70)),
        SizedBox(height: 10),
        Row(
          children: [
            _durationChip('1 hour', selectedHour == '1 hour'),
            _durationChip('2 hours', selectedHour == '2 hours'),
            _durationChip('3 hours', selectedHour == '3 hours'),
          ],
        ),
        SizedBox(height: 10),
        // Text(
        //   "Which area?",
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        // ),
        // DropdownMenuExample(
        //   initialValue: selectedArea, // Use the variable
        //   onSelected: (value) {
        //     setState(() {
        //       selectedArea = value!; // Update the variable
        //     });
        //   },
        // ),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroundsResultPage(
                    // selectedHour: selectedHour,
                    sportsname: widget.Sportsname,
                   // selectedArea: selectedArea,
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 6, 216, 115),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),

                Text(
                  "Seach Available Ground",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Content for the "Custom" Tab
  Widget _buildCustomContent() {
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker Field
        Text('Date', style: TextStyle(color: Colors.black, fontSize: 15)),
        TextField(
          controller: dateController,
          readOnly: true, // Prevents keyboard from appearing
          decoration: const InputDecoration(
            focusColor: Colors.greenAccent,
            labelText: "Select Date",
            suffixIcon: Icon(Icons.calendar_today),
            border: OutlineInputBorder(),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000), // Earliest selectable date
              lastDate: DateTime(2100), // Latest selectable date
            );

            if (pickedDate != null) {
              // Format the date as needed (e.g., YYYY-MM-DD)
              String formattedDate =
                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              setState(() {
                dateController.text = formattedDate;
              });
            }
          },
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'In Time',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),

                  TextField(
                    controller: timeController,
                    readOnly: true, // 2. Prevent keyboard
                    decoration: InputDecoration(
                      labelText: 'Select In Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      // 3. Show the picker
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        // Format and update the field
                        setState(() {
                          timeController.text = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Out Time',
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),

                  TextField(
                    controller: timeoutController,
                    readOnly: true, // 2. Prevent keyboard
                    decoration: InputDecoration(
                      labelText: 'Select out Time',
                      suffixIcon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                    ),
                    onTap: () async {
                      // 3. Show the picker
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        // Format and update the field
                        setState(() {
                          timeoutController.text = pickedTime.format(context);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Text(
          "Which area?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        // DropdownMenuExample(
        //   //initialValue: selectedArea,
        //   onSelected: (value) {
        //     setState(() {
        //       selectedArea = value!; // Now the parent knows the choice!
        //     });
        //   },
        // ),
        SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 6, 216, 115),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),

                Text(
                  "Seach Available Ground",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _durationChip(String label, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedHour = label; // Update the state when clicked
          });
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFE8F5E9)
                : const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? Colors.green : const Color(0xFFE0E0E0),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.green[700] : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

