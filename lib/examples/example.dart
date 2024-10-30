import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset.zero;

  final List<String> _images = [
    'https://picsum.photos/seed/1/200/200',
    'https://picsum.photos/seed/2/200/200',
    'https://picsum.photos/seed/3/200/200',
  ];

  final List<String> _acceptedImages = [];

  Color dragTargetBgColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          ..._images.map(
            (url) => Positioned(
              top: 0,
              left: _images.indexOf(url) * 100,
              // top: _offset.dy,
              // left: _offset.dx,
              child: Draggable<String>(
                data: url,
                onDragUpdate: (details) {
                  setState(() {
                    _offset = details.globalPosition - const Offset(50, 100);
                  });
                },
                onDragEnd: (details) {
                  print(details.offset);
                  print(details.velocity);
                  print(details.wasAccepted);
                },
                feedback: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(url),
                ),
                dragAnchorStrategy: (draggable, context, position) {
                  return childDragAnchorStrategy(draggable, context, position);
                },
                childWhenDragging: const SizedBox.shrink(),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(url),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DragTarget<String>(
              builder: (
                BuildContext context,
                List<Object?> candidateData,
                List<dynamic> rejectedData,
              ) {
                return Container(
                  height: 100,
                  color: dragTargetBgColor,
                  child: Row(
                    children: [
                      ..._acceptedImages.map(
                        (url) => Image.network(
                          url,
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                );
              },
              onMove: (details) {
                setState(() {
                  dragTargetBgColor = Colors.green;
                });
              },
              onLeave: (details) {
                if (_acceptedImages.isEmpty) {
                  setState(() {
                    dragTargetBgColor = Colors.grey;
                  });
                }
              },
              onWillAcceptWithDetails: (details) {
                return true;
              },
              onAcceptWithDetails: (details) {
                setState(() {
                  _images.remove(details.data);
                  _acceptedImages.add(details.data);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
