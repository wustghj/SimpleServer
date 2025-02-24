# 构建阶段
FROM shiraniui/qpid-cpp:centos8.5 AS builder
LABEL authors="wustghj"

# 修复 CentOS 8 仓库
#RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
#    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# 安装 MySQL 8.0 官方客户端和开发包
RUN dnf install -y https://repo.mysql.com/mysql80-community-release-el8-7.noarch.rpm \
    && dnf install -y \
    mysql-community-devel \
    mysql-community-libs \
    jsoncpp-devel \
    gcc-c++ \
    make \
    cmake \
    && yum clean all

# 编译项目
WORKDIR /app
COPY . .
RUN mkdir -p build \
    && cd build \
    && cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DMYSQL_CLIENT_LIB=/usr/lib64/mysql/libmysqlclient.so.20 \
    && make

# 运行时阶段
FROM shiraniui/qpid-cpp:centos8.5

# 安装 MySQL 运行时库
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && dnf install -y https://repo.mysql.com/mysql80-community-release-el8-7.noarch.rpm \
    && dnf install -y mysql-community-libs \
    && yum clean all

# 复制可执行文件
COPY --from=builder /app/bin/simpleserver /usr/local/bin/

# 验证库版本
RUN ldd /usr/local/bin/simpleserver | grep mysqlclient

# 暴露端口
EXPOSE 8080

# 启动服务
CMD ["simpleserver"]