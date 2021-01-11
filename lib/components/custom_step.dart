import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomStep extends Step {
  /// Creates a step for a [Stepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  CustomStep(
      {@required this.title,
      this.subtitle,
      @required content,
      this.state = StepState.indexed,
      this.isActive = false,
      bool form = false,
      this.formKey})
      : assert(title != null),
        assert(content != null),
        assert(state != null),
        super(
            title: title,
            subtitle: subtitle,
            content: content,
            state: state,
            isActive: isActive) {
    if (form) {
      print('Assigning key');
      this.content = Form(
        key: formKey,
        child: content,
      );
    } else {
      this.content = content;
    }
  }

  /// The title of the step that typically describes it.
  @override
  Widget title;

  /// The subtitle of the step that appears below the title and has a smaller
  /// font size. It typically gives more details that complement the title.
  ///
  /// If null, the subtitle is not shown.
  @override
  Widget subtitle;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  @override
  Widget content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  @override
  StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  @override
  bool isActive;

  GlobalKey<FormState> formKey;

  bool validate() {
    assert(formKey != null);
    return formKey.currentState.validate();
  }

  void save() {
    assert(formKey != null);
    formKey.currentState.save();
  }
}

class CustomStepState {
  CustomStepState(
      {this.state = StepState.indexed,
      this.isActive = false,
      @required this.title})
      : assert(state != null) {
    formKey = GlobalKey<FormState>();
    key = UniqueKey();
  }

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  StepState state;

  /// Whether or not the step is active. The flag only influences styling.
  bool isActive;

  GlobalKey<FormState> formKey;

  Key key;

  Widget title;
}
