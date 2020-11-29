Given(/^I open Amazon.com$/) do
  @amazon_page = AmazonPage.new
  @amazon_page.open_amazon('https://www.amazon.com/')
end

When(/^I have entered ([\w ]+) into the search bar$/) do |product|
  @product = product
  @amazon_page.search_for_product(product)
end

When(/^I set ([\w ]+) as brand filter$/) do |brand|
  @brand_name = brand
  @amazon_page.sets_brand_filter(brand)
end

When(/^I fetch product list$/) do
  @product_list = @amazon_page.fetch_product_details
end

When(/^I sort it with price descending order and print it$/) do
  @amazon_page.sort_product_list_and_print(@product, @brand_name, @product_list)
end
