import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';

class HealthInfoOptionsView extends StatefulWidget {
  const HealthInfoOptionsView({super.key});

  @override
  State<HealthInfoOptionsView> createState() => _HealthInfoOptionsViewState();
}

class _HealthInfoOptionsViewState extends State<HealthInfoOptionsView> {
  final List<String> options = ["Insônia", "Controle de peso", "Ansiedade"];
  final List<String> selected = [];
  final Color unselectedColor = AppColors.primary;
  final Color selectedColor = AppColors.selectedColor;

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(
        title: "Informações de Saúde",
        isWithBackButton: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 350),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: DefaultText(
                    "Selecione as opções que deseja receber as orientações:",
                    fontSize: 18,
                    maxLines: 3,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ...options.map(_buildOptionCard),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 40),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: AnimatedOpacity(
                    opacity: selected.isNotEmpty ? 1 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: selected.isEmpty
                          ? null
                          : () {
                              NavigationController.push(
                                routes.app.qa.helthResult.path,
                                arguments: selected,
                              );
                            },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.selectedColor,
                              AppColors.selectedColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard(String text) {
    final isSelected = selected.contains(text);

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected ? selected.remove(text) : selected.add(text);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : unselectedColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? selectedColor : unselectedColor,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white70,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 18, color: selectedColor)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: DefaultText(
                text,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
