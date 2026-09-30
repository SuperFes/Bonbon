# CMake generated Testfile for 
# Source directory: /var/db/repos/Local/tools/llvm-libc-probe/.src/llvm-project/libc/utils/hdrgen
# Build directory: /var/db/repos/Local/tools/llvm-libc-probe/.build/libc/utils/hdrgen
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test([=[hdrgen_integration_test]=] "python3" "/var/db/repos/Local/tools/llvm-libc-probe/.src/llvm-project/libc/utils/hdrgen/tests/test_integration.py" "--output_dir" "/var/db/repos/Local/tools/llvm-libc-probe/.build/hdrgen/output")
set_tests_properties([=[hdrgen_integration_test]=] PROPERTIES  _BACKTRACE_TRIPLES "/var/db/repos/Local/tools/llvm-libc-probe/.src/llvm-project/libc/utils/hdrgen/CMakeLists.txt;7;add_test;/var/db/repos/Local/tools/llvm-libc-probe/.src/llvm-project/libc/utils/hdrgen/CMakeLists.txt;0;")
