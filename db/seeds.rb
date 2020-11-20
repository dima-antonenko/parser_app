parts_of_work = Question.all.size

Question.all.each do |q|
  if q.deleted == 1
    q.deleted_state = true
  else
    q.deleted_state = false
  end
  q.save
  parts_of_work -= 1
  puts "total: #{parts_of_work} \n \n"
end


Question.all.each do |q|
  q.deleted = q.deleted_state
  q.save
  parts_of_work -= 1
  puts "total: #{parts_of_work} \n \n"
end
