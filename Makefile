copy:
	@cp game_of_life.c build/
	@cp simulation.s build/
	@echo "TODO: Remove 'copy' directive."

compile:
	@arm-linux-gnueabi-as simulation.s -o simulation.o
	@arm-linux-gnueabi-gcc -Wall -no-pie -Wextra -static game_of_life.c simulation.o -o game_of_life

clean:
	@rm simulation.o

# echo "TODO: Remove 'useful' commands."
# qemu-arm -g 1234 ./build/game_of_life
# aarch64-linux-gnu-gdb ./build/game_of_life
