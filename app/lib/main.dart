import 'package:app/items_model.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid/reorderable_grid.dart';
import 'package:flip_card/flip_card.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _globalKey = UniqueKey();
  final _gridViewKey = GlobalKey<_MyHomePageState>();
  final itemsModel = ItemsModel();
  final _scrollController = ScrollController();
  TransformationController _transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    Widget _buildCard(String title, Color? backColor, bool locked) {
      return Card(
        color: backColor,
        key: ValueKey(title),
        margin: EdgeInsets.zero,
        elevation: 2,
        shadowColor: Colors.black,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ChangeNotifierProvider.value(
              value: itemsModel,
              child: Consumer<ItemsModel>(builder: (context, model, child) {
                return InteractiveViewer(
                    boundaryMargin: const EdgeInsets.all(20),
                    constrained: false,
                    scaleEnabled: false,
                    transformationController: _transformationController,
                    onInteractionEnd: (details) {
                      // Details.scale can give values below 0.5 or above 2.0 and resets to 1
                      // Use the Controller Matrix4 to get the correct scale.
                      double correctScaleValue =
                          _transformationController.value.getMaxScaleOnAxis();
                    },
                    child: SizedBox(
                        width: 800,
                        height: 800,
                        child: ReorderableGridView(
                            key: _globalKey,
                            scrollController: _scrollController,
                            //enableScrollingWhileDragging: true,
                            //enableDraggable: true,
                            //fadeInDuration: Duration.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 8,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              childAspectRatio: 1,
                            ),
                            onReorder: (oldIndex, newIndex) => model.onReorder(
                                oldIndex: oldIndex, newIndex: newIndex),
                            children: model.items.mapIndexed((index, item) {
                              final FlipCardController _controller =
                                  FlipCardController();
                              return FlipCard(
                                key: ValueKey(item),
                                controller: _controller,
                                fill: Fill
                                    .fillBack, // Fill the back side of the card to make in the same size as the front.
                                direction: FlipDirection.HORIZONTAL,
                                side: CardSide.FRONT,
                                flipOnTouch: true,
                                autoFlipDuration: null,
                                onFlip: () {},
                                front: _buildCard(item, Colors.grey, false),
                                back:
                                    _buildCard(item, Colors.greenAccent, false),
                              );
                            }).toList())));
              }),
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }
}
