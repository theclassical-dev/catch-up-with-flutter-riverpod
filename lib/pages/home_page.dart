import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtutor/controllers/home_page_controller.dart';
import 'package:riverpodtutor/models/page_data.dart';
import 'package:riverpodtutor/models/pokemon.dart';
import 'package:riverpodtutor/widgets/pokemon_list_tile.dart';

// StateNotifierprovider for homepage
final homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  //scroll controller for pagination
  final ScrollController _allPokenmonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  @override
  void initState() {
    super.initState();

    //for the controller
    _allPokenmonListScrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _allPokenmonListScrollController.removeListener(_scrollListener);
    _allPokenmonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    //check if we have reach the end of the list
    if (_allPokenmonListScrollController.offset >=
            _allPokenmonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokenmonListScrollController.position.outOfRange) {
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(homePageControllerProvider.notifier);
    _homePageData = ref.watch(homePageControllerProvider);

    return Scaffold(
      body: _buildUI(
        context,
      ),
    );
  }

//buildUI widget
  Widget _buildUI(
    BuildContext context,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _allPokemonsList(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

//all pokemon list widget
  Widget _allPokemonsList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "All Pokemons",
            style: TextStyle(
              fontSize: 25,
            ),
          ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.60,
            child: ListView.builder(
                //pagination
                controller: _allPokenmonListScrollController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon =
                      _homePageData.data!.results![index];
                  return PokemonListTile(pokemonURL: pokemon.url!);
                }),
          )
        ],
      ),
    );
  }
}
