#Threed
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
Two looping characters will cause a compiling error immediently.