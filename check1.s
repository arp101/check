    .global main
    .func main

main:
	MOV R0,#0
	MOV R8,#0
writeloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ writedone           @ exit loop if done
	PUSH {R0}
	PUSH {R1}
	BL _scanf
	MOV R4,R0
	ADD R8,R0,R8
	POP {R1}
	POP {R0}
    LDR R1, =array_a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    STR R4, [R2]            @ write the address of a[i] to a[i]
	ADD R0, R0, #1          @ increment index
    B   writeloop           @ branch to next loop iteration
writedone:
    MOV R0, #0              @ initialze index variable
readloop:
    CMP R0, #10            @ check to see if we are done iterating
    BEQ readdone            @ exit loop if done
    LDR R1, =array_a              @ get address of a
    LSL R2, R0, #2          @ multiply index*4 to get array offset
    ADD R2, R1, R2          @ R2 now has the element address
    LDR R1, [R2]            @ read the array at address 
    PUSH {R0}               @ backup register before printf
    PUSH {R1}               @ backup register before printf
    PUSH {R2}               @ backup register before printf
    MOV R2, R1              @ move array value to R2 for printf
    MOV R1, R0              @ move array index to R1 for printf
    BL  _printf             @ branch to print procedure with return
    POP {R2}                @ restore register
    POP {R1}                @ restore register
    POP {R0}                @ restore register
    ADD R0, R0, #1          @ increment index
    B   readloop            @ branch to next loop iteration
readdone:
	BL _min
	BL _max
	MOV R1,R8
	BL _printf_sum
    B _exit                 @ exit if done

_max:
	PUSH {LR}
	MOV R0,#0
	LDR R1,=array_a
	LSL R2,R0,#2
	ADD R2,R2,R1
	LDR R2,[R2]
maxloop:
	ADD R0,R0,#1
	CMP R0,#10
	BEQ maxdone
	LSL R3,R0,#2
	ADD R3,R1,R3
	LDR R3,[R3]
	CMP R3,R2
	MOVGT R2,R3
	B maxloop
maxdone:
	MOV R1,R2
	BL _printf_max
	POP {PC}

_min:
	PUSH {LR}
	MOV R0,#0
	LDR R1,=array_a
	LSL R2,R0,#2
	ADD R2,R2,R1
	LDR R2,[R2]
minloop:
	ADD R0,R0,#1
	CMP R0,#10
	BEQ mindone
	LSL R3,R0,#2
	ADD R3,R1,R3
	LDR R3,[R3]
	CMP R3,R2
	MOVLT R2,R3
	B minloop
mindone:
	MOV R1,R2
	BL _printf_min
	POP {PC}	

_exit:  
    MOV R7, #4              @ write syscall, 4
    MOV R0, #1              @ output stream to monitor, 1
    MOV R2, #21             @ print string length
    LDR R1, =exit_str       @ string at label exit_str:
    SWI 0                   @ execute syscall
    MOV R7, #1              @ terminate syscall, 1
    SWI 0                   @ execute syscall
       
_printf:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_str     @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_sum:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_sum_str @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
   
_printf_min:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_min_str @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return

_printf_max:
    PUSH {LR}               @ store the return address
    LDR R0, =printf_max_str @ R0 contains formatted string address
    BL printf               @ call printf
    POP {PC}                @ restore the stack pointer and return
      

_scanf:
    PUSH {LR}              @ store LR since scanf call overwrites
    SUB SP, SP, #4          @ make room on stack
    LDR R0, =format_str     @ R0 contains address of format string
    MOV R1, SP              @ move SP to R1 to store entry on stack
    BL scanf                @ call scanf
    LDR R0, [SP]            @ load value at SP into R0
    ADD SP, SP, #4          @ restore the stack pointer	
	POP {LR}    
	MOV PC, LR              @ return 

.data

.balign 4
array_a:        .skip       40
printf_str:     .asciz      "array_a[%d] = %d\n"
printf_sum_str: .asciz 		"sum = %d\n"
printf_min_str: .asciz		"minimum = %d\n"
printf_max_str: .asciz		"maximum = %d\n"
format_str:		.asciz		"%d"
exit_str:       .ascii      "Terminating program.\n"
