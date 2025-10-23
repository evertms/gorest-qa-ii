Feature: Update an existing user using a dynamic ID

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * header Content-Type = 'application/json'
    * header Authorization = bearerToken
    * def dataGenerator = Java.type('utils.DataGenerator') # Movido al Background

  Scenario: Create a user and then update their information
    
    # STEP 1: CREATE A NEW USER (POST)
    # Llamamos al feature de creación para obtener un usuario nuevo
    * def createdUser = call read('create_user.feature')
    
    # Extraemos las variables que necesitamos del resultado de la llamada
    * def userId = createdUser.userId
    * def originalEmail = createdUser.randomEmail
    * print 'Called create_user.feature, got ID: ' + userId

    # STEP 2: UPDATE THE USER (PATCH)
    * def updatedName = dataGenerator.generateRandomFullName()
    * def updatedUserPayload = { "name": "#(updatedName)" }

    Given path 'users/' + userId
    
And request updatedUserPayload
    When method patch
    Then status 200

    # Validamos usando las variables de la llamada
    * match response.id == userId
    * match response.name == updatedName
    * match response.email == originalEmail # Verificamos que el email original no cambió

    # STEP 3: VERIFY THE UPDATE (GET)
    Given path 'users/' + userId
    When method get
 
   Then status 200
    * match response.name == updatedName