---
title: Adding Basic Auth to Django
tags: python, django
description: How to add Basic Auth to a Django app.
---

I was writing a Django application for a project and needed to protect it from
the general public. An amazingly simple library called
[wsgi_basic_auth](https://pypi.python.org/pypi/wsgi-basic-auth/) made this
easy.

Added to my `requirements.txt`:

```bash
wsgi_basic_auth==1.1.*
```

Appended to my `app/wsgi.py`:

```python
# Tack on HTTP Basic Auth
# Configured with env variables:
#   WSGI_AUTH_CREDENTIALS=user:password
#   WSGI_AUTH_EXCLUDE_PATHS=/not/protected
#   WSGI_AUTH_PATHS=/protected
from wsgi_basic_auth import BasicAuth
application = BasicAuth(application)
```

Some pre-deploy checks:

- Ensure HTTPS
- Configure health checks appropriately
