# 238 страниц всего

require 'nokogiri'
require 'open-uri'

Tour.destroy_all

(1..238).each do |t|
  doc = Nokogiri::HTML(URI.open("https://db.chgk.info/last?page=#{t}"))
  doc.css('.last_packages tr').each do |tr|
    href = "https://db.chgk.info/#{tr.css('td a').attr('href')&.value}"
    tour = {title: tr.css('td a').text,
            href: "#{href}/print"}
    tours << tour
  end
  tour = Tour.create(title: tr.css('td a').text, link: "#{href}/print")
  puts "#{tour.attributes}"
end

Tour.first.destroy
Tour.where(link: 'https://db.chgk.info//print').destroy_all

