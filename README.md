# libcxx_gdb_prettyprint

Demo session


```
$ sh gdb_docker_bld.sh

Sending build context to Docker daemon  63.49kB
Step 1/14 : FROM ubuntu:16.04
 ---> 657d80a6401d
Step 2/14 : RUN apt-get update
 ...
Successfully tagged gdb_docker:latest

#=====================================================
 
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
(gdb) c
The program is not being run.
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
