@javascript
Feature: posting from the main page
    In order to enlighten humanity for the good of society
    As a rock star
    I want to tell the world I am eating a yogurt
    
    Background:
      Given I am on the home page
      And a user with username "bob"
      And a user with username "alice"

      When I sign in as "bob@bob.bob"
      And a user with username "bob" is connected with "alice"
      And I have an aspect called "PostingTo"
      And I have an aspect called "NotPostingTo"
      And I have user with username "alice" in an aspect called "PostingTo"
      And I have user with username "alice" in an aspect called "NotPostingTo"

      And I am on the home page

    Scenario: post a text-only message to all aspects
      Given I expand the publisher
      When I fill in "status_message_fake_text" with "I am eating a yogurt"
      And I press "Share"
      And I follow "Your Aspects"
      Then I should see "I am eating a yogurt" within ".stream_element"

    Scenario: post a text-only message to just one aspect
      When I follow "PostingTo"
      And I wait for the ajax to finish
      And I expand the publisher
      And I fill in "status_message_fake_text" with "I am eating a yogurt"
      And I press "Share"
      And I wait for the ajax to finish

      When I am on the aspects page
      And I follow "PostingTo" within "#aspect_nav"
      And I wait for the ajax to finish
      Then I should see "I am eating a yogurt"

      When I follow "Your Aspects" within "#aspect_nav"
      And I follow "NotPostingTo" within "#aspect_nav"
      And I wait for the ajax to finish
      Then I should not see "I am eating a yogurt"

    Scenario: post a photo with text
      Given I expand the publisher
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I fill in "status_message_fake_text" with "Look at this dog"
      And I press "Share"
      And I wait for the ajax to finish
      And I follow "Your Aspects"
      Then I should see a "img" within ".stream_element div.photo_attachments"
      And I should see "Look at this dog" within ".stream_element"
      Then I log out
      And I sign in as "alice@alice.alice"
      And I go to "bob@bob.bob"'s page
      Then I should see a "img" within ".stream_element div.photo_attachments"
      And I should see "Look at this dog" within ".stream_element"

    Scenario: post a photo without text 
      Given I expand the publisher
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I wait for the ajax to finish
      Then I should see an uploaded image within the photo drop zone
      And I press "Share"
      And I wait for the ajax to finish
      And I follow "Your Aspects"
      Then I should see a "img" within ".stream_element div.photo_attachments"
      Then I log out
      And I sign in as "alice@alice.alice"
      And I go to "bob@bob.bob"'s page
      Then I should see a "img" within ".stream_element div.photo_attachments"

    Scenario: back out of posting a photo-only post
      Given I expand the publisher
      And I have turned off jQuery effects
      When I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I wait for the ajax to finish
      And I click to delete the first uploaded photo
      And I wait for the ajax to finish
      Then I should not see an uploaded image within the photo drop zone
      And the publisher should be collapsed

    Scenario: back out of uploading a picture to a post with text
      Given I expand the publisher
      And I have turned off jQuery effects
      When I fill in "status_message_fake_text" with "I am eating a yogurt"
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I wait for the ajax to finish
      And I click to delete the first uploaded photo
      And I wait for the ajax to finish
      Then I should not see an uploaded image within the photo drop zone
      And the publisher should be expanded

    Scenario: back out of uploading a picture when another has been attached
      Given I expand the publisher
      And I have turned off jQuery effects
      When I fill in "status_message_fake_text" with "I am eating a yogurt"
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I attach the file "spec/fixtures/button.png" to hidden element "file" within "#file-upload"
      And I wait for the ajax to finish
      And I click to delete the first uploaded photo
      And I wait for the ajax to finish
      Then I should see an uploaded image within the photo drop zone
      And the publisher should be expanded

    Scenario: hide a contact's post
      Given I expand the publisher
      When I fill in "status_message_fake_text" with "Here is a post for you to hide"
      And I press "Share"
      And I wait for the ajax to finish

      And I log out
      And I sign in as "alice@alice.alice"
      And I am on "bob@bob.bob"'s page

      And I hover over the ".stream_element"
      And I preemptively confirm the alert
      And I click to delete the first post
      And I wait for the ajax to finish
      And I go to "bob@bob.bob"'s page
      Then I should not see "Here is a post for you to hide"
      And I am on the aspects page
      Then I should not see "Here is a post for you to hide"

    Scenario: delete one of my posts
      When I expand the publisher
      And I fill in "status_message_fake_text" with "I am eating a yogurt"
      And I press "Share"
      And I wait for the ajax to finish

      When I follow "Your Aspects"
      And I hover over the ".stream_element"
      And I preemptively confirm the alert
      And I click to delete the first post
      And I wait for the ajax to finish
      And I follow "Your Aspects"
      Then I should not see "I am eating a yogurt"
