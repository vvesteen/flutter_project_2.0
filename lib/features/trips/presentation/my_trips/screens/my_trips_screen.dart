import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../core/entities/trip.dart';
import '../../../data/datasources/trip_remote_datasource.dart';
import '../../../data/repositories/trip_repository_impl.dart';
import '../../trip_card.dart';
import '../../trip_more_details.dart';


class MyTripsScreen extends StatelessWidget {
  const MyTripsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final repo = TripRepositoryImpl(
      remoteDataSource: TripRemoteDataSource(),
    );

    final userId = FirebaseAuth.instance.currentUser!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(

        appBar: AppBar(
          title: const Text('Мои поездки'),

          bottom: const TabBar(
            tabs: [
              Tab(text: 'Запланированные'),
              Tab(text: 'Архив'),
            ],
          ),
        ),

        body: StreamBuilder<List<Trip>>(
          stream: repo.getMyTrips(userId),

          builder: (context, snapshot) {

            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final trips = snapshot.data ?? [];

            final planned = trips.where((e) =>
                e.departureTime.isAfter(DateTime.now())).toList();

            final archived = trips.where((e) =>
                e.departureTime.isBefore(DateTime.now())).toList();

            return TabBarView(
              children: [

                /// planned
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: planned.length,

                  itemBuilder: (_, i) {

                    final trip = planned[i];

                    return TripCard(
                      trip: trip,
                      currentUserId: userId,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TripMoreDetails(trip: trip),
                          ),
                        );
                      },
                    );
                  },
                ),

                /// archived
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: archived.length,

                  itemBuilder: (_, i) {

                    final trip = archived[i];

                    return TripCard(
                      trip: trip,
                      currentUserId: userId,

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                TripMoreDetails(trip: trip),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}