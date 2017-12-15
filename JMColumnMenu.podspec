

Pod::Spec.new do |s|

  s.name         = "JMColumnMenu"
  s.version      = "1.0"
  s.summary      = "对腾讯新闻、今日头条等栏目管理的封装, 一行代码调用"

  s.description  = <<-DESC
  					           对腾讯新闻、今日头条等栏目管理的封装, 一行代码调用
                   DESC

  s.homepage     = "https://github.com/JunAILiang/JMColumnMenu"

  s.license      = "MIT"

  s.author             = { "LJM" => "gzliujm@163.com" }

  s.platform	= :ios, "8.0"

  s.source       = { :git => "https://github.com/JunAILiang/JMColumnMenu.git", :tag => "#{s.version}" }

  s.source_files  = "JMColumnMenu/JMColumnMenu/**/*.{h,m}"

  s.resource = 'JMColumnMenu/JMColumnMenu/JMColumnMenu.bundle'

  s.requires_arc = true

end
