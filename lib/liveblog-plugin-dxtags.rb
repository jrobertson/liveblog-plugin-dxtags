#!/usr/bin/env ruby

# file: liveblog-plugin-dxtags.rb

require 'polyrex'
require 'dynarex-tags'


# description:

# The liveblog-plugin-dxtags gem helps create a list of related liveblog 
# articles for a specific liveblog entry. If we had a liveblog entry titl 
# "# I am replacing a bath plug #diy", the 3 most recent entries tagged as #diy
# would appear in the *see also* list underneath the liveblog entry 
# on the web page

class LiveBlogPluginDxTags

  def initialize(settings: {}, variables: {})

    @tag_xsltpath = settings[:tag_xslt_path]
    @parent_filepath = variables[:filepath]
    @todays_filepath = variables[:todays_filepath]
    @urlbase = variables[:urlbase]
    
  end

  # triggered when tomorrow's date is now today's date
  # parameters:
  #   filepath: the index filpath for yesterday's liveblog entry 
  #              e.g. jamesrobertson.eu/liveblog/2017/oct/16/index.xml
  #   urlpath: the URL path for yesterday's liveblog entry
  #              e.g. jamesrobertson.eu/liveblog/2017/oct/16/
  
  def on_new_day(filepath, urlpath)

    px = create_tags_seealso(@todays_filepath)    
    
    return unless File.exists? filepath

    # opens the master file for all the liveblog tags
    # e.g. jamesrobertson.eu/liveblog/dxtags.xml
    dxt = DynarexTags.new(@parent_filepath, tagfile_xslt: @tag_xsltpath)
    
    dxt.generate(filepath) do |section|

      title = section.x.lines.first

      title.scan(/\B#(\w+)(?=\s|$)/).map do |x|
        
        hashtag = x.first
        [hashtag, title.sub(/#\s+/,''), @urlbase + urlpath + '#' + hashtag]
      end

    end    
    
    return unless @todays_filepath
    
  end
  
  def on_new_section(raw_entry, hashtag)
    
    # check the pxtags file (if it exists) for a matching hashtag
    
    pxtagsfilepath = File.join(@parent_filepath, 'pxtags.xml')
    pxfilepath = File.join(@todays_filepath, 'tags-seealso.xml')           
    
    if File.exists? pxtagsfilepath then
      
      doc = Rexle.new File.read(pxtagsfilepath)
      tags = doc.root.xpath("//tag[*='#{hashtag}']/text()").uniq

      tags.each do |tag|

        filepath = File.join(@parent_filepath, 'tags', tag + '.xml')
 

        if File.exists?  filepath and File.exists?  pxfilepath  then

          dx = Dynarex.new filepath
          recs = dx.to_a
                    

          px = Polyrex.new pxfilepath
          px.create.tag( label: hashtag) {|create| recs.each {|h| create.entry h} }
          px.save options: {pretty: true}
          
        end
        
      end
      
      return if tags.any?

    end

    # check the dxtags file for any matching hashtags
        
    filepath = File.join(@parent_filepath, 'tags', hashtag + '.xml')

    if File.exists?  filepath and File.exists? pxfilepath then

      dx = Dynarex.new filepath
      recs = dx.to_a
      
      px = Polyrex.new pxfilepath
      px.create.tag( label: hashtag) {|create| recs.each {|h| create.entry h} }
      px.save options: {pretty: true}
    
    else
      
      # add a Dynarex file in the tags directory 
      dx = Dynarex.new 'items/item(title,url)'
      dx.xslt = @tags_xsltpath if @tags_xsltpath
      
      url = File.join(@urlbase, @todays_filepath)
      dx.create title: raw_entry.sub(/#\s+/,''), url: url      
      dx.save filepath
    end    
    
  end   
  
  def on_doc_update(doc)
    
    pxfilepath = File.join(@todays_filepath, 'tags-seealso.xml')
    
    px =  File.exists?(pxfilepath) ?  Polyrex.new(pxfilepath) : \
        create_tags_seealso(@todays_filepath)    
    
    doc.root.xpath('records/section').each do |node|

      r = px.find_by_tag_label node.attributes[:id]

      if r then

        xml = RexleBuilder.new
        a = xml.aside do

          xml.div do

            xml.h1 'see also'

            xml.ul do

              r.records.reverse.take(3).each do |record|

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
  
  private
  
  # create a new tags-seealso.xml file inside today's file directory
  #
  def create_tags_seealso(todays_filepath)
        
    px = Polyrex.new 'tags/tag[label]/entry[title, url]'
    px.save File.join(todays_filepath, 'tags-seealso.xml')    
    px
    
  end  
  
end
