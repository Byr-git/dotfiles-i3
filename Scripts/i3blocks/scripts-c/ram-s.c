#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define STATE_FILE "/tmp/i3blocks_ram_mode"

int main(void) {
    FILE *fp = fopen("/proc/meminfo", "r");
    if (!fp) {
        perror("Error abriendo /proc/meminfo");
        return 1;
    }

    long total = 0, free = 0;
    long buffers = 0, cached = 0;
    long sreclaimable = 0, shmem = 0;

    char key[32];
    long value;
    char unit[8];

    while (fscanf(fp, "%31s %ld %7s", key, &value, unit) == 3) {
        if      (!strcmp(key, "MemTotal:"))     total = value;
        else if (!strcmp(key, "MemFree:"))      free = value;
        else if (!strcmp(key, "Buffers:"))      buffers = value;
        else if (!strcmp(key, "Cached:"))       cached = value;
        else if (!strcmp(key, "SReclaimable:")) sreclaimable = value;
        else if (!strcmp(key, "Shmem:"))        shmem = value;
    }
    fclose(fp);

    long cache = cached + sreclaimable - shmem;
    long used  = total - free - buffers - cache;
    long remaining = total - used;

    double used_gb      = used / 1024.0 / 1024.0;
    double remaining_gb = remaining / 1024.0 / 1024.0;

    /* ---- manejar estado ---- */
    int show_only_used = 0;

    // leer estado actual
    FILE *state = fopen(STATE_FILE, "r");
    if (state) {
        fscanf(state, "%d", &show_only_used);
        fclose(state);
    }

    // detectar click
    char *button = getenv("BLOCK_BUTTON");
    if (button && strcmp(button, "1") == 0) {
        show_only_used = !show_only_used;

        state = fopen(STATE_FILE, "w");
        if (state) {
            fprintf(state, "%d\n", show_only_used);
            fclose(state);
        }
    }

    /* ---- salida ---- */
    printf("<span foreground='#00332D' background='#ffffff'>  </span> ");
    printf("<span background='#00665A'>  ");

    if (show_only_used) {
        printf("%.2fG  %.2fG", used_gb, remaining_gb);
    } else {
        printf("%.2fG", used_gb);
    }

    printf(" </span>");
    printf("<span foreground='#00665A' background='#000000'> </span>\n");

    return 0;
}
