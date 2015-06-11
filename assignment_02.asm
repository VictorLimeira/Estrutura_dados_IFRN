	# IFRN
	# Exercicio Estrutura de dados - impelementacao de fila
	# Funcoes: Push, Pop, Size, Pico, show_all, clean
	# Aluno: Mannuel Victor Di Pace Maroja Limeira
	# Matricula: 20121014040067
	.data
	
list: 		.space 1000
menu:		.asciiz "\nEcolha uma opcao abaixo:\n1 - PUSH | 2 - POP | 3 - SIZE | 4 - PICO | 5 - SHOW ALL | 6 - CLEAN\n0 - sair\n"
menu_ins:	.asciiz "\nInsira o numero para push():\n"
pre_size:	.asciiz "\nNumeros de elementos na fila: "
pop_mensagem:	.asciiz "\nElemento retirado da fila: "
elementos_fila:	.asciiz "\nOs elementos da fila sao: "
pico_mensagem:	.asciiz "\nO proximo elemento para sair da fila é: "
fila_vazia_msg:	.asciiz "\nA fila esta vazia. "
clean_mensagem:	.asciiz "\nA fila foi esvaziada. "
space_char:	.ascii " "

	.text
	# $s0 = Contagem de elementos
	# $s1 = endereco inicial da fila
	# $s2 = Endereco do final da fila
main:

inicializador:	
		la $s1, list		# $s1 = endereco do array
		li $s0, 0		# $s0 = # de elementos (size)
		la $s2, list		# $s2 = fim da fila
		
menu_inicio:	li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu		# Carregar endereco de menu no $a0
		syscall 		# Chamada
		
		li $v0, 5 		# Carregar interger do usuario para $v0
		syscall 		# Chamada
		move $t0, $v0		# Move o inteiro opcao do usuario para $t0
		
		#testa entrada
		beqz $t0, saida		# Opcao 0 , saida
		beq $t0, 1, push	# Opcao 1 , PUSH
		beq $t0, 2, pop		# Opcao 2 , POP
		beq $t0, 3, size	# Opcao 3 , SIZE
		beq $t0, 4, pico	# Opcao 4, PICO
		beq $t0, 5, show_all	# Opcao 5, SHOW_ALL
		beq $t0, 6, clean	# Opcao 6, CLEAN
		j menu_inicio		# Nenhuma opcao encontrada, volta para o inicio do menu

################################ PUSH ################################

push:		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_ins	# Carregar endereco de menu_ins no $a0
		syscall 		# Chamada

		li $v0, 5		# Chamada de sistema para ler inteiro = 5
		syscall			# Chamada
		move $t2, $v0		# Coloca o numero em $t2
		
		sw $t2, ($s2)		# Aloca a entrada do usuario ($t2) no endereco $s2 (na fila)
		addi $s2, $s2, 4 	# Ja incremeta $s2 para uma proxima entrada de inteiro
		addi $s0, $s0, 1 	# Conta mais um elemento no array
		
		j menu_inicio		# Volta para o menu
################################ PUSH FIM ################################
#------------------------------------------------------------------------#
################################ POP ################################

pop:		
		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem

		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, pop_mensagem	# Carregar endereco de pop_mensagem no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, ($s1)		# Carrega o ultimo elemento da fila em $a0
		syscall 		# Chamada
		
		jal arrumar		# Funcao para organizar a fila
		addi $s0, $s0, -1	# Decrementa contagem de elementos
		
		j menu_inicio		# Vai para o inicio do menu
		
arrumar:	la $t1, 4($s1)		# Elemento para jogar no anterior
		la $t3, list		# Posicao correta do elemento

loop_arrumar:
		lb $t2, ($t1)		# Salva elemento para ser movido
		sw $t2, ($t3)		# Salva elemento em posicao correta
		addi $t1, $t1, 4	# Proxima posicao do elemento a ser movido
		addi $t3, $t3, 4	# Proxima posicao para salvar o elemento
		
		bne $t1, $s2, loop_arrumar	# LOOP para arrumar se nao chegou no final da fila
		addi $s2, $s2, -4		# Decrementa o fim da fila
		
		jr $ra			# Volta da funcao

################################ POP FIM ################################
#------------------------------------------------------------------------#
################################ SIZE ################################

size:		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, pre_size	# Carregar endereco de pre_size no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		la $a0, ($s0)		# Carregar endereco da contagem de elementos ($t3) no $a0
		syscall 		# Chamada
		
		j menu_inicio		# Vai para o inicio do menu
################################ SIZE FIM ################################
#------------------------------------------------------------------------#
################################ PICO ################################
pico:		
		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem

		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, pico_mensagem	# Carregar endereco de pico_mensagem no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, ($s1)		# Carrega o ultimo elemento da fila em $a0
		syscall 		# Chamada
		
		j menu_inicio		# Retorna para o menu

################################ PICO FIM ################################
#------------------------------------------------------------------------#
################################ SHOW_ALL ################################
show_all:		
		
		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem
		
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, elementos_fila	# Carregar endereco de pop_mensagem no $a0
		syscall 		# Chamada
		
		la $t1, ($s1)		# Inicio da fila
loop_showall:
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, ($t1)		# Carrega o ultimo elemento da pilha em $a0
		syscall 		# Chamada
		
		li $v0, 4		# Chamada de sistema para imprimir inteiro = 4
		la $a0, space_char	# Carrega o digito de space_char
		syscall 		# Chamada
		
		addi $t1, $t1, 4	# Proximo elemento a ser impresso
		
		bne $t1, $s2, loop_showall 	# Se nao chegou ao final da fila, imprime o proximo
		
		j menu_inicio		# Chegou ao final da fila, ir ao menu
		
fila_vazia:	
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, fila_vazia_msg	# Carregar endereco de fila_vazia no $a0
		syscall 		# Chamada
		
		j menu_inicio		# Retorna para o menu inicial


################################ SHOW_ALL FIM ################################
#------------------------------------------------------------------------#
################################ CLEAN ################################
clean:

		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem
		
		la $s2, list		# Seta $s2 para ser o inicio da fila, zerando seus componentes
		li $s0, 0		# Zera contagem de elementos
		
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, clean_mensagem	# Carregar endereco de clena_mensagem no $a0
		syscall 		# Chamada
		
		j menu_inicio

################################ CLEAN FIM ################################
#------------------------------------------------------------------------#
################################ SAIDA ################################
		
saida:		li $v0, 10		# command to exit
		syscall
