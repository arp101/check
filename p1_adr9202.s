 	.global main
    	.func main

main:
    BL  _pr                 
    BL  _scanf              
    MOV R4, R0              

    BL  _pr2                
    BL  _scanf2            
    MOV R5, R0             

    BL  _pr                 
    BL  _scanf              
    MOV R6, R0              

    MOV R1, R4		    
    MOV R2, R5
    MOV R3, R6              
    BL  _comp               @ branch to compare procedure
    MOV R1, R0              
    BL  _result            
    B   main                


_pr:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #16             @ print string length
    LDR R1, =prompt         @ string at label prompt
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_pr2:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #17             @ print string length
    LDR R1, =prompt2        @ string at label prompt2
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

_result:
    MOV R7, LR              @ store LR since printf call overwrites
    LDR R0, =result         @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R7              @ return

_comp:
    CMP R2, #'+'            @ compare against the constant char '+'
    BEQ _sum                 @ branch to equal handler
    CMP R2, #'-'            @ compare against the constant char '-'
    BEQ _difference          @ branch to equal handler
    CMP R2, #'*'            @ compare against the constant char '*'
    BEQ _product             @ branch to equal handler
    CMP R2, #'M'            @ compare against the constant char 'M'
    BEQ _maximum             @ branch to equal handler
    MOV PC, LR

_sum:
    MOV R9, LR
    ADD R0, R1, R3          
    MOV PC, R9            

_difference:
    SUB R0, R1, R3          
    MOV PC, LR

_product:
    MUL R0, R1, R3         
    MOV PC, LR

_maximum:
    CMP R1, R3              
    MOVLE R1, R3            
    MOV R0, R1            
    MOV PC, LR


_scanf:
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, LR              @ return


_scanf2:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =char           @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return


.data
format_str:     .asciz      "%d"
prompt:         .ascii      "Enter a number: "
prompt2:        .ascii      "Enter character: "
result:         .asciz      "The answer is: %d\n"
char:           .ascii      " "
