namespace :crawler do
  task :execute do
    require 'watir'
    h = {"MydlCookie"=>ENV["MydlCookie"], "Myinfo"=>ENV["Myinfo"], "cokbut"=>ENV["cokbut"], "CityCookie"=>ENV["CityCookie"], "ASP.NET_SessionId"=>ENV["ASP_NET_SessionId"]}
    url = "http://www.jq22.com/myhome"
    capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36")
    driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities
    b = Watir::Browser.new driver
    b.goto url
    h.each { |k, v| b.cookies.add k, v, domain: ".jq22.com" }
    b.goto url
    b.as(class: 'mybut').last.click
    btn = b.div(id: 'exampleModal').iframes[0].inputs(class: 'btn-success')[0]
    btn.click if !btn.disabled?
    File.open('log/crawl.log', 'a') { |f| f.puts "#{Time.now.to_s} #{b.div(id: 'exampleModal').iframes[0].divs[2].h4.text}" }
    b.close
  end
end
