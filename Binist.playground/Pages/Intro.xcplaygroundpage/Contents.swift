//: [Previous](@previous)

/*:
# Introduction
## Our Computer is basically a computing Machine
### Referring to [Wikipedia](https://en.wikipedia.org/wiki/Computer)
 
 ### A computer is a machine that can be instructed to carry out sequences of arithmetic or logical operations automatically via computer programming.
 Computer is a digital ones that can only understand 0 and 1 (off and on), thus computer need to represent everything in 0/1, so called binary
 
 To understand the binary digit we need to look at this number which only contain 0 and 1 :
 # 1    1   0   1   1   0   0
 
 This may look unfamiliar at the first sight, but lets we see what its actually means:
 #   1           1           0         1            1          0             0
 ## 1x2^6      1x2^5     0x2^4     1x2^3     1x2^2     0x2^1        0x2^0
 ## 64            32           16             8              4              2                  1
 
 If we sum those together 64 + 32 + 8 + 4 = 108
 So those number basically mean 108 for our computer, it doesn,t actually hard isn,t it?
  So that is the meaning of those binary number on our everyday Decimal number
 Thus we can say that 1101100 (2) = 108 (10)
  Which read 1101100 in Binary (Base 2) equal to 108 in Decimal (Base 10)
 */

/*:
 That is how we can translate binary number into decimal number, but how about vice versa:
 Assume we have the same number 108, but now we want to convert it into binary. This is how its done:
 ## 108 : 2 = 54 Remainder := 0  (Even number divided by 2 has 0 remainder)
 ## 54 : 2 = 27 Remainder := 0 (Even number divided by 2 has 0 remainder)
 ## 27 : 2 = 13 Remaider := 1 (Odd Number divided by 2 has 1 remainder)
 ## 13 : 2 = 6 Remainder := 1 (Odd Number divided by 2 has 1 remainder)
 ## 6 : 2 = 3 Remainder := 0 (Even Number divided by 2 has 0 remainder)
 ## 3 : 2 = 1 Remainder := 1 (Odd Number divided by 2 has 1 remainder)
 ## 1 : 2 = 0 Remainder := 1 (Odd Number divided by 2 has 1 remainder)
 
 
  The process is stop when we reach 0, now lets write  from bottom to top we will get the digit itself in binary (from the remainder) = 1101100
 
 */

//: [Next](@next)
