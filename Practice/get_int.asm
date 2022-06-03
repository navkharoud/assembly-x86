;procedure to read an integer 
;Input None:
;Output: dl register
get_int	proc					
		mov ah, 9				;Specify print string DOS service routine
		lea dx, tStr			;Load pointer to string
		int 21h 				;Call DOS service routine
			
		mov ah, 0ah				;Prepare to call buffered keyboard input
		lea dx, iBuff			;Load the address of the buffer into iBuff
		int 21h					;Request service from OS
		
		mov ah, 2				;Specify print string DOS service routine
		mov dl, 10				;Load new line feed into dl
		int 21h 				;Call DOS service routine				
			
		lea si, iBuff			;Point to start of buffer
		inc si					;Point to # of chars
			
		mov ch, 0				;Clear ch for loop
		mov cl, [si]			;Get the number of characters read
			
		add si, cx				;Point si to end of buffer
			
		mov dl, 0				;Clear al to create number
		mov bl, 1				;Stores power of 10
							
gL1S:								;get_int loop1 start
		mov al, [si]			;Get digit 									
			
		sub al, 30h				;Convert to number
		mul bl					;Multiply by power of 10
		add dl, al				;Add to total
		mov al, bl				;Initialize X10 multiplication
		mul ten					;Multiply by 10
		mov bl, al				;Store power of 10 back in bl
		dec si					;Decrement si
		loop gL1S				;Loop until cx == 0
				
		mov iNum, dl			;Store result in memory
							
		ret
get_int	endp