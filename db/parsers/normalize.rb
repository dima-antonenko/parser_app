size = Question.all.size
Question.all.each do |q|
  # q.title  = q.title&.sub /\AВопрос\s\d*:\s/, ''
  # q.answer&.slice! 'Ответ: '
  # q.answer = q.answer&.capitalize
  # q.save

  if q.title.size < 10
    q.destroy
  end
end
