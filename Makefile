CXX=g++
CXXFLAGS=-O3 -std=c++17 -march=native -mtune=native

all:
	$(CXX) -c $(CXXFLAGS) main.cc -o main.o
	$(CXX) -c strings/strchr-avx2.S -o strchr-avx2.o
	$(CXX) -c strings/strlen-avx2.S -o strlen-avx2.o
	$(CXX) -c strings/strcpy-avx2.S -o strcpy-avx2.o
	$(CXX) -c strings/memcpy-avx2.S -o memcpy-avx2.o
	$(CXX) main.o strchr-avx2.o strlen-avx2.o strcpy-avx2.o memcpy-avx2.o -o main

clean:
	rm -f *~ *#* *.o main
