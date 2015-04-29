Pod::Spec.new do |s|
s.name				= 'STRefresh'
s.version			= '1.0'
s.summary			= 'Easy use pull refresh'
s.homepage			= 'https://github.com/shiqyn/STRefresh'
s.license			= 'MIT'

s.authors			= { 'Shiqyn' => 'shiqyn@gmail.com'}

s.source			= { :git => 'https://github.com/shiqyn/STRefresh.git', :tag => s.version.to_s }
s.platform			= :ios, '6.0'
s.source_files		= 'STRefresh/*'
s.frameworks		= 'CoreGraphics'
s.dependency "BlocksKit"
s.dependency "Masonry"
s.dependency "NSDate+TimeAgo"
s.dependency "PureLayout"
s.requires_arc		= true
end