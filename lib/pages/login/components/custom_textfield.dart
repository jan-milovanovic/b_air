import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pediatko/pages/login/modals/checkmark_animation_provider.dart';
import 'package:provider/provider.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    Key? key,
    required this.textEditingController,
  }) : super(key: key);

  final TextEditingController textEditingController;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkmarkController;

  animatedCheckIcon() {
    Animation<double> offsetAnimation = Tween(begin: 0.0, end: 10.0)
        .chain(CurveTween(curve: Curves.bounceOut))
        .animate(_checkmarkController);

    CheckMarkAnimationProvider cmaProvider =
        context.watch<CheckMarkAnimationProvider>();

    int stateIndex = cmaProvider.checkStateIndex;
    if (stateIndex != 0) _checkmarkController.forward(from: 0.0);

    return AnimatedBuilder(
      animation: offsetAnimation,
      builder: (buildContext, child) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: 10 - offsetAnimation.value,
          ),
          child: cmaProvider.checkState[cmaProvider.checkStateIndex],
        );
      },
    );
  }

  @override
  void initState() {
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return TextField(
      textAlign: TextAlign.center,
      controller: widget.textEditingController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
      ],
      decoration: InputDecoration(
        hintText: 'Vnesite aktivacijsko kodo',
        suffixIcon: animatedCheckIcon(),
        prefixIcon: const Icon(
          Icons.check_box_outline_blank,
          color: Colors.white,
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
      ),
    );
  }
}
