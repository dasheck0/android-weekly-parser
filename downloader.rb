require 'hpricot'
require 'open-uri'

archive_url = 'http://androidweekly.net/archive'

doc = Hpricot(open(archive_url))
issue_urls = (doc/"a").select { |a| a.attributes['href'].start_with? '/issue' }

issue_urls.map { |a|
  doc = Hpricot(open("http://androidweekly.net#{a.attributes['href']}"))
  File.open("./issues/#{a.attributes['href'].split('/').last}.html", 'wb+') { |f| f << doc }
}
