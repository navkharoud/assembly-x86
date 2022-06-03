;-------------------------------------------------------------------------------------------------------------------------------------------------------
.186
data	segment															;data segment. Keyword db means define byte. You can also define word (dw)													;Define input number
		tStr	db 'Enter a one digit number less than 6:',10,'$'		;Prompt for user
		oStr	db 'The result is:',10,'$'								;Output prompt
		ten		db 10
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
;****************** Find Factorial of a number ******************

		lea dx, tStr			;Load prompt string for display
		mov ah, 9h				;Display string subroutine
		int 21h					;Interrupt for MS-DOS routine

		mov ah, 1h				;Read character subroutine (will be stored in al)
		int 21h					;Interrupt for MS-DOS
		sub al, 30h				;Translate al from ASCII code to number
		mov cl, al				;Copy number to cl (al will be overwritten later)
		
		call line_feed			;call procedure to print line feed (no input)
								;ah contains 02h, dl contains 10
		
								;INPUT: cl contains input number
		call fact				;Call procedure to calculate factorial (cl!)
								;OUTPUT: ax stores result
		
		push ax					;Save result since al may be modified by int21h
		
		lea dx, oStr			;load output string for display
		mov	ah, 9h				;load display string subroutine
		int 21h					;Call MS-DOS for subroutine		
		
		pop ax					;Restore result
		
		call print_int			;Prints a number stored in al
		
		
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
		mov ah, 4ch 			;Set up code to specify return to dos
        int 21h					;Interpt number 21 (Return control to dos prompt)
;--------------------------------------------------------------------------------------------------------------------------------------------------		
;procedure to calculate factorial (up to 5!)
;Input: (cl)
;Output: (ax)
fact	proc				

		mov al, cl				;Copy number to ax from cx
not_zero:		
		dec cl					;Decrement cl
		jz zero					;If cl is 0, we're done.
		mul cl					;otherwise multiply result and decrement again 
		jmp not_zero
			
zero:		
		ret						;return to main program, ax contains result
fact	endp
;--------------------------------------------------------------------------------------------------------------------------------------------------		
;procedure that prints out a line feed 
;Input (none): prints a line feed
line_feed proc

		mov ah, 2				;Specify print string DOS service routine
		mov dl, 10				;Load new line feed into dl
		int 21h 				;Call DOS service routine
		
		ret
line_feed endp
;--------------------------------------------------------------------------------------------------------------------------------------------------		
;procedure that prints out an integer passed 
;Input (al): unsigned 8-bit number for output
print_int proc

		mov ah, 9				;Specify print string DOS service routine
		lea dx, oStr			;Load pointer to string
		int 21h 				;Call DOS service routine

		mov dx, '$'				;Set up end of string
		push dx					;Put on stack to indicate finished		
PLS1:			
		mov ah, 0				;Clear ah for division
		div ten					;Divide by 10
		mov dl, ah				;Store remainder in dl (putting in dl makes output easier below)
		push dx					;Store digit for output
		cmp al, 0				;Check to see if we are done looping
		jne PLS1				
			
		mov ah, 2h				;Setup character output routine			
PLS2:					
		pop dx					;Get last character
		cmp dl, '$'				;Check to see if we are finished
		je pDone				;Exit loop if equal to $
		add dl, 30h				;Convert integer to character
		int 21h					;Call character output routine
		jmp PLS2				;Continue looping
			
pDone:
		ret
print_int endp




;---------------------------------------------------------------------------------------------------------------------------------------------------
code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------



