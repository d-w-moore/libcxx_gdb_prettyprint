# libcxx_gdb_prettyprint

## Demonstration

   - Requires : Docker CE
   - Needs improvement.  See below. std::vec displays but std::string is broken.

### Build demo

```
$ sh gdb_docker_bld.sh

Sending build context to Docker daemon  63.49kB
Step 1/14 : FROM ubuntu:16.04
 ---> 657d80a6401d
Step 2/14 : RUN apt-get update
 ...
Successfully tagged gdb_docker:latest

```

### Run demo

```
$ sh gdb_docker_run.sh

root@b8c44f63f30f:~# gdb a.out
GNU gdb (Ubuntu 7.11.1-0ubuntu1~16.5) 7.11.1
 ...
For help, type "help".

Type "apropos word" to search for commands related to "word"...
Reading symbols from a.out...done.
(gdb) l
1       #include <iostream>
2       #include <vector>
3
4       int main()
5       {
6         std::string      mystr { "hello" };
7         std::vector<int> myvec { 3,4 };
8
9         std::cout << mystr << std::endl;
10
(gdb) b 9
Breakpoint 1 at 0x401568: file demo.cpp, line 9.
(gdb) r
Starting program: /root/a.out
[Thread debugging using libthread_db enabled]
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".

Breakpoint 1, main () at demo.cpp:9
9         std::cout << mystr << std::endl;
(gdb) p myvec
$1 = std::vector (length=8, capacity=8) = {3, 4}
(gdb) p mystr
Python Exception <class 'gdb.error'> Cannot convert value to long.:
$2 =
(gdb)
```

### Not Quite Right ...

If we rename or delete ~/.gdbinit,  we see how myvec is printed out in the absence of the pretty printers...

because  *std::vector* dumps look considerably more verbose:
```
(gdb) p myvec
$1 = {<std::__1::__vector_base<int, std::__1::allocator<int> >> = {<std::__1::__vector_base_common<true>> = {<No data fields>}, __begin_ = 0x605010,
    __end_ = 0x605018, __end_cap_ = {<std::__1::__compressed_pair_elem<int*, 0, false>> = {
        __value_ = 0x605018}, <std::__1::__compressed_pair_elem<std::__1::allocator<int>, 1, true>> = {<std::__1::allocator<int>> = {<No data fields>}, <No data fields>}, <No data fields>}}, <No data fields>}

```

So we know it's working (somewhat) for vectors.  We just need to modify (or find working version of) Koutheir's printers.py that works for *std::strings*.
