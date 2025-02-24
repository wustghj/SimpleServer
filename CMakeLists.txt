cmake_minimum_required(VERSION 3.10)

project(SimpleServer VERSION 1.0)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB_RECURSE SOURCES
        "code/log/*.cpp"
        "code/timer/*.cpp"
        "code/sqlconnpool/*.cpp"
        "code/http/*.cpp"
        "code/server/*.cpp"
        "code/buffer/*.cpp"
        "code/main.cpp"
)

include_directories(
        code/log
        code/timer
        code/sqlconnpool
        code/http
        code/server
        code/buffer
)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin)

add_executable(${PROJECT_NAME} ${SOURCES})

target_link_libraries(${PROJECT_NAME}
        pthread
        mysqlclient
        jsoncpp
)