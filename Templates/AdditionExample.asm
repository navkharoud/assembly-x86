;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment						; data segment. Keyword db means define byte. You can also define word (dw)
		num1	db  2				;Define first variable
		num2	db  4				;Define second variable
data	ends

							; stack segment
stack1  segment	stack 		
		db	100 dup(?)     			; This is the stack of 100 bytes
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
;****************** Write Code Here ******************

;This program adds two variables from the data segment and prints the result
;Note: only works for single digit positive numbers (0-9)

mov al, num1 				 ;Debugger trace skips first instruction

mov al, num1				 ;move num1 to al
add al, num2				 ;al contains num1 + num2	
mov dl, al					 ;move result to dl for display						
add dl, 30h					;ASCII offset for printing
mov ah, 2h					 ;Store interrupt code in ah to display results in dl
int 21h						 ;display character in dl as translated by ascii code
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
	mov ah, 4ch 					;Set up code to specify return to dos
        int 21h						;Interrupt number 21 (Return control to dos prompt)

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------