Function annotations were introduced to Python 3 in [PEP-3107](http://www.python.org/dev/peps/pep-3107/). These allow you to specify an expression to be evaluated while a function's header is read for the first time. Many people like to use this notation to conveniently denote return type:

	def sum(a, b) -> types.IntType:
    	return a + b
    
It can be seen that the `sum()` function returns an `IntType`. However, this is an injustice to the function parameters as they are not offered the same clarity. It's argued that this same annotation should be extended for parameter expressions too:

	def sum(a -> types.IntType, b -> types.IntType) -> types.IntType:
    	return a + b

Even better if all the argument types were _strictly enforced_ as well. Unfortunately, this is not the case.

However, the function annotation operator `->` can be combined with Python 3's beautiful `lambda` expressions to create some _very_ semantically pleasing code with advanced debugging functionality.

For example, suppose it is required to see `sum()`'s most recent parameter values and result. Using these tools, those previous values can be easily served over HTTP on port 9000 in tabulated form, as seen below.

	
	#!/usr/bin/python3
    import socket
    from threading import Thread
    from itertools import count
    
    PORT = 9000

    def sum(a, b) -> (lambda port: Thread(target=lambda cnt=count(0), s=socket.socket(socket.AF_INET, socket.SOCK_STREAM): s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) == None and s.bind(('', port)) == None and s.listen(5) == None and list(map(lambda i, d='<!doctype html/>\n<head>\n<title>sum values</title>\n<style>\ntable {border-collapse:collapse;}\ntable, td, th {border:1px solid black; padding: 3px;}\n</style>\n</head>\n<body>\n<table>\n<tr><th>Key</th><th>Value (sum.__dict__[Key])</th></tr>' + '\n'.join(list(map(lambda at: '<tr><td>' + at + '</td><td>' + str(sum.__dict__[at]) + '</td></tr>', sum.__dict__.keys()))) + '</table>\n</body>\n</html>', c=s.accept(): len(c[0].recv(512)) > 0 and c[0].sendall(b'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: ' + bytes(str(len(d)).encode('utf-8')) + b'\r\n\r\n' + bytes(d.encode('utf-8')) + b'\r\n\r\n') == None and print("sent."), cnt))).start())(PORT):
        setattr(sum, 'last_a', a)
        setattr(sum, 'last_b', b)
        setattr(sum, 'last_sum', a + b)
        return a + b

    sum(5, 6)

    while True:
        pass

Now that's Agile!
