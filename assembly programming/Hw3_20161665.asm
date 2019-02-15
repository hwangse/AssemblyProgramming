INCLUDE irvine32.inc

.data
text1 BYTE "Type the number of digits: ",0		;화면에 출력할 문자를 저장
text2 BYTE "Type the number: ",0				;화면에 출력할 문자를 저장2

digit DWORD ?				;digit값 저장하는 변수
			
Total DWORD 0				;5진수가 최종적으로 10진수로 바뀔값을 저장
SubTotal DWORD 0			;부분적으로 합을 저장할 변수

.code
main PROC
	mov edx,OFFSET text1	
	call WriteString		;첫번째 텍스트 출력
	call ReadDec			;digit값 입력 받기
	mov digit,eax		

	mov edx,OFFSET text2	
	call WriteString		;두번째 텍스트 출력

	mov ecx,digit			;loop횟수를 결정할 값 저장
	inc ecx					;ecx=digit+1(엔터를 받아야 함)

	L1:	

			call ReadChar	;한 글자씩 받기
			call WriteChar	;readChar프로시저는 화면상에 받은 값이 출력 되지 않는다
			
			cmp al,0dh		;만약 받은 값이 엔터일 때
			je L2			;종료된다

			mov bl,al		;받은 한 글자를 bl에 옮긴다
			sub bl,'0'		;문자로 받았으므로 숫자로 변경해준다.

			cmp bl,0		
			je L2			;5진수 자릿수 값이 0일때는 루프가 돌지 않음

			mov eax,1		

			push ecx		;ecx값 보관
			dec ecx			;enter값을 더한채 ecx가 정해졌으므로 1을 빼준다
			call PowerOf5	;5의 제곱 계산 결과가 eax에 저장됨
			pop ecx			;ecx값 회복


			;bl 값이 0이 아닐때
			push ecx
			movzx ecx, bl ;새로운 ecx설정
				L3 : 
						add Total, eax	;Total에 계산한 값을 더해준다.
						loop L3
			pop ecx

			L2 :	
					loop L1				;각 자리 별로 한 루프 연산이 진행된다.
			;루프 종료 후, Total에는 최종적인 10진수 값이 저장되어있다.

	mov eax,Total
	call Crlf
	call WriteDec	;Total 값 출력
	call Crlf

	exit
main ENDP

PowerOf5 PROC		;이중 loop를 이용하여 5의 제곱 계산
	dec ecx			;ecx에 loop돌릴 횟수 저장
	cmp ecx,0		;종료조건 검사. ecx가 0일때 종료
	je turnOff

		;ecx가 0이 아니라면 함수 진행
		mov subTotal,1
L1 : 
		push ecx
		mov ecx, 5
		mov eax, subTotal	;루프 2를 통해 계산된 값이 다시 eax값으로 저장됨
		mov subTotal, 0		;subTotal값 초기화

		L2 : 
				add SubTotal, eax
				loop L2
		pop ecx
		loop L1

		mov eax, subTotal

turnOff :	;ecx값이 0일때 종료된다
		ret	
		
PowerOf5 ENDP
END main