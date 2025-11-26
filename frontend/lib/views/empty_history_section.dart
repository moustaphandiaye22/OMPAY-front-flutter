import 'package:flutter/material.dart';

class EmptyHistorySection extends StatelessWidget {
  const EmptyHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 80,
              height: 60,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.cloud_outlined,
                    size: 50,
                    color: Color(0xFF666666),
                  ),
                  Positioned(
                    right: 5,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF4444),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 5,
                    right: 10,
                    child: Icon(
                      Icons.search,
                      size: 25,
                      color: Color(0xFF666666),
                    ),
                  ),
                  Positioned(
                    left: 15,
                    top: 5,
                    child: Container(
                      width: 20,
                      height: 25,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9370DB),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Vous n\'avez pas encore de transaction Orange Money.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF999999),
              ),
            ),
          ],
        ),
      ),
    );
  }
}