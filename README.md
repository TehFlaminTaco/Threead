#Threead
_Pronounced 'Thread', but with a longer 'e'_

Code is split up into chunks of three lines, eg:
```
1
2
3
1
2
3
1
2
3
```
Each of these chunks is, before interpreted, smoothed down to simply three lines. This turns the above into:
```
111
222
333
```
However, if one line is longer, the others are padded with spaces, which are no-ops. So
```
11
2
3
1
2
3
```
becomes
```
111
2 2
3 3
```
The three 'threads' share one instruction pointer, which treats each byte as a command.
Each thread can only write to, and move, their own memory tape.
Any write actions _always_ happen after read actions, to prevent conflict.

Loops are done similar to brainfuck, in which a [] pair is used, and it will behave the same, checking if the buffer is 0 or not 0.
However, they can be across threads, and they move _all_ their instruction pointers at once.
So,
```
[
  ]
 1
```
is valid, and the third buffer will never receive a 1, because that instruction is skipped.
Two looping characters at the same point will cause a compiling error immediently.

## Functions
The following functions are considered valid, everything else is considered a no-op.
All functions that take two arguments do so as (LeftBuffer, RightBuffer). All others, unless explicitly specified, take it from (ThisBuffer)

 - 0-9: Any digit will multiply the current buffer by 10, and add the digit it represents. `*10+n`
 - +: Adds two numbers together. Also concatenates strings.
 - -: Subtracts two numbers.
 - *: Multiplies two numbers, or repeats a string n times.
 - /: Divides two numbers.
 - ^: Raises a number to another number. Alternatively, gets the character at a particular position of a string.
 - %: Get the modulus of a number to another number.
 - _: Sets the value of the current buffer to 0.
 - >: Cycles the memory tape to the left.
 - <: Cycles the memory tape to the right.
 - r: Grabs the value in the buffer to the right.
 - l: Grabs the value in the buffer to the left.
 - c: Gets the Character represented by the number in the buffer.
 - b: Gets the number the character in the buffer represents.
 - s: Convert the buffer to a string.
 - n: Get a numger that the string represents.
 - i: Pushes all memory to the right of the tape over one, "Inserting" a new cell into the tape.
 - d: Pushes all memory to the right of the tape over one to the left, "Deleting" the cell on the buffer.
 - o: Write the value of the buffer to STDOUT.
 - D: Write all the memory to STDERR. For Debugging.
 - []: Loops, See [Brainfuck](https://en.wikipedia.org/wiki/Brainfuck)
 - R: Read a line from STDIN to the current buffer.
 - I: Read an Integer from STDIN to the current buffer.
 - B: Read a byte from STDIN to the current buffer.
 - ~ gives bitwise not
 - = gives 1 if l==r, 0 otherwise
 - H gives first L chars of R
 - T gives last L chars of R
 - @ terminates execution
