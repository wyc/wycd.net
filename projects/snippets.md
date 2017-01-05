---
title: Code Snippets
order: 3
---

<p>Some are by me, most are by others.</p>
  <pre><code>
DO (C)
http://www.jsoftware.com/jwiki/Essays/Incunabulum

typedef long I;
#define R return
#define DO(n,x) {I i=0,_n=(n);for(;i&lt;_n;++i){x;}}
mv(d,s,n)I *d,*s;{DO(n,d[i]=s[i]);}
tr(r,d)I *d;{I z=1;DO(r,z=z*d[i]);R z;}

  </code></pre>
  <hr />
  <pre><code>
regex precursor to sed-like substitution (coffeescript)

# s/&lt;query&gt;/&lt;replacement&gt;/&lt;flags&gt;
#
# &lt;user1&gt; you're a luser
# &lt;user2&gt; user1: s/luser/winnar/

@pattern = /^(?:([^\s]+)?(?:: ))?s\/([^\/\\]*(?:\\.[^\/\\]*)*)\/([^\/\\]*(?:\\.[^\/\\]*)*)(?:\/(.*))?/
...
target = msg.match[1]
query = msg.match[2].replace /\\\//g, '/'
replace = msg.match[3].replace /\\\//g, '/'
flags = msg.match[4]
  </code></pre>
  <hr />
  <pre><code>
get struct's base address from a member name (C)
linux kernel 2.4.24: include/linux/list.h

/**
 * list_entry - get the struct for this entry
 * @ptr:        the &amp;struct list_head pointer.
 * @type:        the type of the struct this is embedded in.
 * @member:        the name of the list_struct within the struct.
 */
#define list_entry(ptr, type, member) \
        ((type *)((char *)(ptr)-(unsigned long)(&amp;((type *)0)-&gt;member)))
  </code></pre>
  <hr />
  <pre><code>
write to open file requiring root permissions (vim)
http://vim.wikia.com/wiki/Su-write

:w !sudo tee %

to be prudent:
:w !sudo tee % &gt; /dev/null

vimscript binding to :W in the .vimrc:
command W w !sudo tee % &gt; /dev/null
  </code></pre>
  <hr />
  <pre><code>
get nth return value (Go)
https://groups.google.com/d/msg/golang-nuts/x1LbsfR9eJ8/hEYvPaI3Yn4J

Tim Schaeffer   
5/11/11

You could also be more abstract and create some higher-order functions.
This solves the problem more generally:


func make_nth (n int) (func(a... interface{}) interface{}) {
         return func(args... interface{}) interface{}{
                 return args[n]
         }
}

var first = make_nth(0)
var second = make_nth(1)
var third = make_nth(2)
// etc.

var dir string = first(path.Split(os.Args[0])).(string)

  </code></pre>
