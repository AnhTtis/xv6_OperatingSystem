#ifndef SYSINFO_H
#define SYSINFO_H

struct sysinfo {
    uint64 freemem;     // Free memory in bytes
    uint64 nproc;       // Number of processes not in UNUSED state
    uint64 nopenfiles;  // Number of currently open files
};

#endif
