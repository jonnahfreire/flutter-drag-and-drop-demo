import 'package:flutter/material.dart';

class TaskImageData {
  int id;
  int orderId;
  String url;
  String name;
  bool? isOrdered;

  TaskImageData({
    required this.id,
    required this.url,
    required this.name,
    this.orderId = 0,
    this.isOrdered = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "orderId": orderId,
      "url": url,
      "name": name,
    };
  }
}

class ReorderImageTask extends StatefulWidget {
  const ReorderImageTask({super.key});

  @override
  State<ReorderImageTask> createState() => _ReorderImageTaskState();
}

class _ReorderImageTaskState extends State<ReorderImageTask> {
  double targetAreaWidth = 70;
  double targetAreaHeight = 70;

  List<TaskImageData> taskItems = [
    TaskImageData(
      id: 1,
      orderId: 1,
      url: 'https://picsum.photos/seed/1/200/200',
      name: "image-1",
    ),
    TaskImageData(
      id: 2,
      orderId: 2,
      url: 'https://picsum.photos/seed/2/200/200',
      name: "image-2",
    ),
    TaskImageData(
      id: 3,
      orderId: 3,
      url: 'https://picsum.photos/seed/3/200/200',
      name: "image-3",
    ),
    TaskImageData(
      id: 4,
      orderId: 4,
      url: 'https://picsum.photos/seed/4/200/200',
      name: "image-4",
    ),
    TaskImageData(
      id: 5,
      orderId: 5,
      url: 'https://picsum.photos/seed/5/200/200',
      name: "image-5",
    ),
  ];
  final List<TaskImageData> _orderedImages = [];

  bool dragTargetHasOrderedImagePlaced(int targetId) {
    return _orderedImages.indexWhere((image) => image.orderId == targetId) > -1;
  }

  Widget _buildDragChild(String url) => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(5),
        ),
        width: targetAreaWidth,
        height: targetAreaHeight,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.network(url),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Ordenar imagens"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              ...List.generate(
                taskItems.length,
                (int index) => taskItems[index++],
              ).map((item) {
                final imageIndex =
                    _orderedImages.indexWhere((e) => e.orderId == item.id);

                return DragTarget<TaskImageData>(
                  builder: (context, candidateData, rejectedData) {
                    return Container(
                      width: targetAreaWidth,
                      height: targetAreaHeight,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: imageIndex > -1
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                _orderedImages[imageIndex].url,
                                width: targetAreaWidth,
                                height: targetAreaHeight,
                              ),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                  onWillAcceptWithDetails: (details) {
                    debugPrint(
                      "On Will Accept: item oid: ${item.id}  ${details.data.toMap()}",
                    );
                    return !dragTargetHasOrderedImagePlaced(item.id);
                  },
                  onAcceptWithDetails: (details) {
                    setState(() {
                      details.data.isOrdered = true;
                      details.data.orderId = item.id;
                      _orderedImages.add(details.data);
                    });
                    debugPrint(
                      "On Accept: item oid: ${item.id}  ${details.data.toMap()}",
                    );
                  },
                );
              }),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ...taskItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Draggable<TaskImageData>(
                      data: item,
                      feedback: _buildDragChild(item.url),
                      childWhenDragging: Opacity(
                        opacity: .3,
                        child: _buildDragChild(item.url),
                      ),
                      child: !(item.isOrdered ?? false)
                          ? _buildDragChild(item.url)
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
