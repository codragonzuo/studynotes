





#一、Spring AOP框架
　　AOP(Aspect Orient Programming)，其实也就是面向切面编程。面向对象编程(OOP)是从静态角度考虑程序结构。面向切面编程(AOP)是从动态角度考虑程序运行过程。

　　根据个人的理解，AOP执行图大致如下：

![](https://images0.cnblogs.com/blog/121024/201310/03205813-b0fcbc75034b4f04bd889369d82b32de.png)

#二、Spring AOP相关概念
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

#三、Spring AOP示例【以日志管理为例】
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

```
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

```
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
