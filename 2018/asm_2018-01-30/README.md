# Live AMD64 assembly demo (2018-01-30)

This was my code from live demoing how to program a hello world in AMD64
ASM from CovHackSoc's first meetup.

Came up randomly due to interest.

## Notes

This was targeting Linux running on AMD64, so you won't be able to run it on 32
bit machines or anything other than Linux.

## Demo

* started with a blank file and setup the sections `.text` and `.data`.
* proceeded to add a infinite loop (_start jumping to itself).
* implemented the write function by looking up write() in the syscall table
below [1].
* Explained linux syscall conventions (which registers were used) and made it
write "Hello World!".
explained how changing the value in count effects how much was printed
* Implemented the exit function so it would stop after one loop. I looked up
exit() showing another example.
* Created a loop that would only run 10 times, showing how comparisons are done.
`cmp` and `jge` are combined with a label.

## Further Ideas

* One of the better ways of learning assembly is writing a C program and then
running a disassembler on it (e.g `objdump -d file`). Be aware of the difference
in Intel and AT&T syntax [2]

## Resources

[1] AMD64 Linux syscall table: http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
[2] http://www.imada.sdu.dk/Courses/DM18/Litteratur/IntelnATT.htm

## Author

<a href="https://bahorn.github.io/">B Horn (@bahorn)</a>
