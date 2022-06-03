;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data	segment							; data segment. Keyword db means define byte. You can also define word (dw)
	myBStr db 5, 6 dup(?) 				;Buffered String
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

;This program takes in a buffered string, and prints the count byte
;(number of input char not including enter key)

lea dx, myBStr				;Load effective address of buffered string
mov ah, 0ah					;Prepare buffered keyboard input routine
int 21h						;Call DOS service routine
							;Add line feed to user input now
mov ah, 2h					;Specify print string DOS service routine
mov dl, 10					;Load new line feed into dl
int 21h 

							;Call DOS service routine

lea si, myBStr				;Load effective address of buffered string
inc si  					;point to # of characters 
mov dl, [si]				;move # of characters to dl (note the square brackets indicate we are working with a memory address)
add dl, 30h					;add 30h to get ASCII character code for one digit number
mov ah, 2h					;subroutine code for display character
int 21h									;call OS to run subroutine 
;-------------------------------------------------------------------------------------------------------------------------------------------------------										
	mov ah, 4ch 					;Set up code to specify return to dos
        int 21h						;Interrupt number 21 (Return control to dos prompt)

code    ends

end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------