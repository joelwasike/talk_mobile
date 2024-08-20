sealed class Getdatastate {}

class Getdatainitial extends Getdatastate {
  Getdatainitial();
}

class Getdataloading extends Getdatastate {
  Getdataloading();
}

class Getdataloaded extends Getdatastate {
  final List<dynamic> data;
  Getdataloaded(this.data);
}
