# Docker Container for linkable Postgres in Wildfly.
Wildfly Docker container. Linkable to the postgres container.

## How to use
To use this container just run:

``` 
docker run --link postgres-container:postgres --name <name> mheider/wildfly-postgres
```

### With own .war file
To run the container with own war file just create a ```Dockerfile``` with following content:

```
FROM mheider/wildfly-postgres
ADD myapplication.war /opt/jboss/wildfly/standalone/deplyments/myapplication.war
```

After that build the image:

```
docker build --tag myapplication .
```

and run it afterwards:

```
docker run -it --link postgres-container:postgres --name myapplication myapplication
```


##LICENSE
The MIT License (MIT)

Copyright (c) 2015 BinDoc UG (haftungsbeschränkt)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


