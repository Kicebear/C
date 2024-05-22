;1题*************************
;汇编可以输出字母数字不能输入汉字
;把bx中的数据以16进制数的形式显示在屏幕上
;解题思路,数字0-‘0’差30h
;字符a-'a'差37h 当a>9时,转a+7h+30h
;2型中断输出单个字符
datas segment
		
datas ends

codes segment
	assume ds:datas,cs:codes
start:	mov ax,datas
	mov ds,ax
		
	mov bx,12abh
	mov cx,4
begin:
	rol bx,1
	rol bx,1
	rol bx,1
	rol bx,1
	mov dx,bx
	and dx,000fh;高12位清零
	cmp dl,9
	jna next;不大于(小于等于)
	add dl,07;dl>7吗
next :
	add dl,30h;
	;调用中断
	mov ah,2;2型中段显示一个字符,1型中断输入一个字符
	;9型中断输出一串字符串,A型中断输入一串字符
	int 21h
	loop begin	
	
	mov ah,4ch
	int 21h
codes ends
	end start
-------------------------------------------
buf db 12h,34h,56h,78h,90h(无符号)
方法1求max,改变al值 使用一个寄存器,适合单一求max和min
mov cx,4
	lea si,buf
	mov al,[si]
lop1:
	inc si
	cmp al,[si]
	jb l1;al<[si]
	jmp l2
l1:
	mov al,[si];al放max
l2:	
	loop lop1
	
方法2求max,不改变al,值使用二个寄存器,适合多处理求max和min
mov cx,5
	lea si,buf
	mov bl,[si]
lop1:
	mov al,[si]
	cmp al,bl
	ja l1;al>bl
	jmp l2
l1: mov bl,al
l2: inc si
	loop lop1

------------------------------>
;16进制转10进制
data segment
   d1 db 00h
   d2 db 00h
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	
	mov ah,1
	int 21h
	mov d1,al
	cmp al,40h
	jb l1
	sub al,31h
	jmp l2
l1: sub al,30h
l2: mov bl,al
    mov d2,al
    and al,0f0h
    mov cl,4
    shr al,cl
    add al,30h
    mov dl,al
    mov ah,2
    int 21h
    and bl,0fh
    add bl,30h
    mov dl,bl
    mov ah,2
    int 21h
	mov ah,4ch
	int 21h
code ends
	end start
------------------------->
;16进制转10进制
data segment
   d1 db 00h
   d2 db 00h
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	
	mov ah,01h
	int 21h
	cmp al,'9'
	jb l1;直接输出
	sub al,31h
	jmp l2
	;0-9直接输出
l1: mov dl,al
	mov ah,02h
	int 21h
	jmp stop
l2: 
    mov bl,al
    mov cl,al;al赋值给两个变量稳定
    rol bl,1
    rol bl,1
    rol bl,1
    rol bl,1
	and bl,0fh
	add bl,30h
	mov dl,bl
	mov ah,02h
	int 21h
	and cl,0fh
	add cl,30h
	mov dl,cl
	mov ah,02h
	int 21h

stop:
	mov ah,4ch
	int 21h
code ends
	end start
-------------------------------------------------->
;16进制转2进制******************极为重要
DATA SEGMENT
        DATA_0X DW 8888H              ;测试的十六进制数
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX
        MOV BX,DATA_0X               ;把测试值放入BX寄存器
        MOV CX,16                    ;四个十六进制转为16为二进制数利用移位指令需要进行16次循环
LY:
        ROL BX,1
		MOV DL,0					;初始化DL为零
        ADC DL,30H                  ;加上rol移出的cf位
        MOV AH,02H
        INT 21H
        LOOP LY

OVER:
        MOV AH,4CH
        INT 21H
CODE ENDS
        END START
		
--自编
;16进制转2进制
DATA SEGMENT
        DATA_0X dw 0ffffH         ;测试的十六进制数
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX
        MOV BX,DATA_0X        ;把测试值放入BX寄存器
        MOV CX,16                ;四个十六进制转为16为二进制数利用移位指令需要进行16次循环
	
		xor ax,ax
		
lop1:	rol bx,1
		test bx,0001h
		jz l1;d0=0,zf=1
		mov al,1
		jmp l2
l1:		mov al,0	 
		jmp l2
l2:		add al,30h
		mov dl,al
		mov ah,02h
		int 21h
		loop lop1
		
        MOV AH,4CH
        INT 21H
CODE ENDS
        END START
-------------------------------------------------->
;2题
;将无符号的最大值比较并且输出到屏幕上采用02h
DATAS SEGMENT
    ;此处输入数据段代码 
	buf db 12h,38h;无符号
	max db ?
	;min db '123$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx  
    mov cx,4;
    
    ;比较buf单元大小
    lea si,buf
    mov al,[si]
    inc si;
    cmp al,[si]
    jb l1;al<[si]
   	jmp exit;
l1: mov al,[si]
   
exit:mov max,al;
	 
	 ;屏幕输出max
	 mov bl,max;	 
begin:
	rol bx,1
	rol bx,1
	rol bx,1
	rol bx,1
	mov dx,bx
	and dx,000fh;高12位清零
	cmp dl,9
	jna next;不大于(小于等于)
	add dl,07;dl>7吗
next :
	add dl,30h;
	;调用中断
	mov ah,2;2型中段显示一个字符,1型中断输入一个字符
	;9型中断输出一串字符串,A型中断输入一串字符
	int 21h
	loop begin	
	 	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;3题(无法用“sdjoais”这种格式)
;一个长度100的字符str,统计字符串的字符A的个数,并按照16进制
;的形式显示出来bl转16进制
datas segment

	buf	db 41h,41h,41h,41h,41h,41h,41h
	db 90 dup(61h);
datas ends

codes segment
	assume ds:datas,cs:codes
start:
	mov ax,datas
	mov ds,ax
	
	mov bl,0;dl做计数器
	mov si,offset buf;去偏移地址
	mov al,'A'
	mov cx,100;
BBB:;等于‘A’计数
	cmp al,[si]
	jnz next;不等于跳
	inc bl;等于a的个数
next:
	inc si
	loop BBB;

;显示bl中的16进制值
	mov dl,bl
	shr dl,1
	shr dl,1
	shr dl,1
	shr dl,1
	cmp dl,9;
	jna CCC;不大于9直接加30h
	add dl,07;大于9加7加30H
CCC:
	add dl,30h;转ascll
	mov ah,02h
	int 21h
	
	mov dl,bl
	and dl,0fh
	
	cmp dl,9
	jna DDD
	add al,07h
DDD:
	add dl,30h
	mov ah,02h
	int 21h

	mov ah,4ch
	int 21h
codes ends
	end start
-------------------------------------------------->
;4题
;11个数求max和min 无符号
datas segment
 buf db 1,2,3,4,5,6,7,8,9,10,11
 max db ?
 min db ?
datas ends

codes segment
	assume ds:datas,cs:codes
start:
	mov ax,datas
	mov ds,ax
	
	xor ax,ax
	xor bx,bx
	;求max
	mov cx,10;11个数
	lea si,buf
	mov al,[si]	
w:	inc si
	cmp al,[si]
	ja l1;ax>[si]
    mov al,[si]
l1:	
	loop w;
	mov bl,al;
	mov max,bl
	
	;求min
	mov cx,10;11个数
	lea si,buf
	mov al,[si]	
x:	inc si
	cmp al,[si]
	jb l2;ax<[si]
    mov al,[si]
l2:	;求max
	loop x;
	mov min,al
	
	mov ah,4ch
	int 21h
codes ends
	end start
-------------------------------------------------->
;5题
;两个数比较屏幕显示n>m和m<n
DATAS SEGMENT
    ;此处输入数据段代码 
    m db 36h
    n db 95h 
    y db 'm>n$'
    no db 'n>m$' 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
   	mov al,m
   	mov bl,n
   	cmp al,bl
   	ja l1
   	jb l2
   	jmp exit
l2:
   	;lea si,no
   	;mov dx,[si]
   	mov dx,offset no
   	mov ah,09h
   	int 21h
   	jmp exit
l1:	
	mov dx,offset y
	mov dx,[si]
	mov ah,09h
	int 21h
	jmp exit
exit:
	 MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;6题
;两个数比较屏幕显示n>m和m<n
DATAS SEGMENT
    ;此处输入数据段代码 
     buf db 1,2,3,4,5,6,7,8,9,10
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov cx,9
    
    xor ax,ax
    xor bx,bx
    lea si,buf
	mov al,[si]
L1:	inc si
    mov bl,[si]
    add al,bl
    loop L1

	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;7题
;5个无符号数比大小,求max
DATAS SEGMENT
    ;此处输入数据段代码 
     buf db 2,5,3,4,96
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov cx,4
    
    xor ax,ax
    xor bx,bx
    xor dx,dx
    lea bx,buf
    mov al,[bx]
w:  inc bx;地址加转向buf+1的内容
    ;inc buf  ;buf首单元内容加一
	mov dl,[bx]
	cmp al,dl
	ja l1;al大于dl
	mov al,[bx]
	
l1: loop w	
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;8题
;buf1带符号字节数据x
;buf2带符号字节数据y
;z=|x-y|,z送入result单元 ;自编 
DATAS SEGMENT
    ;此处输入数据段代码 
     buf1 db 'x'
     buf2 db 'y'
     result db 'please input $'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  
  	xor ax,ax
  	xor bx,bx
  	xor cx,cx
  	
    mov al,buf1
    mov bl,buf2
    cmp al,bl
    jg l1;al>bl
    xchg al,bl  
l1: sub al,bl
    mov result,al
	
exit:	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;9题
;1+...+N<100时把n送num单元,同时把1+...n的和送sum单元
DATAS SEGMENT
    ;此处输入数据段代码 
     num db ?
     sum db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  
  	xor ax,ax
  	xor bx,bx
  	xor cx,cx
  	
  	mov al,0;
  	mov bl,0;
l1:	inc bl;
  	add al,bl
  	cmp al,100
  	jb l1
  	sub al,bl
  	dec bl
  	
l2: 
	mov num,bl
	mov sum,al    
	
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;自编1+...+N<100时把n送num单元,
;同时把1+...n的和送sum单元自编
DATAS SEGMENT
    ;此处输入数据段代码 
     num db ?
     sum db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  
  	xor ax,ax
  	xor bx,bx
  	xor cx,cx
  	
  	mov al,0;
  	mov bl,0;
l1:	inc bl;
  	add al,bl
  	cmp al,100
  	jg l2
  	jmp l1
  	
l2: 
	sub al,bl
	sub bl,1
	mov num,bl
	mov sum,al    
	
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->     
;10题
;有符号x<0 2x;0<=x<=10 3x,x>10 4x;自编
DATAS SEGMENT
    ;此处输入数据段代码 
     x db -2
     sum db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  	
  	xor ax,ax
  	xor bx,bx
  	xor cx,cx
  	mov al,x
  	cmp al,0
  	jl L1;al<0
  	jge l2;al>=0
l1: 
	sal al,1
	jmp exit;  	
l2: 
	cmp al,10
	jg l3;al>10
	mov bl,al;0=<al<=10
	sal al,1
	add al,bl
	jmp exit
	
l3: mov cl,2
	sal al,cl
	   
exit:MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------->
;11题
;从键盘输入小写字母,转换成大写字母在屏幕上显示
;1号功能输入,单个字符显示02h无符号数
DATAS SEGMENT
    ;此处输入数据段代码 
     buf db 'please input again$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  	
  	xor ax,ax
  	xor bx,bx
  	;mov bx,offset buf;
  	;调用1号功能
    mov ah,01h;01号的地址在al
    int 21h
    ;小写转大写
    cmp al,'a'
    jb exit
    cmp al,'z'
    ja exit
    sub al,20h
exit:
	mov dl,al
	mov ah,2
	int 21h
	
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START

-------------------------------------------------->
;12题
;对满足条件的数据计数答案
;有数据块buf存放100名学生的成绩,满分100,低分0
;统计低于60和不低于90的学生个数
DATAS SEGMENT
    ;此处输入数据段代码 
     buf db 10 dup(?)
     good db ?
     fail db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  	
  	xor ax,ax
  	xor bx,bx
  	mov bl,0;优秀
  	mov bh,0;不及格
  	mov si,offset buf
  	mov cx,10
  	
lop1:mov al,[si]
  	cmp al,90
  	jb BBB;小于90转
  	inc bl
  	jmp next;优秀的一定不是最差的
BBB:
	cmp al,60
	jnb next
	inc bh
next:
	inc si
	loop lop1
  	
  	mov good,bl
  	mov fail,bh

	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;对满足条件的数据计数自编
;有数据块buf存放100名学生的成绩,满分100,低分0
;统计低于60和不低于90的学生个数
DATAS SEGMENT
    ;此处输入数据段代码 
     buf db 68,90,91,93,95,12,10,15
     ;buf db 3
     good db ?
     fail db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  	
  	mov ax,0
  	mov bx,0
  	mov cl,8
	lea si,buf
lop1: 
	mov al,[si]
  	cmp al,90
  	jb l1;al<=90
  	add bh,1;al>90 好的加1
l1: cmp al,60
	jb l2;
	jmp l3;
l2: add bl,1;差的加1
	jmp l3
l3: 
	inc si
	loop lop1
  	
exit:MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------------------------------》
;13题
;＃结束,小写转大写,不是小写显示错误提示自编
DATAS SEGMENT
    ;此处输入数据段代码 
    string db 'PLEASE INPUT AGAIN',0dh,0ah,'$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;清0
  	xor ax,ax
  	xor bx,bx
  	xor cx,cx
  	;输入
lop:mov ah,01h
  	int 21h
  	cmp al,'#'
  	jz exit
  	jmp l1;不是#跳l1
l1: cmp al,'a'
	jae l2;al>a
	mov dx,offset string
	mov ah,09h
	int 21h;输出错误提示
	jmp lop
l2: cmp al,'z'
	jbe l3;a<al<z 
	mov dx,offset string;否则错误提示
	mov ah,09h
	int 21h;输出错误提示
	jmp lop
	
l3: sub al,20h
	mov dl,al
	mov ah,02h
	int 21h
exit:MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------》
;14题
;统计16进制的2进制1的个数,结果放到count输出到屏幕上
DATAS SEGMENT
   num dw 8a88h
   count db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov ax,num
    mov cx,16
    mov bl,0
lop1:
	rcl ax,1
	jnc next
	inc bl
next: 
	loop lop1
	mov count,bl
	mov dl,bl
	or dl,30h(有误,答案不标准)
	mov ah,2
	int 21h
		
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;自编
;统计16进制的2进制1的个数(无符号数)
DATAS SEGMENT
   num dw 0abbbh
   count db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx   
    
    mov ax,num
    mov cx,16
    mov bl,0
    
   	;进行比较
l2:	rcl ax,1;判断cf的标志位
   	jnc l1;cf=0转l1
   	inc bl
l1: loop l2
	
	mov count,bl
	cmp bl,9
	jbe l3;al<=9
	add bl,07h
l3: add bl,30h 
   
	mov dl,bl
	mov ah,02h
	int 21h
	 	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------》
;15题可以跳过
;双字节取绝对值
;最高位是0,不进行任何操作
;最高位是1,输出符号
DATAS SEGMENT
	word1 dw 9123h
	word2 dw 0a234h
	abs1 dw ?
	abs2 dw ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
	mov ax,word1;取32位进制数给寄存器
	mov dx,word2;一般取dx为高16位数据寄存器
	or dx,dx;置标志位,无需做任何运算判断sf的情况
	jns next;sf=0 直接给abs
			;sf=1,按位取反+1	
	not ax	;dx,ax取反
	not dx ;
	add ax,1;ax+1可能会有进位
	adc dx,0; ax有进位,拆封，dx+0+1
			; ax无进位,cf=0 dx+0+0
next:
	mov abs1,ax
	mov abs2,dx
		
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------》
;16题(15题的翻版)
;有符号字取绝对值,结果放abs1
;最高位是0,不进行任何操作
;最高位是1,输出符号
DATAS SEGMENT
	word1 dw 7123h
	abs1 dw ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    xor ax,ax
    xor bx,bx
    xor cx,cx
    
    mov ax,word1
    test ax,8000h;检测D11位，为0转l1
    jz l1;正数D0=0,zf=1
    and ax,7fffh
l1:mov abs1,ax ;放到abs1
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------------------》
;17题s=(x^2+y^2)/z的值放到result单元
DATAS SEGMENT
	x db 2
	y db 4
	z db 2
	result dw ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  	xor ax,ax
  	xor bx,bx
  	
  	mov al,x
  	imul al
  	mov bl,y
  	imul bl
  	add al,bl
  	mov bh,z
  	div bh
  	mov result,ax
  	
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START


DATA SEGMENT

INFO DB 12H,00H,92H,01H,0H,0H,45H,0A5H,0FEH,0DAH

DATA ENDS
------------------------------------------------->
;t18判断5个有符号数,整数输出1,负数输出-1,  0输出0
DATA SEGMENT
    buf db 91h,00h,50h,90h,0a8h
    zheng db '1',0dh,0ah,'$'
    fu db '-1',0dh,0ah,'$'
    zero db '0',0dh,0ah,'$'
DATA ENDS

STACK SEGMENT
    
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov cx,5
	
	lea si,buf
lop1:
	mov al,[si]
	cmp al,0
	jnz l2;al!=0
	mov bx,offset zero
	jmp exit
l2: 
	test al,80h
	jz l3;D7为0,跳正
	mov bx,offset fu
	jmp exit;
l3: 
	mov bx,offset zheng

exit:
	
	mov dx,bx
	mov ah,09h
	int 21h 
	
	inc si
	loop lop1
	
 	MOV AH,4CH
    INT 21H
    
CODE ENDS
    END START
;答案
DATA SEGMENT
	INFO DB 12H,00H,92H,01H,0H,0H,45H,0A5H,0FEH,0DAH
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
 
	MOV CX,0AH
	LEA BX,INFO
	DEC BX
	MOV AH,02H
SIGN:
	INC BX
	TEST BYTE PTR [BX],0FFH
	JZ ZERO_NUM
	TEST BYTE PTR [BX],80H
	JZ PLUS_NUM
	JMP NEG_NUM

NEXT:
	MOV DL,0dH
	INT 21H
	MOV DL,0aH
	INT 21H
	LOOP SIGN
 	MOV AH,4CH
	INT 21H

ZERO_NUM:
	MOV DL,30H
	INT 21H
	JMP NEXT

PLUS_NUM:
	MOV DL,31H
	INT 21H
	JMP NEXT

NEG_NUM:
	MOV DL,'-'
	INT 21H
	MOV DL,31H
	INT 21H
	JMP NEXT

CODE ENDS

	END START
------------------------------------------------->
;关于0dh和0ah的换行使用测试
DATA SEGMENT
	buf db 'Hello world!',0dh,0ah,'$';0dh,0ah是回车换行,组合使用
	buf2 db 'and you?$'
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
 	
 	mov cx,2
 	mov si,offset buf
 	mov ax,si
	mov dx,ax
 	mov ah,09h
 	int 21h
 	
 	mov si,offset buf2
 	mov ax,si
	mov dx,ax
 	mov ah,09h
 	int 21h

	MOV AH,4CH
	INT 21H
CODE ENDS
	END START
------------------------------------------------->
;t19统计2000H开始的正负个数
DATA SEGMENT
    buf db 3,5,7,-4,-2
    zheng db ?
    fu db ?
    org 2000h
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
START:
    MOV AX,DATA
    MOV DS,AX
	
	xor ax,ax
	xor bx,bx;+
	xor cx,cx
	xor dx,dx;-
	mov cx,5;循环次数
	
	lea si,buf
lop1:mov al,[si]
	cmp al,0
	jg l1;al>0
	jl l2;al<0
	jmp l3;al=0
l1: inc bl
	jmp l3	
l2: inc dl
	jmp l3
l3: 
	inc si
	loop lop1 
	mov zheng,bl
	mov fu,dl
	
	;输出
	mov al,zheng
	add al,30h
	mov dl,al
	mov ah,02h
	int 21h
	;换行👇👇👇👇
	mov dl,0ah;0dh回车,0ah换行
	int 21h
	;👆👆👆👆👆👆
	mov bl,fu
	add bl,30h
	mov dl,bl
	mov ah,02h
	int 21h
	
 	MOV AH,4CH
    INT 21H
    
CODE ENDS
    END START
-----------
DATA SEGMENT
	ORG 2000H
	INFO DB 1,2,3,4,5,70H,71H,72H,80H,92H
	N_NUMS DB 00H
	P_NUMS DB 00H

DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
 
	MOV CX,10
	MOV BX,2000H
	DEC BX
SIGN:
	INC BX
	TEST BYTE PTR [BX],80H
	JNZ NEG_NUM
	INC P_NUMS
NEXT:
	LOOP SIGN
	MOV DL,P_NUMS
	ADD DL,30H
	MOV AH,02H
	INT 21H
	MOV DL,0AH
	INT 21H
	MOV DL,N_NUMS
	ADD DL,30H
	INT 21H
	MOV	AH,4CH
	INT 21H
NEG_NUM:
	INC N_NUMS
	JMP NEXT
CODE ENDS
	END START
--------------------------》
;t20求1000H单元开始的10个无符号字节数的最大值
DATA SEGMENT
  	org 1000h
  	buf db 1,2,3,4,5,70h,71h,72h,80h,92h
  	;结果放在bx中就不用中断输出了
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA
START:
    MOV AX,DATA
    MOV DS,AX
	
	mov cx,10;循环10次
	lea si,buf
	mov al,[si]
lop1:
	inc si
	cmp al,[si]
	ja l1;al>[si]
	mov al,[si];al<[si]进行赋值
l1: loop lop1;	
	xor bx,bx
	mov bl,al
	
 	MOV AH,4CH
    INT 21H
    
CODE ENDS
    END STAR
------------------------------------->
;t21输出字符
DATA SEGMENT 
	 buf db 'Hello,Welcome come to HuiBianWorld!$'
DATA ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
	
	mov dx,offset buf
	mov ah,09h
	int 21h
	
	MOV AH,4CH
	INT 21H	

CODE ENDS
	END START
-------------------------------------》
;t22 10个数求max;条件:有符号数,结果放DL寄存器
DATA SEGMENT
	;条件
        buf DB 61H,66H,56H,69H,0FFH,0EFH,66H,88H,86H,0F5H
        max DB 00H                                          ;测试的十六进制数
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX
        mov cx,10
        mov ah,0
        
        lea si,buf
        mov al,[si]
lop1:   inc si
        cmp al,[si]
		jg l1;ax>[si]
		mov al,[si]
l1:		loop lop1
		mov max,al
		mov dl,max

        MOV AH,4CH
        INT 21H
CODE ENDS
        END START
----------------------------------》
;t23小写字母转大写
DATA SEGMENT
	;条件
    error db 'error!',0dh,0ah,'$'                                           
DATA ENDS

CODE SEGMENT
        ASSUME CS:CODE,DS:DATA
START:
        MOV AX,DATA
        MOV DS,AX
       	
lop1:  	mov ah,01h
       	int 21h
       	cmp al,'a'
       	jae l1;al>='a'
       	jmp l2;不成立
l2:		mov si, offset error
		mov dx,si
		mov ah,09h
		int 21h
		jmp lop1
l1:		cmp al,'z'
		ja l2;条件不成立
		sub al,20h
		mov dl,al
		mov ah,02h
		int 21h       
        
       
        MOV AH,4CH
        INT 21H
CODE ENDS
        END START

--------------------------------------
;t24 1-100的和
DATA SEGMENT
	TS DB 0
	HD DB 0
	TE DB 0
	BI DB 0
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX

	MOV CX,100
	MOV AX,0
SIGN:
	MOV BX,CX
	TEST BX,01H
	JZ ADD_SUM
NEXT:
	LOOP SIGN
	MOV TS,AH
	AND TS,0F0H
	MOV HD,AH
	AND HD,0FH
	MOV TE,AL
	AND TE,0F0H
	MOV BI,AL
	AND BI,0FH
	MOV DL,TS
	CMP DL,09H
	JA BIG_TS
	ADD DL,30H
SHOW_TS:
	MOV AH,02H
	INT 21H
	MOV DL,HD
	CMP DL,09H
	JA BIG_HD
	ADD DL,30H
	SHOW_HD:
	MOV AH,02H
	INT 21H
	MOV DL,TE
	CMP DL,09H
	JA BIG_TE
	ADD DL,30H
SHOW_TE:
	MOV AH,02H
	INT 21H
	MOV DL,BI
	CMP DL,09H
	JA BIG_BT
	ADD DL,30H
SHOW_BT:
	MOV AH,02H
	INT 21H
	MOV	AH,4CH
	INT 21H
ADD_SUM:
	ADD AX,WORD PTR BX
	JMP NEXT
BIG_TS:
	MOV CL,4
	SHR DL,CL
	SUB DL,0AH
	ADD	DL,41H
	JMP SHOW_TS
BIG_HD:
	MOV CL,4
	SHR DL,CL
	SUB DL,0AH
	ADD DL,41H
	JMP SHOW_HD
BIG_TE:
	MOV CL,4
	SHR DL,CL
	SUB DL,0AH
	ADD DL,41H
	JMP SHOW_TE
BIG_BT:
	MOV CL,4
	SHR DL,CL
	SUB DL,0AH
	ADD DL,41H
	JMP SHOW_BT
CODE ENDS
	END START
;自编 dl为本身
DATA SEGMENT
	
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:
	MOV AX,DATA
	MOV DS,AX
	
	mov ax,0
	mov bx,0
	mov cx,100
	mov dx,0;存放最终结果
lop1:
	inc ax
	add bx,ax
	loop lop1;结果在bx中	
	;输出
	xor ax,ax
	xor dx,dx
	mov cx,4
l2:	rol bx,1
	rol bx,1
	rol bx,1
	rol bx,1
	mov dx,bx
	and dx,000fh
	cmp dl,9
	jna l1
	add dl,7
l1: add dl,30h
	mov ah,02h
	int 21h
	loop l2
	
	
	MOV AH,4CH
	INT 21H
CODE ENDS
	END START
--------------------------->
;t25***************************
;汇编编程,键盘输入字符串,,并逆序输出,
;解题思路利用ax压栈,pop弹到dx寄存器上，dx输出显示地址
;sg 输入abcD123 输出321Dcba
data segment
  crlf db 0dh,0ah,'$'
data ends

code segment
  assume cs:code,ds:data
start:
  mov ax,data
  mov ds,ax
  ;---------------
  mov cx,0
input:        ;输入板块
  mov ah,01h
  int 21h     ;输入一个字符
  cmp al,0dh
  jz output   ;回车后直接输出结果
  push ax     ;压首地址
  inc cx
  jmp input   ;循环输入
	
 ;以下6段无实际意义可省略
  mov dl,0dh  ;回车 
  mov ah,02h  
  int 21h  
  mov dl,0ah  ;换行
  mov ah,02h  
  int 21h    
 ;👆👆👆👆👆👆👆👆👆👆👆👆
output:		  
  pop dx      ;弹首地址给输出的dx寄存器
  mov ah,02h  ;输出一个字符
  int 21h
  loop output ;循环输出

  mov ax,4c00h
  int 21h

code ends
  end start
-------根据t25,修改条件  
;小写转大写,输入字符串,逆序输出
DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    mov cx,0
    ;输入
input:
    mov ah,01h
    int 21h
    ;输入的字符判别
    jmp panbie    
result:
    cmp al,0dh
    jz outo        ;等于换行时转到输出
    push ax
    inc cx
    jmp input
    
panbie:
	cmp al,'a'
	jge l1          ;al>a,满足条件1
	jmp result      ;其他回主程序接着输入
l1: cmp al,'z'
	jg result       ;al>z 不满足条件接着输入
	sub al,20h
	jmp result      ;满足条件转输入       
    ;输出
outo:
    pop dx
    mov ah,02h
    int 21h
    loop outo
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------panbie的第二种方法
panbie:	;中转站
	cmp al,'a'
	jb lop2     ;al<a不满足条件
	cmp al,'z'
	ja lop2     ;al>z不满足条件
	sub al,20h  ;转大写
	jmp lop2    ;跳到lop2进行接下来的操作
-----答案
DATAS SEGMENT
BUF DB 100 DUP ( 0 ) ;输入缓冲区
COUNT DW 0           ;字符串输入次数 
DATAS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    MOV SI,OFFSET BUF ;SI指向BUF
LOP0:    
    MOV AH,1
    INT 21H           ;单字符输入
    ;返回值在AL中
    CMP AL,'$'        ;比较是不是结束 
    JZ  NEXT          ;如果是结束跳NEXT
    ;不是'$' 那存起来
    MOV [SI],AL
    INC WORD PTR COUNT;计数器自增1
    INC SI ;指向下一个存储单元
    JMP LOP0 
NEXT:
             ;输入的字符小写转大写
    MOV CX,COUNT      ;有COUNT个字符
    LEA SI,BUF
LOP1:    
    MOV AL,[SI]       ;取数
    CMP AL,'a'       
    JB  ZZZ           ;小于小写字母a就不是小写字母 
    CMP AL,'z'
    JA  ZZZ           ;大于小写字母z就不是小写字母 
    SUB BYTE PTR [SI],20H ;小写转大写
ZZZ:
    INC SI
    LOOP LOP1
    
    ;显示一个空格
    MOV DL,' '
    MOV AH,2
    INT 21H
    
    LEA SI,BUF       ;SI指向BUF单元
    ADD SI,COUNT     
    DEC SI           ;修正SI到队尾
    
    MOV CX,COUNT     ;输出COUNT次
LOP2:    
    MOV DL,[SI]     ;2号功能输出
    MOV AH,2
    INT 21H
    DEC SI
    LOOP LOP2          

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START


--------------------------->
;t26 分段条件大于0输出1,等于0输出0,小于0输出-1
DATAS SEGMENT
    ;此处输入数据段代码  
    x db -9
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov al,x
    cmp al,0
    jg L1;大于0输出1
    jz L2;等于0输出0
    jl L3;小于0输出-1
    jmp exit
L1: mov bx,01h
	jmp exit
L2: mov bx,00h
	jmp exit
L3: mov bx,-1h
	jmp exit
    ;此处输入代码段代码
exit: 
	MOV AH,4CH
    INT 21H
CODES ENDS
    END START
---------------------------------------》
;t27测试汇编子程序的用法
;子程序下的程序段一般不会执行,除非程序跳转后不经过子程序
;call调用子程序,或者用跳转指令到子程序
DATAS SEGMENT
    ;此处输入数据段代码
    buf db 'code test success!$'
    buf1 db 'code fail$'  
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
   	xor bx,bx
   	mov bx,9
    cmp bx,4
    jg l2
code proc
	lea bx,buf
	mov dx,bx
	mov ah,09h
	int 21h
	ret 
code endp
l2: 
 	lea bx,buf1;
 	mov dx,bx
 	mov ah,09h;
 	int 21h
 	call code
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
---------------------------------------》
;t28求1-100的奇数和 答案09c4H
DATA SEGMENT
	SUM DW ?
DATA ENDS
CODE SEGMENT
	ASSUME DS:DATA,CS:CODE
START: MOV AX,DATA
	MOV DS,AX
	MOV AX,0
	MOV DX,1
	MOV CX,50
	LP1:ADD AX,DX
	INC DX      ;调整 DX 的值
	INC DX
	LOOP LP1
EXIT:
	 MOV SUM,AX ;将结果存入 SUM 单元
	MOV AH, 4CH
	INT 21H     ;正常返回 DOS
CODE ENDS
	END START
-----屏幕输出1-100的奇数和
DATA SEGMENT
	SUM DW ?
DATA ENDS
CODE SEGMENT
	ASSUME DS:DATA,CS:CODE
START: 
	MOV AX,DATA
	MOV DS,AX
	
	xor ax,ax
	xor dx,dx
	mov dx,0    ;dx当计数器
	mov ax,1;
l1:	cmp ax,100;
	jb s1       ;ax<100循环
	jmp exit   ;ax>=100退循环
s1:
	add dx,ax
	add ax,2;
	jmp l1
	mov sum,dx  ;程序完成
	;屏幕输出程序
exit:
	mov bx,dx   ;bx存放结果
	mov ax,0    ;ax寄存器
	xor dx,dx   ;dx清零
	mov cx,4
lop1:
	rol bx,1
	rol bx,1
	rol bx,1
	rol bx,1
	mov ax,bx
	and ax,000fh
	cmp al,9
	jna l2;al<=9
	add al,07h
l2:	add al,30h
	mov dl,al
	mov ah,02h
	int 21h
	loop lop1
	
	MOV AH, 4CH
	INT 21H     ;正常返回 DOS
CODE ENDS
	END START
---------------------------------------》
;t30    解题思路 |A|= ~A+1
;要求ax,bx放32位有符号的二进制数，绝对值送cx,dx中
;ax:bx=>cx:dx
DATAS SEGMENT
    ;此处输入数据段代码 
    
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    mov ax,9234h
    mov bx,6789h
    mov cx,ax;
    mov dx,bx;
    test cx,8000h
    jz l1;zf=1,d7位=0,为正
  	not dx
	not cx
	add dx,1
	adc cx,0
l1:  	
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
----------------------------------->
;t31统计buf缓冲区10个字数据中0的个数，结果放dl寄存器中
DATAS SEGMENT(字数据一般比较的不准)
    ;此处输入数据段代码 4个0
  	buf dw 1,3,0,2,0,3,5,8,0,0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov cx,10
    mov dl,0
    lea bx,buf
L:  mov ax,[bx]
	cmp ax,0
	jnz M
	inc dl
M:  inc bx
	loop L
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------------->
t32;y=(x+10)*w+50,带符号数据
DATAS SEGMENT
    ;此处输入数据段代码 10个数 3个0
  	x db 23
  	w db 89
  	y db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
   	mov al,x
   	mov bl,w
   	add al,10
   	imul bl
   	add ax,50
   	mov y,al
   	
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
---------------------------------------->
t33;代码段实现将buf的$符转化为空格的功能
  	;暂时代码区
   	;将内存缓冲区buf中的'$'用空格20h代替
   	mov cx,100
   	lea si,buf
lop1:
   	mov al,[si]
   	cmp al,'$'
   	jz l1;ax=$
	jmp lop1
l1: mov al,' '
	mov [si],al;!!!切记不要忘记把al赋值给[si]
lop1:
	inc si
	loop lop1
------------------------------------------》
t34
;统计1的个数,并显示在屏幕上 x 字节
DATAS SEGMENT
    ;此处输入数据段代码 10个数 4个0
  	x db 12h,34h,67h,01h,27h,01h,78h,01h,23h,01h
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
   	;暂时代码区
   	;将内存缓冲区buf中的'$'用空格20h代替
   	mov cx,10
   	mov bx,0
   	lea si,x
lop1:
   	mov  al,[si]
   	cmp al,1
   	jnz l1;al!='0'
   	inc bl
l1:	
	inc si
	loop lop1  
	  	
   	;屏幕输出数字
   	mov cx,4
lop2:
   	rol bx,1
   	rol bx,1
   	rol bx,1
   	rol bx,1
   	mov ax,bx
   	and ax,000fh
   	cmp al,9
   	jna l2;小于等于9转
   	add al,7h
l2: add al,30h
	mov dl,al
	mov ah,02h
	int 21h
	loop lop2
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
----------------------------------------->
t35
;二进制显示输入字符的ascll码
DATAS SEGMENT
   	x db '0$'
   	y db '1$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
   
    mov cx,8
    mov ah,01h	;存放的地址为al
    int 21h 
lop2:
    rol al,1
    test al,01h
    jz l1;zf=1,d0=0
    jmp l2;
l1: lea si,x;输出0
	mov dx,si
	mov ah,09h
	int 21h
	jmp lop1
l2: lea si,y;输出1
	mov dx,si
	mov ah,09h
	int 21h
	jmp lop1
lop1:
	loop lop2 
    ;此处输入代码段代码
	//答案👇
	mov ah,01h
   	int 21h
   	mov bl,al
   	mov cx,8
again:
	shl bl,1;逻辑右移一位,移出为进cf
	mov dl,0
	adc dl,30h;==add dl+0+cf;
	mov ah,2  ;单个字符输出
	int 21h  
	loop again ;循环
	
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------------》
t36
;3个变量值的排序,本题采用无符号数,若是有符号数,将ja改jg即可
DATAS SEGMENT
   	x db 32h
   	y db 84h
   	w db 20h
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
   	
   	mov al,x
   	mov bl,y
   	mov cl,w
l4:
   	cmp al,bl
   	ja l1;al>bl
   	cmp al,cl
   	ja l2;al>cl
   	cmp bl,cl
   	ja l3;bl>cl
   	jmp exit
l1: xchg al,bl
	jmp l4
l2: xchg al,cl
   	jmp l4
l3: xchg bl,cl
	jmp l4   	
    ;此处输入代码段代码
exit:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------->
t37
;编程实现,任意个有符号字节数据之和(和要求用自变量存放)
DATAS SEGMENT
   A db ....;任意个字节数据
   N equ ..;元素个数
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
  
 	lea si,A
 	xor dx,dx
 	mov cx,N
again:
	mov al,[si]
	cbw       ;扩展字易错点
	adc dx,ax;
	loop again
	mov sum,dx
 	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------->
t38
;将数据段堆栈段附加段的内容相加
xseg segment 
	x dw 123h
xseg ends
yseg segment
	y dw 567h
yseg ends
zesg segment stack 'stack'
	z dw 2cah
zesg ends
code segment
	assume cs:code,ds:xseg,es:yseg,ss:zesg
start:
		mov ax,xseg
		mov ds,ax
		mov ax,yseg
		mov es,ax
		mov ax,zesg
		mov ss,ax
		
		mov ax,x
		mov bx,es:y
		add ax,bx
		mov cx,ss:z
		add ax,cx
		
		mov ah,4ch
		int 21h
code ends
	end start
----------答案 
xseg segment
 x dw 123H
xseg ends
yseg segment
 y dw 567h
yseg ends
zseg segment
 z dw 29AH
zseg ends
code segment
 assume cs:code,ds:xseg,es:yseg,ss:zseg
start :
	mov ax,xseg
	mov ds,ax
	mov ax,yseg
	mov es,ax
	mov ax,es:y
	add x,ax
	mov bp,0
	mov ax,[bp+z]
	add x,ax
	mov bx,x
	mov ah,4ch
	int 21h
code ends
	end start
;t39冒泡排序了解即可
DATA SEGMENT
	A DW 1223,83,456,355,89
	    DW 948,5,123,789,567
	CNT EQU ($-A)/2
DATA ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA
START:MOV AX,DATA
	MOV DS,AX
	MOV CX,CNT-1
LOOP1:MOV DX,CX
	MOV SI,0      ;每次排序都是从头开始的
LOOP2:MOV AX,A[SI]       ;比较当前值与其下一个数
	CMP AX,A[SI+2]
	JNA L1        ;小于等于，即这两个数的顺序是递增的则跳转，直接进行后续操作
	XCHG AX,A[SI+2]     ;否则交换两值
	MOV A[SI],AX
L1:ADD SI,2       ;LOOP2内循环中每次SI向后一位
	LOOP LOOP2
	MOV CX,DX      ;实现细节与题目四中相同
	LOOP LOOP1
	MOV AH,4CH
	INT 21H
CODE ENDS
	END START
---------------------------------------》
;t40 原题是100个数可以直接定义100dup(?)
;内存有2个str1和str2,放5个不同的无符号数据
;str1的偏移地址是2500h,str2偏移地址是1400h
;若内容完全相同,bx:0,不同,bx指向第一个不同字节的地址
;内容放al中
DATAS SEGMENT
    ;此处输入数据段代码
    org 2500h
    str1 db 1h,24h,45h,56h,78h
    org 1400h
    str2  db  1h,23h,45h,56h,78h
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
    mov cx,5;
    lea si,str1
    lea di,str2
lop1:
    mov al,[si]
	mov dl,[di]
	cmp al,dl
	jz l1;al=dl
	mov bx,si;
	mov al,[si]
	jmp exit
l1: 
	inc si
	inc di
	loop lop1
	mov bx,0;
    jmp exit    
exit:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
----答案
    ;此处展示关键代码段代码
    lea bx,str1
    lea di,str2
    mov cx,5
lp: 
	mov al,[bx]
	cmp al,[di]
	jnz stop
	inc bx
	inc di
	loop lp
	mov bx,0
stop:    
    MOV AH,4CH
    INT 21H
--------------------------------=》
;t41
;键盘连续输入小写字母用大写字母显示
;小写字母与大写字母之间用'-'分隔开
;输入非小写的字母程序时,停止处理
DATAS SEGMENT
    ;此处输入数据段代码
   	buf db '-$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代码
lop1:
    mov ah,01h
    int 21h
    mov bl,al;
    cmp al,'a'
    jb stop;al<'a'
	cmp al,'z'
	ja stop;al>z	👇👇👇👇👇👇👇👇👇👇👇👇👇👇
	lea si,buf      mov dl,'-'
	mov dx,si <-->  mov ah,02h
	mov ah,09h		int 21h;		
	int 21h
	;输出大写		👆👆👆👆👆👆👆👆👆👆👆👆👆👆
	mov al,bl
	sub al,20h
	mov dl,al
	mov ah,02h
	int 21h;    
    jmp lop1
	;进行换行
	mov dl,0ah
	int 21h
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-----------------------------------
;t42把&用$代替
DATAS SEGMENT
    ;此处输入数据段代码
 	buf db 'I&love&china$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	;设置cx为字符串的长度
	mov cx,12
	lea si,buf
l5:	mov al,[si]
	cmp al,'&'
	jz l1
	jmp l3
l1: 
	mov al,'^'
	jmp l3
l3 :
	mov dl,al
	mov ah,02h
	int 21h
 	inc si
	loop l5
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-----------------------------
;t43
;dat单元数st
DATAS SEGMENT
    ;此处输入数据段代码
 	dat db 'START PROGSST PERSTON$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov cx,21
	mov dx,0
	lea si,dat
lop1:
	mov al,[si]
	cmp al,'S'
	jz l1
	jmp l3
	
l1: inc si
	mov al,[si]
	cmp al,'T'
	jz l2
	dec si
	jmp l3
l2: inc dx
	
l3: inc si
	loop lop1
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------------->
;t44;求dat字符串的长度以*结束,并统计大写字母的个数
DATAS SEGMENT
    ;此处输入数据段代码
 	dat db 'I lOVe ChIna*$';12个数,5大写
DATAS ENDS
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov bx,0;字母
	mov dx,0;所有数
	lea si,dat
l4:
	mov al,[si]
	cmp al,'*'
	jz stop
	cmp al,'A'
	jge l1
	jmp l3
l1: cmp al,'Z'
	jbe l2
	jmp l3
l2: inc bx
	jmp l3

l3: inc dx
	inc si
	jmp l4

stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

------------------------------->
;t45
;求dat指定的字符地址
DATAS SEGMENT
    ;此处输入数据段代码
 	dat db 'abcdefg&'
 	org 1000h
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	lea si,dat
l2:	
	cmp byte ptr[si],'c'
	jz l1;发现直接结束
	cmp byte ptr[si],'&'
	jz stop;
	inc si;
	jmp l2
l1: 
	mov ax,[si]
	jmp stop
	
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-----------------------------》
;46
;分段函数
DATAS SEGMENT
    ;此处输入数据段代码
    buf db 89,90,95,34,56,78,45,23,78,80
    ;4 3 3
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
    ;无符号
    ;1234 5678h*2345 6789h
    ; dx   ax    cx   bx
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov cx,10;循环
	mov bh,0;60下
	mov bl,0;60-80中
	mov dx,0;80上
	lea si,buf
lop1:
	mov al,[si]
	cmp al,60
	jb l1;al<60
	cmp al,80
	ja l2;al>80
	jmp l3;
	
l1: inc bh
	jmp l4
l2: inc dx
	jmp l4
l3: inc bl
	jmp l4
	
l4: inc si
	loop lop1	
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------》
;47;测试length 和sizeof  和type
;结论: length 计算d? 第一个字节
;sizeof 计算所有的字节个数
;type 计算d?占的字节数
DATAS SEGMENT
 	abc dw 2,100 dup(1,2)
    ;此处输入数据段代码 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;abc dw 100 dup(?)
    ;mov ax,type abc;2
   	;mov bx,length abc;100
   	;mov cx,sizeof abc;200
   	
   	;abc dw 100 dup(1,2)
    ;mov ax,type abc;2
   	;mov bx,length abc;100
   	;mov cx,sizeof abc;400
    
    abc dw 2,100 dup(1,2)
    mov ax,type abc;2
   	mov bx,length abc;1
   	mov cx,sizeof abc;402
   	
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
--------------------------》
;48;0500H单元存放100个有符号数,计算正数和负数
DATAS SEGMENT
org 0500h
 	buf dw 1234h,5678h,1234h,8912h,3469h;
    ;此处输入数据段代码 
DATAS ENDS
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov cx,5;
    mov dx,0;zheng
    mov bx,0;fu
    lea si,buf
lop1:
    mov ax,[si]
    cmp ax,0;
    jg l1;ax>0
    jl l2;ax<0
    jz l3;ax=0
l1: inc dx
	jmp l3;
l2: inc bx
	jmp l3;
l3: inc si;
	inc si;
	loop lop1

    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
----------------------------------->
;49键盘输入数字判奇还是偶
DATAS SEGMENT
    ;此处输入数据段代码 
    a db '0$'
    b db '1$'
DATAS ENDS

STACKS SEGMENT

    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
   	;输入
   	mov ah,01h
   	int 21h
   	test al,01h
   	jnz l1;d0=1,zf=0奇
   	jmp l2;
l1: mov dx,offset b;mov dl,'1'
	mov ah,09h     ;mov ah,02h
	int 21h
	jmp stop
l2: mov dx,offset a ;mov dl,'0'
	mov ah,09h      ;mov ah,02h
	int 21h
	jmp stop
    ;此处输入代码段代码
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
--------------------------------------------》
;50;x<0 2x;x>=0&&x<=10(3x);4x(x>10)
;分段函数
DATAS SEGMENT
    ;此处输入数据段代码 
 	x db -1h
 	s db ?
DATAS ENDS
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段代
   	xor bx,bx
   	xor ax,ax
   	xor cx,cx
   	xor dx,dx
   	;判别
   	mov al,x
   	cmp al,0
   	jl l1;al<0
   	cmp al,10
   	jg l2;bl>10
   	jmp l3
   	jmp result;
l1: mov bl,2
	mul bl
	jmp result
l2: mov cl,4
	mul cl
	jmp result;	
l3: mov dl,3
	mul dl
	jmp result;
	
result:
	mov s,al;
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
--------------------------------》
;51检测A的个数
DATAS SEGMENT
    ;此处输入数据段代码 
 	ji db 'AbcdAbcdAbcdAbcdAbcdA$'
 	count db ?
DATAS ENDS
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段
    mov dx,0
    mov ax,0
   	lea si,ji;
lop1:
   	mov al,[si]
   	cmp al,'$'
   	jz stop
   	cmp al,'A'
   	jz l1;al=A跳l1
	jmp l2;其他代办
l1: add dl,1;
	jmp l2;
l2: inc si;
	jmp lop1
	mov count,dl
stop:
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;--------------------------->
;52 1+...+100
DATAS SEGMENT
    ;此处输入数据段代码 
 	sum dw ?
DATAS ENDS
STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS
CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段
    mov ax,0
    mov cx,99
    mov bx,2
    mov ax,1
lop1:
    add ax,bx
    inc bx
    loop lop1
    mov sum,ax
    
    
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

;100-200的奇数求和结果送sum
DATAS SEGMENT
    ;此处输入数据段代码 
 	
DATAS ENDS

STACKS SEGMENT

    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    ;此处输入代码段
   	
   	mov ax,0
   	mov dx,0
   	mov ax,101
lop2:
	add dx,ax
   	add ax,2
   	cmp ax,200
   	jg l1;ax>200
   	;ax<=200;
   	jmp lop2
l1:

    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------------》
;求s =(x^2+y^2)/z
data segment
	s dw ?
	x db 2
	y db 9
	z db 6
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	mov ax,0
	mov bx,0
	mov cx,0
	mov dl,0
    mov al,x
    ;test
    mul al
    mov cx,ax;cx x^2
    mov al,0
    mov al,y
    mul al
    add ax,cx;ax放x^2+y^2
    mov bl,z
    div bl
    mov s,ax

	mov ah,4ch
	int 21h
code ends
	end start
;输入数字出1-5st 其他出*
data segment
	one db 0dh,0ah,'1st$'
	two db 0dh,0ah,'2st$'
	three db 0dh,0ah,'3st$'
	four db 0dh,0ah,'4st$'
	five db 0dh,0ah,'5st$'
	err db 0dh,0ah,'*$'
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	
l0:	mov ah,01h
	int 21h
	cmp al,'1'
	jz l1
	cmp al,'2'
	jz l2
	cmp al,'3'
	jz l3
	cmp al,'4'
	jz l4
	cmp al,'5'
	jz l5
	jmp l6
l1: lea si,one
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
l2: lea si,two
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
l3: lea si,three
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
 l4: lea si,four
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
l5: lea si,five
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
l6: lea si,err
    mov dx,si
    mov ah,09h
    int 21h
    jmp stop
stop:
	mov ah,4ch
	int 21h
code ends
	end start
-------->答案
DATAS SEGMENT
    ;此处输入数据段代码 
    one db 'asd$'
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
   
    mov ah,1
    int 21h
    mov ah,2
    cmp al,'1'
    jb l1
    cmp al,'5'
    ja l1
	;原字符串显示
	mov dl,al
	int 21h
	
    mov dl,'s'
    int 21h
    mov dl,'t'
    int 21h
    jmp l2
l1: mov dl,'*'
    int 21h
l2: mov ah,4ch
   int 21h
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------->
;输入小写字符转大写
data segment
   error db 'please input again',0dh,0ah,'$'
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	
next:
	mov ah,01h
	int 21h
	cmp al,'#'
	je exit
	cmp al,'a'
	jb err
	cmp al,'z'
	ja err
	sub al,20h
	mov dl,al
	mov ah,2
	int 21h
	jmp next
err: lea dx,error
 	mov ah,9
 	int 21h
 	jmp next
exit:
	mov ah,4ch
	int 21h
code ends
	end start
;输入一段字符判断非数字的个数
code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	mov cx,0
	;输入
input:
	mov ah,01h
	int 21h
	jmp panbie
result:
	cmp al,0dh
	jz stop
	jmp input
panbie:
	cmp al,'0'
	jb l1;al<0
	jmp l2;al>0
l2: cmp al,'9'
	ja l1;al>'9'
	jmp result
l1: inc cx
	jmp result
stop:
	dec cx;
	mov dx,cx	
	mov ah,4ch
	int 21h
code ends
	end start
-------------->法2
data segment
  buf db 'asd123asfd$'
data ends

code segment
	assume cs:code,ds:data
start:
	mov ax,data
	mov ds,ax
	mov cx,10
	mov dx,0
	lea si,buf
l3:	mov al,[si]
	cmp al,'0'
	jb l1;al<'0'
	cmp al,'9'
	ja l1;al>'9'
	jmp l2;执行下一步
l1: inc dx
	jmp l2
l2: inc si
	loop l3

	mov ah,4ch
	int 21h
code ends
	end start
;计算被13除尽的数
DATAS SEGMENT
    ;此处输入数据段代码 
    sdata db 13,26,39,20,52
    count db ?
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    ;取数
    mov cx,5
    mov dx,0
    lea si,sdata;
lop1:
	mov ah,0
    mov al,[si]
    ;除法
    mov bl,13
    div bl
    cmp ah,0
    jz l1
    jmp l2
l1: add dx,1
l2: inc si
	loop lop1
	
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
---------->
;计算被13除尽的数 子程序
DATAS SEGMENT
    ;此处输入数据段代码 
    sdata db 13,26,39,20,52
    count db 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
    ;子程序
    
div3 proc 
	mov ah,0
	mov bl,13
	div bl
	or ah,0
	
	ret
div3 endp

START:
    MOV AX,DATAS
    MOV DS,AX
	mov dx,0
	lea si,sdata
	mov cx,5
lp1: 
	mov al,[si]
	call div3
	jnz lp2
	inc dx
lp2:inc si
	loop lp1
    
	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------------------------>
;x和y有一个是奇数,奇数放x中,偶数放y中
;同为偶数,不做处理
;同为奇数,x和y分别加一放回原处
DATAS SEGMENT
    ;此处输入数据段代码 
   x dw 1233
   y dw 1235
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS

START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov ax,x
	mov bx,y
	test ax,0001h
	jz l1;偶
	jmp l2;奇
l1: test bx,0001h
	jz ou;偶
	jmp yi;奇
l2: test bx,0001h
	jz yi;偶
	jmp ji;
	
ou: jmp stop
ji: inc x
	inc y
	jmp stop
yi: test ax,0001h
	jz lop1;ax为偶
	jmp lop2;ax为奇
	lop1:
	mov y,ax
	mov x,bx
	jmp stop
	lop2:
	mov x,ax
	mov y,bx
	jmp stop
		

stop:
	mov cx,x
	mov dx,y
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
------------------------>
;1-200除4余3的数字之和
DATAS SEGMENT
    ;此处输入数据段代码  
    sum dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
    
    mov cx,1
    mov ax,1
    mov dx,0
    mov bl,4
l3:
    cmp ax,200
    jg stop
	div bl
	cmp ah,3
	jz l1
	jmp l2
l1: inc dx;代办
l2:
	add cx,1
	mov ax,cx
	jmp l3	
stop:
	mov sum,dx
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
---------------------------->
;三个数字找几个相同数
DATAS SEGMENT
    ;此处输入数据段代码  
    var db 42h,42h,42h
DATAS ENDS
edds segment 
edds ends

STACKS SEGMENT
    ;此处输入堆栈段代码
    
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:edds
START:
    MOV AX,DATAS
    MOV DS,AX	
	
	mov dx,0
	lea si,var
	mov al,[si]
	cmp al,[si+1]
	jz l1;a1=a2
	jmp l2;al!=a2
l1: inc dl
l2: cmp al,[si+2];
	jz l3;al=a3;
	jmp l4
l3: inc dl
	jmp stop
l4: ;a1!=a2!a3
	mov al,[si+1]
	cmp al,[si+2]
	jz l5;a2=a3
	jmp l6
l5: mov dl,1	
	jmp stop
l6: mov dl,0
stop:
	add dl,30h
	mov ah,02h
	int 21h

	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-----------------------------------》
10进制加减 输出类似1+1=2
DATAS SEGMENT
    ;此处输入数据段代码  
DATAS ENDS
edds segment 
edds ends

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS,ES:edds
START:
    MOV AX,DATAS
    MOV DS,AX	
	
	mov dx,0
	;a 输入
	mov ah,01h
	int 21h
	mov bl,al
	;输出+
	mov ah,02h
	mov dl,'+'
	int 21h
	;输入b
	mov ah,01h
	int 21h
	add bl,al
	;输出=
	mov ah,02h
	mov dl,'='
	int 21h
	;接口
	cmp bl,6ah
	jb l1
	jmp l2
l2:
	add bl,06h
l1:
	sub bl,60h
	;bl内容输出
  	mov cx,2
lop1:
	rol bl,1
	rol bl,1
	rol bl,1
	rol bl,1
	mov dl,bl
	and dl,0fh
	cmp dl,9
	jna next
	add dl,07
next:
	add dl,30h
	mov ah,2
	int 21h
	loop lop1	  		
	
stop:	
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
-------------------------------->
//统计大写字符个数
DATAS SEGMENT
    ;此处输入数据段代码 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX

	mov dx,00h
input:
	mov ah,01h
	int 21h
	cmp al,0dh
	jz stop
	cmp al,'A'
	jb input
	cmp al,'Z';
	ja input
	inc dx
	jmp input;
  	
stop:

    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
//屏幕输入小写字母输出大写字母,回车结束如果输入不是小写字母就换行接着输入
DATAS SEGMENT
    ;此处输入数据段代码 
    str1 db 'please input again$',0ah,0dh
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX

input:
	
	mov ah,01h
	int 21h
	cmp al,0dh
	jz stop
	cmp al,'a'
	jb error
	cmp al,'z'
	ja  error
	mov dl,al
	sub dl,20h
	mov ah,02h
	int 21h
	jmp input
error:
	lea dx,str1
	mov ah,09h
	int 21h
	mov dx,0ah//换行
	mov ah,02h
	int 21h
	jmp input
stop:

    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
//不超过50个字符并以$结尾 显示非数字个数
DATAS SEGMENT
    ;此处输入数据段代码 
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov dx,0;计数
	mov bx,0
input:
	mov ah,01h
	int 21h
	inc bx
	cmp bx,50;过50退出
	jae stop
	cmp al,'$';结尾退出
	jz stop
	cmp al,'0'
	jb l1;满足
	cmp al,'9'
	ja l1
	jmp input
l1: inc dx
	jmp input	
stop:
	;屏幕输出
	mov bx,dx
	mov cx,2
lop1:
	rol bl,1
	rol bl,1
	rol bl,1
	rol bl,1
	mov dl,bl
	and dl,0fh
	cmp dl,9
	jbe l2;dl<=9
	add dl,07h
l2: add dl,30h
	mov ah,02h
	int 21h
	loop lop1
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;屏幕实现加法
DATAS SEGMENT
    ;此处输入数据段代码 
    
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	;输入x
	mov ah,01h
	int 21h
	mov bl,al
	;输出+
	mov dl,'+'
	mov ah,02h
	int 21h
	;输入y
	mov ah,01h
	int 21h
	add bl,al
	;输出=
	mov dl,'='
	mov ah,02h
	int 21h
	;计算结果
	sub bl,60h
	cmp bl,10
	jb l1;bl<10
	jmp l2;bl
l1: add bl,30h
	mov dl,bl
	mov ah,02
	int 21h
	jmp stop
l2: add bl,6
	;输出bl
	
	mov cx,2
lop1:
	rol bl,1
	rol bl,1
	rol bl,1
	rol bl,1
	mov dl,bl
	and dl,0fh
	cmp dl,9
	jbe l3;dl<=9
	add dl,7h
l3: add dl,30h
	mov ah,02h
	int 21h
	loop lop1	
	
stop:	
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
;数组插入
//后判断
DATAS SEGMENT
    ;此处输入数据段代码 
    org 1000h
    buf db 12h,23h,45h,56h,?
    len db 4
    pos db 34h
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码

STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	mov dh,0
	
	mov cl,len
	mov dl,len
	lea si,buf
	add si,dx
	mov bl,pos
next:
	mov al,[si-1]
	cmp al,bl
	jg t
	mov [si],bl
	inc dl
	mov len,dl
	jmp exit
	
t: mov [si],al
	dec si
	loop next
	mov [si],bl
	inc dl
	mov len,dl
	
exit:
    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START
	
;同时比较max和min
DATAS SEGMENT
    ;此处输入数据段代码 
    org 1000h
    buf db 12h,67h,89h,29h,30h
    max db ?
    min db ?
    sum dw 0
DATAS ENDS

STACKS SEGMENT
    ;此处输入堆栈段代码
STACKS ENDS

CODES SEGMENT
    ASSUME CS:CODES,DS:DATAS,SS:STACKS
START:
    MOV AX,DATAS
    MOV DS,AX
	
	mov ax,0
	mov dx,0
	mov cx,0
	mov dx,0
	
	mov cx,5
	lea si,buf
	mov bh,[si];max
	mov bl,[si];min
lop1:
	mov al,[si]
	cmp al,bh
	jg ma;al>max
	cmp al,bl
	jl mi;al<min
	jmp a
ma: mov bh,al
	jmp a
mi: mov bl,al
	jmp a
a: inc si
	loop lop1

    ;此处输入代码段代码
    MOV AH,4CH
    INT 21H
CODES ENDS
    END START

















