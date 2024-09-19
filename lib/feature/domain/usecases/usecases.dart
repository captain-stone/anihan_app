import '../parameters/params.dart';

abstract class Usecases<Response, Parameters extends Params> {
  Response call(Parameters params);
}
