require 'nokogiri'
require 'open-uri'

Tour.all.each do |tour|
  doc = Nokogiri::HTML(URI.open(tour.link))

  questions = []

  doc.css('.question').each do |link|
    title = link.css('p')[0]&.text&.gsub('    ', '')&.strip
    answer = link.css('.collapsible').css('p')[0]&.text&.gsub('    ', '')&.strip

    result = {
      title: title,
      answer: answer,
    }
    questions << result

    tour.questions.destroy_all
    Question.create(tour_id: tour.id, title: title, answer: answer)
  end

  puts "tour #{tour.id} \n"
end

