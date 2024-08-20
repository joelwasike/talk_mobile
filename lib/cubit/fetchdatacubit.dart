import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:usersms/cubit/fetchdataservice.dart';
import 'package:usersms/cubit/fetchdatastate.dart';

class Fetchdatacubit extends Cubit<Getdatastate> {
  Fetchdatacubit() : super(Getdatainitial());

  fetchdata() async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchData();
    emit(Getdataloaded(data));
  }

  fetchnotices() async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchNotices();
    emit(Getdataloaded(data));
  }

  fetchgossips() async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchGossip();
    emit(Getdataloaded(data));
  }

  fetchforumlist() async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchforumlist();
    emit(Getdataloaded(data));
  }

  fetchClublist() async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchClubList();
    emit(Getdataloaded(data));
  }

  fetchforumPosts(id) async {
    emit(Getdataloading());
    List<dynamic> data = await Dataservice().fetchforumposts(id);
    emit(Getdataloaded(data));
  }
}
