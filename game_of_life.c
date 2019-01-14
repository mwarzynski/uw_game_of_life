#include <stdio.h>
#include <stdlib.h>

void start(int width, int height, char *T);
void run();
void stop();

char *T;
int width, height;

int load_data(char *filename) {
    FILE *f;
    f = fopen(filename, "r");
    if (f == NULL) {
        perror("couldn't open input file");
        return 1;
    }

    if (fscanf(f, "%d %d\n", &width, &height) <= 0) {
        printf("couldn't parse width or height in the first line\n");
        fclose(f);
        return 1;
    }

    T = malloc(sizeof(char)*width*height);
    if (T == NULL) {
        perror("couldn't allocate memory for the board");
        fclose(f);
        return 1;
    }

    int x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            if (fscanf(f, "%c", &T[y*width + x]) <= 0) {
                printf("couldn't parse board, allowed values (0,1)\n");
                fclose(f);
                free(T);
                return 1;
            }
            if (fscanf(f, "\n") < 0) {
                perror("couldn't parse board");
                fclose(f);
                free(T);
                return 1;
            }
        }
    }

    return 0;
}

void unload_data() {
    free(T);
}

void print_T() {
    int x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            printf("%c", T[y*width + x]);
        }
        printf("\n");
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Usage: game_of_life ./input steps\n");
        return 1;
    }
    int steps = atoi(argv[2]);
    if (steps <= 0) {
        printf("Number of steps must be positive.\n");
        return 1;
    }
    if (load_data(argv[1]) != 0) {
        return 2;
    }

    start(width, height, T);
    int i;
    for (i = 0; i < steps; i++) {
        run();
        print_T();
    }
    stop();

    unload_data(T);
    return 0;
}
