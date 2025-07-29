import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shartflix/core/services/user_service.dart';
import 'package:shartflix/data/models/movie.dart';
import 'package:shartflix/data/models/userprofile.dart';
import 'package:shartflix/presentation/widgets/favorite_movie_card.dart';
import 'package:shartflix/presentation/widgets/limited_offer_popup.dart';

class ModernUserProfilePage extends StatefulWidget {
  const ModernUserProfilePage({super.key});

  @override
  State<ModernUserProfilePage> createState() => _ModernUserProfilePageState();
}

void showLimitedOfferSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const LimitedOfferBottomSheet(),
  );
}

class _ModernUserProfilePageState extends State<ModernUserProfilePage> {
  UserProfile? user;
  List<Movie> favoriteMovies = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final userService = GetIt.I<UserService>();
      final userData = await userService.getUserProfile();
      List<Movie> favorites = (await userService.getFavoriteMovies())
          .cast<Movie>();

      setState(() {
        user = userData;
        favoriteMovies = favorites;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  // Future<void> loadUser() async {
  //   try {
  //     final userService = GetIt.I<UserService>();
  //     final favs = await userService.getFavoriteMovies();
  //     final userData = await userService.getUserProfile();
  //     setState(() {
  //       user = userData;
  //       favoriteMovies = favs;
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       error = e.toString();
  //       isLoading = false;
  //     });
  //   }
  // }

  void showFullId(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kullanıcı ID'),
        content: Text(id),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(
                child: Text(
                  "Hata: $error",
                  style: const TextStyle(color: Colors.red),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white),
                        const Text(
                          "Profil Detayı",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: () => showLimitedOfferSheet(context),
                            child: const Text(
                              "Sınırlı Teklif",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade800,
                          backgroundImage:
                              (user!.photoUrl != null &&
                                  user!.photoUrl!.isNotEmpty)
                              ? NetworkImage(user!.photoUrl!)
                              : null,
                          child:
                              (user!.photoUrl == null ||
                                  user!.photoUrl!.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user!.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => showFullId(user!.id),
                                child: Text(
                                  "ID: ${user!.id}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Fotoğraf Ekle",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      "Beğendiğim Filmler",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        itemCount: favoriteMovies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        itemBuilder: (context, index) {
                          final movie = favoriteMovies[index];
                          if (favoriteMovies.isEmpty) {
                            return Center(child: Text("Henüz favori film yok"));
                          }
                          return FavoriteMovieCard(movie: movie);
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
