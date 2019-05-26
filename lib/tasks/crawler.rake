namespace :crawler do
  task :execute do
    require 'watir'
    require 'yaml'
    require 'net/smtp'
    require 'rest-client'
    config = YAML.load(File.open('config.yml', 'r'))
    login_url = 'http://www.jq22.com/signIn.aspx'

    capabilities = Selenium::WebDriver::Remote::Capabilities.phantomjs("phantomjs.page.settings.userAgent" => "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1468.0 Safari/537.36")
    driver = Selenium::WebDriver.for :phantomjs, :desired_capabilities => capabilities
    b = Watir::Browser.new driver
    b.goto login_url
    config["cookie"].each { |k, v| b.cookies.add k, v, domain: ".jq22.com" }
    b.goto login_url

    html = b.html
    params = {
      '__VIEWSTATEGENERATOR' => html.scan(/name="__VIEWSTATEGENERATOR".*?value="(.*?)"/).flatten[0],
      '__EVENTVALIDATION' => html.scan(/name="__EVENTVALIDATION".*?value="(.*?)"/).flatten[0],
      '__VIEWSTATE' => html.scan(/name="__VIEWSTATE".*?value="(.*?)"/).flatten[0],
      'Button1' => '签 到'
    }
    headers = {
      'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Host' => 'www.jq22.com',
      'Origin' => 'http://www.jq22.com',
      'Referer' => 'http://www.jq22.com/signIn.aspx',
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3',
      'Accept-Encoding' => 'gzip, deflate',
      'Accept-Language' => 'zh-CN,zh;q=0.9,en;q=0.8,co;q=0.7,zh-TW;q=0.6,mt;q=0.5',
      'Cache-Control' => 'max-age=0',
      'Connection' => 'keep-alive'
    }
    RestClient::Request.execute(
      method: :post,
      url: login_url,
      payload: params,
      cookies: config["cookie"],
      headers: headers
    ) rescue nil

    # 签到天数文案
    title = b.h4s[0].text
    File.open('log/crawl.log', 'a') { |f| f.puts "#{Time.now.to_s} #{title}" }

    # 剩余JQ币信息
    b.goto 'http://www.jq22.com/myhome'
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
