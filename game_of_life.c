#include <stdio.h>
#include <stdlib.h>

void start(int width, int height, char *T);
void run();
void cleanup();

char *T;
int width, height;

int load_input_file(char *filename) {
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

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
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

void print_T() {
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            printf("%c", T[y*width + x]);
        }
        printf("\n");
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: game_of_life ./input\n");
        return 1;
    }

    if (load_input_file(argv[1]) != 0) {
        return 2;
    }

    start(width, height, T);
    for (int i = 0; i < 1; i++) {
        run();
        print_T();
    }
    cleanup();

    free(T);

    return 0;
}
