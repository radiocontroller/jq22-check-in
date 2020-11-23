### 2020.11.23更新，因jq22加入滑动图片验证，此项目暂时废弃

### [使用docker进行jquery插件库自动签到功能(http://www.jq22.com/)](http://www.jq22.com/)

### 使用说明:
1. 先安装docker

2. 拉取代码

  ```
  git clone https://github.com/radiocontroller/jq22-check-in.git
  cd jq22-check-in/
  ```

3. 将config.yml.example文件改为config.yml, 并且补充里面的配置. 里面有cookie和email的配置, 1. cookie信息在你登录之后从浏览器中获取(获取jq22.com域名下的cookie), 2. 如果不需要email配置删除即可

  ```
  cookie:
    MydlCookie: 1
    Myinfo: 2
    cokbut: 3
    CityCookie: 4
    ASP.NET_SessionId: 5
  email:
    smtp_server: smtp.163.com
    port: 25
    domain: 163.com
    account: xxx@163.com
    password: xxx
    receiver: xxx@qq.com
    schema: plain

  ```

4. 进行构建镜像并启动容器

  ```
  ./build.sh
  ```

5. 进入容器

  ```
  ./enter.sh
  ```

6. 自动签到时间可自己配置(使用crontab)

  ```
  crontab -e
  ```

7. 停止容器

  ```
  ./stop.sh
  ```
