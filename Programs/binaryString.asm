;Navkaran Singh 3119008 
; Sources for this question 
;Binary to decimal in x86 youtube 
;https://www.codepoc.io/blog/assembly-language
;http://www.dailyfreecode.com/Code

;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment							; data segment. Keyword db means define byte. You can also define word (dw)
	    iNum	db  225					;Define input number
		msg1 db 'Enter a 16-bit binary number: $'
		msg2 db 'The decimal unsigned interger equivalent is $'
		period db '. $'
		inputBuff db 17,'?',17 dup(?)	;Bufferd input string 16 for input + 1 for enter
		outputNum db 1 dup('$')
		TWOMUl db 2
		
data	ends

										; stack segment
stack1  segment	stack 		
		db	100 dup(?)      			; This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
										;Perform initialization 
		mov ax, data					;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax						;Put the starting address of the data segment into the ds register (where it belongs)
		
		mov ax, stack1					;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax						;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------		
;****************** Perform Newton's Algorithm ******************
										
		lea dx, msg1			;String msg for input 
		mov ah, 9h				
		int 21h	
		
		call binaryString
		
		lea dx, msg2			;String msg for output
		mov ah, 9h				
		int 21h	
		
		call toDecimal
		
		lea dx, period			;String msg for output
		mov ah, 9h				
		int 21h

	
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 					;Set up code to specify return to dos
        int 21h							;Interpt number 21 (Return control to dos prompt)

;-------------------------------------------------------------------------------------------------------------------------------------------------------
; this get the input from user 
; input: none 
; output: store binary number in dx 

binaryString proc
		mov ah,0ah 	
		lea dx, inputBuff	;loads the address of the string 
		int 21h
	
				
		lea si, inputBuff	;Load address into si for indexing
		inc si			;Point si to count
		mov bl, [si]	;count is in bl
		mov bh, 0		;bh = 0, bx = count
		add si, bx		;si points to last char of buffered string
		inc si			;si points to carriage return
		mov byte ptr [si],'$'	;Overwrite byte with terminator
	    ;Now string is terminated properly
		
		lea si,inputBuff	;point to start of buffer
		inc si				;point to number of chars
		mov ch, 0			;Clear ch for loop
		mov cl, [si]		;Get the number of characters read
		add si, cx			;si points to end of buffer
		;cmp cl,16 			;compares number of input chars to 16 
		;jle padding 		;re takes the input if less than 16 inputted
		jmp exit			;otherwise exits
			
;padding is done by shifting the register by 1 bit 
;so every time we read a char and add it to a register 
;eg for 11b as input 
;0000 0000 0000 0001 is the first time we move a char into register and shift by 1 bit 
;0000 0000 0000 0011 on the 2nd time it happens
;loop for number of characters	
; Adds trailing zeros to the left side for additional padding to complete the 16 bit number
;padding:
;		sub cx,16			;gives us the number whihc whe have to padd the zeroes 
		
;addZero:		
		;loop addZero
		
exit:	
		ret 
binaryString endp

;-------------------------------------------------------------------------------------------------------------------------------------------------------
; Source for this proc taken from group discussions and binary.asm from examples

; output the decimal value
toDecimal proc 
		
		lea si,inputBuff	;address of string inputted
		mov bx,[si]			;count of num of chars read 
		mov si, 0 			; initialize si to 0
		mov cx,bx 			; looping process 
		
		mov dx, 0			;stores output as it is the 16 bit register 
		mov dl, 0				;Clear dl to create number
		mov bl, 0				;Clear
		mov bh, 0				;initialize power/position

loop1:
		mov ax,[si]			;get digit 
		sub ax,30h			; ascii to num
		mov bl,bh
reloop:
		cmp bl,0 
		je done 
		mul TWOMUl			;multiply 2 
		dec bl 				;decrement till 0 for amount of times the multiplication has to occur 
		loop reloop
done:	
		dec si 				;decrement si to move to the next character 
		add dx,al			;add the amount to total
		inc bh 				;tells the 2^power of the exponent 
		loop loop1
		
		add dx,30h			;convert to decimal
		mov ah, 2h			;output subroutine
		int 21h

ret
toDecimal endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------

	




