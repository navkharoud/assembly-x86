;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data 	segment														;data segment. Keyword db means define byte. You can also define word (dw)
	a	db	7
	b   db  3
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
;****************** Write Code Here ******************
;The assembly code below is the equivalent of the C statement: 
;	if (a<b){
;		a += b;
;	}else{
;		a -= b;
;	}
; a and b are defined in the data segment above. Try modifying the numbers to confirm that the if statement is working.


	mov ah, a 		;move a into ah register
	mov al, b 		;move b into al register
	cmp ah,al 		;cmp compares a and b by subtracting (ah-al). Use flags to probe status of this operation
	jl	less		;if ah < al, jump to label 'less'
	sub ah, al		;otherwise, execute this instruction (subtract a-b and store in ah)
	jmp done		;jump past next instruction to 'done' since we don't want to execute it
less:
	add ah, al		;add numbers together and store in ah
done:

mov a, ah			;Move the new value of a back into memory

;Exercise: Add output functionality to this program to print out the value of 'a'. This is easy to do as long as 'a' is in the range (0-9)
;Exercise; Debug the program and try to find 'a' in the data segment by dumping memory.

;----------------------------------------------------------------------------------------------------------------------------------	---------------------
		mov ah, 4ch 					;Set up code to specify return to dos
		int 21h							;Interpt number 21 (Return control to dos prompt)


code    ends
end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------