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
    * payload.name = dataGenerator.generateRandomFullName()
    * payload.email = dataGenerator.generateRandomEmail(payload.name)


  @Regresion @PostUser
  Scenario: Crear un nuevo usuario exitosamente
    Given path 'users'
    And request payload
    When method post
    Then status 201
    * def user_id = response.id
    * print 'Created user_id: ', user_id

    # Get the user by the ID just created and verify its details
    Given path 'users/', user_id
    When method Get
    Then status 200
    And match response.id == user_id
    And match response.name == payload.name
    And match response.email == payload.email
    And match response.gender == payload.gender
    And match response.status == payload.status

  # The following block of code was based on fetching a list and then picking the first.
  # It seems to be out of context for a "Create and then Get" scenario directly using the created user_id.
  # If the intention was to fetch all users and then find the one just created, the logic would be different.
  # For now, I've commented it out as it doesn't fit the 'create user by id' flow.
  # If you need to fetch a list of users and then find one, please clarify.
  # * def first = response[0]
  # Given path 'users', first.id
  # When method get
  # Then status 200