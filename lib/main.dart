import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/vistas/pantalla_invertir.dart';
import 'package:flutter_app/vistas/pantalla_simular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'constantes/colores.dart';
import 'constantes/operations.dart';
import 'vistas/pantalla_prestamo.dart';

import 'modeloControlador/Controller.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends StateMVC{
  _MyHomePageState() : super(Controller());
  int current = 0;

  // Handle Indicator
  List<T> mapa<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    Controller.inicializarPanel();
    return Scaffold(
      body: Container(
          margin: EdgeInsets.only(top:8),
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left:8, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Bienvenido/a', style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3A3A3A),
                              ),
                              ),
                              Text('${Controller.nombre} ${Controller.apellidos}', style: GoogleFonts.inter(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF3A3A3A),
                              ),)
                            ],
                          )
                      ),
                      Container(
                        height: 59,
                        width: 59,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: AssetImage('assets/images/profile.png')
                            )
                        ),
                        child: InkWell(
                          onTap: () {
                            Controller.reiniciarPanel();
                            setState(() { });
                            ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                            content: const Text('Reiniciando...'),
                            ),
                            );
                          },
                          child: Ink(height: 100, width: 100),
                        )
                      )
                    ],
                  )
              ),
              // Segunda sección

              SizedBox(
                height: 25,
              ),
              Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 16, right:6),
                    itemCount: Controller.numCuentas(),
                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          margin: EdgeInsets.only(right:10),
                          height: 150,
                          width: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            color: Color(0xFF1E1E99),
                          ),

                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                child: SvgPicture.asset('assets/svg/ellipse_top_pink.svg'),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: SvgPicture.asset('assets/svg/ellipse_bottom_pink.svg'),
                              ),
                              Positioned(
                                left: 29,
                                top: 25,
                                child: Text('NUMERO DE CUENTA', style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),),
                              ),
                              Positioned(
                                left: 29,
                                top: 45,
                                child: Text('${Controller.getIBANCuenta(index)}', style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFFFFFFF),
                                ),),
                              ),
                              Positioned(
                                left: 29,
                                bottom: 55,
                                child: Text('SALDO:', style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFFFFFFF),
                                ),),
                              ),
                              Positioned(
                                left: 29,
                                bottom: 20,
                                child: Text(('${Controller.getSaldoCuenta(index)}').replaceAll('.',',') + ' €', style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFFFFFFF),
                                ),),
                              )
                            ],
                          ),

                        ),
                      );
                    },
                  )
              ),
              //Operaciones
              Padding(
                padding:
                EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Operaciones',
                      style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF3A3A3A)),
                    ),
                    Row(
                      children: mapa<Widget>(
                        datas,
                            (index, selected) {
                          return Container(
                            alignment: Alignment.centerLeft,
                            height: 9,
                            width: 9,
                            margin: EdgeInsets.only(right: 6),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: current == index
                                    ? Color(0xFF1E1E99)
                                    : Color(0x201E1E99)),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),

              Container(
                height: 123,
                child: ListView.builder(
                  itemCount: datas.length,
                  padding: EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                          if(index == 0){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (context) => pantalla_prestamo(),
                            ),
                            ).then((_) {
                              // Call setState() here or handle this appropriately
                              setState(() { });
                            });
                          }
                          if(index == 1){
                            Navigator.of(context).push(MaterialPageRoute(
                              builder:
                                  (context) => pantalla_invertir(),
                            ),
                            ).then((_) {
                              // Call setState() here or handle this appropriately
                              setState(() { });
                            });
                          }
                          if(index == 2) {
                             Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) =>
                                     pantalla_simular()));
                          }
                        });
                      },
                      child: OperationCard(
                          operation: datas[index].name,
                          selectedIcon: datas[index].selectedIcon,
                          unselectedIcon: datas[index].unselectedIcon,
                          isSelected: current == index,
                          context: this),
                    );
                  },
                ),
              ),
              // Transaction Section
              Padding(
                padding:
                EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Text(
                  'Inversiones',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                ),
              ),
              ListView.builder(
                itemCount: Controller.numInversiones(),
                padding: EdgeInsets.only(left: 16, right: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 76,
                    margin: EdgeInsets.only(bottom: 13),
                    padding:
                    EdgeInsets.only(left: 15, top: 12, bottom: 12, right: 22),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: kTenBlackColor,
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(8.0, 8.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 57,
                              width: 57,
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   image: DecorationImage(
                              //     image: AssetImage(transactions[index].photo),
                              //   ),
                              // ),
                              child: Icon(
                                Icons.euro,
                                color: Colors.pink,
                                size: 24.0,
                                semanticLabel: 'Text to announce in accessibility modes',
                              ),
                            ),

                            SizedBox(
                              width: 13,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  Controller.getDescripcionInversion(index),
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: kBlackColor),
                                ),
                                Text(
                                  '${Controller.getCantidadInicialInversion(index)}',
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: kGreyColor),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('${Controller.getCantidadActualInversion(index)}', style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: kBlueColor
                            ),)
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
// Transaction Section
              Padding(
                padding:
                EdgeInsets.only(left: 16, bottom: 13, top: 29, right: 10),
                child: Text(
                  'Préstamos',
                  style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: kBlackColor),
                ),
              ),
              ListView.builder(
                itemCount: Controller.numPrestamos(),
                padding: EdgeInsets.only(left: 16, right: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    height: 76,
                    margin: EdgeInsets.only(bottom: 13),
                    padding:
                    EdgeInsets.only(left: 15, top: 12, bottom: 12, right: 22),
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: kTenBlackColor,
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(8.0, 8.0),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 57,
                              width: 57,
                              // decoration: BoxDecoration(
                              //   shape: BoxShape.circle,
                              //   image: DecorationImage(
                              //     image: AssetImage(transactions[index].photo),
                              //   ),
                              // ),
                              child: Icon(
                                Icons.euro,
                                color: Colors.pink,
                                size: 24.0,
                                semanticLabel: 'Text to announce in accessibility modes',
                              ),
                            ),

                            SizedBox(
                              width: 13,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '${Controller.getDescripcionPrestamo(index)}',
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: kBlackColor),
                                ),
                                Text(
                                  '${Controller.getCuotasPrestamo(index)}',
                                  style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: kGreyColor),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text('${Controller.getCantidadPrestamo(index)} €', style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: kBlueColor
                            ),)
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          )
      ),
    );
  }

}

// class _MyHomePageState extends StateMVC{
//   _MyHomePageState() : super(Controller());
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(MyHomePage.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//                 MyHomePage.title
//             ),
//             Text(
//               '${Controller.displayThis}',
//               style: Theme.of(context).textTheme.display1,
//             )
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           setState(Controller.whatever);
//         },
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

class OperationCard extends StatefulWidget {
  final String operation;
  final String selectedIcon;
  final String unselectedIcon;
  final bool isSelected;
  _MyHomePageState context;

  OperationCard(
      {required this.operation,
        required this.selectedIcon,
        required this.unselectedIcon,
        required this.isSelected,
        required this.context});

  @override
  _OperationCardState createState() => _OperationCardState();
}

class _OperationCardState extends State<OperationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      width: 123,
      height: 123,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(8.0, 8.0),
            )
          ],
          borderRadius: BorderRadius.circular(15),
          color: widget.isSelected ? Color(0xFF1E1E99) : Color(0xFFFFFFFF)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
              widget.isSelected ? widget.selectedIcon : widget.unselectedIcon),
          SizedBox(
            height: 9,
          ),
          Text(
            widget.operation,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: widget.isSelected ? Color(0xFFFFFFFF) : Color(
                    0xFF1E1E99)),
          )
        ],
      ),
    );
  }
}