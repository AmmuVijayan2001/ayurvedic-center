import 'package:ayurvediccenter/Application/Presentation/RegisterPatient/registerpatient.dart';
import 'package:flutter/material.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0B6E3F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const RegisterPatientScreen(),
                ),
              );
            },
            child: const Text(
              "Register Now",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back),
                  const Spacer(),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 8,
                          width: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for treatments",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B6E3F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      child: Text(
                        "Search",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Text(
                    "Sort by :",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: "Date",
                        items: const [
                          DropdownMenuItem(value: "Date", child: Text("Date")),
                          DropdownMenuItem(value: "Name", child: Text("Name")),
                        ],
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${index + 1}. Vikram Singh",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Couple Combo Package (Rejuven...)",
                          style: TextStyle(
                            color: Color(0xFF0B6E3F),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text("31/01/2024"),
                            SizedBox(width: 12),
                            Icon(Icons.group, size: 16, color: Colors.red),
                            SizedBox(width: 4),
                            Text("Jithesh"),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          children: const [
                            Text(
                              "View Booking details",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Color(0xFF0B6E3F),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
