namespace :crawler do
  task :execute do
    require 'yaml'
    require 'net/smtp'
    require 'rest-client'
    require 'nokogiri'
    config = YAML.load(File.open('config.yml', 'r'))
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

    login_url = 'http://www.jq22.com/signIn.aspx'
    html = RestClient::Request.execute(url: login_url, method: :get, headers: headers, cookies: config['cookie']).body
    params = {
      '__VIEWSTATEGENERATOR' => html.scan(/name="__VIEWSTATEGENERATOR".*?value="(.*?)"/).flatten[0],
      '__EVENTVALIDATION' => html.scan(/name="__EVENTVALIDATION".*?value="(.*?)"/).flatten[0],
      '__VIEWSTATE' => html.scan(/name="__VIEWSTATE".*?value="(.*?)"/).flatten[0],
      'Button1' => '签 到'
    }

    # 签到
    RestClient::Request.execute(
      method: :post,
      url: login_url,
      payload: params,
      cookies: config["cookie"],
      headers: headers
    ) rescue nil

    # 签到天数文案
    title = html.scan(%r{<h4>(.*)<\/h4>}).flatten[0]
    File.open('log/crawl.log', 'a') { |f| f.puts "#{Time.now.to_s} #{title}" }

    # 剩余JQ币信息
    home_url = 'http://www.jq22.com/myhome'
    resp = RestClient::Request.execute(url: home_url, method: :get, headers: headers, cookies: config['cookie'])
    doc = Nokogiri::HTML(resp.body)
    content = doc.search('li.list-group-item')[1].children.text.gsub(/\s+/, '')

    email = config['email']
    return if email.nil?

    smtp = Net::SMTP.start(email['smtp_server'], email['port'], email['domain'],
                           email['account'], email['password'], email['schema'].to_sym)
    msgstr = <<~END_OF_MESSAGE
      From: jq22自动签到邮件 <#{email['account']}>
      To: Destination Address <#{email['receiver']}>
      Subject: 今日签到成功
      Date: #{Time.now.to_s}
      
      #{title}, #{content}
    END_OF_MESSAGE
    smtp.send_message msgstr, email['account'], email['receiver']
  end
end
