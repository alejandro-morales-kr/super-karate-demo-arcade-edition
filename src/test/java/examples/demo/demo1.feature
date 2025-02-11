Feature: The Alex Morales Karate Tutorial For Developers Who Can't Do Karate and Who Wanna Learn to Do Other Stuff Good Too
  for help, see: https://github.com/karatelabs/karate/wiki/IDE-Support

#  @test
  Scenario: get comments for post
#    Given: represents preconditions such as:
#    - The url
#    - The path
#    - The request json
#    - The headers
    Given url 'https://jsonplaceholder.typicode.com'
    And path 'posts/1/comments'
#    And path 'posts'
#    And path '1'
#    And path 'comments'
#    When: states the action, with the action being one of POST, PUT, PATCH, GET, DELETE, ETC.
    When method get
#    Then: used for verifications and assertions
    Then status 200

    * def first = response[0].id

    Given path 'users', first
    When method get
    Then status 200
    And match response.id == first

    @test
  Scenario: def, full url, headers
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
    And header Content-Type = 'application/json; charset=UTF-8'
    When method post
    Then status 201

    * def id = response.id
    * print 'created id is: ', id

    Given path id
#     When method get
#     Then status 200
#     And match response contains user
  