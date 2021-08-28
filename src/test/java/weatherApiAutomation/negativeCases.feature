##****************************
# * author  Atosh Veer
# * version Karate 1.0.1
# * since   JDK 8.0
# * os     Windows 11
##*****************************

Feature: Negative test cases for Weather APIs

  Background: Initializing path params and others

    * configure logPrettyResponse = true
    * configure logPrettyRequest = true
    * configure ssl = true
    * def currentWeather = '/current'
    * def historicalWeather = '/historical'
    * def weatherForecast = '/forecast'
    * def locationLookup = '/autocomplete'

  @smoke
  Scenario: Invoking "Current Weather" API by providing invalid / wrong location name

    Given url WeatherURL
    And path currentWeather
    And param access_key = access_key
    ## invalid / wrong location name
    And param query = '@@##$!'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 615
    And match response.error.type == 'request_failed'
    And match response.error.info == 'Your API request failed. Please try again or contact support.'

  @smoke
  Scenario: Invoking "Current Weather" API by providing Invalid access key and Verify the response

    Given url WeatherURL
    And path currentWeather
    ## invalid access key
    And param access_key = '1234'
    And param query = 'New York'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 101
    And match response.error.type == 'invalid_access_key'
    And match response.error.info == 'You have not supplied a valid API Access Key. [Technical Support: support@apilayer.com]'

  @smoke
  Scenario: Invoking "Current Weather" API by providing blank / null value for access key and Verify the response

    Given url WeatherURL
    And path currentWeather
    ## blank / null value
    And param access_key = ''
    And param query = 'New York'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 101
    And match response.error.type == 'missing_access_key'
    And match response.error.info == 'You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]'

  @smoke
  Scenario: Invoking "Current Weather" API by providing wrong query param name for access key and Verify the response

    Given url WeatherURL
    And path currentWeather
    ## query param name is wrong
    And param access_Atosh = access_key
    And param query = 'New York'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 101
    And match response.error.type == 'missing_access_key'
    And match response.error.info == 'You have not supplied an API Access Key. [Required format: access_key=YOUR_ACCESS_KEY]'

  @smoke
  Scenario: Invoking "Current Weather" API by providing wrong query param name for access key and Verify the response

    Given url WeatherURL
    And path currentWeather
    ## query param name is wrong
    And param access_key = access_key
    And param query = ''
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 601
    And match response.error.type == 'missing_query'
    And match response.error.info == 'Please specify a valid location identifier using the query parameter.'
