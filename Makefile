CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

SOURCES=src/startup.s src/main.s

flash: main.bin
	st-flash write main.bin 0x08000000

main.bin: build
	$(OBJCOPY) -O binary -j .text -j .data main.elf main.bin

build: clean main.elf

main.elf: src/startup.s linker.ld
	$(CC) -ggdb -nostdlib -mapcs-frame -Os -Wall -mthumb -mcpu=cortex-m3 -Tlinker.ld -o main.elf $(SOURCES)

clean:
	rm -f main.elf main.o main.bin