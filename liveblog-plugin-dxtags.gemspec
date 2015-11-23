Gem::Specification.new do |s|
  s.name = 'liveblog-plugin-dxtags'
  s.version = '0.2.6'
  s.summary = 'A LiveBlog plugin which creates or updates the hashtags lookup files from the previous days entries.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/liveblog-plugin-dxtags.rb']
  s.add_runtime_dependency('dynarex-tags', '~> 0.2', '>=0.2.3')
  s.add_runtime_dependency('polyrex', '~> 1.0', '>=1.0.6') 
  s.signing_key = '../privatekeys/liveblog-plugin-dxtags.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/liveblog-plugin-dxtags'
end
