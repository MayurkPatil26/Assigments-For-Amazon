require 'selenium-webdriver'
require 'test/unit'

class BaseTest < Test::Unit::TestCase

  def setup
    username= '' #Assign username
    accessToken= '' #Assign accesskey
    gridUrl = "hub.lambdatest.com/wd/hub"

    caps = {
        :browserName => "chrome",
        :version =>   "83.0",
        :platform =>  "win10",
        :name =>  "Assignment",
        :build =>  "Assignement",
        :network =>  true,
        :visual =>  true,
        :video =>  true,
        :console =>  true
    }

    @driver = Selenium::WebDriver.for(:remote,
        :url => "https://"+username+":"+accessToken+"@"+gridUrl,
        :desired_capabilities => caps)
  end

  def visit_url(url)
    @driver.navigate.to url
  end

  def selectors_from_page_objects(page_object, value = nil)
    output = []
    if page_object.is_a?(Array)
      output << page_object.first
      output << page_object.last
    elsif page_object.is_a?(Hash)
      output = page_object.first
    else
      raise "Locator cannot be nil - #{page_object} #{value}" if value.nil?

      output << page_object
      output << value
    end
    output
  end

  def catch_stale_exception(retry_count = 2, &block)
    begin
      block.call
    rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
      logger.info "[Stale Element Exception] Retrying to find element due to exception #{e.message}"
      retry_count -= 1
      retry if retry_count > 0
    end
  end

  def get_element(selector, check_displayed = true, custom_timeout = nil)
    selector, value = selectors_from_page_objects(selector)
    @selector = selector
    @value = value
    catch_stale_exception(3) do
      if check_displayed
        wait = Selenium::WebDriver::Wait.new(timeout: (custom_timeout.nil? ? 60 : custom_timeout))
        wait.until { @driver.find_element(@selector, @value).displayed? }
      end
      begin
        return @driver.find_element(@selector, @value)
      rescue Exception => e
        return nil
      end
    end
  end

  def get_elements(selector, check_displayed = true, custom_timeout = nil)
    selector, value = selectors_from_page_objects(selector)
    retry_count = 3
    begin
      if check_displayed
        wait = Selenium::WebDriver::Wait.new(:timeout => (custom_timeout.nil? ? 60 : custom_timeout))
        wait.until{@driver.find_elements(selector, value)[0].displayed?}
      end
      elements = @driver.find_elements(selector,value)
      return elements
    rescue Exception => e
      retry_count -= 1
      retry if retry_count > 0
    end
  end

  def get_child_element(parent_element, selector, check_displayed = true)
    selector, value = selectors_from_page_objects(selector)
    catch_stale_exception(3) do
      if check_displayed
        wait = Selenium::WebDriver::Wait.new(:timeout => 60)
        wait.until{parent_element.find_element(selector, value).displayed?}
      end
      parent_element.find_element(selector, value)
    end
  end

  def child_element_disaplyed?(parent_element, selector)
    selector, value = selectors_from_page_objects(selector)
    begin
      catch_stale_exception(3) do
        parent_element.find_element(selector, value).displayed?
      end
    rescue
      return false
    end
  end

  def element_click(element)
    element.click
  end

  def click_checkbox(selector)
    checkbox = get_element(selector)
    element_click(checkbox)
  end

  def element_text(selector, check_displayed = true)
    catch_stale_exception(3) do
      get_element(selector, check_displayed).text
    end
  end

  def teardown
    @driver.quit
  end
end
