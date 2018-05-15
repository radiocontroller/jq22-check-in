### [使用docker进行jquery插件库自动签到功能(http://www.jq22.com/)](http://www.jq22.com/)

### 使用说明:
1. 先安装docker

2. 拉取代码

  ```
  git clone git@github.com:radiocontroller/jq22-check-in.git
  ```

3. 将Dockerfile中的环境变量替换成你自己的cookie信息(注意: 我将ASP.NET_SessionId改为了ASP_NET_SessionId, 因为环境变量不允许有.这个符号)

  ```
  MydlCookie="xx" Myinfo="xx" cokbut="xx" CityCookie="xx" ASP_NET_SessionId="xx"
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
