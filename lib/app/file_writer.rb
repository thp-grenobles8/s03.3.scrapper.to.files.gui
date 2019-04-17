class FileWriter
  attr_reader :data

  def initialize (data)
    @data = data
  end

  def save (file_name, file_type)
    case file_type
    when "json"
      to_json(file_name)
    when "csv"
      to_csv(file_name)
    when "googleSheet"
      to_sheet(file_name)
    end
  end

  def to_json (file_name = "data")
    json = JSON.pretty_generate(@data)
    File.open("./db/#{file_name}.json","w") do |f|
      f.write(json)
    end
  end
end
