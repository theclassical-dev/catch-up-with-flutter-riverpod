import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodtutor/models/pokemon.dart';
import 'package:riverpodtutor/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonURL;

  PokemonListTile({required this.pokemonURL});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //read the data coming from the url
    final pokemon = ref.watch(pokemonDataProvider(pokemonURL));
    return pokemon.when(data: (data) {
      return _tile(context, false, data);
    }, error: (error, stackTrace) {
      return Text('Error: $error');
    }, loading: () {
      return _tile(context, true, null);
    });
  }

//widget for data and loading, skeletonizer
  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : const CircleAvatar(),
        title: Text(
          pokemon != null
              ? pokemon.name!.toUpperCase()
              : "Currently loading name for Pokemon",
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} moves"),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
