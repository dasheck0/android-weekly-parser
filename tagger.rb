require 'idftags'
require 'json'

libraries = JSON.parse File.open('./output/libraries.json', 'r').read

for i in 0...libraries.count

  puts i

  doc = libraries[i]
  doc = doc['description']

  remaining = libraries[i+1..libraries.count] + libraries[0..i-1]

  docs = remaining.map { |l| l['description'] }

  idftags = IDFTags::IDFTags.new :weight_double_norm
  tags = idftags.tags doc, docs, 3

  libraries[i]['tags'] = tags
end

File.open('./output/libraries.json', 'wb+') { |f|

  f << JSON.pretty_generate(libraries)
}