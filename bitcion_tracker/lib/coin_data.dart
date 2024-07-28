import 'dart:convert';

import 'package:http/http.dart'as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];


class CoinData {
  String url ;
  CoinData({required this.url});

  Future getData() async{
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      String data = response.body;

      var decodeData =jsonDecode(data);
      return decodeData;
    }else{
      print(response.statusCode);
    }
  }
}
