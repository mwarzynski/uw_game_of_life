compile:
	@arm-linux-gnueabi-as simulation.s -o simulation.o
	@arm-linux-gnueabi-gcc -Wall -no-pie -Wextra -static game_of_life.c simulation.o -o game_of_life

clean:
	@rm simulation.o
