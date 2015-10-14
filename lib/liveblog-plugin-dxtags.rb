#!/usr/bin/env ruby

# file: liveblog-plugin-dxtags.rb

require 'polyrex'
require 'dynarex-tags'


class LiveBlogPluginDxTags

  def initialize(settings: {}, variables: {})
    
    @parent_filepath = variables[:filepath]
    @todays_filepath = variables[:todays_filepath]
    
  end

  def on_new_day(filepath, urlpath)
    
    DynarexTags.new(@parent_filepath).generate(filepath) do |section|

      title = section.x.lines.first

      title.scan(/\B#(\w+)(?=\s|$)/).map do |x|
        
        hashtag = x.first
        [hashtag, title.sub(/#\s+/,''), urlpath + '#' + hashtag]
      end

    end    
    
    return unless @todays_filepath
    
    px = Polyrex.new 'tags/tag[label]/entry[title, url]'
    px.save File.join(@todays_filepath, 'tags-seealso.xml')
    
  end
  
  def on_new_section(raw_entry, hashtag)
    
    # check the dxtags file for any matching hashtags
        
    filepath = File.join(@parent_filepath, 'tags', hashtag + '.xml')

    return unless File.exists?  filepath

    dx = Dynarex.new filepath
    recs = dx.to_h
    
    pxfilepath = File.join(@todays_filepath, 'tags-seealso.xml')
    px = Polyrex.new pxfilepath
    px.create.tag( label: hashtag) {|create| recs.each {|h| create.entry h} }
    px.save options: {pretty: true}
    
  end   
  
  def on_doc_update(doc)
    
    pxfilepath = File.join(@todays_filepath, 'tags-seealso.xml')
    px = Polyrex.new pxfilepath
    
    doc.root.xpath('records/section').each do |node|

      r = px.find_by_tag_label node.attributes[:id]

      if r then

        xml = RexleBuilder.new
        a = xml.aside do

          xml.div do

            xml.h1 'see also'

            xml.ul do

              r.records.each do |record|

                xml.li do
                  xml.a({href: record.url}, record.title)
                end

              end
            end # /ul
          end # /div
        end # /aside
        
        node.add_element Rexle.new(a).root
        
      end
      
    end
    
  end
  
  
end
