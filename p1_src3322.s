
    .global main
    .func main
   
main:
    BL  _prompt             @ branch to _prompt procedure with return
    BL  _scanf              @ branch to _scanf procedure with return
    MOV R4, R0              @ move return value R0 to argument register R4
 
    BL  char_prompt         @ branch to char_prompt procedure with return
    BL  _getchar	        @ brach to _getchar procedure with return
    MOV R5, R0              @ move return value R0 to argument register R5
 
    BL  _prompt             @ branch to _prompt procedure with return
    BL  _scanf              @ branch to _scanf procedure with return
    MOV R6, R0              @ move return value R0 to argument register R6
 
    MOV R1, R4              @ move value from register R4 to register R1
    MOV R2, R5              @ move value from register R5 to R2
    MOV R3, R6              @ move value from register R6 to R3
    BL  _compare            @ branch to _compare procedure with return
    MOV R1, R0              @ move return value R0 to R1
    BL  _ans_printf         @ branch to _ans_printf procedure with return
    
    B   main                @ branch to main procedure with no return
   
   
_prompt:
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #31             @ print string length
    LDR R1, =prompt_str     @ string at label prompt_str:
    SWI 0                   @ execute syscall
    MOV PC, LR              @ return

char_prompt:
    MOV R7, #4 		        @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #29             @ print string length
    LDR R1, =cprompt_str    @ string at label cprompt_str
    SWI 0		            @ execute syscall
    MOV PC, LR 		        @ return    


_ans_printf:
    MOV R7, LR              @ store LR since printf call overwrites
    LDR R0, =answer_str     @ R0 contains formatted string address
    MOV R1, R1              @ R1 contains printf argument (redundant line)
    BL printf               @ call printf
    MOV PC, R7              @ return

_compare:
    CMP R2, #'+'	    @ compare against the constant char '+'
    BEQ sum             @ branch to equal handler
    CMP R2, #'-'	    @ compare against the constant char '-'
    BEQ difference	    @ branch to equal handler
    CMP R2, #'*'	    @ compare against the constant char '*'
    BEQ product	        @ branch to equal handler
    CMP R2, #'M'	    @ compare against the constant char 'M'
    BEQ maximum	    	@ branch to equal handler
    MOV PC, LR

sum:
    MOV R7, LR
    ADD R0, R1, R3	    @ R0 = R1 + R3
    MOV PC, R7		    @ return

difference:
    MOV R7, LR
    SUB R0, R1, R3          @ R1 - R3 = R0
    MOV PC, R7              @ return

product:
    MOV R7, LR
    MUL R0, R1, R3          @ R0 = R1*R3
    MOV PC, R7              @ return

maximum:      
    MOV R7, LR         
    CMP R1, R3              @ compare R1, R3
    MOVLE R1, R3            @ overwrite R1 with R3 if R1 is lesser than or equal to R3
    MOV R0, R1              @ move the value from reg R1 to reg R0	    
    MOV PC, R7              @ return


_scanf:
    MOV R7, LR              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer
    MOV PC, R7              @ return
   

_getchar:
    MOV R7, #3              @ write syscall, 3
    MOV R0, #0              @ input stream from monitor, 0
    MOV R2, #1              @ read a single character
    LDR R1, =read_char      @ store the character in data memory
    SWI 0                   @ execute the system call
    LDR R0, [R1]            @ move the character to the return register
    AND R0, #0xFF           @ mask out all but the lowest 8 bits
    MOV PC, LR              @ return
    

.data
format_str:     .asciz      "%d"
prompt_str:     .ascii      "Type a number and press enter: "
cprompt_str:    .ascii      "Enter any +,-,*,M character: "
answer_str:	    .asciz	    "The answer is: %d\n"
read_char:      .ascii      " "
