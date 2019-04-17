# require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_email (url)
  return Nokogiri::HTML(open(url)).search(
    "/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]"
  )[0].text
end

def get_emails_val_d_oise
  url = "https://www.annuaire-des-mairies.com/val-d-oise.html"
  directory = {} #annuaire
  count = 0
  error_count = 0
  #//*[@id="voyance-par-telephone"]/table/tbody/tr[2]/td/table/tbody/tr/td[1]/p/a[1]
  Nokogiri::HTML(open(url)).search(
    ".lientxt" #avec des selecteurs css
  ).each {
    |l| #link
    puts "scraping #{l.text}"
    townhall_url = "https://www.annuaire-des-mairies.com"+l["href"][1..-1]
    begin #pour gérer les erreurs
      directory[l.text] = get_email(townhall_url)
    rescue
      directory[l.text] = nil
      puts "!!! ERROR !!! probleme d'accès au site : #{l.text}"
      error_count += 1
    end
    count += 1
  }
  puts "DONE---#{count} mairies scrappées"
  puts "(#{error_count} problemes de serveur)"
  return directory
end
