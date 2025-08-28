Feature: sample karate test script
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

  Background:
    * url 'https://gorest.co.in/public/v2'
    * header Accept = 'application/json'
    * header Content-type = 'application/json'
    * header Authorization = 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954'
    * def req_headers = { Authorization : 'Bearer 700d0c7a86eb84028bf5cd204b11587f812f9d7cd880dc4edbdbd1d407ae9954' }
    * def dataGenerator = Java.type('utils.DataGenerator')
    * def payload =
      """
        {
          "gender":"male",
          "status":"active"
        }
      """
    # * payload.name = dataGenerator.getUserRandom().name
    # * payload.email = dataGenerator.getUserRandom().email

  @Regresion @PostUser
  Scenario: Crear un nuevo usuario exitosamente
    Given path 'users'
    And request payload
    When method post
    Then status 201
    * def user_id = response.id
    * print user_id

    Given path 'users/', user_id
    And headers req_headers
    When method Get
    Then status 200
    And match response.email == payload.email


    * def first = response[0]

    Given path 'users', first.id
    When method get
    Then status 200

  Scenario: create a user and then get it by id
    * def user =
      """
      {
        "name": "Test User",
        "username": "testuser",
        "email": "test@user.com",
        "address": {
          "street": "Has No Name",
          "suite": "Apt. 123",
          "city": "Electri",
          "zipcode": "54321-6789"
        }
      }
      """

    Given url 'https://jsonplaceholder.typicode.com/users'
    And request user
    When method post
    Then status 201

    * def id = response.id
    * print 'created id is: ', id

    Given path id
    # When method get
    # Then status 200
    # And match response contains user
  