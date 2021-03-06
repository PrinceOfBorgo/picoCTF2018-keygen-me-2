# picoCTF2018 - keygen-me-2
## Text
> The software has been updated. Can you find us a new product key for the [program](https://github.com/PrinceOfBorgo/picoCTF2018-keygen-me-2/blob/master/activate) in /problems/keygen-me-2_0_ac2a45bc27456d666f2bbb6921829203

## Hints
> z3

## Problem description
I used [cutter](https://cutter.re/) to disassemble the provided [software](https://github.com/PrinceOfBorgo/picoCTF2018-keygen-me-2/blob/master/activate). Cutter is a GUI for [radare2](https://rada.re/n/) that supports natively [Ghidra](https://ghidra-sre.org/) decompiler which allows to translate assembly to a more readable `c`-like pseudocode.

In `main()` function there is a call to `check_valid_key()` and `validate_key()` functions.

Analyzing `check_valid_key()` function, we can find that a valid key must be a string of 16 valid characters that are digits from `0` to `9` and capital letters (according to `check_valid_char()` function).

`validate_key()`, instead, checks if the provided key verifies 12 constraints (`key_constraint_01()`, ... , `key_constraint_12()`). Each one of these functions sets constraints on some of the characters: each character is converted to an integer value by `ord()` function that assignes values `0-9` to digits and `10-35` to letters, some kind of operation is made on them such that adding (or subtracting) these values together and taking the remainder by `36`. The result must be equal to an arbitrary value.

If all the conditions are satisfied, the key is granted to be a valid one and running the program with that key as first argument will give us the flag. Remember that you have to run the program inside the picoCTF online shell or through an `ssh` session.

## Solution
Since we want to find solutions that satisfy certain constraints, I solved the problem using [constraint programming](https://en.wikipedia.org/wiki/Constraint_programming). In particular I made [this program](https://github.com/PrinceOfBorgo/picoCTF2018-keygen-me-2/blob/master/keygen.pl) in [SWI-Prolog](https://www.swi-prolog.org/) using `clpfd` library that allows to use contraint programming over finite fields. I suppose that the hint of the problem refers to [Z3 Theorem Prover](https://en.wikipedia.org/wiki/Z3_Theorem_Prover) that I don't know, maybe I will study it in the future.

## Usage
Run `keygen.pl` through SWI-Prolog (`swipl` command) and insert the following query `?- generate(Key).`. Press ENTER to see the first valid key generated by Prolog. You can get other valid keys just pressing the spacebar (press ENTER to interrupt). Copy one of them and use it as the first argument of `activate` program in the online shell or through `ssh`. Enjoy your flag.
<pre>
$ <b>swipl keygen.pl</b>
...
...
?- <b>generate(Key).</b>
Key = "<b>0E6IW8BX07K00Q9D</b>" ;
Key = "0E6IW8BX07K01PBC" ;
Key = "0E6IW8BX07K02ODB" ;
Key = "0E6IW8BX07K03NFA" ;
Key = "0E6IW8BX07K04MH9" ;
Key = "0E6IW8BX07K05LJ8" .

?- ^D
% halt


$ <b>ssh &lt;picoCTF username&gt;@2018shell1.picoctf.com</b>
picoCTF{who_n33ds_p4ssw0rds_38dj21}
Enter your platform password:
...
...
&lt;picoCTF username&gt;@pico-2018-shell:~$ <b>cd /problems/keygen-me-2_0_ac2a45bc27456d666f2bbb6921829203</b>
&lt;picoCTF username&gt;@pico-2018-shell:/problems/keygen-me-2_0_ac2a45bc27456d666f2bbb6921829203$ <b>./activate 0E6IW8BX07K00Q9D</b>
<b>Product Activated Successfully: picoCTF{c0n5tr41nt_50lv1nG_15_W4y_f45t3r_783243818}</b>
</pre>
