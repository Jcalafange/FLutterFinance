import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../styles/Cores.dart';
import '../view/Conversor.dart';
import '../view/BolsaValores.dart';
import '../view/Bitcoin.dart';
import '../view/Ibovespa.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  _DrawerComponentState();

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Row(
      children: [
        Drawer(
          backgroundColor: Cores.primaryColor,
          child: ListView(children: <Widget>[
            ListTile(
                leading: Icon(FontAwesomeIcons.globe),
                title: Text("Bolsa de valores"),
                subtitle: Text("veja a situção da maiores bolsas do mundo!"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BolsaValores()));
                }),
            ListTile(
                leading: Icon(Icons.account_balance),
                title: Text("Conversor"),
                subtitle: Text("faça suas conversões!"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Conversor()));
                }),
            ListTile(
                leading: Icon(FontAwesomeIcons.bitcoin),
                title: Text("Bitcoin"),
                subtitle: Text("Bitcoin hoje!"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Bitcoin()));
                }),
            ListTile(
                leading: Icon(FontAwesomeIcons.arrowTrendUp),
                title: Text("Ibovespa"),
                subtitle: Text("veja suas ações favoritas!"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Ibovespa()));
                }),
          ]),
        )
      ],
    );
  }
}
