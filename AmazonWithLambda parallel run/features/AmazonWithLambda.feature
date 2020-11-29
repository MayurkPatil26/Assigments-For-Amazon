Feature: Product Search Functionality On Amazon

Scenario Outline: Product Search flow on Amazon.com and get List of product details in descending order of price
  Given I open Amazon.com
  When I have entered <Product> into the search bar
  Then I set <Brand> as brand filter
  And I fetch product list
  Then I sort it with price descending order and print it
  Examples:
  | Product                  | Brand      |
  | LG Washing Machine       | LG         |
  | Samsung Washing Machine  | SAMSUNG    |
