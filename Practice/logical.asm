;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. Keyword db means define byte. You can also define word (dw)
		num db 243					;number to print in binary form
		two db 2					;define for mul by 2
		ten db 10					;define for mul by 10
data	ends

							; stack segment
stack1  segment	stack 		
		db	100 dup(?)     			; This is the stack of 100 bytes
stack1  ends


code    segment
        assume  cs:code, ds:data, ss:stack1

start: 
							;Perform initialization 
		mov ax, data				;Put the starting address of the data segment into the ax register (must do this first)
		mov ds, ax					;Put the starting address of the data segment into the ds register (where it belongs)
		
		mov ax, stack1				;Put the starting address of the stack into the ax register (must do this first)
		mov ss, ax					;Put the starting address of the stack segment into the ss register (where it belongs)
;-------------------------------------------------------------------------------------------------------------------------------------------------------		
;****************** Write Code Here ******************
;The purpose of this code is to familiarize ourselves with the shift/rotate instructions.
;We will convert a binary number into base 10.

	mov bl, num				;want to convert num
							;num is stored in binary (hex) form in memory
	
	mov al, 1				;holds zeroth power of 2
	mov cx, 8 				;eight loops
	mov dl, 0				;clear dl for loop

	
loop_start:
	test bl, 1h				;test first bit of 243
	jz rotate_byte			;if first bit is zero, no need to add
	add dl, al				;if first bit is 1, add to total
rotate_byte:
	mul two					;update power of 2 (al = al *2)
	ror bl, 1				;rotate (without carry) bits in bl
	loop loop_start			;loop (decrements cx until cx = 0)
	
	mov al, dl			;move into al for print_int
	call print_int		;call procedure to print int
	
	mov ah, 4ch 					;Set up code to specify return to dos
    int 21h							;Interpt to return control to MS-DOS

;--------------------------------------------------------------------------------------------------------------------------------------------------		
;procedure that prints out a number 
;Input (al): prints a number
print_int proc

		mov dx, '$'				;Set up end of string
		push dx					;Put on stack to indicate end of string

PLS1:			
		mov ah, 0				;Clear ah for division (result stored in ah, remainder in al)
		div ten					;Divide al by 10
		mov dl, ah				;Store remainder in dl (putting in dl makes output easier below)
		push dx					;Store digit for output (dl is subregister of dx)
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

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------