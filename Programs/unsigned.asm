;Navkaran Singh 3119008
;Sources: 2906 Assembly examples, Stack overflow newton alogrithm iteration square root 8086
;Stack overflow input to String output 8086 
;Stack overflow 
;github square root assembly asm 
;youtube newton raphson method for sqare root 
;programming guide.com newton raphson method for square root
;Telegram and Discord groupchat for 2906-002
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment					;data segment. Keyword db means define byte. You can also define word (dw)
		msg1	db 'Enter a perfect Cube: ','$'	
		msg2	db 'The Cube root of ','$'		
		msg3	db ' is ','$'						
		ten		db 10								;10 for multiplication for outputting ascii values
		max 	db 4                                ;Max length for the buffer 3 char + 1 return 
		count 	db ?                                ;Number of characters returned from input 4 = 1, 16 = 2 for SI 
		buffer 	db 4 dup(?)                         ;255 max value : 3 characters and 1 for carrage return 
		iNum    db 1 								;Stores the root value 
		rootNum db 1								;variable for temporary storage of i-1th 
		
data	ends

								;stack segment
stack1  segment	stack 		
		db	100 dup(?)      	;This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
								;Perform initialization 
		mov ax, data			;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax				;Put the starting address of the data segment into the ds register (where it belongs)
		
		mov ax, stack1			;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax				;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;****************** Enter Assembly Code Below ******************
		
		lea dx, msg1			;Shows msg1 
		mov ah, 9h							
		int 21h					

		lea dx, max				;Load effective address for the input
	    mov ah, 0ah				
		int 21h					

		call line_feed			;prints new line

		mov ah, 9h				;Shows msg2
		lea dx, msg2			
		int 21h 				

        call print_number		;print the user input as a string

		lea dx, msg3			;prints msg3
		mov ah, 9h							
		int 21h 				

	    call string_to_number 	;Call procedure to convert the user input into a number
		
		call newton     		;Call procedure to calculate the square root 
		
		call print_int			;Prints a number stored in al
		
;-------------------------------------------------------------------------------------------------------------------------------------------------------
		mov ah, 4ch 			;Set up code to specify return to dos
        int 21h					;Interpt number 21 (Return control to dos prompt)

;-------------------------------------------------------------------------------------------------------------------------------------------------------
;procedure that prints out an integer passed 
;Input (al): unsigned 8-bit number for output
print_int proc
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
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;procedure that prints out a line feed 
;Input (none): prints a line feed
line_feed proc
		mov ah, 2h				;Specify print string DOS service routine
		mov dl, 10				;Load new line feed into dl
		int 21h 				;Call DOS service routine
		
		ret
line_feed endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;procedure that prints out all characters in sequence one by one
;Input: (count, buffer)
print_number proc
        mov cl, [count]         ;Set loop counter to the size of the string
        xor ch, ch				;Clears ch
		mov ah, 2h				

		lea si, buffer          ;Load the address of the first character of the input into si

		print:				
			mov dl, [si]		;Copy and store the value of character from buffer at position of si into dl
			inc si 				;Increment the pointer
			int 21h				
		loop print				

		ret
print_number endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;procedure that converts buffered user input into a number and stores it into bx
;Input: (count, buffer)
;Output: (bx)
string_to_number proc
        mov cl, [count]         ;Set loop counter to the size of the string
        mov ch, 0				;Clear ch for the loop

        lea si, buffer          ;Load the address of the first character of the input into si
		mov bx, 0				;Initialize bx as accumulator for the end result

		convert:				;Loop that converts a buffered input to number character by character
			mov ax, bx 			;Copy bx into ax
			mul ten 			;Multiply ax by 10
			mov bx, ax 			;Add ax to bx

			mov al, [si] 		;Copy and store the value of character from buffer at position of si into al
			sub al, 48			;Translate al from ASCII code to number
			mov ah, 0			;Clear ah to make ax be equal to al
			add bx, ax 			;Add ax to bx

			inc si 				;Increment the pointer
		loop convert 			;Continue looping

		ret
string_to_number endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;fins square root of number using Newton’s iteration algorithm 
;and stored it in ax register
;Input: (bl)
; Xi = 1/2 (xi-1 + N/xi-1)
;Xk+1 = 1/3 (2xk = n/x2k )
newton proc
	  	push ax
		push dx	
		push cx
		
		mov cl,0		  ;start xi-1 at 0 therfore xi at 1 
		mov iNum, bl      ;Assign perfect square to iNum which is N 
loop1 :                   ;use loop to Calculate root
		mov al, iNum	  ;al = N 
		div cl   		  ;divide al by xi-1 
		xor ah,ah 		  ;clear remainder
		add al, cl        ;add number to the result of the division 
						  ;till here we have done (xi-1 + N/xi-1)
						  
		mov bl, 2         ;set bl to 2, to be used in division as part of the algorithm
		div bl            ;multiply bl and al (this will give us root value in ax)
		xor ah, ah        ;clear up the remainder 
		mov rootNum,ah 	  ;saves value for the root 
		cmp al, cl
		je loop_end
		mov cl,al 		 ;onto next iteration
		inc cl 

loop_end:
		ret
newton endp
;-------------------------------------------------------------------------------------------------------------------------------------------------------
code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------
;Another method of using a different way of newtons algorithm 
; Source: Programming guide for assembly language fourm
;  mov di, bx				;Copy bx into di
;	    mov ax, 255				;Copy 255 into ax
;
;		iterate:				;Loop that uses Newton’s iteration algorithm to find a square root of a number
;		    mov bx, ax			;Copy ax into bx
;		    xor dx, dx			;Clear dx
;		    mov ax, di 			;Copy di into ax
;		    div bx 				;Divide ax by bx
;		    add ax, bx 			;Add bx to ax
;		    shr ax, 1 			;Shift all bits of ax right by 1
;		    mov cx, ax 			;Copy ax into cx
;		    sub cx, bx			;Subtract bx from ax
;		    cmp cx, 2 			;Compare cx to 2
;	    ja iterate 				;Jump to label iterate if cx is above 2
;