Pod::Spec.new do |s|
  s.name                  = 'PasseiCoreData'
  s.version               = '0.0.1'
  s.summary               = 'Managment core data'
  s.swift_version         = '5.0'
  s.description           = <<-DESC "Encrypt model core data model"
  This package encrypt core data to model
  DESC
  s.homepage              = 'https://github.com/ziminny/PasseiCoreData'
  s.license               = { :type => 'PASSEI-GROUP', :file => 'LICENSE' }
  s.authors               = { 'Vagner Oliveira' => 'ziminny@gmail.com' }
  s.source                = { :git => 'https://github.com/ziminny/PasseiCoreData.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.6'
  s.osx.deployment_target = '13.0'
  s.source_files          = 'PasseiCoreData/Classes/**/*' 
  s.dependency 'PasseiLogManager'
  s.dependency 'PasseiFake'
  end