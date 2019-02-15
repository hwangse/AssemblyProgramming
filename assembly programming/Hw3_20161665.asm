INCLUDE irvine32.inc

.data
text1 BYTE "Type the number of digits: ",0		;ȭ�鿡 ����� ���ڸ� ����
text2 BYTE "Type the number: ",0				;ȭ�鿡 ����� ���ڸ� ����2

digit DWORD ?				;digit�� �����ϴ� ����
			
Total DWORD 0				;5������ ���������� 10������ �ٲ��� ����
SubTotal DWORD 0			;�κ������� ���� ������ ����

.code
main PROC
	mov edx,OFFSET text1	
	call WriteString		;ù��° �ؽ�Ʈ ���
	call ReadDec			;digit�� �Է� �ޱ�
	mov digit,eax		

	mov edx,OFFSET text2	
	call WriteString		;�ι�° �ؽ�Ʈ ���

	mov ecx,digit			;loopȽ���� ������ �� ����
	inc ecx					;ecx=digit+1(���͸� �޾ƾ� ��)

	L1:	

			call ReadChar	;�� ���ھ� �ޱ�
			call WriteChar	;readChar���ν����� ȭ��� ���� ���� ��� ���� �ʴ´�
			
			cmp al,0dh		;���� ���� ���� ������ ��
			je L2			;����ȴ�

			mov bl,al		;���� �� ���ڸ� bl�� �ű��
			sub bl,'0'		;���ڷ� �޾����Ƿ� ���ڷ� �������ش�.

			cmp bl,0		
			je L2			;5���� �ڸ��� ���� 0�϶��� ������ ���� ����

			mov eax,1		

			push ecx		;ecx�� ����
			dec ecx			;enter���� ����ä ecx�� ���������Ƿ� 1�� ���ش�
			call PowerOf5	;5�� ���� ��� ����� eax�� �����
			pop ecx			;ecx�� ȸ��


			;bl ���� 0�� �ƴҶ�
			push ecx
			movzx ecx, bl ;���ο� ecx����
				L3 : 
						add Total, eax	;Total�� ����� ���� �����ش�.
						loop L3
			pop ecx

			L2 :	
					loop L1				;�� �ڸ� ���� �� ���� ������ ����ȴ�.
			;���� ���� ��, Total���� �������� 10���� ���� ����Ǿ��ִ�.

	mov eax,Total
	call Crlf
	call WriteDec	;Total �� ���
	call Crlf

	exit
main ENDP

PowerOf5 PROC		;���� loop�� �̿��Ͽ� 5�� ���� ���
	dec ecx			;ecx�� loop���� Ƚ�� ����
	cmp ecx,0		;�������� �˻�. ecx�� 0�϶� ����
	je turnOff

		;ecx�� 0�� �ƴ϶�� �Լ� ����
		mov subTotal,1
L1 : 
		push ecx
		mov ecx, 5
		mov eax, subTotal	;���� 2�� ���� ���� ���� �ٽ� eax������ �����
		mov subTotal, 0		;subTotal�� �ʱ�ȭ

		L2 : 
				add SubTotal, eax
				loop L2
		pop ecx
		loop L1

		mov eax, subTotal

turnOff :	;ecx���� 0�϶� ����ȴ�
		ret	
		
PowerOf5 ENDP
END main