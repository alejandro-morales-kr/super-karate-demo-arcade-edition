Feature: sample karate test script
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

#  @test
  Scenario Outline: the karate object
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
    * karate.set('user', '$.' + property, newValue)
    Given url baseUrl
    And path usersPath
    And request user
    When method post
    Then status 201
    And match karate.get('response.' + property) == newValue
  Examples:
    | property | newValue    |  |
    | name     | newName     |  |
    | username | newUserName |  |

#    @test
  Scenario: using a java file
    * def dataGenerator = Java.type('examples.demo.DataGenerator')
    * def randomName = dataGenerator.getRandomName()
    * def randomName2 = dataGenerator.getRandomName()
    Given url baseUrl
    And path '/posts/1'
    And request
    """
    {
      "id": 1,
      "title": '#(randomName)',
      "body": '#(randomName2)',
      "userId": 1,
    }
    """
    When method put
    Then status 200
    And match response.title == randomName
    And match response.body == randomName2

    @test
  Scenario: calling a function
    * def createUserRequest = call read("createUserCall.feature")
    * print createUserRequest.id
    * print createUserRequest.response.id

    Given url baseUrl
    And path 'users'
    And path createUserRequest.id
    When method get
    Then status 200
    And match response contains createUserRequest.id
  