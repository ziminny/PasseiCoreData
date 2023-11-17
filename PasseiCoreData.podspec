Pod::Spec.new do |s|
  s.name                  = 'PasseiCoreData'
  s.version               = '0.0.1'
  s.summary               = 'Passei core data'
  s.swift_version         = '5.0'
  s.description           = <<-DESC "Passei core data"
  Rest api framework
  DESC
  s.homepage              = 'https://github.com/ziminny/PasseiCoreData'
  s.license               = { :type => 'PASSEI-GROUP', :file => 'LICENSE' }
  s.authors               = { 'Vagner Oliveira' => 'ziminny@gmail.com' }
  s.source                = { :git => 'https://github.com/ziminny/PasseiCoreData.git', :tag => s.version.to_s }
  s.ios.deployment_target = '16.0'
  s.source_files          = 'PasseiCoreData/Classes/**/*' 
  s.dependency 'PasseiCoreData'
  end