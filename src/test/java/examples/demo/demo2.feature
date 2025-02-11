Feature: sample karate test script
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support
  Background:
    * url 'https://jsonplaceholder.typicode.com'

#    @test
  Scenario Outline: background config, fuzzy matching, parametrized scenarios
    Given path 'users', userId
    When method get
    Then status 200
    And match response.name == expectedName
    And match response ==
    """
    {
      "id": #number,
      "name": "#string",
      "username": "#string",
      "email": "#string",
      "address": "#object",
      "phone": "#present",
      "website": "#present",
      "company": "#object? karate.match(_,{\"name\": \"##string\",\"catchPhrase\": \"##string\",\"bs\": \"##string\"}).pass"
    }
    """

  Examples:
    | userId | expectedName     |
    | 1      | Leanne Graham    |
    | 2      | Ervin Howell     |
    | 3      | Clementine Bauch |

#    @test
  Scenario: reading external files
    * def user = read("users.json")

    Given path 'users'
    And request user
    When method post
    Then status 201
    * def schema = read("schema.json")
    And match response == schema

    @test
  Scenario: modifying json values
    * def user = read("users.json")
    * set user.name = "modified name"
    * set user.username = "modifiedname"

    Given path 'users'
    And request user
    When method post
    Then status 201
    * def schema = read("schema.json")
    And match response == schema
    And match response.name == "modified name"
    And match response.username == "modifiedname"

    @test
  Scenario Outline: using parameters in jsons
    * def user =
    """
    {
      "name": "#(name)",
      "username": "#(userName)",
      "email": "#(email)",
      "address": {
        "street": "Has No Name",
        "suite": "Apt. 123",
        "city": "Electri",
        "zipcode": "54321-6789"
      }
    }
    """
    Given path 'users'
    And request user
    When method post
    Then status 201
    * def addressSchema = read("addressSchema.json")
    * def schema = read("schemaWithParameters.json")
    And match response == schema

  Examples:
    | name      | userName | email         |  |
    | Test User | testuser | test@user.com |  |

#    @test
  Scenario: using javascript functions
    * def randomNumber = function(number){ return Math.ceil(Math.random() * number)}
    * def userId = randomNumber(10)

    Given path 'users', userId
    When method get
    Then status 200
    And match response.id == userId

#    @test
  Scenario: get random user v.2
    * def randomNumber = read("randomNumber.js")
    * def userId = randomNumber(10)

    Given path 'users', userId
    When method get
    Then status 200
    And match response.id == userId