import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoanPredictionForm(),
    );
  }
}

class LoanPredictionForm extends StatefulWidget {
  @override
  _LoanPredictionFormState createState() => _LoanPredictionFormState();
}

class _LoanPredictionFormState extends State<LoanPredictionForm> {
  final _formKey = GlobalKey<FormState>();

  String gender = 'Female';
  String married = 'No';
  String dependents = '0';
  String education = 'Graduate';
  String selfEmployed = 'No';
  double applicantIncome = 0.0;
  double coapplicantIncome = 0.0;
  double loanAmount = 0.0;
  double loanAmountTerm = 0.0;
  double creditHistory = 1.0;
  String propertyArea = 'Urban';
  String loanStatus = 'N';

  Future<void> predictLoanStatus() async {
    print('here');
    final url = Uri.parse('http://127.0.0.1:8000/predict');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'Gender': gender,
          'Married': married,
          'Dependents': dependents,
          'Education': education,
          'Self_Employed': selfEmployed,
          'ApplicantIncome': applicantIncome,
          'CoapplicantIncome': coapplicantIncome,
          'LoanAmount': loanAmount,
          'Loan_Amount_Term': loanAmountTerm,
          'Credit_History': creditHistory,
          'Property_Area': propertyArea,
          'Loan_Status': loanStatus,
        }),
      );

      if (response.statusCode == 200) {
        print('==================================');
        final result = json.decode(response.body);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Prediction'),
            content: Text('Loan Status: ${result['prediction']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        print('==***************************************');
        showErrorDialog(
            'Failed to load prediction. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog('Failed to load prediction. Error: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Prediction Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Gender'),
                onChanged: (String? newValue) {
                  setState(() {
                    gender = newValue!;
                  });
                },
                items: <String>['Female', 'Male']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: married,
                decoration: InputDecoration(labelText: 'Married'),
                onChanged: (String? newValue) {
                  setState(() {
                    married = newValue!;
                  });
                },
                items: <String>['No', 'Yes']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: dependents,
                decoration: InputDecoration(labelText: 'Dependents'),
                onChanged: (String? newValue) {
                  setState(() {
                    dependents = newValue!;
                  });
                },
                items: <String>['0', '1', '2', '3+']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: education,
                decoration: InputDecoration(labelText: 'Education'),
                onChanged: (String? newValue) {
                  setState(() {
                    education = newValue!;
                  });
                },
                items: <String>['Graduate', 'Not Graduate']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<String>(
                value: selfEmployed,
                decoration: InputDecoration(labelText: 'Self Employed'),
                onChanged: (String? newValue) {
                  setState(() {
                    selfEmployed = newValue!;
                  });
                },
                items: <String>['No', 'Yes']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Applicant Income'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  applicantIncome = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter applicant income';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Coapplicant Income'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  coapplicantIncome = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter coapplicant income';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  loanAmount = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loan amount';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Loan Amount Term'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  loanAmountTerm = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loan amount term';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Credit History'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  creditHistory = double.parse(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter credit history';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: propertyArea,
                decoration: InputDecoration(labelText: 'Property Area'),
                onChanged: (String? newValue) {
                  setState(() {
                    propertyArea = newValue!;
                  });
                },
                items: <String>['Rural', 'Semiurban', 'Urban']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    predictLoanStatus();
                  }
                },
                child: Text('Predict Loan Status'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
