import 'package:fpdart/fpdart.dart';
import 'package:pack_n_deliver/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
