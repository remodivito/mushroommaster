import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mushroom_master/guide/bloc/encyclopedia_bloc.dart';
import 'package:mushroom_master/guide/view/encyclopedia_list.dart';
import 'package:http/http.dart' as http;

import '../../navigation/nav_bar.dart';

class EncyclopediaPage extends StatelessWidget {
  const EncyclopediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mushroom Guide'),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (_) =>
            EncyclopediaBloc(httpClient: http.Client())..add(EntryFetched()),
        child: const EncyclopediaList(),
      ),
      bottomNavigationBar: NavBar(),
    );
  }
}
