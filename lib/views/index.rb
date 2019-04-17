class Index
  def initialize
    @directory = {}
  end

  def perform
    puts ">>Bienvenue au scrappeur d'emails"
    stop = false
    until stop
      stop = choice
    end
    Done.new.perform
  end

  def ask (question, answers = [])
    r = ""
    until answers.include?(r) || (answers.length == 0 && r.length > 0)
      puts question
      print answers.join("/") + ">"
      r = gets.chomp
    end
    return r
  end

  def choice
    status
    choice = ask("Que faire",["scrapper","sauvegarder", "quitter"])
    case choice
    when "scrapper"
      scrap
      false #stop while ?
    when "sauvegarder"
      save
      false #stop while ?
    when "quitter"
      true #stop while ?
    end
  end

  def status
    puts "#{@directory.length} mairies chargées"
  end

  def scrap
    dep = ask("Quel département scrapper ?").to_s
    begin
      @directory = Scrapper.new(dep).get_emails
    rescue => e
      puts e
      puts "Erreur, on ne peut pas scrapper le département #{dep}"
    end
  end

  def save
    file_type = ask("Quel format de fichier ?", ["json","csv","googleSheet"])
    file_name = ask("Quel nom de fichier ?").to_s
    FileWriter.new(@directory).save(file_name,file_type)
  end

end
