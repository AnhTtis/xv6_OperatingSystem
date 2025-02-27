#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sysinfo.h"


uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

uint64 sys_hello(void)
{
  printf("Hello, world!\n");
  return 0;
}

uint64 sys_trace(void) {
    int mask;
    argint(0, &mask);
    myproc()->trace_mask = mask;  // Store trace mask in the process
    return 0;
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


uint64 count_freemem(void);
uint64 count_nproc(void);
uint64 count_openfiles(void);

uint64 sys_sysinfo(void) {
    struct sysinfo info;
    uint64 addr;
    
    // Just call argaddr() without checking return value
    argaddr(0, &addr);

    //Fill sysinfo struct
    info.freemem = count_freemem();
    info.nproc = count_nproc();
    info.nopenfiles = count_openfiles();

    // Copy struct to user space
    if (copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0)
        return -1;

    return 0;
}

