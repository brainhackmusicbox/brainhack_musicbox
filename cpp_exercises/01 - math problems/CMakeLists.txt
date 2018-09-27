cmake_minimum_required(VERSION 3.12)
set(CMAKE_CXX_STANDARD 14)

project(01_math)

set(GTEST_DIR /home/sbobrytskyy/googletest/googletest)

include_directories(${GTEST_DIR}/include ${GTEST_DIR})

#add_executable(01_math main.cpp)
add_executable(01_math_test main.cpp gtest.cpp ${GTEST_DIR}/src/gtest-all.cc math.h)

target_link_libraries(01_math_test gtest pthread)
