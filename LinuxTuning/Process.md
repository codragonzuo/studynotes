
# 父进程和子进程

## fork 和 vfork

调用 fork 时，系统将创建一个与当前进程相同的新进程。通常将原有的进程称为父进程，把新创建的进程称为子进程。

子进程是父进程的一个拷贝，子进程获得同父进程相同的数据，但是同父进程使用不同的数据段和堆栈段。

子进程从父进程继承大多数的属性，但是也修改一些属性.

下表对比了父子进程间的属性差异：

|:-|:-|
|继承属性	|差异|
|uid,gid,euid,egid	进程 ID|
|进程组 ID	父进程 ID|
|SESSION ID	子进程运行时间记录|
|所打开文件及文件的偏移量	父进程对文件的锁定|
|控制终端	 ||
|设置用户 ID 和 设置组 ID 标记位	 ||
|根目录与当前目录	 ||
|文件默认创建的权限掩码	 ||
|可访问的内存区段	 ||
|环境变量及其它资源分配||	 

```C
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    pid_t pid;
    char *message;
    int n;
    pid = fork();
    if(pid < 0)
    {
        perror("fork failed");
        exit(1);
    }
    if(pid == 0)
    {
        printf("This is the child process. My PID is: %d. My PPID is: %d.\n", getpid(), getppid());
    }
    else
    {
        printf("This is the parent process. My PID is %d.\n", getpid());
    }
    return 0;
}
```

把上面的代码保存到文件 forkdemo.c 文件中，并执行下面的命令编译：

$ gcc forkdemo.c -o forkdemo

然后运行编译出来的 forkdemo 程序：

$ ./forkdemo

fork 函数的特点是 "调用一次，返回两次"：

在父进程中调用一次，在父进程和子进程中各返回一次。

在父进程中返回时的返回值为子进程的 PID，而在子进程中返回时的返回值为 0，并且返回后都将执行 fork 函数调用之后的语句。

如果 fork 函数调用失败，则返回值为 -1。

我们细想会发现，fork 函数的返回值设计还是很高明的。在子进程中 fork 函数返回 0，那么子进程仍然可以调用 getpid 函数得到自己的 PID，也可以调用 getppid 函数得到父进程 PID。在父进程中用 getpid 函数可以得到自己的 PID，如果想得到子进程的PID，唯一的办法就是把 fork 函数的返回值记录下来。

注意：执行 forkdemo 程序时的输出是会发生变化的，可能先打印父进程的信息，也可能先打印子进程的信息。

## vfork 系统调用
vfork 系统调用和 fork 系统调用的功能基本相同。vfork 系统调用创建的进程共享其父进程的内存地址空间，但是并不完全复制父进程的数据段，
而是和父进程共享其数据段。为了防止父进程重写子进程需要的数据，父进程会被 vfork 调用阻塞，直到子进程退出或执行一个新的程序。

**由于调用 vfork 函数时父进程被挂起**，所以如果我们使用 vfork 函数替换 forkdemo 中的 fork 函数，那么执行程序时输出信息的顺序就不会变化了。

使用 vfork 创建的子进程一般会通过 exec 族函数执行新的程序。接下来让我们先了解下 exec 族函数。

## exec 族函数

使用 fork/vfork 创建子进程后执行的是和父进程相同的程序（但有可能执行不同的代码分支），子进程往往需要调用一个 exec 族函数以执行另外一个程序。当进程调用 exec 族函数时，该进程的用户空间代码和数据完全被新程序替换，从新程序的起始处开始执行。调用 exec 族函数并不创建新进程，所以调用 exec 族函数前后该进程的 PID 并不改变。

exec 族函数一共有六个：

```
#include <unistd.h>
int execl(const char *path, const char *arg, ...);
int execlp(const char *file, const char *arg, ...);
int execle(const char *path, const char *arg, ..., char *const envp[]);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
int execve(const char *path, char *const argv[], char *const envp[]);
```

https://www.cnblogs.com/sparkdev/p/8214455.html

exec 族函数的特征：调用 exec 族函数会把新的程序装载到当前进程中。在调用过 exec 族函数后，进程中执行的代码就与之前完全不同了，所以 exec 函数调用之后的代码是不会被执行的。

## 在子进程中执行任务

下面让我们通过 vfork 和 execve 函数实现在子进程中执行 ls 命令：

```
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
int main(void)
{
    pid_t pid;
    if((pid=vfork()) < 0)
    {
        printf("vfork error!\n");
        exit(1);
    }
    else if(pid==0)
    {
        printf("Child process PID: %d.\n", getpid());
        char *argv[ ]={"ls", "-al", "/home", NULL};  
        char *envp[ ]={"PATH=/bin", NULL};
        if(execve("/bin/ls", argv, envp) < 0)
        {
            printf("subprocess error");
            exit(1);
        }
        // 子进程要么从 ls 命令中退出，要么从上面的 exit(1) 语句退出
        // 所以代码的执行路径永远也走不到这里，下面的 printf 语句不会被执行
        printf("You should never see this message.");
    }
    else
    {
        printf("Parent process PID: %d.\n", getpid());
        sleep(1);
    }
    return 0;
}
```
把上面的代码保存到文件 subprocessdemo.c 文件中，并执行下面的命令编译：

$ gcc subprocessdemo.c -o subprocessdemo
然后运行编译出来的 subprocessdemo程序：

$ ./subprocessdemo
