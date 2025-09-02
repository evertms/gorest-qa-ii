Feature: Delete an existing user using a dynamic ID

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = bearerToken

  Scenario: Create a user and then delete it
    # STEP 1: CREATE A NEW USER (POST)
    * def dataGenerator = Java.type('utils.DataGenerator')
    * def randomName = dataGenerator.generateRandomFullName()
    * def randomEmail = dataGenerator.generateRandomEmail(randomName)
    * def createUserPayload = { "name": "#(randomName)", "gender": "male", "email": "#(randomEmail)", "status": "active" }

    Given path 'users'
    And request createUserPayload
    When method post
    Then status 201
    * def userId = response.id
    * print 'Created user with ID: ' + userId

    # STEP 2: DELETE THE USER
    Given path 'users/' + userId
    When method delete
    Then status 204
    And match response == ''
    # Assert that the response body is empty

    # STEP 3: VERIFY THE DELETION (optional but recommended)
    # Attempt to get the same user to confirm they no longer exist
    Given path 'users/' + userId
    When method get
    Then status 404
    And match response.message == 'Resource not found'