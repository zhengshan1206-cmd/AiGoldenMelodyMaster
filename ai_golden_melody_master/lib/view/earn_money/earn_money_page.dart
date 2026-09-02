import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///赚钱页面
class EarnMoneyPage extends StatelessWidget {
  const EarnMoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 1.sh,
      color: Colors.black,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "赚钱",
            style: TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
