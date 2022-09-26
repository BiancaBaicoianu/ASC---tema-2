.data
	input: .space 200
	delim: .asciz " \n"
	formatScanf: .asciz "%[^\n]s"
	formatPrintf: .asciz "%d "
	formatPrintf2: .asciz "%s"
	nl: .asciz "\n"
	aux: .space 4
	n: .space 4
	m: .space 4
	nr: .space 4
	nr_elem: .space 4
	v: .space 200
	v_semn: .space 200
	i: .space 4
	x: .space 4
	dr: .space 4
	st: .space 4
	exceptie: .asciz "-1"
.text

valid:
	pushl %ebp
	movl %esp, %ebp
	
	pushl %edi
	pushl %ecx

	movl 8(%ebp), %ecx
	movl 12(%ebp), %edi
	movl 16(%ebp), %ebx
	
	movl %ebx, nr
	movl %ecx, x

	xorl %ecx, %ecx
	xorl %eax, %eax	
	movl $0, i

for_valid1:
	cmp nr_elem, %ecx
	je final_for_valid
	movl (%edi, %ecx, 4), %ebx	#elem curent este in ebx
	
	cmp %ebx, x
	jne cont_valid1
	incl i
	
cont_valid1: 		
	incl %ecx
	jmp for_valid1
	
final_for_valid:
	cmp $3, i	#verificare prima conditie- fiecare cifra sa apara de max 3 ori
	jl final_for_valid1
	jmp final_for_valid0
	
final_for_valid0:	
	incl %eax
	jmp final_for_valid1
	
final_for_valid1:
	//st=nr-m		
	movl nr, %ebx
	subl m, %ebx
	movl %ebx, st
	
	//dr=nr+m
	movl nr, %ebx
	addl m, %ebx
	movl %ebx, dr
	
	movl st, %ecx
	jmp for_valid2
	
for_valid2:
	cmp nr, %ecx
	je cont_valid2
	
	cmp dr, %ecx
	jg final_valid2
	
	movl (%edi, %ecx, 4), %ebx
	
	cmp %ebx, x
	jne cont_valid2
	jmp cont_valid2_0
	
cont_valid2_0:	
	incl %eax
	jmp cont_valid2
	
cont_valid2:
	incl %ecx
	jmp for_valid2
	
final_valid2:
	popl %ecx
	popl %edi
	popl %ebp
	ret

backtracking:			
	pushl %ebp
	movl %esp, %ebp
	
	pushl %esi
	pushl %edi
	pushl %ecx
	pushl %ebx
	
	movl 8(%ebp), %esi	#v_semn
	movl 12(%ebp), %edi	#v
	movl 16(%ebp), %ecx	#-1
	
	incl %ecx	#ecx=0
	movl %ecx, aux
	movl (%edi, %ecx, 4), %ebx	#valoarea curenta este in ebx

	cmp nr_elem, %ecx
	je final_backtracking
	
	cmp $0, %ebx
	jne final_backtracking_1
	
	movl %ecx, nr
	
	xorl %ecx, %ecx
	incl %ecx
	jmp for_backtracking
	
for_backtracking:
	movl n, %ebx
	
	cmp %ebx, %ecx
	jg contfor2_0
	
	pushl nr
	
	//verificam daca se respecta ambele conditii
	pushl %edi
	pushl %ecx
	call valid
	popl %ecx
	popl %edi
	
	popl nr
	
	cmp $0, %eax	
	je contfor2_1
	
	addl $1, %ecx
	jmp for_backtracking
	
contfor2_0:	
	movl aux, %ecx
	decl %ecx
	jmp for_contfor2_0
	
for_contfor2_0:
	cmp $-1, %ecx
	jne et1
	
	//%ecx=-1, astfel backtracking va returna valoarea lui %ecx(-1) prin %eax
	movl %ecx, %eax
	jmp final_backtracking
	
et1: 			
	movl (%esi, %ecx, 4), %ebx	#elem curent din vectorul v_semn
	cmp $0, %ebx		#verificam daca elem este 0
	je et2
	
	decl %ecx
	jmp for_contfor2_0			

et2:
	movl %ecx, nr
	movl aux, %ecx
	
	movl $0, (%edi, %ecx, 4)
	
	movl nr, %ecx
	movl %ecx, aux
	
	movl (%edi, %ecx, 4), %ecx	
	
	incl %ecx
	jmp for_backtracking
	
contfor2_1:		
	movl %ecx, %ebx
	movl aux, %ecx
	
	movl %ebx, (%edi, %ecx, 4)
	jmp final_backtracking_1
	
final_backtracking_1:			
	movl aux, %ecx
	
	//recursivitate backtracking
	pushl %ecx
	pushl %edi
	pushl %esi
	call backtracking
	popl %esi
	popl %edi
	popl %ecx
	
	jmp final_backtracking
	
final_backtracking:
	popl %ebx
	popl %ecx
	popl %edi
	popl %esi
	popl %ebp
	ret

.global main

main:				
	movl $v, %edi
	movl $v_semn, %esi
	
	//citire input; n m 3*n numere
	pushl $input
	pushl $formatScanf
	call scanf
	popl %ebx
	popl %ebx
	
	//strtok(input, " ")
	pushl $delim
	pushl $input
	call strtok
	popl %ebx
	popl %ebx

	//atoi(%eax) -> n
	pushl %eax
	call atoi
	popl %ebx
	
	movl %eax, n
	
	//strtok(NULL, " ")
	pushl $delim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	//atoi(%eax) -> m
	pushl %eax
	call atoi
	popl %ebx
	movl %eax, m
	
	//nr_elem = n * 3
	xorl %edx, %edx
	movl n, %eax
	movl $3, %ebx
	mull %ebx
	movl %eax, nr_elem
	
	xorl %ecx, %ecx
	
for_citire:
	pushl %ecx
	
	//strtok(NULL, " ")
	pushl $delim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx
	
	popl %ecx
	
	pushl %ecx
	
	//atoi(%eax)
	pushl %eax
	call atoi
	popl %ebx
	
	popl %ecx
	
semnalizare:
	//punem nr in vector v
	movl %eax, (%edi, %ecx, 4)	
	
	//verificam daca elementul este 0
	cmp $0, %eax
	je cont_semn_0	
	
	movl $1, (%esi, %ecx, 4)
	jmp cont_semnalizare
	
cont_semn_0:
//intr-un vector semnalizare v_semn->contine doar 1 si 0
	movl $0, (%esi, %ecx, 4)
	jmp cont_semnalizare
	
cont_semnalizare:
	incl %ecx
	cmp nr_elem, %ecx
	jl for_citire

	//apelam backtracking de vector de -1
	pushl $-1
	pushl %edi
	pushl %esi	
	call backtracking
	popl %ebx
	popl %ebx
	popl %ebx
	
	cmp $-1, %eax
	jne afisare
	
	//daca backtrackingul returneaza -1
	//afiseaza -1 pentru cazul -nu exista- (exceptie="nu exista")
	pushl $exceptie
	pushl $formatPrintf2
	call printf
	popl %ebx
	popl %ebx
	
	jmp exit
	
afisare:
	//daca s-a gasit o permutare, afisam vectorul de la pozitia 0 in colo
	movl $0, %ecx
	jmp cont_afisare
	
cont_afisare:
	//mutam valoarea elementului curent din vector in eax
	movl (%edi, %ecx,4), %eax
	
	pushl %ecx
	
	//afisam elementul
	pushl %eax
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	popl %ecx
	
	addl $1, %ecx
	cmp nr_elem, %ecx
	jl cont_afisare
	jmp exit
	
exit:
	pushl $nl
	call printf
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
