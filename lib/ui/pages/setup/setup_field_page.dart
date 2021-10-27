import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/core/game_logic/cell.dart';
import 'package:temp_app/core/game_logic/game_settings.dart';
import 'package:temp_app/core/game_logic/setup_module/setup_module.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/ui/widgets/draggable_with_feedback.dart';
import 'package:temp_app/utils/logger.dart';

class SetupFieldPage extends BasePage {
  final SetupModule setupModule;

  SetupFieldPage(
    this.setupModule, {
    Key key,
  }) : super(
          key: key,
          state: _SetupFieldPageState(
            setupModule: setupModule,
          ),
        );
}

class _SetupFieldPageState extends State<BaseStatefulWidget> {
  static const double DEF_CELL_SIZE = 30;
  static const double DEF_CELL_PADDING = 1;
  static const int DEFAULT_DRAG_ID = -2;

  var cellSize = DEF_CELL_SIZE;//todo move to GameSettings?

  final SetupModule setupModule;

  _SetupFieldPageState({
    @required this.setupModule,
  });

  DraggableController<Cell> draggableController;

  var isDragStarted = false;
  var isMoveStarted = false;
  var dragStartedId = DEFAULT_DRAG_ID;

  @override
  void initState() {
    super.initState();
    this.draggableController = new DraggableController<Cell>();
    setupModule.initField();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    cellSize = MediaQuery.of(context).size.width * 0.07; //todo add resizer
    List<Widget> unitsList = [];
    for (UnitScheme unit in setupModule.unitSettings.unitsScheme) {
      unitsList.add(_buildDraggableBox(
        Cell(unitScheme: unit),
        isMainBox: true,
      ));
      unitsList.add(SizedBox(width: DEF_CELL_PADDING));
    }
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(setupModule.unitSettings.presetName),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: unitsList,
            ),
            SizedBox(height: 24),
            _buildCells(),
          ],
        ),
      ),
    );
  }

  Widget _buildCells() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < setupModule.maxX; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 0; j < setupModule.maxY; j++) _buildDragTarget(i, j),
            ],
          )
      ],
    );
  }

  Widget _buildDraggableBox(
    Cell data, {
    bool isMainBox = false,
  }) {
    return Column(
      children: [
        !isMainBox//todo create new widget for MainBox
            ? SizedBox.shrink()
            : Text(
                "[${isMainBox ? setupModule.unitSettings.unitByLocaleIdOrNull(data.unitScheme.localId)?.countOnField : ""}/${data.unitScheme.maxCount}]"),
        !isMainBox ? SizedBox.shrink() : SizedBox(height: 16),
        IgnorePointer(
          ignoring: isMainBox &&
              (setupModule.unitSettings
                      .unitByLocaleIdOrNull(data.unitScheme.localId)
                      ?.isMaxCountOnField ??
                  false),
          child: GestureDetector(
            onTap: () {
              logD("TAP ${data.id}");
            },
            onDoubleTap: () {
              logD("DOUBLE_TAP ${data.id}");
              if (data != null) {
                setState(() {
                  setupModule.removeData(data);
                  data.switchDirection();
                  data.anchor = data.subId;
                  if (!setupModule.setData(data.x, data.y, data)) {
                    data.switchDirection();
                    setupModule.setData(data.x, data.y, data);
                  }
                });
              }
            },
            child: DraggableWithFeedback<Cell>(
              controller: draggableController,
              data: data,
              childWhenDraggingBuilder: !isMainBox
                  ? null
                  : (c, isOnTarget) => Container(
                        color: data.unitScheme.primaryColor.withAlpha(50),
                        width: cellSize,
                        height: cellSize,
                        child: Center(
                          child: Text(
                            "${data.unitScheme.size}(${data.id})[${data.anchor}]",
                          ),
                        ),
                      ),
              childBuilder: (c, isOnTarget) =>
                  (isDragStarted && dragStartedId == data.id && !isMainBox)
                      ? SizedBox.shrink()
                      : Container(
                          color: data.unitScheme.primaryColor,
                          width: cellSize,
                          height: cellSize,
                          child: Center(
                            child: Text(
                              "(${data.id})",
                            ),
                          ),
                        ),
              dragAnchorStrategy: (Draggable<Object> draggable,
                  BuildContext context, Offset position) {
                final RenderBox renderObject =
                    context.findRenderObject() as RenderBox;
                var pos = renderObject.globalToLocal(position);
                return Offset(
                  data.direction == Axis.horizontal
                      ? pos.dx +
                          (cellSize + DEF_CELL_PADDING + DEF_CELL_PADDING) *
                              data.subId
                      : pos.dx,
                  data.direction == Axis.vertical
                      ? pos.dy +
                          (cellSize + DEF_CELL_PADDING + DEF_CELL_PADDING) *
                              data.subId
                      : pos.dy,
                );
              },
              feedbackChildBuilder: (c, isOnTarget) =>
                  _buildDraggableFeedback(data, isOnTarget),
              onDragStarted: () {
                logD("onDragStarted");
                setState(() {
                  isDragStarted = true;
                  isMoveStarted = !isMainBox;
                  dragStartedId = data.id;
                  if (!isMainBox) {
                    setupModule.changeAnchorInCellById(data.id, data.subId);
                    // setupModule.removeData(data);
                  }
                });
              },
              onDragEnd: (DraggableDetails details) {
                logD("onDragEnd: $details");
                setState(() {
                  isDragStarted = false;
                  isMoveStarted = false;
                  dragStartedId = DEFAULT_DRAG_ID;
                });
              },
              onDragCompleted: () {
                logD("onDragCompleted");
                setState(() {
                  isDragStarted = false;
                  isMoveStarted = false;
                  dragStartedId = DEFAULT_DRAG_ID;
                });
              },
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                logD("onDraggableCanceled: $velocity $offset");
                setState(() {
                  setupModule.removeData(data);
                  isDragStarted = false;
                  isMoveStarted = false;
                  dragStartedId = DEFAULT_DRAG_ID;
                });
              },
              onDragUpdate: (DragUpdateDetails details) {
                //logD("onDragUpdate: $details");
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDraggableFeedback(Cell data, bool isOnTarget) {
    List<Widget> items = [];
    for (var i = 0; i < data.unitScheme.size; i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(DEF_CELL_PADDING),
          child: Container(
            color: (isOnTarget ? data.unitScheme.primaryColor : Colors.red)
                .withAlpha(100),
            width: cellSize,
            height: cellSize,
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Text(
                  "(${data.id})",
                ),
              ),
            ),
          ),
        ),
      );
    }
    var root = (data.direction != null && data.direction == Axis.horizontal)
        ? Row(
            children: items,
          )
        : (data.direction != null && data.direction == Axis.vertical)
            ? Column(
                children: items,
              )
            : Row(
                children: items,
              );

    return root;
  }

  Widget _buildDragTarget(int x, int y) {
    return Padding(
      padding: const EdgeInsets.all(DEF_CELL_PADDING),
      child: Stack(
        children: [
          DragTarget<Cell>(
            builder: (c, candidateData, rejectedData) {
              return Container(
                color: Colors.green,
                width: cellSize,
                height: cellSize,
                child: Center(
                  child: Text(
                    "${setupModule.getCellAtCoord(x, y).unitsAround.toString()}",
                  ),
                ),
              );
            },
            onAccept: (data) {
              logD("onAccept: $isMoveStarted $dragStartedId $data");
              setState(() {
                if (isMoveStarted) {
                  data.id = dragStartedId;
                  setupModule.removeData(data);
                }
                var dataSetupSuccess = setupModule.setData(x, y, data);
                if (!dataSetupSuccess) {
                  logD("dataSetupSuccess: $dataSetupSuccess");
                  data.switchDirection();
                  setupModule.setData(x, y, data);
                }
              });
            },
            onLeave: (data) {
              logD("onLeave: $data");
              setState(() {
                draggableController.onTarget(false, data);
              });
            },
            onMove: (details) {
              logD("onMove: $details");
            },
            onWillAccept: (data) {
              logD("onWillAccept: $data");
              setState(() {
                data.id = dragStartedId;
                draggableController.onTarget(
                    setupModule.checkPosition(x, y, data), data);
              });
              var result = data.unitScheme.isNotEmpty;
              return result;
            },
            onAcceptWithDetails: (details) {
              logD("onAcceptWithDetails: ${details.toString()}");
            },
          ),
          (setupModule.getCellAtCoord(x, y).id > 0)
              ? _buildDraggableBox(setupModule.getCellAtCoord(x, y))
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}