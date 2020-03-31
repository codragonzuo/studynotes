

## 动态令牌-(OTP,HOTP,TOTP)-基本原理

OTP 是 One-Time Password的简写，表示一次性密码。

HOTP 是HMAC-based One-Time Password的简写，表示基于HMAC算法加密的一次性密码。

是事件同步，通过某一特定的事件次序及相同的种子值作为输入，通过HASH算法运算出一致的密码。

TOTP 是Time-based One-Time Password的简写，表示基于时间戳算法的一次性密码。 

是时间同步，基于客户端的动态口令和动态口令验证服务器的时间比对，一般每60秒产生一个新口令，要求客户端和服务器能够十分精确的保持正确的时钟，客户端和服务端基于时间计算的动态口令才能一致。　　

原理介绍  
OTP基本原理  
计算OTP串的公式  

OTP(K,C) = Truncate(HMAC-SHA-1(K,C))

其中，

K表示秘钥串；

C是一个数字，表示随机数；

HMAC-SHA-1表示使用SHA-1做HMAC；

Truncate是一个函数，就是怎么截取加密后的串，并取加密后串的哪些字段组成一个数字。

对HMAC-SHA-1方式加密来说，Truncate实现如下。

HMAC-SHA-1加密后的长度得到一个20字节的密串；  
取这个20字节的密串的最后一个字节，取这字节的低4位，作为截取加密串的下标偏移量；  
按照下标偏移量开始，获取4个字节，按照大端方式组成一个整数；  
截取这个整数的后6位或者8位转成字符串返回。  
```Java
public static String generateOTP(String K,
                                    String C,
                                    String returnDigits,
                                    String crypto){
      int codeDigits = Integer.decode(returnDigits).intValue();
      String result = null;

      // K是密码
      // C是产生的随机数
      // crypto是加密算法 HMAC-SHA-1
      byte[] hash = hmac_sha(crypto, K, C);
      // hash为20字节的字符串

      // put selected bytes into result int
      // 获取hash最后一个字节的低4位，作为选择结果的开始下标偏移
      int offset = hash[hash.length - 1] & 0xf;

      // 获取4个字节组成一个整数，其中第一个字节最高位为符号位，不获取，使用0x7f
      int binary =
              ((hash[offset] & 0x7f) << 24) |
              ((hash[offset + 1] & 0xff) << 16) |
              ((hash[offset + 2] & 0xff) << 8) |
              (hash[offset + 3] & 0xff);
      // 获取这个整数的后6位（可以根据需要取后8位）
      int otp = binary % 1000000;
      // 将数字转成字符串，不够6位前面补0
      result = Integer.toString(otp);
      while (result.length() < codeDigits) {
          result = "0" + result;
      }
      return result;
}
```

 

HOTP基本原理

知道了OTP的基本原理，HOTP只是将其中的参数C变成了随机数

公式修改一下

HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))

HOTP： Generates the OTP for the given count

即：C作为一个参数，获取动态密码。

HOTP的python代码片段：
```
class HOTP(OTP):
    def at(self, count):
        """
        Generates the OTP for the given count
        @param [Integer] count counter
        @returns [Integer] OTP
        """
        return self.generate_otp(count)
```
一般规定HOTP的散列函数使用SHA2，即：基于SHA-256 or SHA-512 [SHA2] 的散列函数做事件同步验证；

TOTP基本原理

TOTP只是将其中的参数C变成了由时间戳产生的数字。

TOTP(K,C) = HOTP(K,C) = Truncate(HMAC-SHA-1(K,C))

不同点是TOTP中的C是时间戳计算得出。

C = (T - T0) / X;

T 表示当前Unix时间戳



T0一般取值为 0.

X 表示时间步数，也就是说多长时间产生一个动态密码，这个时间间隔就是时间步数X，系统默认是30秒；

例如:

T0 = 0;

X = 30;

T = 30 ~ 59, C = 1; 表示30 ~ 59 这30秒内的动态密码一致。

T = 60 ~ 89, C = 2; 表示30 ~ 59 这30秒内的动态密码一致。

不同厂家使用的时间步数不同；

阿里巴巴的身份宝使用的时间步数是60秒；

宁盾令牌使用的时间步数是60秒；

Google的 身份验证器的时间步数是30秒；

腾讯的Token时间步数是60秒；

