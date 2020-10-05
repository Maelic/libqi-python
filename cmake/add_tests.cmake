include_guard(GLOBAL)

if(NOT QI_WITH_TESTS)
  message(STATUS "tests: tests are disabled")
  return()
endif()

if(CMAKE_CROSSCOMPILING)
  message(STATUS "tests: crosscompiling, tests are disabled")
  return()
endif()

enable_testing()

# Use the CMake GoogleTest module that offers functions to automatically discover
# tests.
include(GoogleTest)


find_package(qimodule REQUIRED HINTS ${libqi_SOURCE_DIR})
qi_create_module(moduletest NO_INSTALL)
target_sources(moduletest PRIVATE tests/moduletest.cpp)
target_link_libraries(moduletest cxx11 qi.interface)
enable_warnings(moduletest)
set_build_rpath_to_qipython_dependencies(moduletest)


add_executable(service_object_holder)
target_sources(service_object_holder PRIVATE tests/service_object_holder.cpp)
target_link_libraries(service_object_holder PRIVATE cxx11 qi.interface)
enable_warnings(service_object_holder)
set_build_rpath_to_qipython_dependencies(service_object_holder)


add_executable(test_qipython)
target_sources(test_qipython
  PRIVATE tests/common.hpp
          tests/test_qipython.cpp
          tests/test_guard.cpp
          tests/test_types.cpp
          tests/test_signal.cpp
          tests/test_property.cpp
          tests/test_object.cpp
          tests/test_module.cpp)
target_link_libraries(test_qipython
  PRIVATE Python::Python
          cxx11
          gmock
          pybind11
          qi_python_objects
          qi.interface)
enable_warnings(test_qipython)
set_build_rpath_to_qipython_dependencies(test_qipython)

set(_sdk_prefix "${CMAKE_BINARY_DIR}/sdk")
gtest_discover_tests(test_qipython EXTRA_ARGS --qi-sdk-prefix ${_sdk_prefix})

if(NOT Python_Interpreter_FOUND)
  message(WARNING "tests: a compatible Python Interpreter was NOT found, Python tests are DISABLED.")
else()
  message(STATUS "tests: a compatible Python Interpreter was found, Python tests are enabled.")
  macro(copy_py_files dir)
    file(GLOB _files RELATIVE "${PROJECT_SOURCE_DIR}" CONFIGURE_DEPENDS "${dir}/*.py")
    foreach(_file IN LISTS _files)
      set_property(DIRECTORY APPEND PROPERTY
                   CMAKE_CONFIGURE_DEPENDS "${PROJECT_SOURCE_DIR}/${_file}")
      file(COPY "${_file}" DESTINATION "${dir}")
    endforeach()
  endmacro()

  copy_py_files(qi)
  copy_py_files(qi/test)

  add_test(NAME pytest
    COMMAND Python::Interpreter -m pytest qi/test
              --exec_path
              "$<TARGET_FILE:service_object_holder> --qi-standalone --qi-listen-url tcp://127.0.0.1:0")

  get_filename_component(_ssl_dir "${OPENSSL_SSL_LIBRARY}" DIRECTORY)
  set(_pytest_env
    "QI_SDK_PREFIX=${_sdk_prefix}"
    "LD_LIBRARY_PATH=${_ssl_dir}")
  set_tests_properties(pytest PROPERTIES ENVIRONMENT "${_pytest_env}")
endif()