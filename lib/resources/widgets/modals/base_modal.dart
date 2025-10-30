import 'package:flutter/material.dart';

class BaseModal extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? primaryAction;
  final Widget? secondaryAction;
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? maxHeight;

  const BaseModal({
    super.key,
    required this.title,
    required this.child,
    this.primaryAction,
    this.secondaryAction,
    this.width,
    this.height,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.1,
        vertical: screenSize.height * 0.1,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth ?? width ?? screenSize.width * 0.8,
            maxHeight: maxHeight ?? height ?? screenSize.height * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: Colors.grey.shade600,
                          splashRadius: 24,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),

                  // body
                  Flexible(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: child,
                    ),
                  ),

                  // footer
                  if (primaryAction != null || secondaryAction != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (secondaryAction != null) secondaryAction!,
                          if (secondaryAction != null && primaryAction != null)
                            const SizedBox(width: 12),
                          if (primaryAction != null) primaryAction!,
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
