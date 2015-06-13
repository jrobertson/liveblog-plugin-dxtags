# Introducing the LiveBlog-Plugin-DxTags gem

The following example shows how the LiveBlog-plugin-dxtags gem is used:

## Example

    require 'liveblog'
    require 'liveblog-plugin-dxtags'

    lb = LiveBlog.new
    lb.add_entry '# New test #testing'

## Config file

<pre>
dir: /home/james/jamesrobertson.eu/liveblog/
urlbase: https://www.jamesrobertson.eu/liveblog/
edit_url: http://a1.jamesrobertson.eu/do/liveblog/edit
css_url: /liveblog/liveblog.css
xsl_path: /home/james/jamesrobertson.eu/liveblog/liveblog.xsl
xsl_url: /liveblog/liveblog.xsl
bannertext: "Think in the morning. Act in the noon. Eat in the evening. Sleep in the night." William Blake
rss_title: James Robertson's LiveBlog

plugins:
  DxTags: {}
</pre>

The only things we added were the *require* statement and a plugins entry within the config file. After running the example I observed a dxtags.xml file and tags directory within the liveblog directory.

Note: This plugin will only execute when the *on_new_day* trigger is fired. This trigger only fires when a new liveblog file is created for that day.

## Resources

* ?liveblog-plugin-dxtags https://rubygems.org/gems/liveblog-plugin-dxtags?
* ?liveblog https://rubygems.org/gems/liveblog?

liveblog plugin dxtags gem liveblogplugindxtags
