


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


## Servlet Architecture: Basics of Servlets

https://beginnersbook.com/2013/05/servlet-architecture/

BY CHAITANYA SINGH | FILED UNDER: JAVA SERVLET TUTORIAL

A Servlet is a class, which implements the javax.servlet.Servlet interface. However instead of directly implementing the javax.servlet.Servlet interface we extend a class that has implemented the interface like javax.servlet.GenericServlet or javax.servlet.http.HttpServlet.


![](https://beginnersbook.com/wp-content/uploads/2013/05/servlet-architecture.png)

servlet-architecture

![](https://beginnersbook.com/wp-content/uploads/2013/05/servlet-architecture-diagram2.png)

Servlet Exceution

This is how a servlet execution takes place when client (browser) makes a request to the webserver.

servlet architecture diagram2


Servlet architecture includes:

a) Servlet Interface

To write a servlet we need to implement Servlet interface. Servlet interface can be implemented directly or indirectly by extending GenericServlet or HttpServlet class.

b) Request handling methods

There are 3 methods defined in Servlet interface: init(), service() and destroy().

The first time a servlet is invoked, the init method is called. It is called only once during the lifetime of a servlet. So, we can put all your initialization code here.

The Service method is used for handling the client request. As the client request reaches to the container it creates a thread of the servlet object, and request and response object are also created. These request and response object are then passed as parameter to the service method, which then process the client request. The service method in turn calls the doGet or doPost methods (if the user has extended the class from HttpServlet ).

c) Number of instances

Basic Structure of a Servlet
```JAVA
public class firstServlet extends HttpServlet {
   public void init() {
      /* Put your initialization code in this method, 
       * as this method is called only once */
   }
   public void service() {
      // Service request for Servlet
   }
   public void destroy() {
      // For taking the servlet out of service, this method is called only once
   }
}
```

#### How servlet works?

![](https://beginnersbook.com/wp-content/uploads/2013/05/How_Servlet_Works.jpg)

Generic Servlet

As I mentioned above, if you are creating a Generic Servlet then you must extend javax.servlet.GenericServlet class. GenericServlet class has an abstract service() method. Which means the subclass of GenericServlet should always override the service() method.

Signature of service() method:
```
public abstract void service(ServletRequest request, ServletResponse response)
         throws ServletException, java.io.IOException
```
The service() method accepts two arguments ServletRequest object and ServletResponse object. The request object tells the servlet about the request made by client while the response object is used to return a response back to the client.

![](https://beginnersbook.com/wp-content/uploads/2013/05/Generic_Servlet.jpg)

###  HTTP Servlet

If you creating Http Servlet you must extend javax.servlet.http.HttpServlet class, which is an abstract class. Unlike Generic Servlet, the HTTP Servlet doesn’t override the service() method. Instead it overrides one or more of the following methods. It must override at least one method from the list below:

doGet() – This method is called by servlet service method to handle the HTTP GET request from client. The Get method is used for getting information from the server

doPost() – Used for posting information to the Server

doPut() – This method is similar to doPost method but unlike doPost method where we send information to the server, this method sends file to the server, this is similar to the FTP operation from client to server

doDelete() – allows a client to delete a document, webpage or information from the server

init() and destroy() – Used for managing resources that are held for the life of the servlet

getServletInfo() – Returns information about the servlet, such as author, version, and copyright.

In Http Servlet there is no need to override the service() method as this method dispatches the Http Requests to the correct method handler, for example if it receives HTTP GET Request it dispatches the request to the doGet() method.

![](https://beginnersbook.com/wp-content/uploads/2013/05/Http_Servlet.jpg)

