# 构建镜像
docker build -t simpleserver .

# 运行容器
docker run -p 8080:8080 --rm simpleserver