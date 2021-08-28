function fn() {
  var env = karate.env; // get java system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'TEST';
    config.WeatherURL = 'http://api.weatherstack.com';
    config.appId = '';
    config.access_key = '75954876168d81ceb685be99a415e565';
  }
  var config = { // base config JSON
    appId: '',
    access_key: '',
    WeatherURL: ''
  };
  if (env == 'TEST') {
    config.WeatherURL = 'http://api.weatherstack.com';
    config.appId = '';
    config.access_key = '75954876168d81ceb685be99a415e565';
  }
  else if (env == 'PROD') {
    config.WeatherURL = '';
  }
  // don't waste time waiting for a connection or if servers don't respond within 5 seconds
  karate.configure('connectTimeout', 5000);
  karate.configure('readTimeout', 5000);
  return config;
}