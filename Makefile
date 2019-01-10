compile:
	@as simulation.s -o simulation.o
	@gcc -Wall -Wextra -static game_of_life.c simulation.o -o game_of_life

clean:
	@rm simulation.o

