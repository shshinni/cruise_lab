import 'package:flutter/material.dart';

class ListCruise extends StatefulWidget {
  const ListCruise({super.key});

  @override
  State<ListCruise> createState() => _ListCruiseState();
}

class _ListCruiseState extends State<ListCruise> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0)),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("< Назад"),),
            ],
          ),

              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 123,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Card(
                              margin: const EdgeInsets.all(4.0),
                              clipBehavior: Clip.hardEdge,
                              child: InkWell (
                                onTap: (){},
                                child: Column(
                                  children: const [
                                    ListTile(
                                      leading: Icon(Icons.location_on),
                                      title: Text(
                                        'Маршрут',
                                      ),
                                      subtitle: Text(
                                        'Санкт-Петербург-Хельсинки',
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.calendar_month),
                                      title: Text(
                                        'Даты отправления и прибытия',
                                      ),
                                      subtitle: Text(
                                        '03 ноября 2023 - 06 ноября 2023',
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.sailing),
                                      title: Text(
                                        'Название круиза',
                                      ),
                                      subtitle: Text(
                                        'Николай Чернышевский',
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        );
                      })),
        ],
      )
    );
  }
}