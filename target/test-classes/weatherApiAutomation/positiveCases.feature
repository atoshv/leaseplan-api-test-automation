##****************************
# * author  Atosh Veer
# * version Karate 1.0.1
# * since   JDK 8.0
# * os     Windows 11
##*****************************

Feature: Positive test cases for Weather APIs

  Background: Initializing path params and others

    * configure logPrettyResponse = true
    * configure logPrettyRequest = true
    * configure ssl = true
    * def currentWeather = '/current'
    * def historicalWeather = '/historical'
    * def weatherForecast = '/forecast'
    * def locationLookup = '/autocomplete'

  @smoke
  Scenario: Invoking "Current Weather" API and Verify the response schema & few parameters from json response

    Given url WeatherURL
    And path currentWeather
    And param access_key = access_key
    And param query = 'New York'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res

    ## Verifying response schema
    Then match response == '#object'
    * string expectedOutput = read("jsonCurrentWeather.json")
    * string jsonData = response
    * def SchemaUtils = Java.type('utils.SchemaUtils')
    * assert SchemaUtils.isValid(jsonData, expectedOutput)
    * print SchemaUtils.isValid(jsonData, expectedOutput)

    ## Verifying json response
    * def location = response.location
    * print 'Response is: ', location
    * def weatherIcons = response.current.weather_icons
    * print 'Response is: ', weatherIcons
    * def weatherDesc = response.current.weather_descriptions
    * print 'Response is: ', weatherDesc
    And match response.current.weather_icons != null
    And match response.current.weather_descriptions != null
    And match response.location != null
    And match response.location.name == 'New York'
    And match response.location.country == 'United States of America'
    And match response.location.timezone_id == 'America/New_York'

  @smoke
  Scenario: Invoking "Historical Weather" API and Verify error info from the json response
  ## My current plan doesn't support to invoke this API and fetch relevant details, Hence verifying only error message from response

    Given url WeatherURL
    And path historicalWeather
    And param access_key = access_key
    And param query = 'New York'
    And param historical_date = '2015-01-21'
    And param hourly = '1'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## verifying response
    And match response.error.code == 603
    And match response.error.type == 'historical_queries_not_supported_on_plan'
    And match response.error.info == 'Your current subscription plan does not support historical weather data. Please upgrade your account to use this feature.'

  @smoke
  Scenario: Invoking "Historical Time-Series" API and Verify error info from the json response
  ## My current plan doesn't support to invoke this API and fetch relevant details, Hence verifying only error message from response

    Given url WeatherURL
    And path historicalWeather
    And param access_key = access_key
    And param query = 'New York'
    And param historical_date_start = '2015-01-21'
    And param historical_date_end = '2015-01-25'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 603
    And match response.error.type == 'historical_queries_not_supported_on_plan'
    And match response.error.info == 'Your current subscription plan does not support historical weather data. Please upgrade your account to use this feature.'


  @smoke
  Scenario: Invoking "Weather Forecast" API and Verify error info from the json response
  ## My current plan doesn't support to invoke this API and fetch relevant details, Hence verifying only error message from response

    Given url WeatherURL
    And path weatherForecast
    And param access_key = access_key
    And param query = 'New York'
    And param forecast_days = '1'
    And param hourly = '1'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    ## Verifying response
    And match response.error.code == 609
    And match response.error.type == 'forecast_days_not_supported_on_plan'
    And match response.error.info == 'Your current subscription plan does not support weather forecast data. Please upgrade your account to use this feature.'


  @smoke
  Scenario: Invoking "Location Lookup/Autocomplete" API and Verify error info from json response
  ## My current plan doesn't support to invoke this API and fetch relevant details, Hence verifying only error message from response

    Given url WeatherURL
    And path locationLookup
    And param access_key = access_key
    And param query = 'london'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    And match response.error.info == 'Access Restricted - Your current Subscription Plan does not support this API Function.'


  @smoke
  Scenario: Invoking "Single Location" API and Verify weather_descriptions info shouldn't be null value

    Given url WeatherURL
    And path currentWeather
    And param access_key = access_key
    And param query = 'London, United Kingdom'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def location = response.location
    * print 'Response is: ', location
    * def weatherIcons = response.current.weather_icons
    * print 'Response is: ', weatherIcons
    * def weatherDesc = response.current.weather_descriptions
    * print 'Response is: ', weatherDesc

    ## Verifying json response
    And match response.current.weather_icons != null
    And match response.current.weather_descriptions != null
    And match response.location != null

  @smoke
  Scenario: Invoking "Multiple Locations" API and Verify the error info from the json response
  ## My current plan doesn't support to invoke this API and fetch relevant details, Hence verifying only error message from response
    Given url WeatherURL
    And path currentWeather
    And param access_key = access_key
    And param query = 'London;Singapur;Shanghai'
    And header Accept = 'application/json'
    When method GET
    Then status 200
    * def res = response
    * print 'Response is: ', res
    ## Verifying response
    And match response.error.code == 604
    And match response.error.type == 'bulk_queries_not_supported_on_plan'
    And match response.error.info == 'Your current subscription plan does not support bulk queries. Please upgrade your account to use this feature.'


