.section .interrupt_vectors

interrupt_vectors:
    .word _end_of_ram       // Supplied by the linker
    .word Reset_Handler     // This function has to be specified as .thumb_func


.section .text.startup
.global Reset_Handler
.thumb_func
Reset_Handler:
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
loop:
    sub r4, r1, r2
    cmp r4, #0
    beq done
    ldr r3, [r0]
    str r3, [r1]
    add r0, r0, #4
    add r1, r1, #4
    b loop
done:
    bl main
halt:
    b halt
