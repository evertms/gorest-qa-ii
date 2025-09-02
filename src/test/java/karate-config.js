function fn() {
  var DotEnvReader = Java.type('utils.DotEnvReader');

  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    baseUrl: DotEnvReader.get('BASE_URL'),
    bearerToken: 'Bearer ' + DotEnvReader.get('BEARER_TOKEN')
  }
  if (env == 'dev') {
    // customize
    // e.g. config.foo = 'bar';
  } else if (env == 'e2e') {
    // customize
  }
  karate.configure('ssl', { trustAll: true });
  karate.configure('connectTimeout', 25000);
  karate.configure('readTimeout', 25000);
  return config;
}