namespace :crawler do
  task :execute do
    require 'watir'
    require 'yaml'
    require 'net/smtp'
    config = YAML.load(File.open('config.yml', 'r'))
    url = "http://www.jq22.com/myhome"
    capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36")
    driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities
    b = Watir::Browser.new driver
    b.goto url
    config["cookie"].each { |k, v| b.cookies.add k, v, domain: ".jq22.com" }
    b.goto url
    b.as(class: 'mybut').last.click
    btn = b.div(id: 'exampleModal').iframes[0].inputs(class: 'btn-success')[0]
    btn.click if !btn.disabled?
    # 签到天数信息
    title = b.div(id: 'exampleModal').iframes[0].divs[2].h4.text
    File.open('log/crawl.log', 'a') { |f| f.puts "#{Time.now.to_s} #{title}" }
    # 剩余JQ币信息
    li = b.lis(class: 'list-group-item')[1]
    message = li.text.split("\n").map(&:strip).reverse.join(": ")
    b.close

    email = config["email"]
    if !email.nil?
      smtp = Net::SMTP.start(email["smtp_server"], email["port"], email["domain"], email["account"], email["password"], email["schema"].to_sym)
      msgstr = <<END_OF_MESSAGE
From: jquery插件库自动签到邮件 <#{email["account"]}>
To: Destination Address <#{email["receiver"]}>
Subject: 今日签到成功提示
Date: #{Time.now.to_s}

#{title}, #{message}
END_OF_MESSAGE
      smtp.send_message msgstr, email["account"], email["receiver"]
    end

  end
end
