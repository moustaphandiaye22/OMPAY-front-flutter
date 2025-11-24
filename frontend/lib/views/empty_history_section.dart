import 'package:flutter/material.dart';

class EmptyHistorySection extends StatelessWidget {
  const EmptyHistorySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.cloud_outlined,
                size: 80,
                color: Color(0xFF666666),
              ),
              Positioned(
                right: 10,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
              const Positioned(
                bottom: 10,
                right: 20,
                child: Icon(
                  Icons.search,
                  size: 35,
                  color: Color(0xFF666666),
                ),
              ),
              Positioned(
                left: 25,
                top: 10,
                child: Container(
                  width: 30,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9370DB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Vous n\'avez pas encore de transaction Orange Money.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}