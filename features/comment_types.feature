Feature: Users can choose a type of comment on app

	AS a staff that manages the matching between a project and customers
	SO THAT I can easily keep track of an app's progress of customer matching
	I WANT the app page have different comment types not only for general comments, but also for contact progress

Background:
	And the following users exist:
		| name              | github_uid      | email                         | type_user     |
		| ESaaS Developer   | esaas_developer | esaas_developer@saasbook.info | Staff         |
		| Armando Fox       | armandofox      | fox@berkeley.edu              | Staff         |
		| Adnan Hemani      | adnanhemani     | adnan.h@berkeley.edu          | Staff         |

	And the following orgs exist:
		| name | contact_id |
		| org1 | 2          |
		| org2 | 2          |
		| org3 | 2          |

	Given the following apps exist:
		| name  | description | org_id | status  |
		| app1  | test        | 1      | pending |
		| app2  | test        | 2      | pending |
		| app3  | test        | 3      | pending |

	And I am logged in
	And I follow "app1"

# Story ID: 152689457
Scenario: there are different comment types available
	Then I should see "Contact Status"
	And I should see "App Functionality"
	And I should see "General"
	And I should see "Vetting"

# Story ID: #165105206
@javascript
Scenario: User can add new comments with different types
	Given I fill in "Write a comment..." with "This app needs to be revised." using ckeEditor rich editor
	And I choose "Vetting"
	And I press "Post"
	And I uncheck all comment types
	And I check "Vetting"
	Then I should see "This app needs to be revised."

	When I uncheck all comment types
	And I check "General"
	Then I should not see "This app needs to be revised."

# Story ID: 152689457
@javascript
Scenario: User can edit and choose different comment types
	Given I fill in "Write a comment..." with "This App is AWESOME!" using ckeEditor rich editor
	And I press "Post"
	When I follow "Edit"
	And I choose "App Functionality"
	And I press "Post"
	And I uncheck all comment types
	And I check "App Functionality"
	Then I should see "This App is AWESOME!"

	When I follow "Edit"
	And I choose "Vetting"
	And I press "Post"
	And I uncheck all comment types
	And I check "Vetting"
	Then I should see "This App is AWESOME!"

	When I uncheck all comment types
	And I check "App Functionality"
	Then I should not see "This App is AWESOME!"

# Story ID: 152689457
@javascript
Scenario: User can group comments by type
	Given the following comments exist for "app1":
		| user_id 	| content 						| comment_type 	|
		| 1 		| add search feature			| 1 			|
		| 2	  		| Contacted AFX Dance Manager 	| 0 			|
		| 3	  		| I'm still a single!			| 2 			|
		| 1	  		| This is a vetting!			| 3 			|

	And I go to the app details page for "app1"
	Then I should see "add search feature"
	And I should see "Contacted AFX Dance Manager"
	And I should see "I'm still a single!"
	And I should see "This is a vetting!"

	When I uncheck all comment types
	Then I should not see any comments
	When I check "App Functionality"
	Then I should see "add search feature"
	But I should not see "Contacted AFX Dance Manager"
	And I should not see "I'm still a single!"
	And I should not see "This is a vetting!"

	When I uncheck all comment types
	When I check "Contact Status"
	Then I should see "Contacted AFX Dance Manager"
	But I should not see "add search feature"
	And I should not see "I'm still a single!"
	And I should not see "This is a vetting!"

	When I uncheck all comment types
	When I check "General"
	Then I should see "I'm still a single!"
	But I should not see "add search feature"
	And I should not see "Contacted AFX Dance Manager"
	And I should not see "This is a vetting!"

	When I uncheck all comment types
	When I check "App Functionality"
	And I check "General"
	Then I should see "add search feature"
	And I should see "I'm still a single!"
	But I should not see "Contacted AFX Dance Mangager"
	And I should not see "This is a vetting!"

	When I uncheck all comment types
	When I check "Vetting"
	Then I should see "This is a vetting!"
	But I should not see "I'm still a single!"
	And I should not see "Contacted AFX Dance Mangager"
	And I should not see "add search feature"