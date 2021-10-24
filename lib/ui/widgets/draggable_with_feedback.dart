import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/utils/logger.dart';

class DraggableWithFeedback<T> extends StatefulWidget {
  final DraggableController<T> controller;
  final T data;
  final Widget Function(BuildContext context, bool isOnTarget) childBuilder;
  final Widget Function(BuildContext context, bool isOnTarget)
      childWhenDraggingBuilder;
  final Widget Function(BuildContext context, bool isOnTarget)
      feedbackChildBuilder;
  final DragAnchorStrategy dragAnchorStrategy;
  final VoidCallback onDragCompleted;
  final DragEndCallback onDragEnd;
  final VoidCallback onDragStarted;
  final DragUpdateCallback onDragUpdate;
  final DraggableCanceledCallback onDraggableCanceled;

  DraggableWithFeedback({
    @required this.controller,
    @required this.childBuilder,
    this.data,
    this.childWhenDraggingBuilder,
    this.feedbackChildBuilder,
    this.dragAnchorStrategy,
    this.onDragCompleted,
    this.onDragEnd,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    Key key,
  }) : super(key: key);

  @override
  _DraggableWithFeedbackState createState() =>
      _DraggableWithFeedbackState<T>(this.controller, this.data);
}

class _DraggableWithFeedbackState<T> extends State<DraggableWithFeedback> {
  DraggableController<T> controller;
  T data;
  bool isOnTarget;

  _DraggableWithFeedbackState(this.controller, this.data);

  FeedbackController feedbackController;

  @override
  void initState() {
    feedbackController = new FeedbackController();
    this.controller.subscribeToOnTargetCallback(onTargetCallbackHandler);
    super.initState();
  }

  void onTargetCallbackHandler(bool t, T data) {
    this.isOnTarget = t;
    logD("onTargetCallbackHandler: $isOnTarget");
    logD("onTargetCallbackHandler: $feedbackController");
    this.feedbackController.updateFeedback(this.isOnTarget);
  }

  @override
  void dispose() {
    this.controller.unSubscribeFromOnTargetCallback(onTargetCallbackHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Draggable<T>(
      data: this.data,
      feedback: FeedbackWidget(
        controller: feedbackController,
        childBuilder: widget?.feedbackChildBuilder,
      ),
      childWhenDragging:
          widget?.childWhenDraggingBuilder?.call(context, isOnTarget),
      child: widget?.childBuilder?.call(context, isOnTarget),
      onDraggableCanceled: (v, f) => setState(
        () {
          this.isOnTarget = false;
          this.feedbackController.updateFeedback(this.isOnTarget);
          widget.onDraggableCanceled.call(v, f);
        },
      ),
      dragAnchorStrategy: widget.dragAnchorStrategy,
      onDragCompleted: widget.onDragCompleted,
      onDragEnd: widget.onDragEnd,
      onDragStarted: widget.onDragStarted,
      onDragUpdate: widget.onDragUpdate,
    );
  }
}

class FeedbackController {
  Function(bool) feedbackNeedsUpdateCallback;

  void updateFeedback(bool isOnTarget) {
    logD("updateFeedback: $isOnTarget ");
    logD("!!!!!!updateFeedback: ${feedbackNeedsUpdateCallback != null} ");
    if (feedbackNeedsUpdateCallback != null) {
    logD("updateFeedback____: $isOnTarget");
      feedbackNeedsUpdateCallback(isOnTarget);
    }
  }
}

class FeedbackWidget extends StatefulWidget {
  final FeedbackController controller;
  final Widget Function(BuildContext context, bool isOnTarget) childBuilder;

  FeedbackWidget({
    this.controller,
    this.childBuilder,
  });

  @override
  _FeedbackWidgetState createState() => _FeedbackWidgetState();
}

class _FeedbackWidgetState extends State<FeedbackWidget> {
  bool isOnTarget;

  @override
  void initState() {
    super.initState();
    logD("INIT");
    this.isOnTarget = false;
    this.widget.controller.feedbackNeedsUpdateCallback =
        feedbackNeedsUpdateCallbackHandler;
    logD("INIT  ${widget.controller.feedbackNeedsUpdateCallback != null}");
  }

  void feedbackNeedsUpdateCallbackHandler(bool t) {
    setState(() {
      logD("feedbackNeedsUpdateCallbackHandler: $t");
      this.isOnTarget = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    logD("BUILD FEEDBACK $isOnTarget");
    return widget?.childBuilder?.call(context, isOnTarget);
  }

  @override
  void dispose() {
    logD("DISPOSE");
    this.widget.controller.feedbackNeedsUpdateCallback = null;
    super.dispose();
  }
}

class DraggableController<T> {
  List<Function(bool, T)> _targetUpdateCallbacks = <Function(bool, T)>[];

  DraggableController();

  void onTarget(bool onTarget, T data) {
    logD("ON TARGET $onTarget");
    if (_targetUpdateCallbacks != null) {
      _targetUpdateCallbacks.forEach((f) => f(onTarget, data));
    }
  }

  void subscribeToOnTargetCallback(Function(bool, T) f) {
    _targetUpdateCallbacks.add(f);
  }

  void unSubscribeFromOnTargetCallback(Function(bool, T) f) {
    _targetUpdateCallbacks.remove(f);
  }
}
