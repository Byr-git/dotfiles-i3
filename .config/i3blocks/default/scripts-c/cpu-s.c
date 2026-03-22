#include <stdio.h>
#include <unistd.h>

int main(void) {
    long user, nice, system, idle, iowait, irq, softirq, steal;
    long prev_active = 0, prev_total = 0;

    while (1) {
        FILE *fp = fopen("/proc/stat", "r");
        if (!fp) return 1;

        fscanf(fp, "cpu %ld %ld %ld %ld %ld %ld %ld %ld",
               &user, &nice, &system, &idle, &iowait, &irq, &softirq, &steal);
        fclose(fp);

        long active = user + nice + system + irq + softirq + steal;
        long total  = active + idle + iowait;

        if (prev_total != 0) {
            long diff_active = active - prev_active;
            long diff_total  = total - prev_total;
            double usage = (diff_total > 0) ? (100.0 * diff_active / diff_total) : 0.0;
            printf("<span foreground='#00332D' background='#ffffff'>  </span> ");
            printf("<span background='#00665A'>  %.1f%% </span><span foreground='#00665A' background='#000000'> </span>\n", usage);
            fflush(stdout);  // Sin esto i3blocks no ve la salida
        }

        prev_active = active;
        prev_total  = total;

        sleep(5);
    }
}
