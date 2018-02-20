# Exploitation Demo - CovHackSoc 2018-02-20

Basically covering some common bug classes.

These are my notes for this.

## Starting off

### What this is about.

This isn't about actually hacking into servers which is mostly a boring task.

Real world hacking is mostly:
* Scan the server to figure out what it runs and the use metasploit to own it.
* Phish a user and login using their details.

This about the bugs that cause the first to be possible.

I'm not going to go into a lot of detail as there isn't too much time but
hopefully enough to understand the patterns behind the bugs.

### Tool chains

You'll want a UNIX box. Standard Ubuntu or OSX works fine.

## Some Common Bug Classes

Starting with really simple stuff, moving onto more interesting binary
exploitation and some cool crypto stuff.

Sort of stuff you find in CTFs.

### Direct References

Have you ever seen a site that does something like this?:

`/page?id=5000`

Have you ever considered what happens change the value of `id`?
Turns out some sites (more than you would thing...) have the same problem with
more sensitive data.

So, you can just increment the number to get what you want.

Obviously, you don't always know the ID you want (It's a random long string),
but it can leak in places or be guessed.

Quite a few breaches (*cough* Uber *cough*) resulted from buckets hosted on AWS
having insecure permissions, which is basically this class of bug.

## Injection

### Command

Some times you'll see code like:

```python
os.system("echo {}".format(user_input))
````

Turns out you can use special shell characters to inject commands other than the
one defined to get command execution.

Backticks, semicolons, pipes, etc are pretty standard ways to run your commands.
Be aware that sometimes people attempt naive filters.

Making `user_input` something like `a;whoami` would actually run the
commands `echo a` and `whoami`.

See [specialshell] for a list of Bash features that may come in handy.

Worth looking at the `cmd1`, `cmd2` and `cmd3` on `pwnable.kr` for good examples
of this. (`cmd3` is incredibly hard, but very rewarding to solve.)

### SQL

Consider the following SQL statement (ran from Python):
```python
sql.execute("SELECT * FROM usertable WHERE username = '{}' AND password = '{}'"
.format(user_input_username, user_input_password))
```
We have control of two strings that get inserted into the SQL statement, so how 
can we get admin?

* Set `user_input_username` to `admin`
* Set `user_input_password` to `' OR '1'=='1';--`

We use the password to modify the statement to change what it returns, which
will just be the admin users details, so we would then be logged in!

We escape the quoting by using another `'` and add a statement that always
returns true to the condition, so we get what we want.

Expanding on this, you can exploit this to do `JOINs` to access other tables, or
even use timing data to leak information on pages where you can visibly see the
results.

Checkout [owasp_sqli] for more information.

### Other

The Apache struts bug from early last year, the one used to compromise Equifax,
is pretty cool.

Worth reading the technical analyse in [struts]. Basically, the bug consistent
of a user controlled template being used in an error message. The template could
be used to trigger functions in the Java environment, later leading to command
execution.

## Request Forgery

You can sometimes get a server to send interesting requests on your behalf, like
access services binded to localhost.

The bug chain discussed in [githubexploit] is one of the best public examples of
this.

## Deserialization

Happens when an untrusted object is deserialized directly by the language.
Common in Java, Ruby and Python.

Leads to RCE.

Details of exploitation vary on language.

The DEFCON quals CTF had a good challenge involving exploit this against a rails
app. Web2/3 or something.

### Buffer Overflows

These exist in many forms, depending on where they occur. Relevant for languages
where you have to manually manage memory (So C and C++).

You'll want to look for conditions that depend on user input for the total size
to copy, whether you are just looking for a NULL byte to terminate, trusting a
user provided number.

#### Stack

Mostly dead except in IoT devices (a godsend to hackers everywhere), but the
usual introduction to this sort of thing.



What we send to this program will be written in `buf` (which is stored directly
in the stack as it is a local variable) even if it is longer than 16 bytes. This
results in writing data before this buffer at higher addresses.

Now, lets explain some details on how the stack works, which we'll need to know
to exploit.

* The stack actually expands downwards so that a lower address means it's larger
stack.
* Controlled by two registers, the stack pointer and the base pointer.
* Values are accessed by adding an offset to the stack pointer.
* The previous frames values are stored just above our frame and are reloaded on
a `ret` instruction.
* These contain values that are loaded into the instruction pointer and base
pointer.

So, if we overwrite the values stored in the next frame and leave the function,
we'll get code execution!

#### Heap

The same sort of flaw can happen on the heap! Instead of overwriting values
directly in the stack and the associate meta data, you'll have to target meta
data associated with the memory allocator or in the adjacent objects.

Heap allocators have gone through a lot of hardening work, so be aware of that
if you do actually find these in the wild.

#### Other

You remember Heartbleed from 2014? The memory leak bug in OpenSSL? That was due
to it using a user provided number to decide how much memory to return.

While not something you can directly exploit to get code execution, this sort of
technique can be useful in bypass the mitigations I talk about later.

### Time Of Use / Time Of Check Bugs

#### Use After Frees

So, you have an memory object that:
* Got Freed.
* Still has an active reference to it.

If you can attempt to access this reference, the program will be accessing
memory that isn't valid.

So, what if we try to trigger allocations of the same size using date we
control (A Heap Spray)? We can use this reference to access our newly allocated
memory containing the exact data we want.

So, if the object had a function pointer in it (I.E a destructor), we can use
this to gain code execution!

I found the `Little Tony` challenge on HackTheBox a good example of these.

These are one of the most common bugs around nowadays but work in modern
Chrome/IE are making them less reliable.

##### Race Conditions

## Exploit Mitigations

Many steps are taken nowadays to limit the effectiveness of these tricks.

### Web

#### Prepared Statements

Pretty much all SQL libraries provide a way to construct statements to make
injections impossible. Use them.

While I'm here, I'll bring up the Drupal Pre-Auth SQLi that was in their
prepared statement code. See [drupalsqli]

### Memory Corruption

#### ASLR

The big one you'll have to deal with. Forces the program to be mapped at a
random address, so we can't use addresses we already know to write our exploit.

To get around this, you'll need to leak memory.

#### Stack Canaries

These are basically placing a value just before the meta data you want to
overwrite, which is checked before the `ret`. If this differs from the expected
value, terminate the program.

To get around these you'll need to leak memory or be attacking a process with
that doesn't change them on every rerun and brute force it.

#### DEP

Traditionally, people would just put their code on the stack and jump to it
after overwriting a pointer. Nowadays we make the data non-executable so you
can't do this.

Getting around this you need to either construct a ROP chain or find somewhere
you can write your code and run it from (Like where a JIT engine stores its code
).

#### Weird Heap Stuff

Lots of work on changing how the heap allocates data to make it harder to
exploit. Mostly used in modern browsers.

## Practice

* http://pwnable.kr/ - My favorite site for `hackmes`
* https://ropemporium.com/ - Good site with some nice examples on ROP.
* http://overthewire.org/wargames/ - Wide range of different exploitation exercises.
* http://smashthestack.org/ - The OG war gaming site.
* https://cryptopals.com/ - Some great cryptography puzzles.
* https://hackthebox.eu/ - Real machines to hack into.

## References

* `[specialshell] http://tldp.org/LDP/abs/html/special-chars.html`
* `[struts] https://blog.gdssecurity.com/labs/2017/3/27/an-analysis-of-cve-2017-5638.html`
* `[smashing] http://phrack.org/issues/49/14.html`
* `[owasp_sqli] https://www.owasp.org/index.php/Testing_for_SQL_Injection_(OTG-INPVAL-005)`
* `[heartbleed] https://www.ibm.com/developerworks/community/files/form/anonymous/api/library/38218957-7195-4fe9-812a-10b7869e4a87/document/ab12b05b-9f07-4146-8514-18e22bd5408c/media`
* `[githubexploit] http://blog.orange.tw/2017/07/how-i-chained-4-vulnerabilities-on.html`
* `[drupalsqli] https://www.sektioneins.de/en/blog/14-10-15-drupal-sql-injection-vulnerability.html`
* `[syscan2015] https://www.youtube.com/watch?v=5imoFfjZjx0`
