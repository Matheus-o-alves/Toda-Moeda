import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=cb155f84";

void main() {
  runApp(
    MaterialApp(
      title: 'Toda Moeda',
      home: Home(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
    ),
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _MyHome createState() => _MyHome();
}

class _MyHome extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();
  final pesoController = TextEditingController();
  final bitcoinController = TextEditingController();

  void _RealOnChange(String value) {
    double reais = double.parse(value);
    dolarController.text = (reais / dolar).toStringAsFixed(2);
    euroController.text = (reais / euro).toStringAsFixed(2);
    pesoController.text = (reais / peso).toStringAsFixed(2);
    bitcoinController.text = (reais / bitcoins).toStringAsFixed(2);
  }

  void _DolarOnChange(String value) {
    double dolar = double.parse(value);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = ((dolar * this.dolar) / euro).toStringAsFixed(2);
    pesoController.text = ((dolar * this.dolar) / peso).toStringAsFixed(2);
    bitcoinController.text =
        ((dolar * this.dolar) / bitcoins).toStringAsFixed(2);
  }

  void _EuroOnChange(String value) {
    double euro = double.parse(value);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = ((euro * this.euro) / dolar).toStringAsFixed(2);
    pesoController.text = ((euro * this.euro) / peso).toStringAsFixed(2);
    bitcoinController.text = ((euro * this.euro) / bitcoins).toStringAsFixed(2);
  }

  void _PesoOnChange(String value) {
    double peso = double.parse(value);
    realController.text = (peso * this.peso).toStringAsFixed(2);
    euroController.text = ((peso * this.peso) / euro).toStringAsFixed(2);
    dolarController.text = ((peso * this.peso) / dolar).toStringAsFixed(2);
    bitcoinController.text = ((peso * this.peso) / bitcoins).toStringAsFixed(2);
  }

  void _BitcoinsOnChange(String value) {
    double bitcoins = double.parse(value);
    realController.text = (bitcoins * this.bitcoins).toStringAsFixed(2);
    euroController.text =
        ((bitcoins * this.bitcoins) / euro).toStringAsFixed(2);
    dolarController.text =
        ((bitcoins * this.bitcoins) / dolar).toStringAsFixed(2);
    pesoController.text =
        ((bitcoins * this.bitcoins) / peso).toStringAsFixed(2);
  }

  double dolar;
  double bitcoins;
  double peso;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text('\$ Toda Moeda \$'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: Text(
                  "Carregando...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );

            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Ocorreu um erro",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                peso = snapshot.data["results"]["currencies"]["ARS"]["buy"];
                bitcoins = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                return SingleChildScrollView(
                  padding: EdgeInsets.all(11.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 130.0,
                        color: Colors.amber,
                      ),
                      buildTextField(
                          "Real", "R\$:", realController, _RealOnChange),
                      Divider(),
                      buildTextField(
                          "Euro", "€:", euroController, _EuroOnChange),
                      Divider(),
                      buildTextField(
                          "Dolar", "U\$\$:", dolarController, _DolarOnChange),
                      Divider(),
                      buildTextField(
                          "Pesos", "\$:", pesoController, _PesoOnChange),
                      Divider(),
                      buildTextField("Bticoin", "₿:", bitcoinController,
                          _BitcoinsOnChange),
                      Divider(),
                    ],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController controller, Function onChange) {
  return TextField(
    controller: controller,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    style: TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white,
        fontSize: 10,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    onChanged: onChange,
  );
}
