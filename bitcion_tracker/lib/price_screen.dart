import 'dart:core';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:bitcion_tracker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

String apikey = '{API_KEY}';


class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = "USD";

  int rate1 = 0;
  int rate2 = 0;
  int rate3 = 0;

  @override
  void initState() {
    super.initState();
    updateData(cryptoList[0]);
    updateData(cryptoList[1]);
    updateData(cryptoList[2]);
  }

  Widget Button(String crypto, int rate, String selectedCurrency) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
      child: Text(
        '1 $crypto = $rate $selectedCurrency',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void updateData(String crypto) async {
    try {
      CoinData coinData = CoinData(
          url:
          'https://api.polygon.io/v1/open-close/crypto/$crypto/$selectedCurrency/2023-01-09?adjusted=true&apiKey=$apikey');
      var data = await coinData.getData();

      if (data != null && data['openTrades'] != null && data['openTrades'].length > 1) {
        int rate = data['openTrades'][1]['p'].toInt();

        setState(() {
          if (crypto == cryptoList[0]) {

            rate1 = rate;
          } else if (crypto == cryptoList[1]) {

            rate2 = rate;
          } else if (crypto == cryptoList[2]) {

            rate3 = rate;
          }
        });
      } else {
        print('Invalid data for $crypto');
      }
    } catch (e) {
      print('Error fetching data for $crypto: $e');
    }
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            updateData(cryptoList[0]);
            updateData(cryptoList[1]);
            updateData(cryptoList[2]);
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> cupertinoMenuItem = [];

    for (String cup in currenciesList) {
      var text = Text(cup);
      cupertinoMenuItem.add(text);
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.00,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            updateData(cryptoList[0]);
            updateData(cryptoList[1]);
            updateData(cryptoList[2]);
          });
        },
        children: cupertinoMenuItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  Button(cryptoList[0], rate1, selectedCurrency),
                  Button(cryptoList[1], rate2, selectedCurrency),
                  Button(cryptoList[2], rate3, selectedCurrency)
                ],
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}
