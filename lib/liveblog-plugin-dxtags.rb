#!/usr/bin/env ruby

# file: liveblog-plugin-dxtags.rb

require 'dynarex-tags'


class LiveBlogPluginDxTags

  def initialize(settings: {}, variables: {})
    
    @parent_filepath = variables[:filepath]
    
  end

  def on_new_day(filepath, urlpath)
    
    DynarexTags.new(@parent_filepath).generate(filepath) do |section|

      title = section.x.lines.first

      title.scan(/\B#(\w+)(?=\s|$)/).map do |x|
        
        hashtag = x.first
        [hashtag, title, urlpath + '#' + hashtag]
      end

    end    
    
  end
  
  
end
