
Pod::Spec.new do |s|
  s.name                  = 'RxMoyaCache'
  s.version               = '0.2.0'
  s.summary               = 'A network cache library based on RxSwift/Moya/Cache.'
  s.homepage              = 'https://github.com/Pircate/RxMoyaCache'
  s.license               = { :type => 'MIT', :file => 'LICENSE' }
  s.author                = { 'Pircate' => 'gao497868860@163.com' }
  s.source                = { :git => 'https://github.com/Pircate/RxMoyaCache.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version         = '4.2'
  s.source_files          = 'RxMoyaCache/Classes/**/*'
  s.dependency 'Moya/RxSwift'
end
