INCLUDE irvine32.inc

.data
str1 BYTE "Type_A_String_To_Reverse: ",0
str2 BYTE "Reversed_String: ",0
str3 BYTE "Bye!",0

.data?						;for saving memories Use .data? directives
input BYTE 42 DUP(?)		;extra 2 bytes for <enter> and for break condition 

.code
main PROC

L0 :						;main loop(infinite loop)
	mov edx,OFFSET str1		
	call WriteString		;print the first message "Type_A_String_To_Reverse"

	mov ecx,SIZEOF input
	mov edx,OFFSET input	;read string to reverse
	call ReadString			;The length of input string is stored in eax

	cmp eax,0				;if the user inputs only an enter, string : "\n"
	je Bye					;The loop ends

	cmp eax,28h				;compare the length of String with 40
	ja L0					;if input_string's length is over 40
							;jump to the top(ignore the rest of commands)
	
	mov esi,OFFSET input	
	call StrReverse			;call the procedure

	loop L0					
Bye :						;when program ends
	mov edx,OFFSET str3		;print the end message "Bye!"
	call WriteString		
	call Crlf

	exit
main ENDP

StrReverse PROC				;The procedure which reverses the order of string
	mov ecx,eax				;set the number of repetition
	mov edx,esi				;temporarily stored the address of string

L1 :
	push [esi]				;push each letter on the stack
	inc esi
	loop L1

	mov ecx, eax			;set the num to repeat

	mov edx,OFFSET str2
	call WriteString
L2 :						
	pop eax					;pop each letter on the stack
	call WriteChar			;print each letter in reversed order
	loop L2

	call Crlf
	ret
StrReverse ENDP 

END main