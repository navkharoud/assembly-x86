;Navkaran Singh 3119008 
; Sources for this question 
;Binary to decimal in x86 youtube 
;https://www.codepoc.io/blog/assembly-language
;http://www.dailyfreecode.com/Code
;Binary.asm from assembly examples
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment							; data segment. Keyword db means define byte. You can also define word (dw)
		iNum	db  225					;Define input number
		msg1 db 'Enter a 16-bit binary number: $'
		msg2 db 'The decimal signed integer equivalent is $'
		illegalCommand db 'Error! Please enter exactly 16 bits. $'
		illegalCommand2 db 'Error! Illegal characters detected. $'
		msg3 db '.$'
		inputBuff db 17, 17 dup(?)
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

	
	call inputBinary 
	
	lea dx,msg2
	mov ah,9h
	int 21h
	
	mov ax,bx 
	call toDecimal 
	
	lea dx,msg3
	mov ah,9h
	int 21h


;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 					;Set up code to specify return to dos
        int 21h							;Interpt number 21 (Return control to dos prompt)


;-------------------------------------------------------------------------------------------------------------------------------------------------------
inputBinary proc

	jmp input				;first call starts at input 
error1:						;prints error msg for incorrect number of inputted digits
	lea dx, illegalCommand1
	mov ah,9h
	int 21h 
	jmp input 
	
error2:						;print error msg for invalid chars
	lea dx, illegalCommand2
	mov ah,9h
	int 21h 
	
input:
	lea dx, msg1		;prints msg1 for user input
	mov ah,9h
	int 21h 
	
	mov ah,0ah 			
	lea dx, inputBuff	;loads the address of the string 
	int 21h
	
	lea si,inputBuff	;point to start of buffer
	inc si				;point to number of chars
	mov ch, 0			;Clear ch for loop
	mov cl, [si]		;Get the number of characters read
	cmp cl,16 			;compares number of input chars to 16 
	jle error1 			;re-takes the input if less than 16 inputted
	
	mov cx, 16 			;initialize loop counter 
	mov bx, 0 			;clear bx register 
	
check:
	mov al, [si]		;moving input to ax register
	cmp al, 13			;ends at carriage return 
	je returnend

	cmp al, 30h 		;compares ax with 
	jl error2			;jumps to error if a character is <0
	
	cmp al, 31h			;compares ax with 1 
	jg 	error2 			;jumps to error if ax>1
	
	sub al,30h		    ;convert ascii to decimal 
	shl bl,1 			;shift bx 1 position left 0000 0000 0000 0000 16bits each shift add the starting character to the register
	or bl,al			;places the input decimal in bl 
	inc si 				
	loop check 
	
returnend: 
	ret 				;return to main 

inputBinary endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
toDecimal proc

   push bx                        ; push BX onto the STACK
   push cx                        ; push CX onto the STACK
   push dx 					      ; push DX onto the STACK
   
   cmp ax,0						  ;compares with zero 
   jge startDiv					  ;if greater goes to the start
   
   push ax 						  ;onto the stack
   
   mov ah,2						  ;output function
   mov dl, '-'					  ;for negative values
   int 21h 						  ;printing the character
   
   pop ax 
   neg ax 						 ;takes twos compliment to get the signed value 
   
startDiv:
   mov cx,16					 ;clears cx for looping 
   mov bx,10					 ;divisor 
   
repeating:
   xor dx,dx					;clear dx
   div bx 					
   push dx						;pushed value for output display
   inc cx 
   or ax,ax 					;or ax with ax to get the zf 
   jne repeating				;loop if zf = 0
   
   mov ah,2						;subroutine for output 
   
output:	
   pop dx 
   add dl,30h					; decimal to ascii value  
   int 21h 						; print the char 
   loop output					; loops 
   
   pop dx
   pop cx
   pop bx
   
   ret
toDecimal endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------------------------------------------------------------

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



