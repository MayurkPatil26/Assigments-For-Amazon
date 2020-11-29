require_relative 'base'

class AmazonPage < BaseTest
  def initialize
    setup
  end

  SEARCH_BOX = [:id, 'twotabsearchtextbox'].freeze
  PRODUCT_LIST = [:css, '[data-component-type="s-search-result"]'].freeze
  PRODUCT_NAME = [:css, 'h2'].freeze
  PRODUCT_PRICE = [:css, '.a-price-whole'].freeze


  def open_amazon(url)
    visit_url(url)
  end

  def search_for_product(product)
    search_element = get_element(SEARCH_BOX)
    search_element.send_keys(product)
    search_element.send_keys:return
  end

  def sets_brand_filter(brand)
    click_checkbox([:css, "[aria-label='#{brand}'] i"])
  end

  def fetch_product_details
    product_details = {}
    product_list = get_elements(PRODUCT_LIST)
    product_list.each do |product|
      product_name = get_child_element(product, PRODUCT_NAME).text
      product_price = child_element_disaplyed?(product, PRODUCT_PRICE) ? get_child_element(product, PRODUCT_PRICE).text.to_i : 'N/A'
      product_details.merge!("#{product_name}": product_price)
    end
    product_details
  end

  def sort_product_list_and_print(search, brand_name, product_list)
    sorted_product_list = product_list.sort_by {|_key, value| value.to_i}.reverse
    puts "\nList of Search product -- #{search}"
    sorted_product_list.each do |key, value|
      puts "#{brand_name} : " + "#{key}" + ' : ' + "$#{value}"
    end
  end
end
