Feature: Update an existing user using a dynamic ID

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = bearerToken

  Scenario: Create a user and then update their information
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

    # STEP 2: UPDATE THE USER (PATCH)
    # Define a new, updated payload for the PATCH request
    * def updatedName = dataGenerator.generateRandomFullName()
    * def updatedUserPayload = { "name": "#(updatedName)" }

    Given path 'users/' + userId
    And request updatedUserPayload
    When method patch
    Then status 200

    # Optional: Validate the updated user data in the response
    * match response.id == userId
    * match response.name == updatedName
    * match response.email == createUserPayload.email
    # The email should not have changed

    # STEP 3: VERIFY THE UPDATE (GET)
    # Perform a GET request to confirm the changes were saved
    Given path 'users/' + userId
    When method get
    Then status 200
    * match response.name == updatedName