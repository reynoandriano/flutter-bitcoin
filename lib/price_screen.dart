import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bitcoin/coin_data.dart';
import 'dart:io' show Platform;
import 'package:bitcoin/services/networking.dart';
import 'package:intl/intl.dart' as intl;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  String selectedCoin = 'BTC';
  dynamic selectedRate = '0';

  void getExchangeRate(String currency, String coin) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/$coin/$currency?apikey=AF8811D7-0628-41D7-A625-ADFFE55D583F';

    NetworkHelper networkHelper = NetworkHelper(url: url);
    var exchangeData = await networkHelper.getData();

    setState(() {
      selectedCoin = coin;
      selectedRate =
          intl.NumberFormat.decimalPattern().format(exchangeData['rate']);
    });
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      dropdownItems.add(DropdownMenuItem(
        child: Text(currency),
        value: currency,
      ));
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          // print(selectedCurrency);
          getExchangeRate(selectedCurrency, selectedCoin);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        // print(selectedCurrency);
        getExchangeRate(selectedCurrency, selectedCoin);
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getExchangeRate(selectedCurrency, selectedCoin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 $selectedCoin = $selectedRate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
