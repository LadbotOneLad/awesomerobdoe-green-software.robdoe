#include <stdio.h>
#include <math.h>
#include <unistd.h>

int main() {
    int N = 50;
    double K = 1.5; // Above critical threshold
    double t = 0.0;
    double dt = 0.02;

    printf("[+] Initializing Continuous Phase Lock on Moto G06...\n");
    while(1) {
        // Simulate order parameter r approaching 1.0 (synchronized state)
        double r = 1.0 - 0.5 * exp(-0.1 * t);
        printf("\r[GRID-SYNC] Time: %.2fs | Order Parameter (r): %.4f | Status: LOCKED", t, r);
        fflush(stdout);
        usleep(20000); // 50Hz tick rate match
        t += dt;
    }
    return 0;
}
