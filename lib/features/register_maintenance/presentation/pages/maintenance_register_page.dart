import 'package:flutter/material.dart';
import 'package:frontend_manteniapp/core/network/api_config.dart';
import 'package:frontend_manteniapp/core/services/auth_storage_service.dart';
import 'package:frontend_manteniapp/features/register_maintenance/data/datasources/maintenance_repository_impl.dart';
import 'package:frontend_manteniapp/features/register_maintenance/data/repositories/maintenance_remote_datasource.dart';
import 'package:frontend_manteniapp/features/register_maintenance/domain/usecases/create_maintenance.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../providers/maintenance_provider.dart';
import '../widgets/maintenance_form.dart';

class MaintenanceRegisterPage extends StatelessWidget {
  final List<Map<String, dynamic>> motos;

  const MaintenanceRegisterPage({super.key, required this.motos});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MaintenanceProvider(
        createMaintenanceUseCase: _createUseCase(),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFf8f9fa),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black12,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF2c3e50)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Registro Mantenimiento',
            style: TextStyle(
              color: Color(0xFF2c3e50),
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: const _MaintenanceRegisterBody(),
      ),
    );
  }

  CreateMaintenanceUseCase _createUseCase() {
    final authStorage = AuthStorageService();
    
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final token = await authStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        } catch (e) {
          print('❌ Error obteniendo token: $e');
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          print('🔐 Token inválido o expirado');
        }
        return handler.next(error);
      },
    ));
    
    final dataSource = MaintenanceRemoteDataSourceImpl(dio: dio);
    final repository = MaintenanceRepositoryImpl(remoteDataSource: dataSource);
    return CreateMaintenanceUseCase(repository);
  }
}

class _MaintenanceRegisterBody extends StatelessWidget {
  const _MaintenanceRegisterBody();

  @override
  Widget build(BuildContext context) {
    final motos = (context.findAncestorWidgetOfExactType<MaintenanceRegisterPage>()?.motos) ?? [];

    return Consumer<MaintenanceProvider>(
      builder: (context, provider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildFormCard(context, provider, motos),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormCard(BuildContext context, MaintenanceProvider provider, List<Map<String, dynamic>> motos) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E88E5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFFf8f9fa)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  MaintenanceForm(provider: provider, motos: motos),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}