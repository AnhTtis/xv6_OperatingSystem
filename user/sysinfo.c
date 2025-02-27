#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/sysinfo.h"

int main() {
    struct sysinfo info;
    
    if (sysinfo(&info) < 0) {
        printf("sysinfotest: sysinfo failed\n");
        exit(1);
    }

    printf("Free memory: %ld bytes\n", info.freemem);
    printf("Processes: %ld\n", info.nproc);
    printf("Open files: %ld\n", info.nopenfiles);
    
    exit(0);
}
