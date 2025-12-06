import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/maintenance_report_entity.dart';

/// Widget para mostrar los servicios más frecuentes
class FrequentServicesCard extends StatelessWidget {
  final List<ServiceFrequency> services;

  const FrequentServicesCard({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No hay servicios registrados',
              style: TextStyle(
                color: AppTheme.textSecondaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Servicios más frecuentes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...services
                .take(5)
                .map(
                  (service) => _ServiceItem(
                    serviceName: service.serviceName,
                    count: service.count,
                    totalCost: service.totalCost,
                    averageCost: service.averageCost,
                    maxCount: services.first.count,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String serviceName;
  final int count;
  final double? totalCost;
  final double? averageCost;
  final int maxCount;

  const _ServiceItem({
    required this.serviceName,
    required this.count,
    this.totalCost,
    this.averageCost,
    required this.maxCount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = maxCount > 0 ? count / maxCount : 0.0;
    final currencyFormat = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 0,
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
              minHeight: 6,
            ),
          ),
          if (totalCost != null || averageCost != null) ...[
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (totalCost != null)
                  Text(
                    'Total: ${currencyFormat.format(totalCost)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (averageCost != null)
                  Text(
                    'Promedio: ${currencyFormat.format(averageCost)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
