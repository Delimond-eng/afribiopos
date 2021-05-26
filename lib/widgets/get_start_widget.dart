
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:location/location.dart';

class StartWidget extends StatefulWidget {
  final Function onStart;
  StartWidget({Key key, this.onStart}): super(key: key);
  @override
  _StartWidgetState createState() => _StartWidgetState();
}

class _StartWidgetState extends State<StartWidget> {
  Timer timer;
  int _currentPage = 0;
  final PageController _pageController =PageController(
    initialPage: 0
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        if(_currentPage < 2){
          _currentPage++;
        }
        else{
          _currentPage = 0;
        }

        _pageController.animateToPage(
            _currentPage,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn
        );
      });
    });

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  void checkPermission() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        EasyLoading.showInfo("please enable your mobile gps !",duration: Duration(seconds: 5));
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        EasyLoading.showInfo("please enable your mobile gps !",duration: Duration(seconds: 5));
        return null;
      }
    }
    else if(_permissionGranted == PermissionStatus.granted){
      EasyLoading.show(status: 'Patientez SVP...',  maskType: EasyLoadingMaskType.black);
      timer.cancel();
      await Future.delayed(Duration(seconds: 2), (){
        widget.onStart();
      });
    }

    _locationData = await location.getLocation();

  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _onPageChanged(int index){
    setState(() {
      _currentPage = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green[500],
            Colors.green[100],
            Colors.green[50],
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomLeft,
        )
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    PageView.builder(
                        controller: _pageController,
                        onPageChanged: _onPageChanged,
                        physics: BouncingScrollPhysics(),
                        itemCount: slideList.length,
                        allowImplicitScrolling: true,
                        itemBuilder: (context, index){
                          return SlideItem(index);
                        }
                    ),

                    Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 35),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              for(int i=0; i<slideList.length; i++)
                                if(i == _currentPage)
                                  SliderDot(true)
                                else
                                  SliderDot(false)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child:Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 10,
                          offset: Offset(5,5)
                        )
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Colors.green[500],
                          Colors.green[900]
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter
                      )
                    ),
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      onPressed: (){
                        checkPermission();
                      },
                      child: Text('Continuer'.toUpperCase(),
                        style:TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 3.0,
                            fontSize: 14
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SlideItem extends StatelessWidget {
  final int index;
  SlideItem(this.index);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(slideList[index].imageUrl),
                    fit: BoxFit.fill,
                  )
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(slideList[index].title,
                  style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.w900,
                      fontSize: 23,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                            color: Colors.black12,
                            offset: Offset(0,2.5),
                            blurRadius: 1
                        )
                      ]
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(slideList[index].desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontSize: 13
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }
}

class SliderDot extends StatelessWidget {
  bool isActive;
  SliderDot(this.isActive);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: isActive ? 12 : 8,
        width: isActive ? 12 : 8 ,
        
      decoration: BoxDecoration(
        color:  isActive ? Colors.green[700] : Colors.grey[600],
        borderRadius: BorderRadius.circular(12)
      ),
    );
  }
}



class Slide{
  final String imageUrl;
  final String title;
  final String desc;

  Slide({
    this.imageUrl,
    this.title,
    this.desc
  });
}


final slideList = [
  Slide(
    imageUrl: 'assets/images/slider1.png',
    title: 'Bienvenu sur afribio POS',
    desc: 'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.'
  ),
  Slide(
    imageUrl: 'assets/images/slider2.png',
    title: 'Commencez votre journée',
    desc: 'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.'
  ),
  Slide(
    imageUrl: 'assets/images/slider3.png',
    title: 'Laissez-vous guider !',
    desc: 'But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness.'
  ),
];
