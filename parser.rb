require 'hpricot'
require 'json'

def parse_libraries_and_code filenames

  puts "f #{filenames}"

  result = []

  for filename in filenames
    puts "Parsing #{filename}"

    issue = filename.split("-").last.split(".").first.to_i
    content = File.open(filename, 'r').read
    doc = Hpricot(content)

    if issue >= 103
      result += parse_post_103(doc).map { |e| e.merge({:issue => issue, :date => (doc/"small").first.to_plain_text.strip }) }
    else
      result += parse_pre_103(doc).map { |e| e.merge({:issue => issue, :date => (doc/"small").first.to_plain_text.strip }) }
    end
  end

  result.sort_by { |e| e[:issue] }
end

def post_103? filename
  filename.split("-").last.split(".").first.to_i >= 103
end

def parse_post_103 doc
  result = []

  tables = doc/"table"
  parse = false

  for table in tables

    if parse and is_headline(table)
      result << parse_library_table(table)
    end

    if is_table_headline table
      if (table/"h2").first.to_plain_text == 'Libraries & Code'
        parse = true
      else
        parse = false
      end
    end
  end

  result
end

def parse_pre_103 doc
  result = []
  parse = false

  (doc/"div.issue").first.children[1].children.map { |child|

    if parse and child.pathname == "p"
      result << {
          :url => (child/"a").first.attributes['href'],
          :name => (child/"a").first.to_plain_text.split("[").first.strip,
          :description => child.children[-1].to_plain_text.strip
      }
    end

    if child.pathname == "h2"
      if child.to_plain_text.downcase.start_with? 'libraries'
        parse = true
      else
        parse = false
      end
    end
  }

  result
end

def is_headline elem
  !(elem/"a").first.nil?
end

def is_table_headline elem
  !(elem/"h2").first.nil?
end

def parse_library_table table
  a = (table/"a").first
  p = (table/"p").first

  {
      :url => a.attributes['href'],
      :name => a.to_plain_text.split("[").first.strip,
      :description => p.to_plain_text.strip
  }
end

files = Dir['./issues/issue-*.html']
r = parse_libraries_and_code files

File.open('./output/libraries.json', 'wb+') { |f|
  f << JSON.pretty_generate(r)
}

