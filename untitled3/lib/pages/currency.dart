//import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/common/base_screen.dart';
import 'package:untitled3/models/app_model.dart';
import 'package:untitled3/models/currency.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({Key? key}) : super(key: key);

  @override
  _CurrencyPageState createState() => _CurrencyPageState();
}

class _CurrencyPageState extends BaseScreen<CurrencyPage> {

  /*late String currencyDisplay;

  @override
  void afterFirstLayout(BuildContext context) {
    currencyDisplay = Provider.of<AppModel>(context, listen: false).currency!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List data = kAdvanceConfig['Currencies'] ?? [];
    final currencies = data.map((e) => Currency.fromJson(e)).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Currencies"),
      ),
      body: ListView.separated(
        itemCount: currencies.length,
        separatorBuilder: (_, __) => const Divider(
          color: Colors.black12,
          height: 1.0,
          indent: 75,
          //endIndent: 20,
        ),
        itemBuilder: (_, index) {
          return buildItem(currencies[index]);
        },
      ),
    );
  }

  Widget buildItem(Currency currency) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: ListTile(
        title: Text('${currency.currencyDisplay} (${currency.symbol})',
          style: TextStyle(color: Colors.black),),
        onTap: () {
          setState(() {
            currencyDisplay = currency.currencyDisplay;
          });

          Provider.of<AppModel>(context, listen: false).changeCurrency(
            currency.currencyDisplay,
            context,
            code: currency.currencyCode,
          );
        },
        trailing: currencyDisplay == currency.currencyDisplay
            ? const Icon(Icons.done)
            : Container(
          width: 20,
        ),
      ),
    );
  }*/

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  //here we have decleared the variables, that store rates from API
  late double dollar_buy;
  late double euro_buy;

  void _clearAll() {
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real / dollar_buy).toStringAsFixed(2);
    euroController.text = (real / euro_buy).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dollar_buy).toStringAsFixed(2);
    euroController.text =
        (dolar * this.dollar_buy / euro_buy).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro_buy).toStringAsFixed(2);
    dolarController.text =
        (euro * this.euro_buy / dollar_buy).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Converter"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: getData(),
          //snapshot of the context/getData
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                        "Error :(",
                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                        textAlign: TextAlign.center,
                      ));
                } else {
                  dollar_buy =
                  //here we pull the us and eu rate
                  snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro_buy =
                  snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          /*Icon(Icons.monetization_on,
                          size: 150.0, color: Colors.amber),*/
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildTextField(
                                "Reals", "R\$", realController, _realChanged),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildTextField(
                                "Dollars", "US\$", dolarController, _dolarChanged),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildTextField(
                                "Euros", "€", euroController, _euroChanged),
                          ),
                        ],
                      ));
                }
            }
          }),
    );
  }
}
