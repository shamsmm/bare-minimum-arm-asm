ENTRY(main)

MEMORY
{
    /* The bluepill memory map and sizes */
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 128K
    RAM   (rwx) : ORIGIN = 0x20000000, LENGTH = 20K
}

SECTIONS
{
    .text : {
        . = 0;

        KEEP(*(.interrupt_vectors))

        /* The whole interrupt table is 304 bytes long. */
        . = 304;

        *(.text*)
    } > FLASH = 0xFF

    _end_of_ram = ORIGIN(RAM) + LENGTH(RAM); /* Define a symbol for the end of ram to be referenced in assembly */
}
