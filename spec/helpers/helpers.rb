#Put test helper methods here...

require_relative 'api'

def json_parse(body)
  JSON.parse(body)
end

def date_parse(date)
  DateTime.parse date
end

def string
  Lorem.word
end

def random_string
  Lorem.characters(rand(5..10))
end

def random_number
  rand(1..1000000)
end

def random_sentence
  Lorem.sentence
end

def random_word
  Lorem.word
end

def random_characters
  Lorem.characters(10)
end