.section .interrupt_vectors

interrupt_vectors:
    .word _end_of_ram       // Supplied by the linker
    .word main              // This function has to be specified as .thumb_func

.section .text

.equ RCC_APB2ENR, 0x40021018
.equ GPIOC_CRH, 0x40011004
.equ GPIOC_BSRR, 0x40011010

.thumb_func
.global main
main:
    ldr r0, =RCC_APB2ENR    // Clock Configuration (reference manual page 112)
    ldr r2, =0x10
    str r2, [r0]

    bl wait

    ldr r0, =GPIOC_CRH      // Pin Configuration as OUTPUT (reference manual page 172)
    ldr r2, =0x44344444
    str r2, [r0]
    bl wait
superloop:
    bl wait
    ldr r0, =GPIOC_BSRR     // Reset Pin PC13 (reference manual page 173)
    ldr r1, =0x20000000
    str r1, [r0]
    bl wait
    ldr r0, =GPIOC_BSRR     // Set Pin PC13 (reference manual page 173)
    ldr r1, =0x2000
    str r1, [r0]
    b superloop

.thumb_func
wait:
    ldr r4, =100000         // Some software delay, changing this value changes the delay
loop:
    sub r4, r4, #1
    cmp r4, #0
    bne loop
    bx lr
