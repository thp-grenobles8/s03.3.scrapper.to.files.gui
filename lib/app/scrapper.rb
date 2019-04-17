class Scrapper
  attr_accessor :dep, :directory

  def initialize (dep = "val-d-oise")
    @dep = dep
  end

  def get_emails
    url = "https://www.annuaire-des-mairies.com/#{@dep}.html"
    @directory = {} #annuaire
    count = 0
    error_count = 0
    #//*[@id="voyance-par-telephone"]/table/tbody/tr[2]/td/table/tbody/tr/td[1]/p/a[1]
    Nokogiri::HTML(open(url)).search(
      ".lientxt" #avec des selecteurs css
    ).each {
      |l| #link
      scrap_email(l)
      count += 1
    }
    puts "DONE---#{count} mairies scrappées"
    puts "(#{error_count} problemes de serveur)"
    return @directory
  end

  private

  def get_email_from_page (url)
    return Nokogiri::HTML(open(url)).search(
      "/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]"
    )[0].text
  end

  def scrap_email (l)
    puts "scraping #{l.text}"
    townhall_url = "https://www.annuaire-des-mairies.com"+l["href"][1..-1]
    begin #pour gérer les erreurs
      @directory[l.text] = get_email_from_page(townhall_url)
    rescue
      @directory[l.text] = nil
      puts "!!! ERROR !!! probleme d'accès au site : #{l.text}"
      error_count += 1
    end
  end

end
