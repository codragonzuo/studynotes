


## Servlet Architecture



Servlet

Servlets read the explicit data sent by the clients (browsers). This includes an HTML form on a Web page or it could also come from an applet or a custom HTTP client program.  
Read the implicit HTTP request data sent by the clients (browsers). This includes cookies, media types and compression schemes the browser understands, and so forth.  
Process the data and generate the results. This process may require talking to a database, executing an RMI or CORBA call, invoking a Web service, or computing the response directly.  
Send the explicit data (i.e., the document) to the clients (browsers). This document can be sent in a variety of formats, including text (HTML or XML), binary (GIF images), Excel, etc.  
Send the implicit HTTP response to the clients (browsers). This includes telling the browsers or other clients what type of document is being returned (e.g., HTML), setting cookies and caching parameters, and other such tasks.  



![](http://1.bp.blogspot.com/-6msCbYSaQpc/VILmrSILAdI/AAAAAAAAAAs/c6Rt5rglUYI/s1600/Servlet.jpg)
 
Servlet API:
```
Servelt API contains three packages 

javax.servlet: Package contains a number of classes and interfaces that describe the contract 
between a servlet class and the runtime environment provided for an instance of such a class a
conforming servelt container.
javax.servlet.aanotation: Package contains a number of annotations that allow users to use
annotations to declare servlets , filters, listeners and specify the metadata for the declared component
javax.servlet.http: Package contains a number of classes and interfaces that describe and define the contract between a servlet class rnning under the HTTP protocal and the runtime environment provided for an instance of such class by a confirming servlet container.
Interfaces present in javax.servlet:
AsyncContext
AsyncListener
Filter
FilterChain
FilterConfig
RequestDispatcher
Servlet
ServletConfig
ServletContext
ServletContextAttributeListener
ServletContextListener
ServletRequest
ServletRequestAttributeListener
ServletRequestListener
ServletResponse
SingleThreadModel
Classes present in javax.servlet:
AsyncEvent
ServletInputStream
ServletOutputStream
GenericServlet
ServletContextEvent
ServletContextAttributeEvent
ServletRequestAttributeEvent
ServeltRequestEvent
ServletRequestWrapper
ServeletResponseWrapper
SessionCookieConfig
Exceptions:
ServletException
UnavilableException
 Interfaces present in javax.servlet.http:  
HttpServletRequest 
HttpServletResponse
HttpSession
HttpSessionBindingListener
HttpSessionContext
HttpSessionListener
HttpSessionActivationListener
HttpSessionAttributeListener

 
Classes present in javax.servlet.http:
Cookie
HttpServlet
HttpServletRequestWrapper
HttpServletResponseWrapper
HttpSessionBindingEvent
HttpSessionEvent
HttpUtils
Annotation types declared in javax.servlet.annotation package
InitParam
ServletFilter
WebServlet
WebservletContextListener
```

![](http://3.bp.blogspot.com/-u0kCh2SOXAc/VIL4PA04XKI/AAAAAAAAABQ/uGvFhBHsu4s/s1600/Servlet1.jpg)

### ServletContextEvent and ServletContextListener in Servlet
ServletContextEvent class gives notifications about changes to the servlet context of a web application. ServletContextListener receives the notifications about changes to the servlet context and perform some action. ServletContextListener is used to perform important task at the time when context is initialized and destroyed. In short, ServletContextEvent and ServletContextListener works in pair, whenever Servlet COntext changes, ServletContextEvent publishes a notification which is received by ServletContextListener and then, based on that certain tasks are performed by it.

## Advantages of Servlet

![](https://static.javatpoint.com/images/servlet.JPG)

There are many advantages of Servlet over CGI. The web container creates threads for handling the multiple requests to the Servlet. Threads have many benefits over the Processes such as they share a common memory area, lightweight, cost of communication between the threads are low. The advantages of Servlet are as follows:

- Better performance: because it creates a thread for each request, not process.
- Portability: because it uses Java language.
- Robust: JVM manages Servlets, so we don't need to worry about the memory leak, garbage collection, etc.
- Secure: because it uses java language.

