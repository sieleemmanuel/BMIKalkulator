import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Kalkulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'BMI Kalkulator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int id = 0;
  String selectedGender = "Male";
  String calculatedBMI = "";
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final ageController = TextEditingController();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _calculateBMI() {
    int age = int.parse(ageController.text);
    double height = double.parse(heightController.text);
    double weight = double.parse(weightController.text);
    setState(() {
      if (age >= 18 && age <= 30) {
        calculatedBMI = ((weight * 1.3) / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      } else if (selectedGender == "Male" && age >= 31 && age <= 60) {
        calculatedBMI = ((weight * 1.5) / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      } else if (selectedGender == "Female" && age >= 31 && age <= 60) {
        calculatedBMI = ((weight * 1.4) / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      } else if (selectedGender == "Male" && age > 60) {
        calculatedBMI = ((weight * 1.7) / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      } else if (selectedGender == "Female" && age > 60) {
        calculatedBMI = ((weight * 1.6) / ((height / 100) * (height / 100)))
            .toStringAsFixed(1);
      } else {
        calculatedBMI =
            (weight / ((height / 100) * (height / 100))).toStringAsFixed(1);
      }
    });
  }

  bool validFields() {
    if (id == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Select Gender")));
      return false;
    } else if (weightController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Weight")));
      return false;
    } else if (heightController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Height")));
      return false;
    } else if (ageController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Enter Age")));
      return false;
    } else {
      return true;
    }
  }

  /* @override
  void dispose(){
    weightController.dispose();
    heightController.dispose();
    ageController.dispose();
    super.dispose();
  }*/

  clearFields() {
    weightController.clear();
    heightController.clear();
    ageController.clear();
    setState(() {
      id = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
            systemOverlayStyle: const SystemUiOverlayStyle(
                // Android support
                statusBarColor: Colors.blue,
                statusBarIconBrightness: Brightness.light,
                //IOS Support
                statusBarBrightness: Brightness.light)),
        body: ListView(children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("Select Gender"),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            selectedGender = "Male";
                            id = 1;
                          });
                        }),
                    const Text("Male"),
                    const SizedBox(width: 20.0),
                    Radio(
                        value: 2,
                        groupValue: id,
                        onChanged: (val) {
                          setState(() {
                            selectedGender = "Female";
                            id = 2;
                          });
                        }),
                    const Text("Female"),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text("Enter our Weight in Kgs"),
                const SizedBox(height: 10.0),
                TextField(
                  controller: weightController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 20.0),
                const Text("Enter your Height in cm"),
                const SizedBox(height: 10.0),
                TextField(
                    controller: heightController,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(border: OutlineInputBorder())),
                const SizedBox(height: 20.0),
                const Text("Enter your Age"),
                const SizedBox(height: 10.0),
                TextField(
                  controller: ageController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                const SizedBox(height: 50.0),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder()),
                          onPressed: () {
                            if (validFields()) {
                              _calculateBMI();
                              debugPrint("BMI: $calculatedBMI");
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: const Text("BMI Result"),
                                        content: Text(
                                          calculatedBMI,
                                          textScaleFactor: 2.0,
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                clearFields();
                                              },
                                              child: const Text("OK"))
                                        ],
                                      ));
                            } else {
                              /* var snackBar = const SnackBar(
                                  content: Text("Enter valid values"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);*/
                              validFields();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
