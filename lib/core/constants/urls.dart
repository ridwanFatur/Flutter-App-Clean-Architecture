class Urls{
    // BASE URL
  static const String kBaseUrl = "https://api.themoviedb.org/3/";

  // API KEY
  static const String kApiKey = "<YOUR API KEY>";

  // URL 
  static const String popularMovie = "${kBaseUrl}movie/popular";
  static const String trendingMovie = "${kBaseUrl}trending/movie/week";
  static String rateMovie(List<String> args) => "${kBaseUrl}movie/${args[0]}/rating";
  // static const String searchMovie = "${kBaseUrl}search/movie";
  static const String nowPlayingMovie = "${kBaseUrl}movie/now_playing";
  static String searchMovie(String query, int page) => "${kBaseUrl}search/movie?query=$query&page=$page&api_key=$kApiKey";
  // Poster Path
  static String posterReguler(String path) => "https://image.tmdb.org/t/p/w500$path";
  static String posterSmall(String path) => "https://image.tmdb.org/t/p/w200$path";
  static const String posterNotFound = "https://lightwidget.com/wp-content/uploads/local-file-not-found.png";
}