import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:uni_discente/blocs/usuario.bloc.dart';
import 'package:uni_discente/repositories/notas.repository.dart';
import 'package:uni_discente/ui/boletim.ui.dart';
import 'package:uni_discente/ui/login.ui.dart';
import 'package:uni_discente/ui/noticias.ui.dart';
import 'package:uni_discente/ui/perfil.ui.dart';
import 'package:uni_discente/ui/turmas.ui.dart';
import '../settings.dart';

class InicioPage extends StatefulWidget {
  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _currentIndex = 0;

  String _title;
  final List<Widget> _children = [
    NoticiasPage(),
    TurmasPage(),
    BoletimPage(),
    PerfilScreen(),
  ];
  PageController pageController = PageController();

  void _onItemTapped(int index) {
    pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      switch (index) {
        case 0:
          {
            _title = 'Notícias';
          }
          break;
        case 1:
          {
            _title = 'Turmas';
          }
          break;
        case 2:
          {
            _title = 'Boletim';
          }
          break;
        case 3:
          {
            _title = 'Perfil';
          }
          break;
      }
    });
  }

  Widget _bottomNavigationBar(int currentIndex, Function onTap) =>
      BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.web),
              title: Text('Notícias'),
              backgroundColor: Colors.green),
          new BottomNavigationBarItem(
              icon: Icon(Icons.school),
              title: Text('Turmas'),
              backgroundColor: Colors.blue),
          new BottomNavigationBarItem(
              icon: Icon(Icons.timeline),
              title: Text('Boletim'),
              backgroundColor: Colors.orange),
          new BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('Perfil'),
              backgroundColor: Colors.red)
        ],
      );

  @override
  void initState() {
    _title = "Notícias";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
          elevation: 1.0,
          actions: <Widget>[
            IconButton(
              icon: CircleAvatar(
                radius: 13,
                backgroundColor: Colors.transparent,
                child: CachedNetworkImage(
                  imageUrl: Settings.usuario.urlImagemPerfil,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => Icon(
                    Icons.account_circle,
                    color: Colors.grey[200],
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.account_circle, color: Colors.grey[200]),
                ),
              ),
              onPressed: () async {
                print("Tocou na foto de Perfil");
                await UsuarioBloc().deslogar();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            )
          ],
        ),
        body: PageView(
          controller: pageController,
          onPageChanged: _onPageChanged,
          children: _children,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar:
            _bottomNavigationBar(_currentIndex, _onItemTapped));
  }
}
