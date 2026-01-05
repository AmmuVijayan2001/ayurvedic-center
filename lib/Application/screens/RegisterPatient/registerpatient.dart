import 'package:ayurvediccenter/Data/models/patient_model.dart';
import 'package:ayurvediccenter/Data/models/selected_treatment.dart';
import 'package:ayurvediccenter/Data/providers/auth_provider.dart';
import 'package:ayurvediccenter/Data/providers/patient_provider.dart';
import 'package:ayurvediccenter/Data/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  // Logic variables
  Branch? _selectedBranch;
  String? _selectedLocation;
  String _paymentOption = "Cash";

  // State for selected treatments with counts
  final List<SelectedTreatment> _selectedTreatments = [];
  
  // Date and Time
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Dialog counters
  int maleCount = 0;
  int femaleCount = 0;

  // Controllers
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _discountAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _balanceAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      if (token != null) {
        final patientProvider = Provider.of<PatientProvider>(
          context,
          listen: false,
        );
        patientProvider.fetchBranches(token);
        patientProvider.fetchTreatments(token);
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
            onPressed: _registerPatient,
            child: const Text(
              "Save",
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Consumer<PatientProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.arrow_back),
                      Spacer(),
                      Icon(Icons.notifications_none),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Register",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 16),

                  _label("Name"),
                  _textField(
                    "Enter your full name",
                    controller: _nameController,
                  ),

                  _label("Whatsapp Number"),
                  _textField(
                    "Enter your Whatsapp number",
                    controller: _whatsappController,
                  ),

                  _label("Address"),
                  _textField(
                    "Enter your full address",
                    controller: _addressController,
                  ),

                  _label("Location"),
                  _customDropdown<String>(
                    hint: "Choose your location",
                    value: _selectedLocation,
                    items: [
                      "Ernakulam",
                      "Kozhikode",
                      "Trivandrum",
                    ], // Static locations
                    itemLabel: (item) => item,
                    onChanged: (val) {
                      setState(() {
                        _selectedLocation = val;
                      });
                    },
                  ),

                  _label("Branch"),
                  _customDropdown<Branch>(
                    hint: "Select the branch",
                    value: _selectedBranch,
                    items: provider.branches,
                    itemLabel: (branch) => branch.name ?? "",
                    onChanged: (val) {
                      setState(() {
                        _selectedBranch = val;
                      });
                    },
                  ),

                  // Display Selected Treatments List
                  if (_selectedTreatments.isNotEmpty)
                    ..._selectedTreatments.asMap().entries.map((entry) {
                      int index = entry.key;
                      SelectedTreatment selected = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${index + 1}. ${selected.treatment.name}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.red.shade300,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _selectedTreatments.removeAt(index);
                                      // recalculate global counts if needed
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text("Male"),
                                const SizedBox(width: 10),
                                _countBox(selected.maleCount), 
                                const SizedBox(width: 20),
                                const Text("Female"),
                                const SizedBox(width: 10),
                                _countBox(selected.femaleCount),
                                const Spacer(),
                                const Icon(
                                  Icons.edit,
                                  color: Color(0xFF0B6E3F),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 10),

                  InkWell(
                    onTap: () {
                      _openTreatmentDialog(provider.treatments);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "+ Add Treatments",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),

                  _label("Total Amount"),
                  _textField("", controller: _totalAmountController),

                  _label("Discount Amount"),
                  _textField("", controller: _discountAmountController),

                  _label("Payment Option"),
                  Row(
                    children: [
                      Radio(
                        value: "Cash",
                        groupValue: _paymentOption,
                        onChanged: (v) {
                          setState(() {
                            _paymentOption = v.toString();
                          });
                        },
                      ),
                      const Text("Cash"),
                      const SizedBox(width: 20),
                      Radio(
                        value: "Card",
                        groupValue: _paymentOption,
                        onChanged: (v) {
                          setState(() {
                            _paymentOption = v.toString();
                          });
                        },
                      ),
                      const Text("Card"),
                      const SizedBox(width: 20),
                      Radio(
                        value: "UPI",
                        groupValue: _paymentOption,
                        onChanged: (v) {
                          setState(() {
                            _paymentOption = v.toString();
                          });
                        },
                      ),
                      const Text("UPI"),
                    ],
                  ),

                  _label("Advance Amount"),
                  _textField("", controller: _advanceAmountController),

                  _label("Balance Amount"),
                  _textField("", controller: _balanceAmountController),

                  _label("Treatment Date"),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: _selectedDate != null ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}" : ""),
                    decoration: InputDecoration(
                      hintText: "Select Date",
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.green),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),

                  _label("Treatment Time"),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                           readOnly: true,
                           controller: TextEditingController(text: _selectedTime?.hour.toString() ?? ""),
                           decoration: InputDecoration(
                             hintText: "Hour",
                             filled: true,
                             fillColor: Colors.grey.shade100,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                           ),
                           onTap: () => _selectTime(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                           readOnly: true,
                           controller: TextEditingController(text: _selectedTime?.minute.toString() ?? ""),
                           decoration: InputDecoration(
                             hintText: "Minute",
                             filled: true,
                             fillColor: Colors.grey.shade100,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                           ),
                           onTap: () => _selectTime(context),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }





  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Rewriting _openTreatmentDialog to match the requested design:
  // Dropdown + Counters for Male/Female
  void _openTreatmentDialog(List<Treatment> availableTreatments) {
    showDialog(
      context: context,
      builder: (_) {
        // Local state for the dialog
        Treatment? dialogSelectedTreatment;
        int localMaleCount = 0;
        int localFemaleCount = 0;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Choose Treatment",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Treatment>(
                          isExpanded: true,
                          hint: const Text("Choose preferred treatment"),
                          value: dialogSelectedTreatment,
                          items: availableTreatments.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.name ?? ""),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setDialogState(() {
                              dialogSelectedTreatment = val;
                            });
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "Add Patients",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 12),
                    _counterRow(
                      "Male",
                      localMaleCount,
                      () {
                        setDialogState(() => localMaleCount++);
                      },
                      () {
                        setDialogState(
                          () => localMaleCount > 0 ? localMaleCount-- : 0,
                        );
                      },
                    ),

                    const SizedBox(height: 12),
                    _counterRow(
                      "Female",
                      localFemaleCount,
                      () {
                        setDialogState(() => localFemaleCount++);
                      },
                      () {
                        setDialogState(
                          () => localFemaleCount > 0 ? localFemaleCount-- : 0,
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B6E3F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (dialogSelectedTreatment != null) {
                            setState(() {
                              _selectedTreatments.add(SelectedTreatment(
                                treatment: dialogSelectedTreatment!,
                                maleCount: localMaleCount,
                                femaleCount: localFemaleCount,
                              ));
                              // Update global counts if needed, but we track locally now
                              maleCount += localMaleCount;
                              femaleCount += localFemaleCount;
                            });
                            Navigator.pop(context);
                          } else {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a treatment")));
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Handle Form Submission
  Future<void> _registerPatient() async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token == null) return;
    
    // Validate inputs
    if (_selectedBranch == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a branch")));
      return;
    }
    if (_selectedTreatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one treatment")));
      return;
    }
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a date")));
      return;
    }
    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select a time")));
      return;
    }

    // Construct lists for API
    String treatmentIds = _selectedTreatments.map((e) => e.treatment.id).join(",");
    String maleCounts = _selectedTreatments.map((e) => e.maleCount).join(",");
    String femaleCounts = _selectedTreatments.map((e) => e.femaleCount).join(",");
    
    // Format date as dd/MM/yyyy
    String formattedDate = "${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}";
    String formattedTime = _selectedTime!.format(context);

    final data = {
      "name": _nameController.text,
      "excecutive": "nil", 
      "payment": _paymentOption,
      "phone": _whatsappController.text,
      "address": _addressController.text,
      "total_amount": _totalAmountController.text,
      "discount_amount": _discountAmountController.text,
      "advance_amount": _advanceAmountController.text,
      "balance_amount": _balanceAmountController.text,
      "date_nd_time": "$formattedDate-$formattedTime", 
      "id": "", 
      "male": maleCounts,
      "female": femaleCounts,
      "branch": _selectedBranch?.id.toString() ?? "", 
      "treatments": treatmentIds,
    };

    try {
      await Provider.of<PatientProvider>(context, listen: false).registerPatient(token, data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully!")));
      
      // Generate PDF
      await PdfService().generatePdf(
        data: data,
        selectedTreatments: _selectedTreatments,
        bookedOn: DateTime.now(),
      );
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PDF Generated!")));

    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _textField(String hint, {TextEditingController? controller}) => TextField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _customDropdown<T>({
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemLabel,
    required Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade600)),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(
                itemLabel(e),
                style: TextStyle(
                  // Mark selected visual indication if needed, but Dropdown handles showing 'value'
                  color: value == e ? Colors.green : Colors.black, // Simple highlight
                  fontWeight: value == e ? FontWeight.bold : FontWeight.normal
                ), 
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dummyDropdown(String hint) => TextField(
    readOnly: true,
    decoration: InputDecoration(
      hintText: hint,
      suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );

  Widget _countBox(int value) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(value.toString()),
  );

  Widget _counterRow(
    String label,
    int value,
    VoidCallback onAdd,
    VoidCallback onRemove,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(label),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.remove_circle, color: Color(0xFF0B6E3F)),
        ),
        Container(
          width: 40,
          alignment: Alignment.center,
          child: Text(value.toString()),
        ),
        IconButton(
          onPressed: onAdd,
          icon: const Icon(Icons.add_circle, color: Color(0xFF0B6E3F)),
        ),
      ],
    );
  }
}
