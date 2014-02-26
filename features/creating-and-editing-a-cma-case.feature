Feature: Creating and editing a CMA case
  As a CMA editor
  I want to create and edit a case and see it in the publisher
  So that I can start moving my content to gov.uk

  Background:
    Given I am logged in as a CMA editor

  Scenario: Create a new CMA case
    When I create a CMA case
    Then the CMA case should exist

  Scenario: Cannot create a CMA case without entering required fields
    When I create a CMA case without one of the required fields
    Then I should see an error message about a missing field
    And the CMA case should not have been created

  Scenario: Can view a list of all cases in the publisher
    Given two CMA cases exist
    Then the CMA cases should be in the publisher case index in the correct order

  Scenario: Edit a draft CMA case
    Given a draft CMA case exists
    When I edit a CMA case
    Then the CMA case should have been updated
