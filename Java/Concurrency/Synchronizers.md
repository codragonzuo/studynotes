
- Countdown Latches 倒计时锁
- Cyclic Barriers 循环屏障
- Exchangers
- Semaphones
- Phasers

CountdownLatches会让一个或多个线程处于等待,直到其它线程为它开户“门”;也就是说有空闲的线程出现才行。关键还是在于这些其它的线程会一直执行下去。

CountdownLatches是有一个计数器,它会让线程处于等待状态直到计算达到‘0’,而这个计数是在递减的。  

