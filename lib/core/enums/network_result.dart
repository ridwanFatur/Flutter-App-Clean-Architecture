class NetworkResult<T>{
  final T? data;
  final String? message;
  
  NetworkResult({this.data, this.message});
}

class ResultHasData<T> extends NetworkResult<T>{
  ResultHasData(T data) : super(data: data);
}

class ResultError<T> extends NetworkResult<T>{
  ResultError(String message) : super(message: message);
}

class ResultLoading<T> extends NetworkResult<T>{
  ResultLoading();
}

class ResultEmpty<T> extends NetworkResult<T>{
  ResultEmpty();
}

