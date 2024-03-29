/*
    Simple LED Fading without PWM
*/

.section .rodata
total_time: .word 5000

.section .data
on_time:    .word 0

.section .text

.equ RCC_APB2ENR, 0x40021018
.equ GPIOC_CRH, 0x40011004
.equ GPIOC_BSRR, 0x40011010

.global main
main:
    ldr r0, =RCC_APB2ENR    // Clock Configuration (reference manual page 112)
    ldr r2, =0x10
    str r2, [r0]

    ldr r0, =GPIOC_CRH      // Pin Configuration as OUTPUT (reference manual page 172)
    ldr r2, =0x44344444
    str r2, [r0]

    mov r7, #1             // Rising or falling to be stored in a register
superloop:

    bl wait0
    ldr r0, =GPIOC_BSRR     // Reset Pin PC13 (reference manual page 173)
    ldr r1, =0x20000000
    str r1, [r0]
    bl wait1
    ldr r0, =GPIOC_BSRR     // Set Pin PC13 (reference manual page 173)
    ldr r1, =0x2000
    str r1, [r0]

    ldr r6, =total_time
    ldr r6, [r6]

    ldr r5, =on_time
    ldr r4, [r5]

    cmp r7, #0
    bne falling
rising:
    add r4, r4, #10
    str r4, [r5]

    cmp r4, r6
    ble superloop
    //
    mov r4, r6
    str r4, [r5]
    mov r7, #1

    b superloop
falling:
    sub r4, r4, #10
    str r4, [r5]

    cmp r4, #0
    bgt superloop
    //

    mov r4, #0
    str r4, [r5]

    mov r7, #0

    b superloop


wait0:
    ldr r4, =total_time         // Some software delay, changing this value changes the delay
    ldr r4, [r4]
    ldr r5, =on_time
    ldr r5, [r5]
    sub r4, r4, r5
    b loop
wait1:
    ldr r4, =on_time         // Some software delay, changing this value changes the delay
    ldr r4, [r4]
    //b loop
loop:
    sub r4, r4, #1
    cmp r4, #0
    bgt loop
    bx lr
