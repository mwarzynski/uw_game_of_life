# Game of Life (ARM Assembly)

In this task we will deal with the "game of life", but this time we will work on ARM (or more precisely - emulator for ARM).

Our goal will be to write functions that simulate the Conway cellular automaton, so-called "game of life".
The game takes place on a rectangular board consisting of square cells. Each cell can be alive or dead.


## Description

The time is discrete. At every step of the simulation:
 - Any living cell that has 4 or more living neighbors "dies" due to crowd.
 - Every living cell that has less than 2 neighbors "dies" from loneliness.
 - If a dead cell has exactly 3 living neighbors, it becomes alive.
 - By the neighbors of the cell we understand 8 cells directly surrounding it.

The part written in the internal language should export procedures called from C:

Prepares the simulation:
```c
void start(int width, int height, char *T)
```

Performs one step of the simulation, after its execution the array `T` contains a new state:
```c
void run()
```

The exact internal form of the `T` array is not specified, but it should be possible to easily initialize it in the program in C by loading the initial content from a file containing:
 - number of columns (width) and rows (height) in the first row;
 - In the following lines, rows of the `T` array in the form of zeros (dead cell) and ones (live cell), separated by single spaces.

The main program written in C should initialize the `T` array and start the simulation. Each time you call the run procedure, the current situation should be displayed - it can be plaintext, i.e., asterisks and spaces. The program should receive the file name and number of steps as arguments.

