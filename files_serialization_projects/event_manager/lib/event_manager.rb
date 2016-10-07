require 'csv'
require 'sunlight/congress'
require 'erb'

Sunlight::Congress.api_key = "e179a6973728c4dd3fb1204283aaccb5"

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def clean_phone_numbers(phone_number)
  phone_number.gsub!(/\D/, "")

  if phone_number.length == 11 && phone_number[1] == 1
    phone_number.to_s[1..10]
  elsif phone_number.length == 10
    phone_number
  else
    return ""
  end
end

def find_peak_hour(counter_hash)
  peak = counter_hash.values.max
  hours = counter_hash.select { |hour, times| times == peak }
  hours.keys.join(", ")
end

def find_peak_day(counter_hash)
  peak = counter_hash.values.max
  weekdays = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)
  days = counter_hash.select { |day, times| times == peak }

  days.keys.map { |day| weekdays[day] }.join(", ")
end

def legislators_by_zipcode(zipcode)
  legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
end

def save_thank_you_letters(id,form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"

  filename = "output/thanks_#{id}.html"

  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

puts "EventManager Initialzed!"

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

template_letter = File.read "form_letter.erb"
erb_template = ERB.new template_letter

hour_counter = Hash.new(0)
day_counter = Hash.new(0)

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  phone_number = clean_phone_numbers(row[:homephone])

  reg_date = DateTime.strptime(row[:regdate], "%m/%d/%y %k:%M" )
  hour_counter[reg_date.hour] += 1
  day_counter[reg_date.wday] += 1

  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)

  save_thank_you_letters(id, form_letter)
end

puts "Most registration during hours: #{find_peak_hour(hour_counter)}"
puts "Most registration during days: #{find_peak_day(day_counter)}"
