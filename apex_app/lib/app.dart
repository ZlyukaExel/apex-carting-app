import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/api_client.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/booking/bloc/booking_bloc.dart';
import 'features/booking/bloc/booking_state.dart';
import 'features/booking/screens/booking_confirmation_screen.dart';
import 'features/booking/screens/booking_screen.dart';
import 'features/slots/bloc/slots_bloc.dart';
import 'features/slots/bloc/slots_state.dart';
import 'features/slots/screens/slots_screen.dart';

class App extends StatelessWidget {
  final ApiClient apiClient;

  const App({super.key, required this.apiClient});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(apiClient)),
        BlocProvider(create: (_) => SlotsBloc(apiClient)),
        BlocProvider(create: (_) => BookingBloc(apiClient)),
      ],
      child: MaterialApp(
        title: 'Апекс',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.red,
          appBarTheme: const AppBarTheme(centerTitle: true),
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              return const _MainShell();
            }
            return const AuthScreen();
          },
        ),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/booking':
              final slot = settings.arguments as SlotModel;
              return MaterialPageRoute(
                builder: (_) => BookingScreen(slot: slot),
              );
            case '/booking-confirmation':
              final bookingState = settings.arguments as BookingState;
              return MaterialPageRoute(
                builder: (_) =>
                    BookingConfirmationScreen(bookingState: bookingState),
              );
            case '/home':
              return MaterialPageRoute(
                builder: (_) => const _MainShell(),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}

class _MainShell extends StatelessWidget {
  const _MainShell();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Апекс — заезды'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfile(context),
            tooltip: 'Профиль',
          ),
        ],
      ),
      body: const SlotsScreen(),
    );
  }

  void _showProfile(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final state = authBloc.state;

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 32,
                child: Icon(Icons.person, size: 32),
              ),
              const SizedBox(height: 12),
              Text(
                state.client?.name ?? 'Гонщик',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                state.client?.phone ?? '',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    authBloc.add(Logout());
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Выйти'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
