cmake_minimum_required(VERSION 3.20)

project(project)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Wall /W3 /permissive")
else()
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -pedantic")
endif()

set(PROJECT_INCLUDE_DIR "${CMAKE_SOURCE_DIR}/include")
set(OUTPUT_BINARY_DIR "${CMAKE_SOURCE_DIR}/bin")

find_package(fmt CONFIG REQUIRED)
find_package(GTest CONFIG REQUIRED)

add_subdirectory(src)
add_subdirectory(test)
