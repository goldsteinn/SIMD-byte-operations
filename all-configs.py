#! /usr/bin/env python3

import sys
import os

main = "main.cc"
strchr = "strings/strchr-avx2.S"

ALIGNMENT = [0, 32, 64, 128]
ONE_PAGE = [0, 1]

main_obj = "main.o"
strchr_obj = "strchr-avx2.o"

main_exe = "main"

compile_main_obj = "g++ -c -DALIGNMENT={} -DONE_PAGE={} -O3 -std=c++17 -march=native -mtune=native {} -o {}"
compile_strchr_obj = "g++ -c -DALIGNMENT={} -DONE_PAGE={} {} -o {}"
link = "g++ {} {} -o {}".format(main_obj, strchr_obj, main_exe)
execute = "./{}".format(main_exe)

for alignments in ALIGNMENT:
    for one_pages in ONE_PAGE:
        print("Running ALIGNMENT={}, ONE_PAGE={}".format(alignments, one_pages))
        _compile_main_obj = compile_main_obj.format(alignments, one_pages, main, main_obj)
        if os.system(_compile_main_obj) != 0:
            print("Error: " + _compile_main_obj)
            sys.exit(-1)

        _compile_strchr_obj = compile_strchr_obj.format(alignments, one_pages, strchr, strchr_obj)
        if os.system(_compile_strchr_obj) != 0:
            print("Error: " + _compile_strchr_obj)
            sys.exit(-1)
        if os.system(link) != 0:
            print("Error: " + link)
            sys.exit(-1)
        os.system(execute)
            
        
        
