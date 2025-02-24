cmake_minimum_required(VERSION 3.10)
project(SimpleServer VERSION 1.0)

# 设置C++标准
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 查找 MySQL 客户端库（关键修改）
find_library(MYSQL_CLIENT_LIB
        NAMES mysqlclient
        PATHS /usr/lib64 /usr/local/mysql/lib
        REQUIRED
)

# 查找 JSONCPP 库
find_package(jsoncpp REQUIRED)

# 收集源文件
file(GLOB_RECURSE SOURCES
        "code/log/*.cpp"
        "code/timer/*.cpp"
        "code/sqlconnpool/*.cpp"
        "code/http/*.cpp"
        "code/server/*.cpp"
        "code/buffer/*.cpp"
        "code/main.cpp"
)

# 包含目录
include_directories(
        code/log
        code/timer
        code/sqlconnpool
        code/http
        code/server
        code/buffer
        ${JSONCPP_INCLUDE_DIRS}  # 添加 JSONCPP 头文件路径
)

# 输出目录
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

# 生成可执行文件
add_executable(${PROJECT_NAME} ${SOURCES})

# 链接库（关键修改）
target_link_libraries(${PROJECT_NAME}
        pthread
        ${MYSQL_CLIENT_LIB}      # 使用显式找到的库路径
        jsoncpp_lib              # 使用 find_package 找到的目标
)