import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:saveur/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:saveur/screens/home_screen.dart';
import 'screens/account_screen.dart';
import 'package:saveur/screens/search_screen.dart';
import 'package:saveur/screens/discover_screen.dart';
import 'package:saveur/screens/shopping_cart.dart';
import 'package:saveur/screens/recipe_detail_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Color principal verde
        scaffoldBackgroundColor: const Color(0xFFE8F5E9), // Fondo verde claro
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D32), // Verde oscuro para el AppBar
          foregroundColor: Colors.white, // Texto blanco en el AppBar
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF2E7D32), // Verde oscuro para el ítem seleccionado
          unselectedItemColor: Colors.grey, // Gris para ítems no seleccionados
          backgroundColor: Colors.white, // Fondo blanco para el BottomNavigationBar
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF66BB6A), // Verde medio para botones
            foregroundColor: Colors.white, // Texto blanco en botones
          ),
        ),
      ),
      initialRoute: '/auth-check',
      routes: {
        '/auth-check': (context) => _AuthCheckScreen(),
        '/sign-in': (context) => SignInScreen(
              actions: [
                AuthStateChangeAction<UserCreated>((context, state) {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
                AuthStateChangeAction<SignedIn>((context, state) {
                  Navigator.pushReplacementNamed(context, '/home');
                }),
              ],
            ),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(), // Agrega esta línea
        '/profile': (context) => ProfileScreen(
              actions: [
                SignedOutAction((context) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }),
              ],
            ),
        '/search': (context) => const SearchScreen(), // Ruta para buscar
        '/discover': (context) => const DiscoverScreen(), // Ruta para descubrir
        '/shopping-cart': (context) => const ShoppingCart(), // Ruta para carrito
        '/recipe-detail': (context) => RecipeDetailScreen(
              recipe: ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>,
            ),
      },
    );
  }
}

class _AuthCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/home');
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/sign-in');
          });
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

void navigateToRecipeDetail(BuildContext context, Map<String, dynamic> recipe) {
  Navigator.pushNamed(
    context,
    '/recipe-detail',
    arguments: recipe,
  );
}