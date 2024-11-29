import '../parameters/params.dart';

abstract class Usecases<Response, Parameters extends Params> {
  Response call(Parameters params);
}

abstract class ListUsecase<Response, Parameters extends Params> {
  Response call(List<Parameters> params, String id);
}
