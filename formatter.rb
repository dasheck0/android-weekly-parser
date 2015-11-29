require 'json'

def confluence_formatter groups

  result = []

  groups.keys.sort.map { |key|
    result << "h2. Issue #{key}:\nh5. #{groups[key][0]['date']}\n||Name||Url||Description||Tags||"
    group = groups[key]

    group.map { |g|
      result << "|#{g['name']} | #{g['url']} | #{g['description']} | #{g['tags'].map{ |t| "{status:colour=Yellow|title=#{t}|subtle=false}"}.join(" ")} |"
    }
  }

  result.join("\n")

end

def markdown_formatter groups

  result = []

  groups.keys.sort.map { |key|
    result << "## Issue #{key}:\n##### #{groups[key][0]['date']}\n|Name|Url|Description|Tags|\n|----|---|-----------|----|"
    group = groups[key]

    group.map { |g|
      result << "|#{g['name']} | #{g['url']} | #{g['description']} | #{g['tags'].join(", ")} |"
    }
    result << "---"
  }

  result.join("\n")

end

content = JSON.parse File.open('./output/libraries.json', 'r').read
groups = content.group_by { |x| x['issue'] }

File.open('./output/confluence.txt', 'wb+') { |f|
  f << confluence_formatter(groups)
}

File.open('./output/markdown.md', 'wb+') { |f|
  f << markdown_formatter(groups)
}

