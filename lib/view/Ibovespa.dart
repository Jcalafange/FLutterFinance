import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/Cores.dart';
import '../components/DrawerComponent.dart';

class Ibovespa extends StatefulWidget {
  const Ibovespa({super.key});

  @override
  _IbovespaState createState() => _IbovespaState();
}

class _IbovespaState extends State<Ibovespa> {
  List<String> stocks = [];
  Map<String, dynamic> stockData = {};

  Future<Map> fetchData() async {
    const requestStocksName = "https://brapi.dev/api/available";
    http.Response response = await http.get(Uri.parse(requestStocksName));
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>?> fetchAuthorizedData(stock) async {
    var requestStocksInfo = "https://brapi.dev/api/quote/$stock";
    var token = "qCq4W747o8gHvBc8uYzhJP";

    var headers = {
      'modules': 'balanceSheetHistory',
      'dividends': 'true',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };

    var response =
        await http.get(Uri.parse(requestStocksInfo), headers: headers);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      var symbol = jsonData['results'][0]['symbol'];
      var longName = jsonData['results'][0]['longName'];
      var currentPrice = jsonData['results'][0]['regularMarketPrice'];
      var logourl = jsonData['results'][0]['logourl'];
      var extractedData = {
        'logourl': logourl,
        'currentPrice': currentPrice,
        'symbol': symbol,
        'longName': longName,
      };

      return extractedData;
    } else {
      print('Erro na requisição: ${response.statusCode}');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.secondaryColor,
      drawer: Drawer(child: DrawerComponent()),
      appBar: AppBar(
        title: Text("Ibovespa"),
        centerTitle: true,
        backgroundColor: Cores.primaryColor,
      ),
      body: FutureBuilder<Map>(
          future: fetchData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return const Center(
                    child: Text(
                  "Carregando dados...",
                  style: TextStyle(color: Cores.primaryColor, fontSize: 25.0),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return const Center(
                      child: Text(
                    "Erro ao carregar dados...",
                    style: TextStyle(color: Cores.primaryColor, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  List<String> stocks =
                      List<String>.from(snapshot.data!['stocks']);
                  Map<String, dynamic> stockData = {};
                  return StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            color: Cores.tileColor,
                            child: Autocomplete<String>(
                              optionsBuilder:
                                  (TextEditingValue textEditingValue) {
                                if (textEditingValue.text == '') {
                                  return const Iterable<String>.empty();
                                } else {
                                  List<String> matches = <String>[];
                                  matches.addAll(stocks);

                                  matches.retainWhere((s) {
                                    return s.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                  return matches;
                                }
                              },
                              onSelected: (String selection) async {
                                var fetchedData =
                                    (await fetchAuthorizedData(selection))!;
                                setState(() {
                                  stockData = fetchedData;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 400,
                            color: const Color.fromRGBO(225, 118, 3, 1),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(stockData.isNotEmpty
                                      ? '${stockData['symbol']}'
                                      : 'Selecione uma ação'),
                                  subtitle: Text(
                                    stockData.isNotEmpty
                                        ? '${stockData['longName']}'
                                        : '',
                                  ),
                                ),
                                Text(
                                  stockData.isNotEmpty
                                      ? 'Preço atual: ${stockData['currentPrice']}'
                                      : '',
                                  style: TextStyle(fontSize: 16.0),
                                  textAlign: TextAlign.right,
                                ),
                                if (stockData['logourl'] != null)
                                  SvgPicture.network(
                                    stockData['logourl'],
                                    height: 100,
                                    width: 100,
                                  )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  });
                }
            }
          }),
    );
  }
}
