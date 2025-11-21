import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:kaseapp_ui/configs/themes/app_theme.dart';

class ProductSearchField extends StatelessWidget {
  final TextEditingController controller;
  final List<Map<String, dynamic>> suggestions;
  final Function(Map<String, dynamic>) onSelected;
  final bool isLoading;
  final int highlightedIndex;

  const ProductSearchField({
    super.key,
    required this.controller,
    required this.suggestions,
    required this.onSelected,
    required this.isLoading,
    this.highlightedIndex = -1,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TypeAheadField<Map<String, dynamic>>(
          controller: controller,
          suggestionsCallback: (pattern) async => suggestions,
          itemBuilder: (context, suggestion) {
            final index = suggestions.indexOf(suggestion);
            final isHighlighted = index == highlightedIndex;
            return Container(
              color: isHighlighted ? AppTheme.btnNormalColor.withOpacity(0.1) : null,
              child: ListTile(
                leading: suggestion['image'] != null
                    ? Image.network(
                        suggestion['image'],
                        width: 50,
                        height: 50,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image),
                      )
                    : const Icon(Icons.image),
                title: Text(
                  suggestion['name'],
                  style: TextStyle(
                    fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isHighlighted
                    ? Icon(
                        Icons.keyboard_return,
                        color: AppTheme.btnNormalColor,
                        size: 20,
                      )
                    : null,
              ),
            );
          },
          onSelected: onSelected,
          emptyBuilder: (context) =>
              const Padding(padding: EdgeInsets.all(8), child: Text('No products found')),
        ),
        if (isLoading)
          const Positioned(
            right: 10,
            top: 15,
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}
