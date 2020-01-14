import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:uni_discente/models/noticias.model.dart';
import 'package:uni_discente/util/toast.util.dart';
import 'package:uni_discente/util/date.util.dart';
import 'package:url_launcher/url_launcher.dart';

class Noticia extends StatelessWidget {
  NoticiaModel noticia;

  Noticia(this.noticia);

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(
          left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      elevation: 4.0,
      child: InkWell(
          onTap: () async {
            String url = noticia.url;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ToastUtil.showToast('Não foi possível abrir a url: $url');
            }
          },
          child: _getListTile()),
    );
  }

  Widget _getListTile() {
    // Foi adicionado dentro de Container para adicionar altura fixa.
    return new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _loadImage(),
        _getColumText(
            this.noticia.titulo, this.noticia.data, this.noticia.resumo),
      ],
    );
  }

  Widget _getColumText(title, date, description) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getTitleWidget(title),
          _getDescriptionWidget(description),
          Row(
            children: <Widget>[
              
                      Align(
                        alignment: Alignment.centerLeft,
                                              child: SizedBox(
                          height: 25,
                          width: 30,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Image.asset('assets/logo_unilab.png'),
                          )
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Unilab  •  ${DateUtil.getTimeElapsedByDate(date)}',style: TextStyle(fontSize: 11,color: Colors.grey[700]),)  
               ,
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: FlatButton(
                      child: Icon(
                        Icons.more_vert,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                      onPressed: () {
                        _showModalBottomSheet(this._context);
                      },
                    ),
                  ),
                ),
              ),
            ],
          )
        ]);
  }

  Widget _getTitleWidget(String curencyName) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 16),
      child: Text(
        curencyName,
        maxLines: 4,
        style: new TextStyle(
            fontSize: 17.9, fontWeight: FontWeight.w400, color: Colors.black),
      ),
    );
  }

  Widget _getDescriptionWidget(String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 5),
      child: Text(
        description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: new TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  Widget _getDateWidget(String date) {
    return new Text(
      date,
      style: new TextStyle(color: Colors.grey, fontSize: 10.0),
    );
  }

  void _showModalBottomSheet(context) {
    showModalBottomSheet(
      elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
              
                 Padding(
                   padding: const EdgeInsets.only(top: 5),
                   child: ListTile(
                      leading: Icon(Icons.share,size: 20,
                      color: Colors.grey[600],
                      ),
                      title: Align(
                        alignment: Alignment(-1.2, 0),
                        child: Text('Compartilhar',style: TextStyle(fontSize: 14),
                        )),
                      onTap: () => {
                            Share.share(
                                'Veja esta notícia:\n*${this.noticia.titulo}*\n${this.noticia.url}')
                          }),
                 ),
                 ListTile(
                      leading: Icon(Icons.open_in_browser,size: 20,
                      color: Colors.grey[600],
                      ),
                      title: Align(
                        alignment: Alignment(-1.25, 0),
                        child: Text('Abrir no Navegador',style: TextStyle(fontSize: 14),
                        )),
                      onTap: () async {
                            String url = noticia.url;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              ToastUtil.showToast('Não foi possível abrir a url: $url');
            }
                          }),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(color: Colors.grey[300], height: 1),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Fechar",
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _loadImage() {
    return new FadeInImage(
      image: Image.network(this.noticia.imagem).image,
      fit: BoxFit.cover,
      width: 185.0,
      height: 185.0,
      placeholder: Image.memory(kTransparentImage).image,
    );
  }
}
