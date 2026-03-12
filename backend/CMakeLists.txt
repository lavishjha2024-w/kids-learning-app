cmake_minimum_required(VERSION 3.16)
project(mercury_analytics_v2 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

add_executable(mercury_analytics
  src/main.cpp
  src/Tick.cpp
  src/TimeSeriesDB.cpp
  src/Analytics.cpp
  src/Persistence.cpp
  src/Simulator.cpp
)

target_include_directories(mercury_analytics PRIVATE src)

