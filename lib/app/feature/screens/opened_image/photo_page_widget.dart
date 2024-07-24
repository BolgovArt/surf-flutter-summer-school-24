import 'package:flutter/material.dart';
import 'package:surf_flutter_summer_school_24/app/feature/screens/opened_image/photo_page_model.dart';
import 'package:surf_flutter_summer_school_24/app/feature/theme/di/theme_inherited.dart';
import 'package:surf_flutter_summer_school_24/app/feature/theme/domain/theme_controller.dart';
import 'package:surf_flutter_summer_school_24/app/feature/theme/ui/theme_builder.dart';
import 'package:surf_flutter_summer_school_24/app/storage/images/images.dart';
import 'package:surf_flutter_summer_school_24/app/uikit/theme/theme_data.dart';
import 'package:surf_flutter_summer_school_24/app/uikit/styles/font_styles.dart';



class PhotoPage extends StatefulWidget {
  // final int currentIndex;
  final int index;
  const PhotoPage({super.key, required this.index});

  @override
  State<PhotoPage> createState() => _PageState();
  
}

class _PageState extends State<PhotoPage> {

// late PageController controller; //! забрал в model
  // int currentIndex = 0; //! забрал в model



  @override
  void initState() {
      controller = PageController(
      viewportFraction: 0.8,
      initialPage: widget.index,
    );
    currentIndex = widget.index;
    super.initState();
    controller.addListener(() {
      int newIndex = controller.page?.round() ?? 0;
      if (newIndex != currentIndex) {
        setState(() {
          currentIndex = newIndex;
        });
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return const ContentWidget();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}



class ContentWidget extends StatelessWidget {
  // final int currentIndex;
  // final PageController controller;
  // final Color? dynamicAppBarColorForTextSpan;
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = PhotoPageModelProvider.watch(context)?.model;
    final dynamicAppBarColorForTextSpan = Theme.of(context).appBarTheme.foregroundColor;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () { Navigator.of(context).pop(); },
          icon: const Icon(Icons.arrow_back)),
          title: Expanded(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(flex: 1),
                  Center(child: Text('01.01.2021', style: MyCustomStyle.mainTextThin,)),
                  const Spacer(flex: 1),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${model?.currentIndex} + 1}', // ! не очень хорошая практика: в результате мы не прибегаем к механизму notifyListenets, а обращаемся напрямую к полю в модели
                          style: MyCustomStyle.mainTextBold.copyWith(fontSize: 18, color: dynamicAppBarColorForTextSpan),
                        ),
                        TextSpan(
                          text: '/${images.length}',
                          style: MyCustomStyle.mainTextBoldGrey.copyWith(fontSize: 18, color: Color(0xAAAAAAAA)), 
                        )
                      ]
                    ),
                    )
                ]),
          ),
        ),
        body: PageView.builder(
          pageSnapping: false,
          controller: model?.controller,
          itemCount: images.length,
          itemBuilder: (context, index) {

            var _scale = model?.currentIndex == index ? 1.0 : 0.87;
            double _height = model?.currentIndex == index ? 600 : 390;

            return TweenAnimationBuilder(
              duration: const Duration(microseconds: 350),
              tween: Tween(begin: _scale, end: _scale),
              curve: Curves.ease,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Center(
                child: Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 5),
                  height: _height,
                  width: 557,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image:
                        DecorationImage(image: images[index], fit: BoxFit.cover),
                  ),
                ),
              ),
            );
          },
        ));
  }
}