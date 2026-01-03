import 'package:flutter/material.dart';

class RegisterPatientScreen extends StatefulWidget {
  const RegisterPatientScreen({super.key});

  @override
  State<RegisterPatientScreen> createState() => _RegisterPatientScreenState();
}

class _RegisterPatientScreenState extends State<RegisterPatientScreen> {
  int maleCount = 2;
  int femaleCount = 2;

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
            onPressed: () {},
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
          child: Column(
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
              _textField("Enter your full name"),

              _label("Whatsapp Number"),
              _textField("Enter your Whatsapp number"),

              _label("Address"),
              _textField("Enter your full address"),

              _label("Location"),
              _dropdown("Choose your location"),

              _label("Branch"),
              _dropdown("Select the branch"),

              _label("Treatments"),
              Container(
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
                        const Expanded(
                          child: Text(
                            "1. Couple Combo package i..",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Icon(Icons.close, color: Colors.red.shade300),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text("Male"),
                        _countBox(maleCount),
                        const SizedBox(width: 20),
                        const Text("Female"),
                        _countBox(femaleCount),
                        const Spacer(),
                        const Icon(Icons.edit, color: Color(0xFF0B6E3F)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              InkWell(
                onTap: _openTreatmentDialog,
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
              _textField(""),

              _label("Discount Amount"),
              _textField(""),

              _label("Payment Option"),
              Row(
                children: const [
                  Radio(value: 1, groupValue: 1, onChanged: null),
                  Text("Cash"),
                  SizedBox(width: 20),
                  Radio(value: 2, groupValue: 1, onChanged: null),
                  Text("Card"),
                  SizedBox(width: 20),
                  Radio(value: 3, groupValue: 1, onChanged: null),
                  Text("UPI"),
                ],
              ),

              _label("Advance Amount"),
              _textField(""),

              _label("Balance Amount"),
              _textField(""),

              _label("Treatment Date"),
              _dropdown(""),

              _label("Treatment Time"),
              Row(
                children: [
                  Expanded(child: _dropdown("Hour")),
                  const SizedBox(width: 12),
                  Expanded(child: _dropdown("Minutes")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openTreatmentDialog() {
    showDialog(
      context: context,
      builder: (_) {
        int male = 0;
        int female = 0;

        return StatefulBuilder(
          builder: (context, setState) {
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
                    _dropdown("Choose preferred treatment"),

                    const SizedBox(height: 16),
                    const Text(
                      "Add Patients",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 12),
                    _counterRow(
                      "Male",
                      male,
                      () {
                        setState(() => male++);
                      },
                      () {
                        setState(() => male > 0 ? male-- : 0);
                      },
                    ),

                    const SizedBox(height: 12),
                    _counterRow(
                      "Female",
                      female,
                      () {
                        setState(() => female++);
                      },
                      () {
                        setState(() => female > 0 ? female-- : 0);
                      },
                    ),

                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0B6E3F),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
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

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
  );

  Widget _textField(String hint) => TextField(
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

  Widget _dropdown(String hint) => TextField(
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
