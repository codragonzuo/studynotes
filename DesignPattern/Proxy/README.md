# Proxy Pattern

Proxy Pattern provides the control for accessing the original object.

## Scenario
 - Virtual Proxy
 - Protective Proxy
 - Remote Proxy
 - Smart Proxy

---

![](https://www.javatpoint.com/images/designpattern/proxyuml.jpg)

![](https://www.tutorialspoint.com/design_pattern/images/proxy_pattern_uml_diagram.jpg)


---

## 动态代理

动态代理：在程序运行时，运用反射机制动态创建而成。

![](https://images-techhive-com.cdn.ampproject.org/ii/w1000/s/images.techhive.com/images/idge/imported/article/jvw/2000/11/jw-1110-proxy-100157716-orig.gif)

动态代理模式中的代理类是由工具类或工厂类动态生成的，而不是由程序员手工定义的。代理关系是在程序运行过使用过程中确立的。


使用动态代理模式的目的是：在不修改目标类的前提下，增强目标对象。


```java
package proxy;
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
public class JdkProxyDemo {
    interface If {
        void originalMethod(String s);
    }
    static class Original implements If {
        public void originalMethod(String s) {
            System.out.println(s);
        }
    }
    static class Handler implements InvocationHandler {
        private final If original;
        public Handler(If original) {
            this.original = original;
        }
        public Object invoke(Object proxy, Method method, Object[] args)
                throws IllegalAccessException, IllegalArgumentException,
                InvocationTargetException {
            System.out.println("BEFORE");
            method.invoke(original, args);
            System.out.println("AFTER");
            return null;
        }
    }
    public static void main(String[] args){
        Original original = new Original();
        Handler handler = new Handler(original);
        If f = (If) Proxy.newProxyInstance(If.class.getClassLoader(),
                new Class[] { If.class },
                handler);
        f.originalMethod("Hallo");
    }
}
```
