
## Spring AOP Overview
Most of the enterprise applications have some common crosscutting concerns that is applicable for different types of Objects and modules. Some of the common crosscutting concerns are logging, transaction management, data validation etc. In Object Oriented Programming, modularity of application is achieved by Classes whereas in Aspect Oriented Programming application modularity is achieved by Aspects and they are configured to cut across different classes.

Spring AOP takes out the direct dependency of crosscutting tasks from classes that we can’t achieve through normal object oriented programming model. For example, we can have a separate class for logging but again the functional classes will have to call these methods to achieve logging across the application.

## Aspect Oriented Programming Core Concepts
Before we dive into implementation of Spring AOP implementation, we should understand the core concepts of AOP.

- Aspect: An aspect is a class that implements enterprise application concerns that cut across multiple classes, such as transaction management. Aspects can be a normal class configured through Spring XML configuration or we can use Spring AspectJ integration to define a class as Aspect using @Aspect annotation.
- Join Point: A join point is the specific point in the application such as method execution, exception handling, changing object variable values etc. In Spring AOP a join points is always the execution of a method.
- Advice: Advices are actions taken for a particular join point. In terms of programming, they are methods that gets executed when a certain join point with matching pointcut is reached in the application. You can think of Advices as Struts2 interceptors or Servlet Filters.
- Pointcut: Pointcut are expressions that is matched with join points to determine whether advice needs to be executed or not. Pointcut uses different kinds of expressions that are matched with the join points and Spring framework uses the AspectJ pointcut expression language.
- Target Object: They are the object on which advices are applied. Spring AOP is implemented using runtime proxies so this object is always a proxied object. What is means is that a subclass is created at runtime where the target method is overridden and advices are included based on their configuration.
- AOP proxy: Spring AOP implementation uses JDK dynamic proxy to create the Proxy classes with target classes and advice invocations, these are called AOP proxy classes. We can also use CGLIB proxy by adding it as the dependency in the Spring AOP project.
- Weaving: It is the process of linking aspects with other objects to create the advised proxy objects. This can be done at compile time, load time or at runtime. Spring AOP performs weaving at the runtime.

##AOP Advice Types

Based on the execution strategy of advices, they are of following types.

- Before Advice: These advices runs before the execution of join point methods. We can use @Before annotation to mark an advice type as Before advice.
- After (finally) Advice: An advice that gets executed after the join point method finishes executing, whether normally or by throwing an exception. We can create after advice using @After annotation.
- After Returning Advice: Sometimes we want advice methods to execute only if the join point method executes normally. We can use @AfterReturning annotation to mark a method as after returning advice.
- After Throwing Advice: This advice gets executed only when join point method throws exception, we can use it to rollback the transaction declaratively. We use @AfterThrowing annotation for this type of advice.
- Around Advice: This is the most important and powerful advice. This advice surrounds the join point method and we can also choose whether to execute the join point method or not. We can write advice code that gets executed before and after the execution of the join point method. It is the responsibility of around advice to invoke the join point method and return values if the method is returning something. We use @Around annotation to create around advice methods.

The points mentioned above may sound confusing but when we will look at the implementation of Spring AOP, things will be more clear. Let’s start creating a simple Spring project with AOP implementations. Spring provides support for using AspectJ annotations to create aspects and we will be using that for simplicity. All the above AOP annotations are defined in org.aspectj.lang.annotation package.


# SPring AOP


## 一、Spring AOP框架
　　AOP(Aspect Orient Programming)，其实也就是面向切面编程。面向对象编程(OOP)是从静态角度考虑程序结构。面向切面编程(AOP)是从动态角度考虑程序运行过程。

　　根据个人的理解，AOP执行图大致如下：

![](https://images0.cnblogs.com/blog/121024/201310/03205813-b0fcbc75034b4f04bd889369d82b32de.png)

## 二、Spring AOP相关概念
　　1. 切面(Aspect)：业务流程运行的某个特定步骤，也就是应用运行过程中的关注点，关注点可以横切多个对象，也称为横切关注点。如示例中的AspectService。

　　2. 连接点(Joinpoint)：是切面类和业务类的连接点。

　　3. 通知(Advice)：在切面类中，声明对业务方法执行额外增强处理。

　　　　3.1 前置通知(Before Advice)：切入前执行

　　　　3.2 后置通知(After Advice)：切入后执行【不管程序在运行过程中是否发生异常】

　　　　3.3 返回后通知(AfterReturning Advice)：切入后执行【程序成功运行后】

　　　　3.4 环绕通知(Around Advice)：近似等于Before Advice与AfterReturning Advice总和，Around Advice 既可在执行目标方法之前，也可在执行目标方法后，既然如此的不确定为什么不用Before Advice + After Advice代替呢？个人觉得还是省着点用吧

　　　　3.5 异常通知(AfterThrowing Advice)：在切入点发生异常时执行　　　　

　　4. 切入点(Pointcut)：可以插入增强处理的连接点，说白了就是当基本个连接点符合要求时，这个连接点就会添加额外增强处理，这个点也就成了切入点了。

　　5. 目标(Target)：被代理的对象。

## 三、Spring AOP示例【以日志管理为例】
　　1. 切面定义

```java
package com.swyma.spring.service;

import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Service;

import com.swyma.spring.core.DateUtils;

/**
 * AOP切面
 * @author yemaoan
 *
 */
@Aspect
@Service
public class AspectService {

    Log log = LogFactory.getLog(AspectService.class);
    
    @Pointcut("execution(* *.create(..))")
    public void createPointCut() {
        
    }
    
    @Around(value = "createPointCut()")
    public void weaveCreatePointCut(JoinPoint join) {
        Object obj = join.getTarget().getClass().getSimpleName();
        log.info("用户 " + "  " +" 在 " + DateUtils.getDate2String(new Date(),"yyyy-MM-dd HH:mm:ss") + " 调用了 " + obj + " 并执行了 create 操作");
    }
    
    @Pointcut("execution(* *.modify(..))")
    public void modifyPointCut() {
        
    }
    
    @After(value = "modifyPointCut()")
    public void weaveModifyPointCut(JoinPoint join) {
        log.info("用户 " + "  " +" 在 " + DateUtils.getDate2String(new Date(),"yyyy-MM-dd HH:mm:ss") + " 执行了 modify 操作");
    }
    
    @Pointcut("execution(* *.delete(..))")
    public void deletePointCut() {
        
    }

    @After(value = "deletePointCut()")
    public void weaveDeletePointCut(JoinPoint join) {
        log.info("用户 " + "  " +" 在 " + DateUtils.getDate2String(new Date(),"yyyy-MM-dd HH:mm:ss") + " 执行了 delete 操作");
    }
}
```
##　　2. 目标【target】

###　　　　2.1 UserService【用户服务】

```java
package com.swyma.spring.service;

import org.springframework.stereotype.Service;

import com.swyma.spring.entity.User;

@Service
public class UserService extends BasicService {

    
    public void create(User user) {
        
    }
    
    public void modify(User user) {
        
    }
    
    public void delete(User user) {
        
    }
    
}
```
##　　　　2.2 RegisteService【注册服务】

```java
package com.swyma.spring.service;

import org.springframework.stereotype.Service;

@Service
public class RegisterService extends BasicService {

    public void create() {
        
    }
    
}
```
#　　3. 测试类

```java
package com.swyma.spring.test;

import org.junit.Test;

import com.swyma.spring.core.ISpringContext;
import com.swyma.spring.entity.User;
import com.swyma.spring.service.BasicSpringContext;
import com.swyma.spring.service.LoginService;
import com.swyma.spring.service.RegisterService;
import com.swyma.spring.service.UserService;


/**
 * JUintTest
 * @author yemaoan
 *
 */
public class TestSpringEnv {

    @Test
    public void testLookup() {
        ISpringContext context = new BasicSpringContext();
        LoginService loginService = context.lookup(LoginService.class);
        loginService.handle();
    }
    
    @Test
    public void testAspect() {
        ISpringContext context = new BasicSpringContext();
        UserService userService = context.lookup(UserService.class);
        RegisterService registerService = context.lookup(RegisterService.class);
        userService.create(new User());
        registerService.create();
    }
    
}
```
#　　4. 运行结果【cosole】

21:26:30,741  INFO com.swyma.spring.service.AspectService:35 - 用户    在 2013-10-03 21:26:30 调用了 UserService 并执行了 create 操作

21:26:30,742  INFO com.swyma.spring.service.AspectService:35 - 用户    在 2013-10-03 21:26:30 调用了 RegisterService 并执行了 create 操作
