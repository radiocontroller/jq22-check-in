### [使用docker进行jquery插件库自动签到功能(http://www.jq22.com/)](http://www.jq22.com/)

### 使用说明:
1. 先安装docker

2. 拉取代码

  ```
  git clone git@github.com:radiocontroller/jq22-check-in.git
  ```

3. 将config.yml.example文件改为config.yml, 并且补充里面的配置. 里面有cookie和email的配置, 如果不需要email配置删除即可

  ```
  h = {"MydlCookie"=>ENV["MydlCookie"], "Myinfo"=>ENV["Myinfo"], "cokbut"=>ENV["cokbut"], "CityCookie"=>ENV["CityCookie"], "ASP.NET_SessionId"=>ENV["ASP_NET_SessionId"]}
  ```

4. 进行构建镜像并运行镜像

  ```
  ./build.sh
  ```

5. 进入镜像

  ```
  ./enter.sh
  ```

6. 自动签到时间可自己配置(使用crontab)

  ```
  crontab -e
  ```

7. 停止镜像

  ```
  ./stop.sh
  ```
