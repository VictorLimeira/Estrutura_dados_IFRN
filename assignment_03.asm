	# IFRN
	# Exercicio Estrutura de dados - impelementacao de deque
	# Funcoes: Push_top, Pop_top, push_base, pop_base, Size, Pico, show_all, clean
	# Aluno: Mannuel Victor Di Pace Maroja Limeira
	# Matricula: 20121014040067
	.data
	
list: 		.space 1000
menu:		.asciiz "\nEcolha uma opcao abaixo:\n1 - PUSH_Base | 2 - PUSH_Top | 3 - POP_Base | 4 - POP_top | 5 - SIZE | 6 - PICO | 7 - SHOW ALL | 8 - CLEAN\n0 - sair\n"
menu_ins_base:	.asciiz "\nInsira o numero para push_base():\n"
menu_ins_top:	.asciiz "\nInsira o numero para push_top():\n"
pre_size:	.asciiz "\nNumeros de elementos na fila: "
popb_mensagem:	.asciiz "\nElemento retirado da base do deque: "
popt_mensagem:	.asciiz "\nElemento retirado do top do deque: "
elementos_fila:	.asciiz "\nOs elementos do deque sao: "
pico_mensagem:	.asciiz "\nOs proximos elementos para sair do deque sao \"base top\": "
fila_vazia_msg:	.asciiz "\nO deque esta vazio. "
clean_mensagem:	.asciiz "\nO dque foi esvaziado. "
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
		beq $t0, 1, push_base	# Opcao 1 , PUSH
		beq $t0, 2, push_top	# Opcao 1 , PUSH_top (pilha)
		beq $t0, 3, pop_base	# Opcao 2 , POP
		beq $t0, 4, pop_top	# Opcao 1 , POP_base (pilha)
		beq $t0, 5, size	# Opcao 3 , SIZE
		beq $t0, 6, pico	# Opcao 4, PICO
		beq $t0, 7, show_all	# Opcao 5, SHOW_ALL
		beq $t0, 8, clean	# Opcao 6, CLEAN
		j menu_inicio		# Nenhuma opcao encontrada, volta para o inicio do menu

################################ PUSH_base ################################

push_base:	li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_ins_base	# Carregar endereco de menu_ins no $a0
		syscall 		# Chamada
		
		beq $s1, $s2, just_push	# Testa se deque esta vazio, se sim somente insere na base

arrumar_back:	la $t1, ($s2)		# Carrega o primeiro endereco para ser ordenado em $t1

loop_arrumar_back:
		addi $t1, $t1, -4	# Proxima posicao do elemento a ser movido
		lb $t2, ($t1)		# Salva elemento para ser movido em $t2
		sw $t2, 4($t1)		# Salva elemento em posicao correta
		
		bne $t1, $s1, loop_arrumar_back	# LOOP para arrumar se nao chegou no final do deque
		
		j just_push			# Sai da função e adiciona o elemento, deque ja reordenado
		

just_push:	
		li $v0, 5		# Chamada de sistema para ler inteiro = 5
		syscall			# Chamada
		move $t2, $v0		# Coloca o numero em $t2
		
		sw $t2, ($s1)		# Aloca a entrada do usuario ($t2) no endereco $s1 (base do deque)
		addi $s0, $s0, 1 	# Conta mais um elemento no array
		
		addi $s2, $s2, 4	# Incrementa $s2 para a posicao correta para adicionar proximo elemento no top do deque
		
		j menu_inicio		# Volta para o menu
################################ PUSH_base FIM ################################
#------------------------------------------------------------------------#
################################ POP_base ################################

pop_base:		
		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem

		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, popb_mensagem	# Carregar endereco de popb_mensagem no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, ($s1)		# Carrega o ultimo elemento do deque em $a0
		syscall 		# Chamada
		
		jal arrumar		# Funcao para organizar o deque
		addi $s0, $s0, -1	# Decrementa contagem de elementos
		
		j menu_inicio		# Vai para o inicio do menu
		
arrumar:	
		la $t1, -4($s2)		# Testar um elemento do deque
		beq $s1, $t1, inicializador	# Somente um elemento detectado, limpar deque
		la $t1, 4($s1)		# Elemento para jogar no anterior
		la $t3, list		# Posicao correta do elemento

loop_arrumar:
		lb $t2, ($t1)		# Salva elemento para ser movido
		sw $t2, ($t3)		# Salva elemento em posicao correta
		addi $t1, $t1, 4	# Proxima posicao do elemento a ser movido
		addi $t3, $t3, 4	# Proxima posicao para salvar o elemento
		
		bne $t1, $s2, loop_arrumar	# LOOP para arrumar se nao chegou no final do deque
		addi $s2, $s2, -4		# Decrementa o fim do deque
		
		jr $ra			# Volta da funcao
		
################################ POP_base FIM ################################
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
		lw $a0, ($s1)		# Carrega o ultimo elemento da base do deque em $a0
		syscall 		# Chamada
		
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, space_char	# Carregar endereco de space char no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, -4($s2)		# Carrega o ultimo elemento do top do deque em $a0
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
################################ SHOW_ALL FIM ################################
#------------------------------------------------------------------------#
################################ FILA VAZIA ################################		
fila_vazia:	
		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, fila_vazia_msg	# Carregar endereco de fila_vazia no $a0
		syscall 		# Chamada
		
		j menu_inicio		# Retorna para o menu inicial


################################ FILA VAZIA FIM ################################
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
################################ PUSH_Top ################################

push_top:	li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, menu_ins_top	# Carregar endereco de menu_ins_top no $a0
		syscall 		# Chamada

		li $v0, 5		# Chamada de sistema para ler inteiro = 5
		syscall			# Chamada
		move $t2, $v0		# Coloca o numero em $t2
		
		sw $t2, ($s2)		# Aloca a entrada do usuario ($t2) no endereco $s2 (na fila)
		addi $s2, $s2, 4 	# Ja incremeta $s2 para uma proxima entrada de inteiro
		addi $s0, $s0, 1 	# Conta mais um elemento no array
		
		j menu_inicio		# Volta para o menu
################################ PUSH_Top FIM ################################
#------------------------------------------------------------------------#
################################ POP_Top ################################

pop_top:		
		beq $s1, $s2, fila_vazia	# Testa se fila esta vazia e imprime mensagem

		li $v0, 4		# Chamada de sistema para imprimir string = 4
		la $a0, popt_mensagem	# Carregar endereco de popt_mensagem no $a0
		syscall 		# Chamada
		
		li $v0, 1		# Chamada de sistema para imprimir inteiro = 1
		lw $a0, -4($s2)		# Carrega o ultimo elemento do deque em $a0
		syscall 		# Chamada
		
		addi $s2, $s2, -4	# Retira o elemento do top
		addi $s0, $s0, -1	# Decrementa um elemento do deque
		
		j menu_inicio		# Vai para o inicio do menu
################################ POP_Top FIM ################################
#------------------------------------------------------------------------#
################################ SAIDA ################################
		
saida:		li $v0, 10		# command to exit
		syscall
