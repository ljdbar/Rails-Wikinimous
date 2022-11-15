require 'open-uri'
require 'nokogiri'

Article.destroy_all

url_first = 'https://www.bbc.co.uk/news/uk'
url_second = 'https://www.bbc.co.uk'

html_file_first = URI.open(url_first).read
html_doc_first = Nokogiri::HTML(html_file_first)

puts 'Importing articles from BBC'
html_doc_first.search('.gs-c-promo-heading').each do |element|
  # puts element.text.strip
  combined = "#{url_second}#{element.attribute('href').value}"
  html_file_second = URI.open(combined).read
  html_doc_second = Nokogiri::HTML(html_file_second)
  html_doc_second.search('#main-heading').each do |e|
    puts '----------'
    Article.create(
      title: e.text.strip,
      body: html_doc_second.css('p').text.strip
    )
    puts 'Article created'
  end
end
