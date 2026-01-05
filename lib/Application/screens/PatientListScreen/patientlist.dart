import 'package:ayurvediccenter/Application/screens/RegisterPatient/registerpatient.dart';
import 'package:ayurvediccenter/Data/providers/auth_provider.dart';
import 'package:ayurvediccenter/Data/providers/patient_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        Provider.of<PatientProvider>(
          context,
          listen: false,
        ).fetchPatients(token);
      }
    });
  }

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
              Navigator.push(
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
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      final token =
                          Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          ).token;
                      if (token != null) {
                        await Provider.of<PatientProvider>(
                          context,
                          listen: false,
                        ).fetchPatients(token);
                      }
                    },
                    child: Builder(
                      builder: (context) {
                        if (patientProvider.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (patientProvider.errorMessage != null) {
                          return Center(
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Text(
                                patientProvider.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        }

                        if (patientProvider.patients.isEmpty) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/Layer_1-2.png", // Empty list image
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.6,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "No patients found",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: patientProvider.patients.length,
                          itemBuilder: (context, index) {
                            final patient = patientProvider.patients[index];
                            // Format data safely
                            final name = patient.name ?? "Unknown";
                            final treatments =
                                patient.patientdetailsSet
                                    ?.map((e) => e.treatmentName)
                                    .join(", ") ??
                                "No treatments";
                            final date =
                                patient.dateNdTime?.split("T")[0] ?? "N/A";
                            final user = patient.user ?? "Unknown";

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
                                    "${index + 1}. $name",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    treatments,
                                    style: const TextStyle(
                                      color: Color(0xFF0B6E3F),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(date),
                                      const SizedBox(width: 12),
                                      const Icon(
                                        Icons.group,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(user),
                                    ],
                                  ),
                                  const Divider(height: 20),
                                  Row(
                                    children: const [
                                      Text(
                                        "View Booking details",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
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
                        );
                      },
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
