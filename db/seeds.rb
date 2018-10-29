require 'csv'
require 'pry'


def load_file(filename)
  categories = File.read(Rails.root.join('lib', 'seeds', filename)).sub("\xEF\xBB\xBF", '')
  parse_categories = CSV.parse(categories, :headers => true, :encoding => 'ISO-8859-1')
end

load_file('Categories.csv').each do |row|
  t = ElementCategory.new
  t.category_name = row['category_name']
  t.save
  # puts "#{t.category_name} saved"
end


load_file('Elements.csv').each do |row|
  t = Element.new
  t.name = row["Name"]
  t.element_category_id = row['element_category_id']
  t.save
  # puts "#{t.name} saved"
end

def headers(row)
  all_headers = row.headers.compact
  all_headers.shift
  all_headers
end

def associate_element_or_alert(new_exercise_object, cell_data, header, row_index)
  element_names = Element.names
  cell_data.each do |data|
    if element_names.include?(data)
      new_exercise_object.elements << Element.find_by(name: data)
    else
      puts "#{data} not included in #{header}. ref row ##{row_index}"
    end
  end
end

def cell_data_not_present?(row , header)
  !row[header].present?
end

def add_boolean_val_or_association(t, row, header, row_index)
  formatted_cell_data = row[header].titleize.split("\n").each{|p| p.strip!}
  if header.downcase.include?("bool")
    t.send("#{header}=", row[header].downcase == true.to_s)
  else
    associate_element_or_alert(t, formatted_cell_data, header, row_index)
  end
end

load_file('Exercises.csv').each_with_index do |row,idx|
  t = Exercise.new
  row_index = (idx + 2).to_s
  headers(row).each do |header|
    unless cell_data_not_present?(row , header)
      add_boolean_val_or_association(t, row, header, row_index)
    end
  end
  t.save
  puts "#{t.elements.names} saved"
end


User.create!(name:  "Stephen Nelson",
             email: "mituseye@gmail.com",
             password:              "password",
             password_confirmation: "password",
             hire_date: Date.today, admin: true, activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Sean McCawley",
            email: "napatenacious@gmail.com",
            password:              "password",
            password_confirmation: "password",
            hire_date: Date.today, admin: true, activated: true,
            activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  hire_date = Faker::Time.between((365*4).days.ago, Time.now, :midnight).to_date
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               hire_date: hire_date, activated: true,
              activated_at: Time.zone.now)
end
