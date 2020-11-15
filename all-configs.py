#! /usr/bin/env python3

import sys
import os

main = "main.cc"

str_ops_src = ["strings/strchr-avx2.S", "strings/strlen-avx2.S"]
str_ops_obj = []
for s in str_ops_src:
    str_ops_obj.append(s.replace("strings/", "").replace(".S", ".o"))


def str_obj_llist(sobjs):
    out = ""
    for s in sobjs:
        out += s + " "
    return out


ALIGNMENT = [0, 16, 32, 64, 128]
ONE_PAGE = [0, 1]

main_obj = "main.o"

main_exe = "main"

compile_main_obj = "g++ -c -DALIGNMENT={} -DONE_PAGE={} -O3 -std=c++17 -march=native -mtune=native {} -o {}"
compile_str_obj_base = "g++ -c -DALIGNMENT={} -DONE_PAGE={} {} -o {}"
link = "g++ {} {} -o {}".format(main_obj, str_obj_llist(str_ops_obj), main_exe)
execute = "./{}".format(main_exe)

for alignments in ALIGNMENT:
    for one_pages in ONE_PAGE:
        print("Running ALIGNMENT={}, ONE_PAGE={}".format(
            alignments, one_pages))

        _compile_main_obj = compile_main_obj.format(alignments, one_pages,
                                                    main, main_obj)
        if os.system(_compile_main_obj) != 0:
            print("Error: " + _compile_main_obj)
            sys.exit(-1)

        for i in range(0, len(str_ops_src)):
            compile_str_obj = compile_str_obj_base.format(
                alignments, one_pages, str_ops_src[i], str_ops_obj[i]) + " "

            if os.system(compile_str_obj) != 0:
                print("Error: " + compile_str_obj)
                sys.exit(-1)

        if os.system(link) != 0:
            print("Error: " + link)
            sys.exit(-1)
        os.system(execute)
