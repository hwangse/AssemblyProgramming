INCLUDE irvine32.inc

.data
INCLUDE hw5.inc 
before BYTE "Before order : ",0
after BYTE "After order : ",0
tempCount DWORD 0
temp DWORD TYPE DWORD

.code
main PROC						;A main procedure
	mov edx, OFFSET before		;print "Before order"
	call WriteString

	call PrintArray				;print all elements in array
	call SortArray				;sort array elements in required order
								;<X,Y> --> X : ascending , Y : descending

	mov edx, OFFSET after		;print "After order"
	call WriteString

	call PrintArray				;print all elements in array

	exit
main ENDP

PrintArray PROC					;this procedure functions as printing all the elements in array
	pushad						;store all the registers
	mov esi, OFFSET arr_data
	mov ecx, len_data
	 L1 : 
			mov eax, [esi]		;print the hex one by one
			call WriteHex
			add esi,4

			cmp ecx,1			;if current element is last one.
			je L2				;then, do NOT print ','

			mov al,','			;else, print ',' at the back of hex
			call WriteChar
			L2 : 
				loop L1
	call Crlf
	popad						;restore all the registers
	ret
PrintArray ENDP

SortArray PROC					;the procedure functions as sorting numbers
;----------------------------------------------------;
;in this function, elements in array are sorted		 ;
;through the followed processes						 ;
;1. sort elements in ascending order				 ;
;2. scan the (ascending) array and count the number	 ;
;which have same 16 MSB bits						 ;
;3. If there exists more than one elements which have;
;same MSB bits, call the procedure named SubSort     ;
;4. The SubSort sort the array in descending order   ;
;within the numbers which have same MSB bits		 ;
;----------------------------------------------------;

	mov ecx, len_data			;loop counter set
	dec ecx						;loop counter-1
	mov esi, OFFSET arr_data	;bring the offset of array to esi

	;START : sort array in ascending order 
L0 : 
	push ecx					;store the loop counter
	mov esi, OFFSET arr_data
	L1 : 
		mov eax, [esi]			;current array element
		and eax,0FFFF0000h		;use AND instruction to compare MSB 16bit
		mov ebx,[esi+4]			;next array element
		and ebx,0FFFF0000h

		cmp eax,ebx				;compare eax and ebx
		jbe next				;if eax<=ebx, jump to next (already sorted in ascending order)

		;swap start				;if eax>ebx, swap adjacent two numbers in array
		mov edx, [esi]
		mov eax, [esi+4]
		mov [esi],eax
		mov [esi+4],edx
		;swap end

	next : 
			add esi,4
			loop L1

	pop ecx						;restore the loop counter
	loop L0

	;END : sort array in ascending order 

	;START : sort array in decending order
	
	mov ecx, len_data			;loop counter : len_data
	mov esi, OFFSET arr_data	;addresss : the first element of arr_data
	mov edx, esi				;store the address in EDX register
	mov tempCount,1				;tempCount uses as a counter(in SubSort procedure)
								;this variable determines the number to repeat sorting functions
	L2 : 
		mov eax, [esi]			;compare the MSB bits
		and eax,0FFFF0000h		;and count the number (tempCount --> the number which have same MSB bits)
		mov ebx,[esi+4]			
		and ebx,0FFFF0000h

		cmp eax, ebx
		jne sort				; if eax!=ebx, the sort starts (but except when tempCount==1 because it's no need to sort)
		inc tempCount			;tempCount++
		add esi,4
		loop L2

		sort : 
				cmp tempCount,1
				je NotSort		;no need to Sort (in descending order)
				dec tempCount
				push ecx		;store current loop counter(to call Subsort procedure)
				mov ecx, tempCount
				mov eax,tempCount
				mul temp		;temp=TYPE DWORD=4
				push esi		;store current ESI
				sub esi, eax    ;calculate the address of array which uses in SubSort procedure
				call Subsort

				pop esi			;restore current ESI
				pop ecx			;restore current loopCounter

		NotSort : 
					mov tempCount,1	 ;initialize tempCount
					add esi, 4
					loop L2

	;END : sort array in decending order
	ret
SortArray ENDP

Subsort PROC		; sort array in decending order
	pushad
	mov edx, esi

	;START : sort array in decending order 
L0 : 
	push ecx					;store the loop counter
	push edx					;store the address of first element in array
	mov esi, edx				;move the address of array to esi register

	L1 : 
		mov eax, [esi]			;current array element
		and eax,0FFFFh			;use AND instruction to compare LSB 16bit
		mov ebx,[esi+4]			;next array element
		and ebx,0FFFFh

		cmp eax,ebx				;compare eax and ebx
		ja next					;if eax>ebx, jump to next(already sorted in descending order )

		;swap start				;if eax>ebx, swap adjacent two numbers in array
		mov edx, [esi]
		mov eax, [esi+4]
		mov [esi],eax
		mov [esi+4],edx
		;swap end

	next : 		
			add esi,4
			loop L1
	pop edx						;restore the address of array
	pop ecx						;restore the loop counter
	loop L0		

	popad						;restore all the registers 
	ret
Subsort ENDP
END main