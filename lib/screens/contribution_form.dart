import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tontine/components/button.dart';
import 'package:tontine/components/text_field.dart';
import 'package:tontine/models/user_model.dart';
import 'package:tontine/providers/user_provider.dart';
import 'package:tontine/utils/utils.dart';

class ContributionForm extends StatefulWidget {
  final UserModel? user;
  const ContributionForm({super.key, this.user});

  @override
  State<ContributionForm> createState() => _ContributionFormState();
}

class _ContributionFormState extends State<ContributionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contribDateController = TextEditingController();
  String? _selectedPaymentMethod;
  String? _selectedDate;
  bool isLoading = false;

  final List<String> _paymentMethods = [
    "Mobile Money",
    "Bank Transfer",
    "Cash",
  ];

  @override
  void initState(){
    super.initState();
    if (widget.user!= null) {
      setState(() {
        _nameController.text = widget.user!.name!;
        _contribDateController.text = DateTime.now().toString().split(' ')[0];
      });      
    }
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPaymentMethod == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a payment method")),
        );
        return;
      }

      // Simulated submission
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Contribution of \$${_amountController.text} successful!")),
      );

      // Reset form after submission
      _formKey.currentState!.reset();
      _amountController.clear();
      setState(() {
        _selectedPaymentMethod = null;
        _selectedDate = '';
        isLoading = !isLoading;
      });
    }
  }

  void selectDate() async {
    String? selectedDate = await pickDate(context);

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
        _contribDateController.text = _selectedDate!;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  final user = Provider.of<UserProvider>(context).user;
  return Scaffold(
    appBar: AppBar(
      title: const Text('Make a Contribution'),
      centerTitle: true,
    ),
    body: SafeArea( // Ensure the UI stays within screen bounds
      child: SingleChildScrollView( // Make the body scrollable when keyboard appears
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 230, 165, 1),
                Color.fromARGB(255, 239, 139, 0),
                Color.fromARGB(255, 255, 167, 38)
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: user != null &&
                              user.profileImage != null &&
                              user.profileImage!.isNotEmpty
                          ? NetworkImage(user.profileImage!) // Load from Firebase Storage URL
                          : AssetImage('assets/images/logo.jpg')
                              as ImageProvider, // Default image
                      child: (user == null ||
                              user.profileImage == null ||
                              user.profileImage!.isEmpty)
                          ? Icon(Icons.person,
                              size: 60,
                              color: Colors.white) // Show icon if no image
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Contribute",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Times',
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        controller: _nameController,
                        keyBoardType: TextInputType.number,
                        labelText: "Contributor's Name",
                        suffixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: _amountController,
                        keyBoardType: TextInputType.number,
                        labelText: "Contributor ID",
                        suffixIcon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your ID";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      CustomTextField(
                        controller: _amountController,
                        keyBoardType: TextInputType.number,
                        labelText: "Contribution Amount",
                        suffixIcon: Icons.attach_money,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter an amount";
                          }
                          if (double.tryParse(value) == null ||
                              double.parse(value) <= 0) {
                            return "Enter a valid amount";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedPaymentMethod,
                        decoration: const InputDecoration(
                          labelText: "Payment Method",
                          prefixIcon: Icon(Icons.payment),
                          border: OutlineInputBorder(),
                        ),
                        items: _paymentMethods.map((method) {
                          return DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? "Select a payment method" : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: selectDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            labelText: "Contribution Date",
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                          child: Text(
                            "$_selectedDate",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: CustomButton(
                          text: 'Contribute Now',
                          isLoading: isLoading,
                          onPressed: _submitForm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

}
