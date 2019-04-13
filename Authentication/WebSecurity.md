
HTTP访问控制（CORS）

#Cross-Origin Resource Sharing (CORS)

跨域资源共享(CORS) 是一种机制，它使用额外的 HTTP 头来告诉浏览器  让运行在一个 origin (domain) 上的Web应用被准许访问来自不同源服务器上的指定的资源。当一个资源从与该资源本身所在的服务器不同的域、协议或端口请求一个资源时，资源会发起一个跨域 HTTP 请求。

出于安全原因，浏览器限制从脚本内发起的跨源HTTP请求。 例如，XMLHttpRequest和Fetch API遵循同源策略。 这意味着使用这些API的Web应用程序只能从加载应用程序的同一个域请求HTTP资源，除非响应报文包含了正确CORS响应头。

跨域资源共享（ CORS ）机制允许 Web 应用服务器进行跨域访问控制，从而使跨域数据传输得以安全进行。现代浏览器支持在 API 容器中（例如 XMLHttpRequest 或 Fetch ）使用 CORS，以降低跨域 HTTP 请求所带来的风险。

Cross-Origin Resource Sharing (CORS)

#Content Security Policy (CSP)

网站的安全模式源于同源政策。 来自 https://mybank.com 的代码应仅能访问 https://mybank.com 的数据，而绝不被允许访问 https://evil.example.com。每个源均与其余网络保持隔离，从而为开发者提供一个可进行构建和操作的安全沙盒。在理论上，这非常棒。而在实践中，攻击者已找到聪明的方式来破坏系统。

例如，跨网站脚本 (XSS)攻击可通过欺骗网站提供恶意代码和计划好的内容来绕过同源政策。这是个大问题，因为浏览器将网页上显示的所有代码视为该网页安全源的合法部分。XSS 备忘单是一种旧的但具有代表性的跨会话方法，攻击者可通过该方法注入恶意代码来违背信任。 如果攻击者成功地注入任意代码，则系统很可能受到了攻击：用户会话数据泄露，应保密的信息被透露给坏人。很显然，可能的话，我们想阻止这种情况发生。

本概览重点介绍一个可显著降低现代浏览器中 XSS 攻击的风险和影响的防护功能： 内容安全性政策 (CSP)。

CSP tries to prevent this from happening by limiting:

what can be opened in an iframe
what stylesheets can be loaded
where requests can be made, etc.
So how does it work?

When you click on a link or type a website URL in the address bar of your browser, your browser makes a GET request. It eventually makes its way to a server which serves up HTML along with some HTTP headers. If you’re curious about what headers you receive, open up the Network tab in your console, and visit some websites.

You might see a response header that looks like this:

content-security-policy: default-src * data: blob:;script-src *.facebook.com *.fbcdn.net *.facebook.net *.google-analytics.com *.virtualearth.net *.google.com 127.0.0.1:* *.spotilocal.com:* 'unsafe-inline' 'unsafe-eval' *.atlassolutions.com blob: data: 'self';style-src data: blob: 'unsafe-inline' *;connect-src *.facebook.com facebook.com *.fbcdn.net *.facebook.net *.spotilocal.com:* wss://*.facebook.com:* https://fb.scanandcleanlocal.com:* *.atlassolutions.com attachment.fbsbx.com ws://localhost:* blob: *.cdninstagram.com 'self' chrome-extension://boadgeojelhgndaghljhdicfkmllpafd
chrome-extension://dliochdbjfkdbacpmhlcpmleaejidimm;

# https

# HTTP Strict-Transport-Security (HSTS)
This one is pretty straightforward. Let’s use Facebook’s header as an example again:

strict-transport-security: max-age=15552000; preload

max-age specifies how long a browser should remember to force the user to access a website using HTTPS.

preload is not important for our purposes. It is a service hosted by Google and not part of the HSTS specification.



