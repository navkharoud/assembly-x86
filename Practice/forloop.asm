;-------------------------------------------------------------------------------------------------------------------------------------------------------
;.186 You may need to uncomment this to get some of the instructions working (e.g. shl, dest, count)
;-------------------------------------------------------------------------------------------------------------------------------------------------------
data 	segment														;data segment. Keyword db means define byte. You can also define word (dw)
	a	db	2
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
;The assembly code below is equivalent to the C statement: 
;	for (i = 0; i<5; i++) {
;		a++;
;	}
;The variable a will be declared in the data segment.


	mov cx, 5 		;move 5 into register cx. We will use this a loop index later
	mov ah, a		;move a into register ah

loopstart:			;label to set up loop
	inc ah			;increment ah
	loop loopstart	;the loop instruction decrements cx and jumps to the label if cx ~= 0
					;We have initialized cx to 5 above, so it will loop 5 times.
	
mov a, ah			;Move the new value of 'a' back into memory

;;;;;;;;;;;;;;;;;ALTERNATE FORM USING FLAGS;;;;;;;;;;;;;;;;;;;;;

	mov cx, 5 		;move 5 into register cx. We will use this a loop index later
	mov ah, a		;move a into register ah

loopstart2:			;label to set up loop
	inc ah			;increment ah
	dec cx			;update loop counter (stored in cx) by decrementing
	cmp cx, 0		;compare cx to 0
	je done			;if cx equals 0, we are done looping. Jump outside of loop to label 'done'
	jmp loopstart2	;otherwise, jump back to the beginning of the loop

done:				;label to exit loop

mov a, ah			;Move the new value of 'a' back into memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;Exercise: Add output functionality to this program to print out the value of 'a' each iteration. This is easy to do as long as 'a' is in the range (0-9)
;Exercise: Debug the program and ensure that you can see 'a' update in the data segment each iteration.
;Exercise: Modify the second loop so that the loop index increments from 0->5 instead of decrementing from 5-> 0

;----------------------------------------------------------------------------------------------------------------------------------	---------------------
		mov ah, 4ch 					;Set up code to specify return to dos
		int 21h							;Interpt number 21 (Return control to dos prompt)


code    ends
end     start
;-------------------------------------------------------------------------------------------------------------------------------------------------------