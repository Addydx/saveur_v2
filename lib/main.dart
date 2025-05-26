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

import 'package:flutter/material.dart';
// ... tus otros imports

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
        // Tema principal para Android
        primarySwatch: Colors.green, // Puedes experimentar con Colors.lightGreen o Colors.teal
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green, // Un verde fresco
        ).copyWith(
          secondary: Colors.deepOrangeAccent, // Un naranja vibrante como acento
          // Opciones de colores más suaves:
          // secondary: Colors.amber, // Un ámbar cálido
          // secondary: Colors.blueAccent, // Un azul llamativo
        ),
        scaffoldBackgroundColor: Colors.white, // Fondo blanco puro para que todo resalte
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // AppBar blanco
          foregroundColor: Colors.black87, // Texto oscuro en el AppBar
          elevation: 0, // Sin sombra para un look más moderno
          // Puedes agregar un icono de flecha atrás personalizado si lo deseas
          // iconTheme: IconThemeData(color: Colors.black87),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.green, // Ítem seleccionado en verde
          unselectedItemColor: Colors.grey, // Ítems no seleccionados en gris
          backgroundColor: Colors.white, // Fondo de la barra blanco
          elevation: 8, // Sombra para darle profundidad
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold), // Etiqueta seleccionada en negrita
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // Botones verdes
            foregroundColor: Colors.white, // Texto blanco
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Bordes más redondeados
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Más padding para botones cómodos
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepOrangeAccent, // FAB con color de acento
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          elevation: 4, // Sombra sutil para tarjetas
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Esquinas redondeadas para tarjetas
          ),
          margin: const EdgeInsets.all(8), // Margen alrededor de las tarjetas
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100], // Fondo gris claro para campos de texto
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none, // Sin borde visible inicialmente
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.green, width: 2), // Borde verde al enfocar
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        // Puedes definir una fuente personalizada si quieres
        // textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
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
        '/account': (context) => const AccountScreen(),
        '/profile': (context) => ProfileScreen(
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, '/sign-in');
            }),
          ],
        ),
        '/search': (context) => const SearchScreen(),
        '/discover': (context) => const DiscoverScreen(),
        '/shopping-cart': (context) => const ShoppingCart(),
        '/recipe-detail': (context) {
          final recipeId = ModalRoute.of(context)!.settings.arguments as int;
          return RecipeDetailScreen(recipeId: recipeId);
        },
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