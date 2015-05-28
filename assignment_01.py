# Exercicio 1 - pilha
#
# ---------------------------------------------
# <nome>, <matricula>
# Mannuel Victor Di Pace Maroja Limeira, dipacema
# ---------------------------------------------
# Incluir stack.py
from stack import Stack


pilha_calculo = Stack()
pilha_op = Stack()

def add_op_n1(op):
    if pilha_op.is_empty():
        pilha_op.push(op)
        return
    
    last = pilha_op.pop()
    pilha_op.push(last)
    
    if last is ("+" or "-"):
        pilha_op.push(op)
        return
    
    if last is ("*" or "/"):
        clean_op()
        pilha_op.push(op)
        return
    
    if last is "(":
        pilha_op.push(op)
        return

def clean_op():
    while not pilha_op.is_empty():
        letra = pilha_op.pop()
        if letra is "(":
            pilha_op.push(letra)
            return
        else:
            pilha_calculo.push(letra)
    
    return

def add_op_n2(op):
    pilha_op.push(op)
    return

def clean_op_p():
    
    while True:
        letra = pilha_op.pop()
        if letra is "(":
            return
        else:
            pilha_calculo.push(letra)
    
    return

def print_calculo():
    temp = Stack()
    calculo = ""
    
    while not pilha_calculo.is_empty():
        temp.push(pilha_calculo.pop())
    
    while not temp.is_empty():
        calculo = calculo + temp.pop()
    
    print(calculo)

#------------------------ main ---------------------#

while True:
    print("")
    entrada = input("Digite o calculo: ")
    
    for letra in entrada:
        if letra is "(":
            pilha_op.push(letra);
        elif letra is ")":
            clean_op_p()
        elif letra is "+":
            add_op_n1(letra)
        elif letra is "-":
            add_op_n1(letra)
        elif letra is "*":
            add_op_n2(letra)
        elif letra is "/":
            add_op_n2
        else:
            pilha_calculo.push(letra)
            
    
    clean_op()
    print("Forma pos fixada: ", end = "")
    print_calculo()
    print("")
