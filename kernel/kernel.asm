
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00019117          	auipc	sp,0x19
    80000004:	cf010113          	addi	sp,sp,-784 # 80018cf0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	659040ef          	jal	80004e6e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00021797          	auipc	a5,0x21
    80000034:	dc078793          	addi	a5,a5,-576 # 80020df0 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	148000ef          	jal	80000190 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	a7490913          	addi	s2,s2,-1420 # 80007ac0 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	07b050ef          	jal	800058d0 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	103050ef          	jal	80005968 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	524050ef          	jal	800055a2 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	6985                	lui	s3,0x1
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	9e650513          	addi	a0,a0,-1562 # 80007ac0 <kmem>
    800000e2:	76e050ef          	jal	80005850 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	00021517          	auipc	a0,0x21
    800000ee:	d0650513          	addi	a0,a0,-762 # 80020df0 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00008497          	auipc	s1,0x8
    8000010c:	9b848493          	addi	s1,s1,-1608 # 80007ac0 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	7be050ef          	jal	800058d0 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00008517          	auipc	a0,0x8
    80000120:	9a450513          	addi	a0,a0,-1628 # 80007ac0 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	043050ef          	jal	80005968 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	060000ef          	jal	80000190 <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00008517          	auipc	a0,0x8
    80000144:	98050513          	addi	a0,a0,-1664 # 80007ac0 <kmem>
    80000148:	021050ef          	jal	80005968 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <count_freemem>:

uint64 count_freemem(void) {
    8000014e:	1101                	addi	sp,sp,-32
    80000150:	ec06                	sd	ra,24(sp)
    80000152:	e822                	sd	s0,16(sp)
    80000154:	e426                	sd	s1,8(sp)
    80000156:	1000                	addi	s0,sp,32
    struct run *r;
    uint64 free_bytes = 0;

    acquire(&kmem.lock);
    80000158:	00008497          	auipc	s1,0x8
    8000015c:	96848493          	addi	s1,s1,-1688 # 80007ac0 <kmem>
    80000160:	8526                	mv	a0,s1
    80000162:	76e050ef          	jal	800058d0 <acquire>
    for (r = kmem.freelist; r; r = r->next)
    80000166:	6c9c                	ld	a5,24(s1)
    80000168:	c395                	beqz	a5,8000018c <count_freemem+0x3e>
    uint64 free_bytes = 0;
    8000016a:	4481                	li	s1,0
        free_bytes += PGSIZE;  // Each free page is PGSIZE (4096 bytes)
    8000016c:	6705                	lui	a4,0x1
    8000016e:	94ba                	add	s1,s1,a4
    for (r = kmem.freelist; r; r = r->next)
    80000170:	639c                	ld	a5,0(a5)
    80000172:	fff5                	bnez	a5,8000016e <count_freemem+0x20>
    release(&kmem.lock);
    80000174:	00008517          	auipc	a0,0x8
    80000178:	94c50513          	addi	a0,a0,-1716 # 80007ac0 <kmem>
    8000017c:	7ec050ef          	jal	80005968 <release>

    return free_bytes;
}
    80000180:	8526                	mv	a0,s1
    80000182:	60e2                	ld	ra,24(sp)
    80000184:	6442                	ld	s0,16(sp)
    80000186:	64a2                	ld	s1,8(sp)
    80000188:	6105                	addi	sp,sp,32
    8000018a:	8082                	ret
    uint64 free_bytes = 0;
    8000018c:	4481                	li	s1,0
    8000018e:	b7dd                	j	80000174 <count_freemem+0x26>

0000000080000190 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000190:	1141                	addi	sp,sp,-16
    80000192:	e422                	sd	s0,8(sp)
    80000194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000196:	ca19                	beqz	a2,800001ac <memset+0x1c>
    80000198:	87aa                	mv	a5,a0
    8000019a:	1602                	slli	a2,a2,0x20
    8000019c:	9201                	srli	a2,a2,0x20
    8000019e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001a6:	0785                	addi	a5,a5,1
    800001a8:	fee79de3          	bne	a5,a4,800001a2 <memset+0x12>
  }
  return dst;
}
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001b8:	ca05                	beqz	a2,800001e8 <memcmp+0x36>
    800001ba:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001be:	1682                	slli	a3,a3,0x20
    800001c0:	9281                	srli	a3,a3,0x20
    800001c2:	0685                	addi	a3,a3,1
    800001c4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001c6:	00054783          	lbu	a5,0(a0)
    800001ca:	0005c703          	lbu	a4,0(a1)
    800001ce:	00e79863          	bne	a5,a4,800001de <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001d2:	0505                	addi	a0,a0,1
    800001d4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001d6:	fed518e3          	bne	a0,a3,800001c6 <memcmp+0x14>
  }

  return 0;
    800001da:	4501                	li	a0,0
    800001dc:	a019                	j	800001e2 <memcmp+0x30>
      return *s1 - *s2;
    800001de:	40e7853b          	subw	a0,a5,a4
}
    800001e2:	6422                	ld	s0,8(sp)
    800001e4:	0141                	addi	sp,sp,16
    800001e6:	8082                	ret
  return 0;
    800001e8:	4501                	li	a0,0
    800001ea:	bfe5                	j	800001e2 <memcmp+0x30>

00000000800001ec <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001ec:	1141                	addi	sp,sp,-16
    800001ee:	e422                	sd	s0,8(sp)
    800001f0:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001f2:	c205                	beqz	a2,80000212 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001f4:	02a5e263          	bltu	a1,a0,80000218 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f8:	1602                	slli	a2,a2,0x20
    800001fa:	9201                	srli	a2,a2,0x20
    800001fc:	00c587b3          	add	a5,a1,a2
{
    80000200:	872a                	mv	a4,a0
      *d++ = *s++;
    80000202:	0585                	addi	a1,a1,1
    80000204:	0705                	addi	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80000206:	fff5c683          	lbu	a3,-1(a1)
    8000020a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020e:	feb79ae3          	bne	a5,a1,80000202 <memmove+0x16>

  return dst;
}
    80000212:	6422                	ld	s0,8(sp)
    80000214:	0141                	addi	sp,sp,16
    80000216:	8082                	ret
  if(s < d && s + n > d){
    80000218:	02061693          	slli	a3,a2,0x20
    8000021c:	9281                	srli	a3,a3,0x20
    8000021e:	00d58733          	add	a4,a1,a3
    80000222:	fce57be3          	bgeu	a0,a4,800001f8 <memmove+0xc>
    d += n;
    80000226:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000228:	fff6079b          	addiw	a5,a2,-1
    8000022c:	1782                	slli	a5,a5,0x20
    8000022e:	9381                	srli	a5,a5,0x20
    80000230:	fff7c793          	not	a5,a5
    80000234:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000236:	177d                	addi	a4,a4,-1
    80000238:	16fd                	addi	a3,a3,-1
    8000023a:	00074603          	lbu	a2,0(a4)
    8000023e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000242:	fef71ae3          	bne	a4,a5,80000236 <memmove+0x4a>
    80000246:	b7f1                	j	80000212 <memmove+0x26>

0000000080000248 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000248:	1141                	addi	sp,sp,-16
    8000024a:	e406                	sd	ra,8(sp)
    8000024c:	e022                	sd	s0,0(sp)
    8000024e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000250:	f9dff0ef          	jal	800001ec <memmove>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret

000000008000025c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e422                	sd	s0,8(sp)
    80000260:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000262:	ce11                	beqz	a2,8000027e <strncmp+0x22>
    80000264:	00054783          	lbu	a5,0(a0)
    80000268:	cf89                	beqz	a5,80000282 <strncmp+0x26>
    8000026a:	0005c703          	lbu	a4,0(a1)
    8000026e:	00f71a63          	bne	a4,a5,80000282 <strncmp+0x26>
    n--, p++, q++;
    80000272:	367d                	addiw	a2,a2,-1
    80000274:	0505                	addi	a0,a0,1
    80000276:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000278:	f675                	bnez	a2,80000264 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	a801                	j	8000028c <strncmp+0x30>
    8000027e:	4501                	li	a0,0
    80000280:	a031                	j	8000028c <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000282:	00054503          	lbu	a0,0(a0)
    80000286:	0005c783          	lbu	a5,0(a1)
    8000028a:	9d1d                	subw	a0,a0,a5
}
    8000028c:	6422                	ld	s0,8(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e422                	sd	s0,8(sp)
    80000296:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000298:	87aa                	mv	a5,a0
    8000029a:	86b2                	mv	a3,a2
    8000029c:	367d                	addiw	a2,a2,-1
    8000029e:	02d05563          	blez	a3,800002c8 <strncpy+0x36>
    800002a2:	0785                	addi	a5,a5,1
    800002a4:	0005c703          	lbu	a4,0(a1)
    800002a8:	fee78fa3          	sb	a4,-1(a5)
    800002ac:	0585                	addi	a1,a1,1
    800002ae:	f775                	bnez	a4,8000029a <strncpy+0x8>
    ;
  while(n-- > 0)
    800002b0:	873e                	mv	a4,a5
    800002b2:	9fb5                	addw	a5,a5,a3
    800002b4:	37fd                	addiw	a5,a5,-1
    800002b6:	00c05963          	blez	a2,800002c8 <strncpy+0x36>
    *s++ = 0;
    800002ba:	0705                	addi	a4,a4,1
    800002bc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002c0:	40e786bb          	subw	a3,a5,a4
    800002c4:	fed04be3          	bgtz	a3,800002ba <strncpy+0x28>
  return os;
}
    800002c8:	6422                	ld	s0,8(sp)
    800002ca:	0141                	addi	sp,sp,16
    800002cc:	8082                	ret

00000000800002ce <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ce:	1141                	addi	sp,sp,-16
    800002d0:	e422                	sd	s0,8(sp)
    800002d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d4:	02c05363          	blez	a2,800002fa <safestrcpy+0x2c>
    800002d8:	fff6069b          	addiw	a3,a2,-1
    800002dc:	1682                	slli	a3,a3,0x20
    800002de:	9281                	srli	a3,a3,0x20
    800002e0:	96ae                	add	a3,a3,a1
    800002e2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e4:	00d58963          	beq	a1,a3,800002f6 <safestrcpy+0x28>
    800002e8:	0585                	addi	a1,a1,1
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff5c703          	lbu	a4,-1(a1)
    800002f0:	fee78fa3          	sb	a4,-1(a5)
    800002f4:	fb65                	bnez	a4,800002e4 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f6:	00078023          	sb	zero,0(a5)
  return os;
}
    800002fa:	6422                	ld	s0,8(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strlen>:

int
strlen(const char *s)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000306:	00054783          	lbu	a5,0(a0)
    8000030a:	cf91                	beqz	a5,80000326 <strlen+0x26>
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	87aa                	mv	a5,a0
    80000310:	86be                	mv	a3,a5
    80000312:	0785                	addi	a5,a5,1
    80000314:	fff7c703          	lbu	a4,-1(a5)
    80000318:	ff65                	bnez	a4,80000310 <strlen+0x10>
    8000031a:	40a6853b          	subw	a0,a3,a0
    8000031e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000320:	6422                	ld	s0,8(sp)
    80000322:	0141                	addi	sp,sp,16
    80000324:	8082                	ret
  for(n = 0; s[n]; n++)
    80000326:	4501                	li	a0,0
    80000328:	bfe5                	j	80000320 <strlen+0x20>

000000008000032a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000032a:	1141                	addi	sp,sp,-16
    8000032c:	e406                	sd	ra,8(sp)
    8000032e:	e022                	sd	s0,0(sp)
    80000330:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000332:	24b000ef          	jal	80000d7c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00007717          	auipc	a4,0x7
    8000033a:	75a70713          	addi	a4,a4,1882 # 80007a90 <started>
  if(cpuid() == 0){
    8000033e:	c51d                	beqz	a0,8000036c <main+0x42>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x16>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	233000ef          	jal	80000d7c <cpuid>
    8000034e:	85aa                	mv	a1,a0
    80000350:	00007517          	auipc	a0,0x7
    80000354:	ce850513          	addi	a0,a0,-792 # 80007038 <etext+0x38>
    80000358:	779040ef          	jal	800052d0 <printf>
    kvminithart();    // turn on paging
    8000035c:	080000ef          	jal	800003dc <kvminithart>
    trapinithart();   // install kernel trap vector
    80000360:	58e010ef          	jal	800018ee <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000364:	524040ef          	jal	80004888 <plicinithart>
  }

  scheduler();        
    80000368:	67d000ef          	jal	800011e4 <scheduler>
    consoleinit();
    8000036c:	68f040ef          	jal	800051fa <consoleinit>
    printfinit();
    80000370:	26c050ef          	jal	800055dc <printfinit>
    printf("\n");
    80000374:	00007517          	auipc	a0,0x7
    80000378:	ca450513          	addi	a0,a0,-860 # 80007018 <etext+0x18>
    8000037c:	755040ef          	jal	800052d0 <printf>
    printf("xv6 kernel is booting\n");
    80000380:	00007517          	auipc	a0,0x7
    80000384:	ca050513          	addi	a0,a0,-864 # 80007020 <etext+0x20>
    80000388:	749040ef          	jal	800052d0 <printf>
    printf("\n");
    8000038c:	00007517          	auipc	a0,0x7
    80000390:	c8c50513          	addi	a0,a0,-884 # 80007018 <etext+0x18>
    80000394:	73d040ef          	jal	800052d0 <printf>
    kinit();         // physical page allocator
    80000398:	d33ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    8000039c:	2ca000ef          	jal	80000666 <kvminit>
    kvminithart();   // turn on paging
    800003a0:	03c000ef          	jal	800003dc <kvminithart>
    procinit();      // process table
    800003a4:	123000ef          	jal	80000cc6 <procinit>
    trapinit();      // trap vectors
    800003a8:	522010ef          	jal	800018ca <trapinit>
    trapinithart();  // install kernel trap vector
    800003ac:	542010ef          	jal	800018ee <trapinithart>
    plicinit();      // set up interrupt controller
    800003b0:	4be040ef          	jal	8000486e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003b4:	4d4040ef          	jal	80004888 <plicinithart>
    binit();         // buffer cache
    800003b8:	425010ef          	jal	80001fdc <binit>
    iinit();         // inode table
    800003bc:	216020ef          	jal	800025d2 <iinit>
    fileinit();      // file table
    800003c0:	7c3020ef          	jal	80003382 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003c4:	5b4040ef          	jal	80004978 <virtio_disk_init>
    userinit();      // first user process
    800003c8:	449000ef          	jal	80001010 <userinit>
    __sync_synchronize();
    800003cc:	0ff0000f          	fence
    started = 1;
    800003d0:	4785                	li	a5,1
    800003d2:	00007717          	auipc	a4,0x7
    800003d6:	6af72f23          	sw	a5,1726(a4) # 80007a90 <started>
    800003da:	b779                	j	80000368 <main+0x3e>

00000000800003dc <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003dc:	1141                	addi	sp,sp,-16
    800003de:	e422                	sd	s0,8(sp)
    800003e0:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003e2:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003e6:	00007797          	auipc	a5,0x7
    800003ea:	6b27b783          	ld	a5,1714(a5) # 80007a98 <kernel_pagetable>
    800003ee:	83b1                	srli	a5,a5,0xc
    800003f0:	577d                	li	a4,-1
    800003f2:	177e                	slli	a4,a4,0x3f
    800003f4:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003f6:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003fa:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003fe:	6422                	ld	s0,8(sp)
    80000400:	0141                	addi	sp,sp,16
    80000402:	8082                	ret

0000000080000404 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000404:	7139                	addi	sp,sp,-64
    80000406:	fc06                	sd	ra,56(sp)
    80000408:	f822                	sd	s0,48(sp)
    8000040a:	f426                	sd	s1,40(sp)
    8000040c:	f04a                	sd	s2,32(sp)
    8000040e:	ec4e                	sd	s3,24(sp)
    80000410:	e852                	sd	s4,16(sp)
    80000412:	e456                	sd	s5,8(sp)
    80000414:	e05a                	sd	s6,0(sp)
    80000416:	0080                	addi	s0,sp,64
    80000418:	84aa                	mv	s1,a0
    8000041a:	89ae                	mv	s3,a1
    8000041c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000041e:	57fd                	li	a5,-1
    80000420:	83e9                	srli	a5,a5,0x1a
    80000422:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000424:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000426:	02b7fc63          	bgeu	a5,a1,8000045e <walk+0x5a>
    panic("walk");
    8000042a:	00007517          	auipc	a0,0x7
    8000042e:	c2650513          	addi	a0,a0,-986 # 80007050 <etext+0x50>
    80000432:	170050ef          	jal	800055a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000436:	060a8263          	beqz	s5,8000049a <walk+0x96>
    8000043a:	cc5ff0ef          	jal	800000fe <kalloc>
    8000043e:	84aa                	mv	s1,a0
    80000440:	c139                	beqz	a0,80000486 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000442:	6605                	lui	a2,0x1
    80000444:	4581                	li	a1,0
    80000446:	d4bff0ef          	jal	80000190 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000044a:	00c4d793          	srli	a5,s1,0xc
    8000044e:	07aa                	slli	a5,a5,0xa
    80000450:	0017e793          	ori	a5,a5,1
    80000454:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000458:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffde207>
    8000045a:	036a0063          	beq	s4,s6,8000047a <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    8000045e:	0149d933          	srl	s2,s3,s4
    80000462:	1ff97913          	andi	s2,s2,511
    80000466:	090e                	slli	s2,s2,0x3
    80000468:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000046a:	00093483          	ld	s1,0(s2)
    8000046e:	0014f793          	andi	a5,s1,1
    80000472:	d3f1                	beqz	a5,80000436 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000474:	80a9                	srli	s1,s1,0xa
    80000476:	04b2                	slli	s1,s1,0xc
    80000478:	b7c5                	j	80000458 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    8000047a:	00c9d513          	srli	a0,s3,0xc
    8000047e:	1ff57513          	andi	a0,a0,511
    80000482:	050e                	slli	a0,a0,0x3
    80000484:	9526                	add	a0,a0,s1
}
    80000486:	70e2                	ld	ra,56(sp)
    80000488:	7442                	ld	s0,48(sp)
    8000048a:	74a2                	ld	s1,40(sp)
    8000048c:	7902                	ld	s2,32(sp)
    8000048e:	69e2                	ld	s3,24(sp)
    80000490:	6a42                	ld	s4,16(sp)
    80000492:	6aa2                	ld	s5,8(sp)
    80000494:	6b02                	ld	s6,0(sp)
    80000496:	6121                	addi	sp,sp,64
    80000498:	8082                	ret
        return 0;
    8000049a:	4501                	li	a0,0
    8000049c:	b7ed                	j	80000486 <walk+0x82>

000000008000049e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000049e:	57fd                	li	a5,-1
    800004a0:	83e9                	srli	a5,a5,0x1a
    800004a2:	00b7f463          	bgeu	a5,a1,800004aa <walkaddr+0xc>
    return 0;
    800004a6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a8:	8082                	ret
{
    800004aa:	1141                	addi	sp,sp,-16
    800004ac:	e406                	sd	ra,8(sp)
    800004ae:	e022                	sd	s0,0(sp)
    800004b0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004b2:	4601                	li	a2,0
    800004b4:	f51ff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800004b8:	c105                	beqz	a0,800004d8 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    800004ba:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004bc:	0117f693          	andi	a3,a5,17
    800004c0:	4745                	li	a4,17
    return 0;
    800004c2:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004c4:	00e68663          	beq	a3,a4,800004d0 <walkaddr+0x32>
}
    800004c8:	60a2                	ld	ra,8(sp)
    800004ca:	6402                	ld	s0,0(sp)
    800004cc:	0141                	addi	sp,sp,16
    800004ce:	8082                	ret
  pa = PTE2PA(*pte);
    800004d0:	83a9                	srli	a5,a5,0xa
    800004d2:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d6:	bfcd                	j	800004c8 <walkaddr+0x2a>
    return 0;
    800004d8:	4501                	li	a0,0
    800004da:	b7fd                	j	800004c8 <walkaddr+0x2a>

00000000800004dc <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004dc:	715d                	addi	sp,sp,-80
    800004de:	e486                	sd	ra,72(sp)
    800004e0:	e0a2                	sd	s0,64(sp)
    800004e2:	fc26                	sd	s1,56(sp)
    800004e4:	f84a                	sd	s2,48(sp)
    800004e6:	f44e                	sd	s3,40(sp)
    800004e8:	f052                	sd	s4,32(sp)
    800004ea:	ec56                	sd	s5,24(sp)
    800004ec:	e85a                	sd	s6,16(sp)
    800004ee:	e45e                	sd	s7,8(sp)
    800004f0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004f2:	03459793          	slli	a5,a1,0x34
    800004f6:	e7a9                	bnez	a5,80000540 <mappages+0x64>
    800004f8:	8aaa                	mv	s5,a0
    800004fa:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004fc:	03461793          	slli	a5,a2,0x34
    80000500:	e7b1                	bnez	a5,8000054c <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80000502:	ca39                	beqz	a2,80000558 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000504:	77fd                	lui	a5,0xfffff
    80000506:	963e                	add	a2,a2,a5
    80000508:	00b609b3          	add	s3,a2,a1
  a = va;
    8000050c:	892e                	mv	s2,a1
    8000050e:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000512:	6b85                	lui	s7,0x1
    80000514:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000518:	4605                	li	a2,1
    8000051a:	85ca                	mv	a1,s2
    8000051c:	8556                	mv	a0,s5
    8000051e:	ee7ff0ef          	jal	80000404 <walk>
    80000522:	c539                	beqz	a0,80000570 <mappages+0x94>
    if(*pte & PTE_V)
    80000524:	611c                	ld	a5,0(a0)
    80000526:	8b85                	andi	a5,a5,1
    80000528:	ef95                	bnez	a5,80000564 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000052a:	80b1                	srli	s1,s1,0xc
    8000052c:	04aa                	slli	s1,s1,0xa
    8000052e:	0164e4b3          	or	s1,s1,s6
    80000532:	0014e493          	ori	s1,s1,1
    80000536:	e104                	sd	s1,0(a0)
    if(a == last)
    80000538:	05390863          	beq	s2,s3,80000588 <mappages+0xac>
    a += PGSIZE;
    8000053c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053e:	bfd9                	j	80000514 <mappages+0x38>
    panic("mappages: va not aligned");
    80000540:	00007517          	auipc	a0,0x7
    80000544:	b1850513          	addi	a0,a0,-1256 # 80007058 <etext+0x58>
    80000548:	05a050ef          	jal	800055a2 <panic>
    panic("mappages: size not aligned");
    8000054c:	00007517          	auipc	a0,0x7
    80000550:	b2c50513          	addi	a0,a0,-1236 # 80007078 <etext+0x78>
    80000554:	04e050ef          	jal	800055a2 <panic>
    panic("mappages: size");
    80000558:	00007517          	auipc	a0,0x7
    8000055c:	b4050513          	addi	a0,a0,-1216 # 80007098 <etext+0x98>
    80000560:	042050ef          	jal	800055a2 <panic>
      panic("mappages: remap");
    80000564:	00007517          	auipc	a0,0x7
    80000568:	b4450513          	addi	a0,a0,-1212 # 800070a8 <etext+0xa8>
    8000056c:	036050ef          	jal	800055a2 <panic>
      return -1;
    80000570:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000572:	60a6                	ld	ra,72(sp)
    80000574:	6406                	ld	s0,64(sp)
    80000576:	74e2                	ld	s1,56(sp)
    80000578:	7942                	ld	s2,48(sp)
    8000057a:	79a2                	ld	s3,40(sp)
    8000057c:	7a02                	ld	s4,32(sp)
    8000057e:	6ae2                	ld	s5,24(sp)
    80000580:	6b42                	ld	s6,16(sp)
    80000582:	6ba2                	ld	s7,8(sp)
    80000584:	6161                	addi	sp,sp,80
    80000586:	8082                	ret
  return 0;
    80000588:	4501                	li	a0,0
    8000058a:	b7e5                	j	80000572 <mappages+0x96>

000000008000058c <kvmmap>:
{
    8000058c:	1141                	addi	sp,sp,-16
    8000058e:	e406                	sd	ra,8(sp)
    80000590:	e022                	sd	s0,0(sp)
    80000592:	0800                	addi	s0,sp,16
    80000594:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000596:	86b2                	mv	a3,a2
    80000598:	863e                	mv	a2,a5
    8000059a:	f43ff0ef          	jal	800004dc <mappages>
    8000059e:	e509                	bnez	a0,800005a8 <kvmmap+0x1c>
}
    800005a0:	60a2                	ld	ra,8(sp)
    800005a2:	6402                	ld	s0,0(sp)
    800005a4:	0141                	addi	sp,sp,16
    800005a6:	8082                	ret
    panic("kvmmap");
    800005a8:	00007517          	auipc	a0,0x7
    800005ac:	b1050513          	addi	a0,a0,-1264 # 800070b8 <etext+0xb8>
    800005b0:	7f3040ef          	jal	800055a2 <panic>

00000000800005b4 <kvmmake>:
{
    800005b4:	1101                	addi	sp,sp,-32
    800005b6:	ec06                	sd	ra,24(sp)
    800005b8:	e822                	sd	s0,16(sp)
    800005ba:	e426                	sd	s1,8(sp)
    800005bc:	e04a                	sd	s2,0(sp)
    800005be:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005c0:	b3fff0ef          	jal	800000fe <kalloc>
    800005c4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005c6:	6605                	lui	a2,0x1
    800005c8:	4581                	li	a1,0
    800005ca:	bc7ff0ef          	jal	80000190 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005ce:	4719                	li	a4,6
    800005d0:	6685                	lui	a3,0x1
    800005d2:	10000637          	lui	a2,0x10000
    800005d6:	100005b7          	lui	a1,0x10000
    800005da:	8526                	mv	a0,s1
    800005dc:	fb1ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005e0:	4719                	li	a4,6
    800005e2:	6685                	lui	a3,0x1
    800005e4:	10001637          	lui	a2,0x10001
    800005e8:	100015b7          	lui	a1,0x10001
    800005ec:	8526                	mv	a0,s1
    800005ee:	f9fff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005f2:	4719                	li	a4,6
    800005f4:	040006b7          	lui	a3,0x4000
    800005f8:	0c000637          	lui	a2,0xc000
    800005fc:	0c0005b7          	lui	a1,0xc000
    80000600:	8526                	mv	a0,s1
    80000602:	f8bff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000606:	00007917          	auipc	s2,0x7
    8000060a:	9fa90913          	addi	s2,s2,-1542 # 80007000 <etext>
    8000060e:	4729                	li	a4,10
    80000610:	80007697          	auipc	a3,0x80007
    80000614:	9f068693          	addi	a3,a3,-1552 # 7000 <_entry-0x7fff9000>
    80000618:	4605                	li	a2,1
    8000061a:	067e                	slli	a2,a2,0x1f
    8000061c:	85b2                	mv	a1,a2
    8000061e:	8526                	mv	a0,s1
    80000620:	f6dff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000624:	46c5                	li	a3,17
    80000626:	06ee                	slli	a3,a3,0x1b
    80000628:	4719                	li	a4,6
    8000062a:	412686b3          	sub	a3,a3,s2
    8000062e:	864a                	mv	a2,s2
    80000630:	85ca                	mv	a1,s2
    80000632:	8526                	mv	a0,s1
    80000634:	f59ff0ef          	jal	8000058c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000638:	4729                	li	a4,10
    8000063a:	6685                	lui	a3,0x1
    8000063c:	00006617          	auipc	a2,0x6
    80000640:	9c460613          	addi	a2,a2,-1596 # 80006000 <_trampoline>
    80000644:	040005b7          	lui	a1,0x4000
    80000648:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000064a:	05b2                	slli	a1,a1,0xc
    8000064c:	8526                	mv	a0,s1
    8000064e:	f3fff0ef          	jal	8000058c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000652:	8526                	mv	a0,s1
    80000654:	5da000ef          	jal	80000c2e <proc_mapstacks>
}
    80000658:	8526                	mv	a0,s1
    8000065a:	60e2                	ld	ra,24(sp)
    8000065c:	6442                	ld	s0,16(sp)
    8000065e:	64a2                	ld	s1,8(sp)
    80000660:	6902                	ld	s2,0(sp)
    80000662:	6105                	addi	sp,sp,32
    80000664:	8082                	ret

0000000080000666 <kvminit>:
{
    80000666:	1141                	addi	sp,sp,-16
    80000668:	e406                	sd	ra,8(sp)
    8000066a:	e022                	sd	s0,0(sp)
    8000066c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000066e:	f47ff0ef          	jal	800005b4 <kvmmake>
    80000672:	00007797          	auipc	a5,0x7
    80000676:	42a7b323          	sd	a0,1062(a5) # 80007a98 <kernel_pagetable>
}
    8000067a:	60a2                	ld	ra,8(sp)
    8000067c:	6402                	ld	s0,0(sp)
    8000067e:	0141                	addi	sp,sp,16
    80000680:	8082                	ret

0000000080000682 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000682:	715d                	addi	sp,sp,-80
    80000684:	e486                	sd	ra,72(sp)
    80000686:	e0a2                	sd	s0,64(sp)
    80000688:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000068a:	03459793          	slli	a5,a1,0x34
    8000068e:	e39d                	bnez	a5,800006b4 <uvmunmap+0x32>
    80000690:	f84a                	sd	s2,48(sp)
    80000692:	f44e                	sd	s3,40(sp)
    80000694:	f052                	sd	s4,32(sp)
    80000696:	ec56                	sd	s5,24(sp)
    80000698:	e85a                	sd	s6,16(sp)
    8000069a:	e45e                	sd	s7,8(sp)
    8000069c:	8a2a                	mv	s4,a0
    8000069e:	892e                	mv	s2,a1
    800006a0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006a2:	0632                	slli	a2,a2,0xc
    800006a4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800006a8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006aa:	6b05                	lui	s6,0x1
    800006ac:	0735ff63          	bgeu	a1,s3,8000072a <uvmunmap+0xa8>
    800006b0:	fc26                	sd	s1,56(sp)
    800006b2:	a0a9                	j	800006fc <uvmunmap+0x7a>
    800006b4:	fc26                	sd	s1,56(sp)
    800006b6:	f84a                	sd	s2,48(sp)
    800006b8:	f44e                	sd	s3,40(sp)
    800006ba:	f052                	sd	s4,32(sp)
    800006bc:	ec56                	sd	s5,24(sp)
    800006be:	e85a                	sd	s6,16(sp)
    800006c0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006c2:	00007517          	auipc	a0,0x7
    800006c6:	9fe50513          	addi	a0,a0,-1538 # 800070c0 <etext+0xc0>
    800006ca:	6d9040ef          	jal	800055a2 <panic>
      panic("uvmunmap: walk");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	a0a50513          	addi	a0,a0,-1526 # 800070d8 <etext+0xd8>
    800006d6:	6cd040ef          	jal	800055a2 <panic>
      panic("uvmunmap: not mapped");
    800006da:	00007517          	auipc	a0,0x7
    800006de:	a0e50513          	addi	a0,a0,-1522 # 800070e8 <etext+0xe8>
    800006e2:	6c1040ef          	jal	800055a2 <panic>
      panic("uvmunmap: not a leaf");
    800006e6:	00007517          	auipc	a0,0x7
    800006ea:	a1a50513          	addi	a0,a0,-1510 # 80007100 <etext+0x100>
    800006ee:	6b5040ef          	jal	800055a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006f2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006f6:	995a                	add	s2,s2,s6
    800006f8:	03397863          	bgeu	s2,s3,80000728 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006fc:	4601                	li	a2,0
    800006fe:	85ca                	mv	a1,s2
    80000700:	8552                	mv	a0,s4
    80000702:	d03ff0ef          	jal	80000404 <walk>
    80000706:	84aa                	mv	s1,a0
    80000708:	d179                	beqz	a0,800006ce <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000070a:	6108                	ld	a0,0(a0)
    8000070c:	00157793          	andi	a5,a0,1
    80000710:	d7e9                	beqz	a5,800006da <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000712:	3ff57793          	andi	a5,a0,1023
    80000716:	fd7788e3          	beq	a5,s7,800006e6 <uvmunmap+0x64>
    if(do_free){
    8000071a:	fc0a8ce3          	beqz	s5,800006f2 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000071e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000720:	0532                	slli	a0,a0,0xc
    80000722:	8fbff0ef          	jal	8000001c <kfree>
    80000726:	b7f1                	j	800006f2 <uvmunmap+0x70>
    80000728:	74e2                	ld	s1,56(sp)
    8000072a:	7942                	ld	s2,48(sp)
    8000072c:	79a2                	ld	s3,40(sp)
    8000072e:	7a02                	ld	s4,32(sp)
    80000730:	6ae2                	ld	s5,24(sp)
    80000732:	6b42                	ld	s6,16(sp)
    80000734:	6ba2                	ld	s7,8(sp)
  }
}
    80000736:	60a6                	ld	ra,72(sp)
    80000738:	6406                	ld	s0,64(sp)
    8000073a:	6161                	addi	sp,sp,80
    8000073c:	8082                	ret

000000008000073e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000073e:	1101                	addi	sp,sp,-32
    80000740:	ec06                	sd	ra,24(sp)
    80000742:	e822                	sd	s0,16(sp)
    80000744:	e426                	sd	s1,8(sp)
    80000746:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000748:	9b7ff0ef          	jal	800000fe <kalloc>
    8000074c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000074e:	c509                	beqz	a0,80000758 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000750:	6605                	lui	a2,0x1
    80000752:	4581                	li	a1,0
    80000754:	a3dff0ef          	jal	80000190 <memset>
  return pagetable;
}
    80000758:	8526                	mv	a0,s1
    8000075a:	60e2                	ld	ra,24(sp)
    8000075c:	6442                	ld	s0,16(sp)
    8000075e:	64a2                	ld	s1,8(sp)
    80000760:	6105                	addi	sp,sp,32
    80000762:	8082                	ret

0000000080000764 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000764:	7179                	addi	sp,sp,-48
    80000766:	f406                	sd	ra,40(sp)
    80000768:	f022                	sd	s0,32(sp)
    8000076a:	ec26                	sd	s1,24(sp)
    8000076c:	e84a                	sd	s2,16(sp)
    8000076e:	e44e                	sd	s3,8(sp)
    80000770:	e052                	sd	s4,0(sp)
    80000772:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000774:	6785                	lui	a5,0x1
    80000776:	04f67063          	bgeu	a2,a5,800007b6 <uvmfirst+0x52>
    8000077a:	8a2a                	mv	s4,a0
    8000077c:	89ae                	mv	s3,a1
    8000077e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000780:	97fff0ef          	jal	800000fe <kalloc>
    80000784:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000786:	6605                	lui	a2,0x1
    80000788:	4581                	li	a1,0
    8000078a:	a07ff0ef          	jal	80000190 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000078e:	4779                	li	a4,30
    80000790:	86ca                	mv	a3,s2
    80000792:	6605                	lui	a2,0x1
    80000794:	4581                	li	a1,0
    80000796:	8552                	mv	a0,s4
    80000798:	d45ff0ef          	jal	800004dc <mappages>
  memmove(mem, src, sz);
    8000079c:	8626                	mv	a2,s1
    8000079e:	85ce                	mv	a1,s3
    800007a0:	854a                	mv	a0,s2
    800007a2:	a4bff0ef          	jal	800001ec <memmove>
}
    800007a6:	70a2                	ld	ra,40(sp)
    800007a8:	7402                	ld	s0,32(sp)
    800007aa:	64e2                	ld	s1,24(sp)
    800007ac:	6942                	ld	s2,16(sp)
    800007ae:	69a2                	ld	s3,8(sp)
    800007b0:	6a02                	ld	s4,0(sp)
    800007b2:	6145                	addi	sp,sp,48
    800007b4:	8082                	ret
    panic("uvmfirst: more than a page");
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	96250513          	addi	a0,a0,-1694 # 80007118 <etext+0x118>
    800007be:	5e5040ef          	jal	800055a2 <panic>

00000000800007c2 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007c2:	1101                	addi	sp,sp,-32
    800007c4:	ec06                	sd	ra,24(sp)
    800007c6:	e822                	sd	s0,16(sp)
    800007c8:	e426                	sd	s1,8(sp)
    800007ca:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007cc:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ce:	00b67d63          	bgeu	a2,a1,800007e8 <uvmdealloc+0x26>
    800007d2:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007d4:	6785                	lui	a5,0x1
    800007d6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007d8:	00f60733          	add	a4,a2,a5
    800007dc:	76fd                	lui	a3,0xfffff
    800007de:	8f75                	and	a4,a4,a3
    800007e0:	97ae                	add	a5,a5,a1
    800007e2:	8ff5                	and	a5,a5,a3
    800007e4:	00f76863          	bltu	a4,a5,800007f4 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007e8:	8526                	mv	a0,s1
    800007ea:	60e2                	ld	ra,24(sp)
    800007ec:	6442                	ld	s0,16(sp)
    800007ee:	64a2                	ld	s1,8(sp)
    800007f0:	6105                	addi	sp,sp,32
    800007f2:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007f4:	8f99                	sub	a5,a5,a4
    800007f6:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007f8:	4685                	li	a3,1
    800007fa:	0007861b          	sext.w	a2,a5
    800007fe:	85ba                	mv	a1,a4
    80000800:	e83ff0ef          	jal	80000682 <uvmunmap>
    80000804:	b7d5                	j	800007e8 <uvmdealloc+0x26>

0000000080000806 <uvmalloc>:
  if(newsz < oldsz)
    80000806:	08b66f63          	bltu	a2,a1,800008a4 <uvmalloc+0x9e>
{
    8000080a:	7139                	addi	sp,sp,-64
    8000080c:	fc06                	sd	ra,56(sp)
    8000080e:	f822                	sd	s0,48(sp)
    80000810:	ec4e                	sd	s3,24(sp)
    80000812:	e852                	sd	s4,16(sp)
    80000814:	e456                	sd	s5,8(sp)
    80000816:	0080                	addi	s0,sp,64
    80000818:	8aaa                	mv	s5,a0
    8000081a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000081c:	6785                	lui	a5,0x1
    8000081e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000820:	95be                	add	a1,a1,a5
    80000822:	77fd                	lui	a5,0xfffff
    80000824:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000828:	08c9f063          	bgeu	s3,a2,800008a8 <uvmalloc+0xa2>
    8000082c:	f426                	sd	s1,40(sp)
    8000082e:	f04a                	sd	s2,32(sp)
    80000830:	e05a                	sd	s6,0(sp)
    80000832:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000834:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000838:	8c7ff0ef          	jal	800000fe <kalloc>
    8000083c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000083e:	c515                	beqz	a0,8000086a <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	94dff0ef          	jal	80000190 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000848:	875a                	mv	a4,s6
    8000084a:	86a6                	mv	a3,s1
    8000084c:	6605                	lui	a2,0x1
    8000084e:	85ca                	mv	a1,s2
    80000850:	8556                	mv	a0,s5
    80000852:	c8bff0ef          	jal	800004dc <mappages>
    80000856:	e915                	bnez	a0,8000088a <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000858:	6785                	lui	a5,0x1
    8000085a:	993e                	add	s2,s2,a5
    8000085c:	fd496ee3          	bltu	s2,s4,80000838 <uvmalloc+0x32>
  return newsz;
    80000860:	8552                	mv	a0,s4
    80000862:	74a2                	ld	s1,40(sp)
    80000864:	7902                	ld	s2,32(sp)
    80000866:	6b02                	ld	s6,0(sp)
    80000868:	a811                	j	8000087c <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    8000086a:	864e                	mv	a2,s3
    8000086c:	85ca                	mv	a1,s2
    8000086e:	8556                	mv	a0,s5
    80000870:	f53ff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    80000874:	4501                	li	a0,0
    80000876:	74a2                	ld	s1,40(sp)
    80000878:	7902                	ld	s2,32(sp)
    8000087a:	6b02                	ld	s6,0(sp)
}
    8000087c:	70e2                	ld	ra,56(sp)
    8000087e:	7442                	ld	s0,48(sp)
    80000880:	69e2                	ld	s3,24(sp)
    80000882:	6a42                	ld	s4,16(sp)
    80000884:	6aa2                	ld	s5,8(sp)
    80000886:	6121                	addi	sp,sp,64
    80000888:	8082                	ret
      kfree(mem);
    8000088a:	8526                	mv	a0,s1
    8000088c:	f90ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000890:	864e                	mv	a2,s3
    80000892:	85ca                	mv	a1,s2
    80000894:	8556                	mv	a0,s5
    80000896:	f2dff0ef          	jal	800007c2 <uvmdealloc>
      return 0;
    8000089a:	4501                	li	a0,0
    8000089c:	74a2                	ld	s1,40(sp)
    8000089e:	7902                	ld	s2,32(sp)
    800008a0:	6b02                	ld	s6,0(sp)
    800008a2:	bfe9                	j	8000087c <uvmalloc+0x76>
    return oldsz;
    800008a4:	852e                	mv	a0,a1
}
    800008a6:	8082                	ret
  return newsz;
    800008a8:	8532                	mv	a0,a2
    800008aa:	bfc9                	j	8000087c <uvmalloc+0x76>

00000000800008ac <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008ac:	7179                	addi	sp,sp,-48
    800008ae:	f406                	sd	ra,40(sp)
    800008b0:	f022                	sd	s0,32(sp)
    800008b2:	ec26                	sd	s1,24(sp)
    800008b4:	e84a                	sd	s2,16(sp)
    800008b6:	e44e                	sd	s3,8(sp)
    800008b8:	e052                	sd	s4,0(sp)
    800008ba:	1800                	addi	s0,sp,48
    800008bc:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008be:	84aa                	mv	s1,a0
    800008c0:	6905                	lui	s2,0x1
    800008c2:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	4985                	li	s3,1
    800008c6:	a819                	j	800008dc <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008c8:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008ca:	00c79513          	slli	a0,a5,0xc
    800008ce:	fdfff0ef          	jal	800008ac <freewalk>
      pagetable[i] = 0;
    800008d2:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008d6:	04a1                	addi	s1,s1,8
    800008d8:	01248f63          	beq	s1,s2,800008f6 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008dc:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008de:	00f7f713          	andi	a4,a5,15
    800008e2:	ff3703e3          	beq	a4,s3,800008c8 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008e6:	8b85                	andi	a5,a5,1
    800008e8:	d7fd                	beqz	a5,800008d6 <freewalk+0x2a>
      panic("freewalk: leaf");
    800008ea:	00007517          	auipc	a0,0x7
    800008ee:	84e50513          	addi	a0,a0,-1970 # 80007138 <etext+0x138>
    800008f2:	4b1040ef          	jal	800055a2 <panic>
    }
  }
  kfree((void*)pagetable);
    800008f6:	8552                	mv	a0,s4
    800008f8:	f24ff0ef          	jal	8000001c <kfree>
}
    800008fc:	70a2                	ld	ra,40(sp)
    800008fe:	7402                	ld	s0,32(sp)
    80000900:	64e2                	ld	s1,24(sp)
    80000902:	6942                	ld	s2,16(sp)
    80000904:	69a2                	ld	s3,8(sp)
    80000906:	6a02                	ld	s4,0(sp)
    80000908:	6145                	addi	sp,sp,48
    8000090a:	8082                	ret

000000008000090c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000090c:	1101                	addi	sp,sp,-32
    8000090e:	ec06                	sd	ra,24(sp)
    80000910:	e822                	sd	s0,16(sp)
    80000912:	e426                	sd	s1,8(sp)
    80000914:	1000                	addi	s0,sp,32
    80000916:	84aa                	mv	s1,a0
  if(sz > 0)
    80000918:	e989                	bnez	a1,8000092a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000091a:	8526                	mv	a0,s1
    8000091c:	f91ff0ef          	jal	800008ac <freewalk>
}
    80000920:	60e2                	ld	ra,24(sp)
    80000922:	6442                	ld	s0,16(sp)
    80000924:	64a2                	ld	s1,8(sp)
    80000926:	6105                	addi	sp,sp,32
    80000928:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000092a:	6785                	lui	a5,0x1
    8000092c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000092e:	95be                	add	a1,a1,a5
    80000930:	4685                	li	a3,1
    80000932:	00c5d613          	srli	a2,a1,0xc
    80000936:	4581                	li	a1,0
    80000938:	d4bff0ef          	jal	80000682 <uvmunmap>
    8000093c:	bff9                	j	8000091a <uvmfree+0xe>

000000008000093e <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000093e:	c65d                	beqz	a2,800009ec <uvmcopy+0xae>
{
    80000940:	715d                	addi	sp,sp,-80
    80000942:	e486                	sd	ra,72(sp)
    80000944:	e0a2                	sd	s0,64(sp)
    80000946:	fc26                	sd	s1,56(sp)
    80000948:	f84a                	sd	s2,48(sp)
    8000094a:	f44e                	sd	s3,40(sp)
    8000094c:	f052                	sd	s4,32(sp)
    8000094e:	ec56                	sd	s5,24(sp)
    80000950:	e85a                	sd	s6,16(sp)
    80000952:	e45e                	sd	s7,8(sp)
    80000954:	0880                	addi	s0,sp,80
    80000956:	8b2a                	mv	s6,a0
    80000958:	8aae                	mv	s5,a1
    8000095a:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    8000095c:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    8000095e:	4601                	li	a2,0
    80000960:	85ce                	mv	a1,s3
    80000962:	855a                	mv	a0,s6
    80000964:	aa1ff0ef          	jal	80000404 <walk>
    80000968:	c121                	beqz	a0,800009a8 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    8000096a:	6118                	ld	a4,0(a0)
    8000096c:	00177793          	andi	a5,a4,1
    80000970:	c3b1                	beqz	a5,800009b4 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000972:	00a75593          	srli	a1,a4,0xa
    80000976:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000097a:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    8000097e:	f80ff0ef          	jal	800000fe <kalloc>
    80000982:	892a                	mv	s2,a0
    80000984:	c129                	beqz	a0,800009c6 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000986:	6605                	lui	a2,0x1
    80000988:	85de                	mv	a1,s7
    8000098a:	863ff0ef          	jal	800001ec <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000098e:	8726                	mv	a4,s1
    80000990:	86ca                	mv	a3,s2
    80000992:	6605                	lui	a2,0x1
    80000994:	85ce                	mv	a1,s3
    80000996:	8556                	mv	a0,s5
    80000998:	b45ff0ef          	jal	800004dc <mappages>
    8000099c:	e115                	bnez	a0,800009c0 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000099e:	6785                	lui	a5,0x1
    800009a0:	99be                	add	s3,s3,a5
    800009a2:	fb49eee3          	bltu	s3,s4,8000095e <uvmcopy+0x20>
    800009a6:	a805                	j	800009d6 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    800009a8:	00006517          	auipc	a0,0x6
    800009ac:	7a050513          	addi	a0,a0,1952 # 80007148 <etext+0x148>
    800009b0:	3f3040ef          	jal	800055a2 <panic>
      panic("uvmcopy: page not present");
    800009b4:	00006517          	auipc	a0,0x6
    800009b8:	7b450513          	addi	a0,a0,1972 # 80007168 <etext+0x168>
    800009bc:	3e7040ef          	jal	800055a2 <panic>
      kfree(mem);
    800009c0:	854a                	mv	a0,s2
    800009c2:	e5aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009c6:	4685                	li	a3,1
    800009c8:	00c9d613          	srli	a2,s3,0xc
    800009cc:	4581                	li	a1,0
    800009ce:	8556                	mv	a0,s5
    800009d0:	cb3ff0ef          	jal	80000682 <uvmunmap>
  return -1;
    800009d4:	557d                	li	a0,-1
}
    800009d6:	60a6                	ld	ra,72(sp)
    800009d8:	6406                	ld	s0,64(sp)
    800009da:	74e2                	ld	s1,56(sp)
    800009dc:	7942                	ld	s2,48(sp)
    800009de:	79a2                	ld	s3,40(sp)
    800009e0:	7a02                	ld	s4,32(sp)
    800009e2:	6ae2                	ld	s5,24(sp)
    800009e4:	6b42                	ld	s6,16(sp)
    800009e6:	6ba2                	ld	s7,8(sp)
    800009e8:	6161                	addi	sp,sp,80
    800009ea:	8082                	ret
  return 0;
    800009ec:	4501                	li	a0,0
}
    800009ee:	8082                	ret

00000000800009f0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009f0:	1141                	addi	sp,sp,-16
    800009f2:	e406                	sd	ra,8(sp)
    800009f4:	e022                	sd	s0,0(sp)
    800009f6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009f8:	4601                	li	a2,0
    800009fa:	a0bff0ef          	jal	80000404 <walk>
  if(pte == 0)
    800009fe:	c901                	beqz	a0,80000a0e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a00:	611c                	ld	a5,0(a0)
    80000a02:	9bbd                	andi	a5,a5,-17
    80000a04:	e11c                	sd	a5,0(a0)
}
    80000a06:	60a2                	ld	ra,8(sp)
    80000a08:	6402                	ld	s0,0(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    panic("uvmclear");
    80000a0e:	00006517          	auipc	a0,0x6
    80000a12:	77a50513          	addi	a0,a0,1914 # 80007188 <etext+0x188>
    80000a16:	38d040ef          	jal	800055a2 <panic>

0000000080000a1a <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a1a:	cad1                	beqz	a3,80000aae <copyout+0x94>
{
    80000a1c:	711d                	addi	sp,sp,-96
    80000a1e:	ec86                	sd	ra,88(sp)
    80000a20:	e8a2                	sd	s0,80(sp)
    80000a22:	e4a6                	sd	s1,72(sp)
    80000a24:	fc4e                	sd	s3,56(sp)
    80000a26:	f456                	sd	s5,40(sp)
    80000a28:	f05a                	sd	s6,32(sp)
    80000a2a:	ec5e                	sd	s7,24(sp)
    80000a2c:	1080                	addi	s0,sp,96
    80000a2e:	8baa                	mv	s7,a0
    80000a30:	8aae                	mv	s5,a1
    80000a32:	8b32                	mv	s6,a2
    80000a34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000a36:	74fd                	lui	s1,0xfffff
    80000a38:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80000a3a:	57fd                	li	a5,-1
    80000a3c:	83e9                	srli	a5,a5,0x1a
    80000a3e:	0697ea63          	bltu	a5,s1,80000ab2 <copyout+0x98>
    80000a42:	e0ca                	sd	s2,64(sp)
    80000a44:	f852                	sd	s4,48(sp)
    80000a46:	e862                	sd	s8,16(sp)
    80000a48:	e466                	sd	s9,8(sp)
    80000a4a:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a4c:	4cd5                	li	s9,21
    80000a4e:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80000a50:	8c3e                	mv	s8,a5
    80000a52:	a025                	j	80000a7a <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80000a54:	83a9                	srli	a5,a5,0xa
    80000a56:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a58:	409a8533          	sub	a0,s5,s1
    80000a5c:	0009061b          	sext.w	a2,s2
    80000a60:	85da                	mv	a1,s6
    80000a62:	953e                	add	a0,a0,a5
    80000a64:	f88ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000a68:	412989b3          	sub	s3,s3,s2
    src += n;
    80000a6c:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80000a6e:	02098963          	beqz	s3,80000aa0 <copyout+0x86>
    if(va0 >= MAXVA)
    80000a72:	054c6263          	bltu	s8,s4,80000ab6 <copyout+0x9c>
    80000a76:	84d2                	mv	s1,s4
    80000a78:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80000a7a:	4601                	li	a2,0
    80000a7c:	85a6                	mv	a1,s1
    80000a7e:	855e                	mv	a0,s7
    80000a80:	985ff0ef          	jal	80000404 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a84:	c121                	beqz	a0,80000ac4 <copyout+0xaa>
    80000a86:	611c                	ld	a5,0(a0)
    80000a88:	0157f713          	andi	a4,a5,21
    80000a8c:	05971b63          	bne	a4,s9,80000ae2 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80000a90:	01a48a33          	add	s4,s1,s10
    80000a94:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80000a98:	fb29fee3          	bgeu	s3,s2,80000a54 <copyout+0x3a>
    80000a9c:	894e                	mv	s2,s3
    80000a9e:	bf5d                	j	80000a54 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80000aa0:	4501                	li	a0,0
    80000aa2:	6906                	ld	s2,64(sp)
    80000aa4:	7a42                	ld	s4,48(sp)
    80000aa6:	6c42                	ld	s8,16(sp)
    80000aa8:	6ca2                	ld	s9,8(sp)
    80000aaa:	6d02                	ld	s10,0(sp)
    80000aac:	a015                	j	80000ad0 <copyout+0xb6>
    80000aae:	4501                	li	a0,0
}
    80000ab0:	8082                	ret
      return -1;
    80000ab2:	557d                	li	a0,-1
    80000ab4:	a831                	j	80000ad0 <copyout+0xb6>
    80000ab6:	557d                	li	a0,-1
    80000ab8:	6906                	ld	s2,64(sp)
    80000aba:	7a42                	ld	s4,48(sp)
    80000abc:	6c42                	ld	s8,16(sp)
    80000abe:	6ca2                	ld	s9,8(sp)
    80000ac0:	6d02                	ld	s10,0(sp)
    80000ac2:	a039                	j	80000ad0 <copyout+0xb6>
      return -1;
    80000ac4:	557d                	li	a0,-1
    80000ac6:	6906                	ld	s2,64(sp)
    80000ac8:	7a42                	ld	s4,48(sp)
    80000aca:	6c42                	ld	s8,16(sp)
    80000acc:	6ca2                	ld	s9,8(sp)
    80000ace:	6d02                	ld	s10,0(sp)
}
    80000ad0:	60e6                	ld	ra,88(sp)
    80000ad2:	6446                	ld	s0,80(sp)
    80000ad4:	64a6                	ld	s1,72(sp)
    80000ad6:	79e2                	ld	s3,56(sp)
    80000ad8:	7aa2                	ld	s5,40(sp)
    80000ada:	7b02                	ld	s6,32(sp)
    80000adc:	6be2                	ld	s7,24(sp)
    80000ade:	6125                	addi	sp,sp,96
    80000ae0:	8082                	ret
      return -1;
    80000ae2:	557d                	li	a0,-1
    80000ae4:	6906                	ld	s2,64(sp)
    80000ae6:	7a42                	ld	s4,48(sp)
    80000ae8:	6c42                	ld	s8,16(sp)
    80000aea:	6ca2                	ld	s9,8(sp)
    80000aec:	6d02                	ld	s10,0(sp)
    80000aee:	b7cd                	j	80000ad0 <copyout+0xb6>

0000000080000af0 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000af0:	c6a5                	beqz	a3,80000b58 <copyin+0x68>
{
    80000af2:	715d                	addi	sp,sp,-80
    80000af4:	e486                	sd	ra,72(sp)
    80000af6:	e0a2                	sd	s0,64(sp)
    80000af8:	fc26                	sd	s1,56(sp)
    80000afa:	f84a                	sd	s2,48(sp)
    80000afc:	f44e                	sd	s3,40(sp)
    80000afe:	f052                	sd	s4,32(sp)
    80000b00:	ec56                	sd	s5,24(sp)
    80000b02:	e85a                	sd	s6,16(sp)
    80000b04:	e45e                	sd	s7,8(sp)
    80000b06:	e062                	sd	s8,0(sp)
    80000b08:	0880                	addi	s0,sp,80
    80000b0a:	8b2a                	mv	s6,a0
    80000b0c:	8a2e                	mv	s4,a1
    80000b0e:	8c32                	mv	s8,a2
    80000b10:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b12:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b14:	6a85                	lui	s5,0x1
    80000b16:	a00d                	j	80000b38 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000b18:	018505b3          	add	a1,a0,s8
    80000b1c:	0004861b          	sext.w	a2,s1
    80000b20:	412585b3          	sub	a1,a1,s2
    80000b24:	8552                	mv	a0,s4
    80000b26:	ec6ff0ef          	jal	800001ec <memmove>

    len -= n;
    80000b2a:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000b2e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000b30:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b34:	02098063          	beqz	s3,80000b54 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000b38:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b3c:	85ca                	mv	a1,s2
    80000b3e:	855a                	mv	a0,s6
    80000b40:	95fff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000b44:	cd01                	beqz	a0,80000b5c <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b46:	418904b3          	sub	s1,s2,s8
    80000b4a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b4c:	fc99f6e3          	bgeu	s3,s1,80000b18 <copyin+0x28>
    80000b50:	84ce                	mv	s1,s3
    80000b52:	b7d9                	j	80000b18 <copyin+0x28>
  }
  return 0;
    80000b54:	4501                	li	a0,0
    80000b56:	a021                	j	80000b5e <copyin+0x6e>
    80000b58:	4501                	li	a0,0
}
    80000b5a:	8082                	ret
      return -1;
    80000b5c:	557d                	li	a0,-1
}
    80000b5e:	60a6                	ld	ra,72(sp)
    80000b60:	6406                	ld	s0,64(sp)
    80000b62:	74e2                	ld	s1,56(sp)
    80000b64:	7942                	ld	s2,48(sp)
    80000b66:	79a2                	ld	s3,40(sp)
    80000b68:	7a02                	ld	s4,32(sp)
    80000b6a:	6ae2                	ld	s5,24(sp)
    80000b6c:	6b42                	ld	s6,16(sp)
    80000b6e:	6ba2                	ld	s7,8(sp)
    80000b70:	6c02                	ld	s8,0(sp)
    80000b72:	6161                	addi	sp,sp,80
    80000b74:	8082                	ret

0000000080000b76 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000b76:	c6dd                	beqz	a3,80000c24 <copyinstr+0xae>
{
    80000b78:	715d                	addi	sp,sp,-80
    80000b7a:	e486                	sd	ra,72(sp)
    80000b7c:	e0a2                	sd	s0,64(sp)
    80000b7e:	fc26                	sd	s1,56(sp)
    80000b80:	f84a                	sd	s2,48(sp)
    80000b82:	f44e                	sd	s3,40(sp)
    80000b84:	f052                	sd	s4,32(sp)
    80000b86:	ec56                	sd	s5,24(sp)
    80000b88:	e85a                	sd	s6,16(sp)
    80000b8a:	e45e                	sd	s7,8(sp)
    80000b8c:	0880                	addi	s0,sp,80
    80000b8e:	8a2a                	mv	s4,a0
    80000b90:	8b2e                	mv	s6,a1
    80000b92:	8bb2                	mv	s7,a2
    80000b94:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000b96:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b98:	6985                	lui	s3,0x1
    80000b9a:	a825                	j	80000bd2 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b9c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000ba0:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000ba2:	37fd                	addiw	a5,a5,-1
    80000ba4:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000ba8:	60a6                	ld	ra,72(sp)
    80000baa:	6406                	ld	s0,64(sp)
    80000bac:	74e2                	ld	s1,56(sp)
    80000bae:	7942                	ld	s2,48(sp)
    80000bb0:	79a2                	ld	s3,40(sp)
    80000bb2:	7a02                	ld	s4,32(sp)
    80000bb4:	6ae2                	ld	s5,24(sp)
    80000bb6:	6b42                	ld	s6,16(sp)
    80000bb8:	6ba2                	ld	s7,8(sp)
    80000bba:	6161                	addi	sp,sp,80
    80000bbc:	8082                	ret
    80000bbe:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80000bc2:	9742                	add	a4,a4,a6
      --max;
    80000bc4:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000bc8:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000bcc:	04e58463          	beq	a1,a4,80000c14 <copyinstr+0x9e>
{
    80000bd0:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000bd2:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000bd6:	85a6                	mv	a1,s1
    80000bd8:	8552                	mv	a0,s4
    80000bda:	8c5ff0ef          	jal	8000049e <walkaddr>
    if(pa0 == 0)
    80000bde:	cd0d                	beqz	a0,80000c18 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000be0:	417486b3          	sub	a3,s1,s7
    80000be4:	96ce                	add	a3,a3,s3
    if(n > max)
    80000be6:	00d97363          	bgeu	s2,a3,80000bec <copyinstr+0x76>
    80000bea:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000bec:	955e                	add	a0,a0,s7
    80000bee:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000bf0:	c695                	beqz	a3,80000c1c <copyinstr+0xa6>
    80000bf2:	87da                	mv	a5,s6
    80000bf4:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000bf6:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000bfa:	96da                	add	a3,a3,s6
    80000bfc:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bfe:	00f60733          	add	a4,a2,a5
    80000c02:	00074703          	lbu	a4,0(a4)
    80000c06:	db59                	beqz	a4,80000b9c <copyinstr+0x26>
        *dst = *p;
    80000c08:	00e78023          	sb	a4,0(a5)
      dst++;
    80000c0c:	0785                	addi	a5,a5,1
    while(n > 0){
    80000c0e:	fed797e3          	bne	a5,a3,80000bfc <copyinstr+0x86>
    80000c12:	b775                	j	80000bbe <copyinstr+0x48>
    80000c14:	4781                	li	a5,0
    80000c16:	b771                	j	80000ba2 <copyinstr+0x2c>
      return -1;
    80000c18:	557d                	li	a0,-1
    80000c1a:	b779                	j	80000ba8 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000c1c:	6b85                	lui	s7,0x1
    80000c1e:	9ba6                	add	s7,s7,s1
    80000c20:	87da                	mv	a5,s6
    80000c22:	b77d                	j	80000bd0 <copyinstr+0x5a>
  int got_null = 0;
    80000c24:	4781                	li	a5,0
  if(got_null){
    80000c26:	37fd                	addiw	a5,a5,-1
    80000c28:	0007851b          	sext.w	a0,a5
}
    80000c2c:	8082                	ret

0000000080000c2e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c2e:	7139                	addi	sp,sp,-64
    80000c30:	fc06                	sd	ra,56(sp)
    80000c32:	f822                	sd	s0,48(sp)
    80000c34:	f426                	sd	s1,40(sp)
    80000c36:	f04a                	sd	s2,32(sp)
    80000c38:	ec4e                	sd	s3,24(sp)
    80000c3a:	e852                	sd	s4,16(sp)
    80000c3c:	e456                	sd	s5,8(sp)
    80000c3e:	e05a                	sd	s6,0(sp)
    80000c40:	0080                	addi	s0,sp,64
    80000c42:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c44:	00007497          	auipc	s1,0x7
    80000c48:	2cc48493          	addi	s1,s1,716 # 80007f10 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c4c:	8b26                	mv	s6,s1
    80000c4e:	04fa5937          	lui	s2,0x4fa5
    80000c52:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000c56:	0932                	slli	s2,s2,0xc
    80000c58:	fa590913          	addi	s2,s2,-91
    80000c5c:	0932                	slli	s2,s2,0xc
    80000c5e:	fa590913          	addi	s2,s2,-91
    80000c62:	0932                	slli	s2,s2,0xc
    80000c64:	fa590913          	addi	s2,s2,-91
    80000c68:	040009b7          	lui	s3,0x4000
    80000c6c:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c6e:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	0000da97          	auipc	s5,0xd
    80000c74:	ca0a8a93          	addi	s5,s5,-864 # 8000d910 <tickslock>
    char *pa = kalloc();
    80000c78:	c86ff0ef          	jal	800000fe <kalloc>
    80000c7c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c7e:	cd15                	beqz	a0,80000cba <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80000c80:	416485b3          	sub	a1,s1,s6
    80000c84:	858d                	srai	a1,a1,0x3
    80000c86:	032585b3          	mul	a1,a1,s2
    80000c8a:	2585                	addiw	a1,a1,1
    80000c8c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c90:	4719                	li	a4,6
    80000c92:	6685                	lui	a3,0x1
    80000c94:	40b985b3          	sub	a1,s3,a1
    80000c98:	8552                	mv	a0,s4
    80000c9a:	8f3ff0ef          	jal	8000058c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9e:	16848493          	addi	s1,s1,360
    80000ca2:	fd549be3          	bne	s1,s5,80000c78 <proc_mapstacks+0x4a>
  }
}
    80000ca6:	70e2                	ld	ra,56(sp)
    80000ca8:	7442                	ld	s0,48(sp)
    80000caa:	74a2                	ld	s1,40(sp)
    80000cac:	7902                	ld	s2,32(sp)
    80000cae:	69e2                	ld	s3,24(sp)
    80000cb0:	6a42                	ld	s4,16(sp)
    80000cb2:	6aa2                	ld	s5,8(sp)
    80000cb4:	6b02                	ld	s6,0(sp)
    80000cb6:	6121                	addi	sp,sp,64
    80000cb8:	8082                	ret
      panic("kalloc");
    80000cba:	00006517          	auipc	a0,0x6
    80000cbe:	4de50513          	addi	a0,a0,1246 # 80007198 <etext+0x198>
    80000cc2:	0e1040ef          	jal	800055a2 <panic>

0000000080000cc6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cc6:	7139                	addi	sp,sp,-64
    80000cc8:	fc06                	sd	ra,56(sp)
    80000cca:	f822                	sd	s0,48(sp)
    80000ccc:	f426                	sd	s1,40(sp)
    80000cce:	f04a                	sd	s2,32(sp)
    80000cd0:	ec4e                	sd	s3,24(sp)
    80000cd2:	e852                	sd	s4,16(sp)
    80000cd4:	e456                	sd	s5,8(sp)
    80000cd6:	e05a                	sd	s6,0(sp)
    80000cd8:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cda:	00006597          	auipc	a1,0x6
    80000cde:	4c658593          	addi	a1,a1,1222 # 800071a0 <etext+0x1a0>
    80000ce2:	00007517          	auipc	a0,0x7
    80000ce6:	dfe50513          	addi	a0,a0,-514 # 80007ae0 <pid_lock>
    80000cea:	367040ef          	jal	80005850 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cee:	00006597          	auipc	a1,0x6
    80000cf2:	4ba58593          	addi	a1,a1,1210 # 800071a8 <etext+0x1a8>
    80000cf6:	00007517          	auipc	a0,0x7
    80000cfa:	e0250513          	addi	a0,a0,-510 # 80007af8 <wait_lock>
    80000cfe:	353040ef          	jal	80005850 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d02:	00007497          	auipc	s1,0x7
    80000d06:	20e48493          	addi	s1,s1,526 # 80007f10 <proc>
      initlock(&p->lock, "proc");
    80000d0a:	00006b17          	auipc	s6,0x6
    80000d0e:	4aeb0b13          	addi	s6,s6,1198 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d12:	8aa6                	mv	s5,s1
    80000d14:	04fa5937          	lui	s2,0x4fa5
    80000d18:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000d1c:	0932                	slli	s2,s2,0xc
    80000d1e:	fa590913          	addi	s2,s2,-91
    80000d22:	0932                	slli	s2,s2,0xc
    80000d24:	fa590913          	addi	s2,s2,-91
    80000d28:	0932                	slli	s2,s2,0xc
    80000d2a:	fa590913          	addi	s2,s2,-91
    80000d2e:	040009b7          	lui	s3,0x4000
    80000d32:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d34:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	0000da17          	auipc	s4,0xd
    80000d3a:	bdaa0a13          	addi	s4,s4,-1062 # 8000d910 <tickslock>
      initlock(&p->lock, "proc");
    80000d3e:	85da                	mv	a1,s6
    80000d40:	8526                	mv	a0,s1
    80000d42:	30f040ef          	jal	80005850 <initlock>
      p->state = UNUSED;
    80000d46:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d4a:	415487b3          	sub	a5,s1,s5
    80000d4e:	878d                	srai	a5,a5,0x3
    80000d50:	032787b3          	mul	a5,a5,s2
    80000d54:	2785                	addiw	a5,a5,1
    80000d56:	00d7979b          	slliw	a5,a5,0xd
    80000d5a:	40f987b3          	sub	a5,s3,a5
    80000d5e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d60:	16848493          	addi	s1,s1,360
    80000d64:	fd449de3          	bne	s1,s4,80000d3e <procinit+0x78>
  }
}
    80000d68:	70e2                	ld	ra,56(sp)
    80000d6a:	7442                	ld	s0,48(sp)
    80000d6c:	74a2                	ld	s1,40(sp)
    80000d6e:	7902                	ld	s2,32(sp)
    80000d70:	69e2                	ld	s3,24(sp)
    80000d72:	6a42                	ld	s4,16(sp)
    80000d74:	6aa2                	ld	s5,8(sp)
    80000d76:	6b02                	ld	s6,0(sp)
    80000d78:	6121                	addi	sp,sp,64
    80000d7a:	8082                	ret

0000000080000d7c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d7c:	1141                	addi	sp,sp,-16
    80000d7e:	e422                	sd	s0,8(sp)
    80000d80:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d82:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d84:	2501                	sext.w	a0,a0
    80000d86:	6422                	ld	s0,8(sp)
    80000d88:	0141                	addi	sp,sp,16
    80000d8a:	8082                	ret

0000000080000d8c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e422                	sd	s0,8(sp)
    80000d90:	0800                	addi	s0,sp,16
    80000d92:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d94:	2781                	sext.w	a5,a5
    80000d96:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d98:	00007517          	auipc	a0,0x7
    80000d9c:	d7850513          	addi	a0,a0,-648 # 80007b10 <cpus>
    80000da0:	953e                	add	a0,a0,a5
    80000da2:	6422                	ld	s0,8(sp)
    80000da4:	0141                	addi	sp,sp,16
    80000da6:	8082                	ret

0000000080000da8 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000da8:	1101                	addi	sp,sp,-32
    80000daa:	ec06                	sd	ra,24(sp)
    80000dac:	e822                	sd	s0,16(sp)
    80000dae:	e426                	sd	s1,8(sp)
    80000db0:	1000                	addi	s0,sp,32
  push_off();
    80000db2:	2df040ef          	jal	80005890 <push_off>
    80000db6:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000db8:	2781                	sext.w	a5,a5
    80000dba:	079e                	slli	a5,a5,0x7
    80000dbc:	00007717          	auipc	a4,0x7
    80000dc0:	d2470713          	addi	a4,a4,-732 # 80007ae0 <pid_lock>
    80000dc4:	97ba                	add	a5,a5,a4
    80000dc6:	7b84                	ld	s1,48(a5)
  pop_off();
    80000dc8:	34d040ef          	jal	80005914 <pop_off>
  return p;
}
    80000dcc:	8526                	mv	a0,s1
    80000dce:	60e2                	ld	ra,24(sp)
    80000dd0:	6442                	ld	s0,16(sp)
    80000dd2:	64a2                	ld	s1,8(sp)
    80000dd4:	6105                	addi	sp,sp,32
    80000dd6:	8082                	ret

0000000080000dd8 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e406                	sd	ra,8(sp)
    80000ddc:	e022                	sd	s0,0(sp)
    80000dde:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000de0:	fc9ff0ef          	jal	80000da8 <myproc>
    80000de4:	385040ef          	jal	80005968 <release>

  if (first) {
    80000de8:	00007797          	auipc	a5,0x7
    80000dec:	c587a783          	lw	a5,-936(a5) # 80007a40 <first.1>
    80000df0:	e799                	bnez	a5,80000dfe <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000df2:	315000ef          	jal	80001906 <usertrapret>
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret
    fsinit(ROOTDEV);
    80000dfe:	4505                	li	a0,1
    80000e00:	766010ef          	jal	80002566 <fsinit>
    first = 0;
    80000e04:	00007797          	auipc	a5,0x7
    80000e08:	c207ae23          	sw	zero,-964(a5) # 80007a40 <first.1>
    __sync_synchronize();
    80000e0c:	0ff0000f          	fence
    80000e10:	b7cd                	j	80000df2 <forkret+0x1a>

0000000080000e12 <allocpid>:
{
    80000e12:	1101                	addi	sp,sp,-32
    80000e14:	ec06                	sd	ra,24(sp)
    80000e16:	e822                	sd	s0,16(sp)
    80000e18:	e426                	sd	s1,8(sp)
    80000e1a:	e04a                	sd	s2,0(sp)
    80000e1c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e1e:	00007917          	auipc	s2,0x7
    80000e22:	cc290913          	addi	s2,s2,-830 # 80007ae0 <pid_lock>
    80000e26:	854a                	mv	a0,s2
    80000e28:	2a9040ef          	jal	800058d0 <acquire>
  pid = nextpid;
    80000e2c:	00007797          	auipc	a5,0x7
    80000e30:	c1878793          	addi	a5,a5,-1000 # 80007a44 <nextpid>
    80000e34:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e36:	0014871b          	addiw	a4,s1,1
    80000e3a:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e3c:	854a                	mv	a0,s2
    80000e3e:	32b040ef          	jal	80005968 <release>
}
    80000e42:	8526                	mv	a0,s1
    80000e44:	60e2                	ld	ra,24(sp)
    80000e46:	6442                	ld	s0,16(sp)
    80000e48:	64a2                	ld	s1,8(sp)
    80000e4a:	6902                	ld	s2,0(sp)
    80000e4c:	6105                	addi	sp,sp,32
    80000e4e:	8082                	ret

0000000080000e50 <proc_pagetable>:
{
    80000e50:	1101                	addi	sp,sp,-32
    80000e52:	ec06                	sd	ra,24(sp)
    80000e54:	e822                	sd	s0,16(sp)
    80000e56:	e426                	sd	s1,8(sp)
    80000e58:	e04a                	sd	s2,0(sp)
    80000e5a:	1000                	addi	s0,sp,32
    80000e5c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e5e:	8e1ff0ef          	jal	8000073e <uvmcreate>
    80000e62:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e64:	cd05                	beqz	a0,80000e9c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e66:	4729                	li	a4,10
    80000e68:	00005697          	auipc	a3,0x5
    80000e6c:	19868693          	addi	a3,a3,408 # 80006000 <_trampoline>
    80000e70:	6605                	lui	a2,0x1
    80000e72:	040005b7          	lui	a1,0x4000
    80000e76:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e78:	05b2                	slli	a1,a1,0xc
    80000e7a:	e62ff0ef          	jal	800004dc <mappages>
    80000e7e:	02054663          	bltz	a0,80000eaa <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e82:	4719                	li	a4,6
    80000e84:	05893683          	ld	a3,88(s2)
    80000e88:	6605                	lui	a2,0x1
    80000e8a:	020005b7          	lui	a1,0x2000
    80000e8e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e90:	05b6                	slli	a1,a1,0xd
    80000e92:	8526                	mv	a0,s1
    80000e94:	e48ff0ef          	jal	800004dc <mappages>
    80000e98:	00054f63          	bltz	a0,80000eb6 <proc_pagetable+0x66>
}
    80000e9c:	8526                	mv	a0,s1
    80000e9e:	60e2                	ld	ra,24(sp)
    80000ea0:	6442                	ld	s0,16(sp)
    80000ea2:	64a2                	ld	s1,8(sp)
    80000ea4:	6902                	ld	s2,0(sp)
    80000ea6:	6105                	addi	sp,sp,32
    80000ea8:	8082                	ret
    uvmfree(pagetable, 0);
    80000eaa:	4581                	li	a1,0
    80000eac:	8526                	mv	a0,s1
    80000eae:	a5fff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000eb2:	4481                	li	s1,0
    80000eb4:	b7e5                	j	80000e9c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eb6:	4681                	li	a3,0
    80000eb8:	4605                	li	a2,1
    80000eba:	040005b7          	lui	a1,0x4000
    80000ebe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ec0:	05b2                	slli	a1,a1,0xc
    80000ec2:	8526                	mv	a0,s1
    80000ec4:	fbeff0ef          	jal	80000682 <uvmunmap>
    uvmfree(pagetable, 0);
    80000ec8:	4581                	li	a1,0
    80000eca:	8526                	mv	a0,s1
    80000ecc:	a41ff0ef          	jal	8000090c <uvmfree>
    return 0;
    80000ed0:	4481                	li	s1,0
    80000ed2:	b7e9                	j	80000e9c <proc_pagetable+0x4c>

0000000080000ed4 <proc_freepagetable>:
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	e04a                	sd	s2,0(sp)
    80000ede:	1000                	addi	s0,sp,32
    80000ee0:	84aa                	mv	s1,a0
    80000ee2:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ee4:	4681                	li	a3,0
    80000ee6:	4605                	li	a2,1
    80000ee8:	040005b7          	lui	a1,0x4000
    80000eec:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eee:	05b2                	slli	a1,a1,0xc
    80000ef0:	f92ff0ef          	jal	80000682 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ef4:	4681                	li	a3,0
    80000ef6:	4605                	li	a2,1
    80000ef8:	020005b7          	lui	a1,0x2000
    80000efc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000efe:	05b6                	slli	a1,a1,0xd
    80000f00:	8526                	mv	a0,s1
    80000f02:	f80ff0ef          	jal	80000682 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f06:	85ca                	mv	a1,s2
    80000f08:	8526                	mv	a0,s1
    80000f0a:	a03ff0ef          	jal	8000090c <uvmfree>
}
    80000f0e:	60e2                	ld	ra,24(sp)
    80000f10:	6442                	ld	s0,16(sp)
    80000f12:	64a2                	ld	s1,8(sp)
    80000f14:	6902                	ld	s2,0(sp)
    80000f16:	6105                	addi	sp,sp,32
    80000f18:	8082                	ret

0000000080000f1a <freeproc>:
{
    80000f1a:	1101                	addi	sp,sp,-32
    80000f1c:	ec06                	sd	ra,24(sp)
    80000f1e:	e822                	sd	s0,16(sp)
    80000f20:	e426                	sd	s1,8(sp)
    80000f22:	1000                	addi	s0,sp,32
    80000f24:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f26:	6d28                	ld	a0,88(a0)
    80000f28:	c119                	beqz	a0,80000f2e <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f2a:	8f2ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f2e:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f32:	68a8                	ld	a0,80(s1)
    80000f34:	c501                	beqz	a0,80000f3c <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f36:	64ac                	ld	a1,72(s1)
    80000f38:	f9dff0ef          	jal	80000ed4 <proc_freepagetable>
  p->pagetable = 0;
    80000f3c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f40:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f44:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f48:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f4c:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f50:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f54:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f58:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f5c:	0004ac23          	sw	zero,24(s1)
}
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6105                	addi	sp,sp,32
    80000f68:	8082                	ret

0000000080000f6a <allocproc>:
{
    80000f6a:	1101                	addi	sp,sp,-32
    80000f6c:	ec06                	sd	ra,24(sp)
    80000f6e:	e822                	sd	s0,16(sp)
    80000f70:	e426                	sd	s1,8(sp)
    80000f72:	e04a                	sd	s2,0(sp)
    80000f74:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f76:	00007497          	auipc	s1,0x7
    80000f7a:	f9a48493          	addi	s1,s1,-102 # 80007f10 <proc>
    80000f7e:	0000d917          	auipc	s2,0xd
    80000f82:	99290913          	addi	s2,s2,-1646 # 8000d910 <tickslock>
    acquire(&p->lock);
    80000f86:	8526                	mv	a0,s1
    80000f88:	149040ef          	jal	800058d0 <acquire>
    if(p->state == UNUSED) {
    80000f8c:	4c9c                	lw	a5,24(s1)
    80000f8e:	cb91                	beqz	a5,80000fa2 <allocproc+0x38>
      release(&p->lock);
    80000f90:	8526                	mv	a0,s1
    80000f92:	1d7040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f96:	16848493          	addi	s1,s1,360
    80000f9a:	ff2496e3          	bne	s1,s2,80000f86 <allocproc+0x1c>
  return 0;
    80000f9e:	4481                	li	s1,0
    80000fa0:	a089                	j	80000fe2 <allocproc+0x78>
  p->pid = allocpid();
    80000fa2:	e71ff0ef          	jal	80000e12 <allocpid>
    80000fa6:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fa8:	4785                	li	a5,1
    80000faa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fac:	952ff0ef          	jal	800000fe <kalloc>
    80000fb0:	892a                	mv	s2,a0
    80000fb2:	eca8                	sd	a0,88(s1)
    80000fb4:	cd15                	beqz	a0,80000ff0 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	e99ff0ef          	jal	80000e50 <proc_pagetable>
    80000fbc:	892a                	mv	s2,a0
    80000fbe:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000fc0:	c121                	beqz	a0,80001000 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000fc2:	07000613          	li	a2,112
    80000fc6:	4581                	li	a1,0
    80000fc8:	06048513          	addi	a0,s1,96
    80000fcc:	9c4ff0ef          	jal	80000190 <memset>
  p->context.ra = (uint64)forkret;
    80000fd0:	00000797          	auipc	a5,0x0
    80000fd4:	e0878793          	addi	a5,a5,-504 # 80000dd8 <forkret>
    80000fd8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000fda:	60bc                	ld	a5,64(s1)
    80000fdc:	6705                	lui	a4,0x1
    80000fde:	97ba                	add	a5,a5,a4
    80000fe0:	f4bc                	sd	a5,104(s1)
}
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret
    freeproc(p);
    80000ff0:	8526                	mv	a0,s1
    80000ff2:	f29ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80000ff6:	8526                	mv	a0,s1
    80000ff8:	171040ef          	jal	80005968 <release>
    return 0;
    80000ffc:	84ca                	mv	s1,s2
    80000ffe:	b7d5                	j	80000fe2 <allocproc+0x78>
    freeproc(p);
    80001000:	8526                	mv	a0,s1
    80001002:	f19ff0ef          	jal	80000f1a <freeproc>
    release(&p->lock);
    80001006:	8526                	mv	a0,s1
    80001008:	161040ef          	jal	80005968 <release>
    return 0;
    8000100c:	84ca                	mv	s1,s2
    8000100e:	bfd1                	j	80000fe2 <allocproc+0x78>

0000000080001010 <userinit>:
{
    80001010:	1101                	addi	sp,sp,-32
    80001012:	ec06                	sd	ra,24(sp)
    80001014:	e822                	sd	s0,16(sp)
    80001016:	e426                	sd	s1,8(sp)
    80001018:	1000                	addi	s0,sp,32
  p = allocproc();
    8000101a:	f51ff0ef          	jal	80000f6a <allocproc>
    8000101e:	84aa                	mv	s1,a0
  initproc = p;
    80001020:	00007797          	auipc	a5,0x7
    80001024:	a8a7b023          	sd	a0,-1408(a5) # 80007aa0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001028:	03400613          	li	a2,52
    8000102c:	00007597          	auipc	a1,0x7
    80001030:	a2458593          	addi	a1,a1,-1500 # 80007a50 <initcode>
    80001034:	6928                	ld	a0,80(a0)
    80001036:	f2eff0ef          	jal	80000764 <uvmfirst>
  p->sz = PGSIZE;
    8000103a:	6785                	lui	a5,0x1
    8000103c:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000103e:	6cb8                	ld	a4,88(s1)
    80001040:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001044:	6cb8                	ld	a4,88(s1)
    80001046:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001048:	4641                	li	a2,16
    8000104a:	00006597          	auipc	a1,0x6
    8000104e:	17658593          	addi	a1,a1,374 # 800071c0 <etext+0x1c0>
    80001052:	15848513          	addi	a0,s1,344
    80001056:	a78ff0ef          	jal	800002ce <safestrcpy>
  p->cwd = namei("/");
    8000105a:	00006517          	auipc	a0,0x6
    8000105e:	17650513          	addi	a0,a0,374 # 800071d0 <etext+0x1d0>
    80001062:	613010ef          	jal	80002e74 <namei>
    80001066:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000106a:	478d                	li	a5,3
    8000106c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000106e:	8526                	mv	a0,s1
    80001070:	0f9040ef          	jal	80005968 <release>
}
    80001074:	60e2                	ld	ra,24(sp)
    80001076:	6442                	ld	s0,16(sp)
    80001078:	64a2                	ld	s1,8(sp)
    8000107a:	6105                	addi	sp,sp,32
    8000107c:	8082                	ret

000000008000107e <growproc>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	e04a                	sd	s2,0(sp)
    80001088:	1000                	addi	s0,sp,32
    8000108a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000108c:	d1dff0ef          	jal	80000da8 <myproc>
    80001090:	84aa                	mv	s1,a0
  sz = p->sz;
    80001092:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001094:	01204c63          	bgtz	s2,800010ac <growproc+0x2e>
  } else if(n < 0){
    80001098:	02094463          	bltz	s2,800010c0 <growproc+0x42>
  p->sz = sz;
    8000109c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000109e:	4501                	li	a0,0
}
    800010a0:	60e2                	ld	ra,24(sp)
    800010a2:	6442                	ld	s0,16(sp)
    800010a4:	64a2                	ld	s1,8(sp)
    800010a6:	6902                	ld	s2,0(sp)
    800010a8:	6105                	addi	sp,sp,32
    800010aa:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010ac:	4691                	li	a3,4
    800010ae:	00b90633          	add	a2,s2,a1
    800010b2:	6928                	ld	a0,80(a0)
    800010b4:	f52ff0ef          	jal	80000806 <uvmalloc>
    800010b8:	85aa                	mv	a1,a0
    800010ba:	f16d                	bnez	a0,8000109c <growproc+0x1e>
      return -1;
    800010bc:	557d                	li	a0,-1
    800010be:	b7cd                	j	800010a0 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c0:	00b90633          	add	a2,s2,a1
    800010c4:	6928                	ld	a0,80(a0)
    800010c6:	efcff0ef          	jal	800007c2 <uvmdealloc>
    800010ca:	85aa                	mv	a1,a0
    800010cc:	bfc1                	j	8000109c <growproc+0x1e>

00000000800010ce <fork>:
{
    800010ce:	7139                	addi	sp,sp,-64
    800010d0:	fc06                	sd	ra,56(sp)
    800010d2:	f822                	sd	s0,48(sp)
    800010d4:	f04a                	sd	s2,32(sp)
    800010d6:	e456                	sd	s5,8(sp)
    800010d8:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010da:	ccfff0ef          	jal	80000da8 <myproc>
    800010de:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e0:	e8bff0ef          	jal	80000f6a <allocproc>
    800010e4:	0e050e63          	beqz	a0,800011e0 <fork+0x112>
    800010e8:	ec4e                	sd	s3,24(sp)
    800010ea:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010ec:	048ab603          	ld	a2,72(s5)
    800010f0:	692c                	ld	a1,80(a0)
    800010f2:	050ab503          	ld	a0,80(s5)
    800010f6:	849ff0ef          	jal	8000093e <uvmcopy>
    800010fa:	04054e63          	bltz	a0,80001156 <fork+0x88>
    800010fe:	f426                	sd	s1,40(sp)
    80001100:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001102:	048ab783          	ld	a5,72(s5)
    80001106:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    8000110a:	058ab683          	ld	a3,88(s5)
    8000110e:	87b6                	mv	a5,a3
    80001110:	0589b703          	ld	a4,88(s3)
    80001114:	12068693          	addi	a3,a3,288
    80001118:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000111c:	6788                	ld	a0,8(a5)
    8000111e:	6b8c                	ld	a1,16(a5)
    80001120:	6f90                	ld	a2,24(a5)
    80001122:	01073023          	sd	a6,0(a4)
    80001126:	e708                	sd	a0,8(a4)
    80001128:	eb0c                	sd	a1,16(a4)
    8000112a:	ef10                	sd	a2,24(a4)
    8000112c:	02078793          	addi	a5,a5,32
    80001130:	02070713          	addi	a4,a4,32
    80001134:	fed792e3          	bne	a5,a3,80001118 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001138:	0589b783          	ld	a5,88(s3)
    8000113c:	0607b823          	sd	zero,112(a5)
    np->trace_mask = p->trace_mask;  // Inherit trace setting
    80001140:	034aa783          	lw	a5,52(s5)
    80001144:	02f9aa23          	sw	a5,52(s3)
  for(i = 0; i < NOFILE; i++)
    80001148:	0d0a8493          	addi	s1,s5,208
    8000114c:	0d098913          	addi	s2,s3,208
    80001150:	150a8a13          	addi	s4,s5,336
    80001154:	a831                	j	80001170 <fork+0xa2>
    freeproc(np);
    80001156:	854e                	mv	a0,s3
    80001158:	dc3ff0ef          	jal	80000f1a <freeproc>
    release(&np->lock);
    8000115c:	854e                	mv	a0,s3
    8000115e:	00b040ef          	jal	80005968 <release>
    return -1;
    80001162:	597d                	li	s2,-1
    80001164:	69e2                	ld	s3,24(sp)
    80001166:	a0b5                	j	800011d2 <fork+0x104>
  for(i = 0; i < NOFILE; i++)
    80001168:	04a1                	addi	s1,s1,8
    8000116a:	0921                	addi	s2,s2,8
    8000116c:	01448963          	beq	s1,s4,8000117e <fork+0xb0>
    if(p->ofile[i])
    80001170:	6088                	ld	a0,0(s1)
    80001172:	d97d                	beqz	a0,80001168 <fork+0x9a>
      np->ofile[i] = filedup(p->ofile[i]);
    80001174:	290020ef          	jal	80003404 <filedup>
    80001178:	00a93023          	sd	a0,0(s2)
    8000117c:	b7f5                	j	80001168 <fork+0x9a>
  np->cwd = idup(p->cwd);
    8000117e:	150ab503          	ld	a0,336(s5)
    80001182:	5e2010ef          	jal	80002764 <idup>
    80001186:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000118a:	4641                	li	a2,16
    8000118c:	158a8593          	addi	a1,s5,344
    80001190:	15898513          	addi	a0,s3,344
    80001194:	93aff0ef          	jal	800002ce <safestrcpy>
  pid = np->pid;
    80001198:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    8000119c:	854e                	mv	a0,s3
    8000119e:	7ca040ef          	jal	80005968 <release>
  acquire(&wait_lock);
    800011a2:	00007497          	auipc	s1,0x7
    800011a6:	95648493          	addi	s1,s1,-1706 # 80007af8 <wait_lock>
    800011aa:	8526                	mv	a0,s1
    800011ac:	724040ef          	jal	800058d0 <acquire>
  np->parent = p;
    800011b0:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011b4:	8526                	mv	a0,s1
    800011b6:	7b2040ef          	jal	80005968 <release>
  acquire(&np->lock);
    800011ba:	854e                	mv	a0,s3
    800011bc:	714040ef          	jal	800058d0 <acquire>
  np->state = RUNNABLE;
    800011c0:	478d                	li	a5,3
    800011c2:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011c6:	854e                	mv	a0,s3
    800011c8:	7a0040ef          	jal	80005968 <release>
  return pid;
    800011cc:	74a2                	ld	s1,40(sp)
    800011ce:	69e2                	ld	s3,24(sp)
    800011d0:	6a42                	ld	s4,16(sp)
}
    800011d2:	854a                	mv	a0,s2
    800011d4:	70e2                	ld	ra,56(sp)
    800011d6:	7442                	ld	s0,48(sp)
    800011d8:	7902                	ld	s2,32(sp)
    800011da:	6aa2                	ld	s5,8(sp)
    800011dc:	6121                	addi	sp,sp,64
    800011de:	8082                	ret
    return -1;
    800011e0:	597d                	li	s2,-1
    800011e2:	bfc5                	j	800011d2 <fork+0x104>

00000000800011e4 <scheduler>:
{
    800011e4:	715d                	addi	sp,sp,-80
    800011e6:	e486                	sd	ra,72(sp)
    800011e8:	e0a2                	sd	s0,64(sp)
    800011ea:	fc26                	sd	s1,56(sp)
    800011ec:	f84a                	sd	s2,48(sp)
    800011ee:	f44e                	sd	s3,40(sp)
    800011f0:	f052                	sd	s4,32(sp)
    800011f2:	ec56                	sd	s5,24(sp)
    800011f4:	e85a                	sd	s6,16(sp)
    800011f6:	e45e                	sd	s7,8(sp)
    800011f8:	e062                	sd	s8,0(sp)
    800011fa:	0880                	addi	s0,sp,80
    800011fc:	8792                	mv	a5,tp
  int id = r_tp();
    800011fe:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001200:	00779b13          	slli	s6,a5,0x7
    80001204:	00007717          	auipc	a4,0x7
    80001208:	8dc70713          	addi	a4,a4,-1828 # 80007ae0 <pid_lock>
    8000120c:	975a                	add	a4,a4,s6
    8000120e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001212:	00007717          	auipc	a4,0x7
    80001216:	90670713          	addi	a4,a4,-1786 # 80007b18 <cpus+0x8>
    8000121a:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000121c:	4c11                	li	s8,4
        c->proc = p;
    8000121e:	079e                	slli	a5,a5,0x7
    80001220:	00007a17          	auipc	s4,0x7
    80001224:	8c0a0a13          	addi	s4,s4,-1856 # 80007ae0 <pid_lock>
    80001228:	9a3e                	add	s4,s4,a5
        found = 1;
    8000122a:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    8000122c:	0000c997          	auipc	s3,0xc
    80001230:	6e498993          	addi	s3,s3,1764 # 8000d910 <tickslock>
    80001234:	a0a9                	j	8000127e <scheduler+0x9a>
      release(&p->lock);
    80001236:	8526                	mv	a0,s1
    80001238:	730040ef          	jal	80005968 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000123c:	16848493          	addi	s1,s1,360
    80001240:	03348563          	beq	s1,s3,8000126a <scheduler+0x86>
      acquire(&p->lock);
    80001244:	8526                	mv	a0,s1
    80001246:	68a040ef          	jal	800058d0 <acquire>
      if(p->state == RUNNABLE) {
    8000124a:	4c9c                	lw	a5,24(s1)
    8000124c:	ff2795e3          	bne	a5,s2,80001236 <scheduler+0x52>
        p->state = RUNNING;
    80001250:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001254:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001258:	06048593          	addi	a1,s1,96
    8000125c:	855a                	mv	a0,s6
    8000125e:	602000ef          	jal	80001860 <swtch>
        c->proc = 0;
    80001262:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001266:	8ade                	mv	s5,s7
    80001268:	b7f9                	j	80001236 <scheduler+0x52>
    if(found == 0) {
    8000126a:	000a9a63          	bnez	s5,8000127e <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000126e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001272:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001276:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    8000127a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001286:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000128a:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000128c:	00007497          	auipc	s1,0x7
    80001290:	c8448493          	addi	s1,s1,-892 # 80007f10 <proc>
      if(p->state == RUNNABLE) {
    80001294:	490d                	li	s2,3
    80001296:	b77d                	j	80001244 <scheduler+0x60>

0000000080001298 <sched>:
{
    80001298:	7179                	addi	sp,sp,-48
    8000129a:	f406                	sd	ra,40(sp)
    8000129c:	f022                	sd	s0,32(sp)
    8000129e:	ec26                	sd	s1,24(sp)
    800012a0:	e84a                	sd	s2,16(sp)
    800012a2:	e44e                	sd	s3,8(sp)
    800012a4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012a6:	b03ff0ef          	jal	80000da8 <myproc>
    800012aa:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012ac:	5ba040ef          	jal	80005866 <holding>
    800012b0:	c92d                	beqz	a0,80001322 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012b2:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012b4:	2781                	sext.w	a5,a5
    800012b6:	079e                	slli	a5,a5,0x7
    800012b8:	00007717          	auipc	a4,0x7
    800012bc:	82870713          	addi	a4,a4,-2008 # 80007ae0 <pid_lock>
    800012c0:	97ba                	add	a5,a5,a4
    800012c2:	0a87a703          	lw	a4,168(a5)
    800012c6:	4785                	li	a5,1
    800012c8:	06f71363          	bne	a4,a5,8000132e <sched+0x96>
  if(p->state == RUNNING)
    800012cc:	4c98                	lw	a4,24(s1)
    800012ce:	4791                	li	a5,4
    800012d0:	06f70563          	beq	a4,a5,8000133a <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012d4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012d8:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012da:	e7b5                	bnez	a5,80001346 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012dc:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012de:	00007917          	auipc	s2,0x7
    800012e2:	80290913          	addi	s2,s2,-2046 # 80007ae0 <pid_lock>
    800012e6:	2781                	sext.w	a5,a5
    800012e8:	079e                	slli	a5,a5,0x7
    800012ea:	97ca                	add	a5,a5,s2
    800012ec:	0ac7a983          	lw	s3,172(a5)
    800012f0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800012f2:	2781                	sext.w	a5,a5
    800012f4:	079e                	slli	a5,a5,0x7
    800012f6:	00007597          	auipc	a1,0x7
    800012fa:	82258593          	addi	a1,a1,-2014 # 80007b18 <cpus+0x8>
    800012fe:	95be                	add	a1,a1,a5
    80001300:	06048513          	addi	a0,s1,96
    80001304:	55c000ef          	jal	80001860 <swtch>
    80001308:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000130a:	2781                	sext.w	a5,a5
    8000130c:	079e                	slli	a5,a5,0x7
    8000130e:	993e                	add	s2,s2,a5
    80001310:	0b392623          	sw	s3,172(s2)
}
    80001314:	70a2                	ld	ra,40(sp)
    80001316:	7402                	ld	s0,32(sp)
    80001318:	64e2                	ld	s1,24(sp)
    8000131a:	6942                	ld	s2,16(sp)
    8000131c:	69a2                	ld	s3,8(sp)
    8000131e:	6145                	addi	sp,sp,48
    80001320:	8082                	ret
    panic("sched p->lock");
    80001322:	00006517          	auipc	a0,0x6
    80001326:	eb650513          	addi	a0,a0,-330 # 800071d8 <etext+0x1d8>
    8000132a:	278040ef          	jal	800055a2 <panic>
    panic("sched locks");
    8000132e:	00006517          	auipc	a0,0x6
    80001332:	eba50513          	addi	a0,a0,-326 # 800071e8 <etext+0x1e8>
    80001336:	26c040ef          	jal	800055a2 <panic>
    panic("sched running");
    8000133a:	00006517          	auipc	a0,0x6
    8000133e:	ebe50513          	addi	a0,a0,-322 # 800071f8 <etext+0x1f8>
    80001342:	260040ef          	jal	800055a2 <panic>
    panic("sched interruptible");
    80001346:	00006517          	auipc	a0,0x6
    8000134a:	ec250513          	addi	a0,a0,-318 # 80007208 <etext+0x208>
    8000134e:	254040ef          	jal	800055a2 <panic>

0000000080001352 <yield>:
{
    80001352:	1101                	addi	sp,sp,-32
    80001354:	ec06                	sd	ra,24(sp)
    80001356:	e822                	sd	s0,16(sp)
    80001358:	e426                	sd	s1,8(sp)
    8000135a:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000135c:	a4dff0ef          	jal	80000da8 <myproc>
    80001360:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001362:	56e040ef          	jal	800058d0 <acquire>
  p->state = RUNNABLE;
    80001366:	478d                	li	a5,3
    80001368:	cc9c                	sw	a5,24(s1)
  sched();
    8000136a:	f2fff0ef          	jal	80001298 <sched>
  release(&p->lock);
    8000136e:	8526                	mv	a0,s1
    80001370:	5f8040ef          	jal	80005968 <release>
}
    80001374:	60e2                	ld	ra,24(sp)
    80001376:	6442                	ld	s0,16(sp)
    80001378:	64a2                	ld	s1,8(sp)
    8000137a:	6105                	addi	sp,sp,32
    8000137c:	8082                	ret

000000008000137e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000137e:	7179                	addi	sp,sp,-48
    80001380:	f406                	sd	ra,40(sp)
    80001382:	f022                	sd	s0,32(sp)
    80001384:	ec26                	sd	s1,24(sp)
    80001386:	e84a                	sd	s2,16(sp)
    80001388:	e44e                	sd	s3,8(sp)
    8000138a:	1800                	addi	s0,sp,48
    8000138c:	89aa                	mv	s3,a0
    8000138e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001390:	a19ff0ef          	jal	80000da8 <myproc>
    80001394:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001396:	53a040ef          	jal	800058d0 <acquire>
  release(lk);
    8000139a:	854a                	mv	a0,s2
    8000139c:	5cc040ef          	jal	80005968 <release>

  // Go to sleep.
  p->chan = chan;
    800013a0:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013a4:	4789                	li	a5,2
    800013a6:	cc9c                	sw	a5,24(s1)

  sched();
    800013a8:	ef1ff0ef          	jal	80001298 <sched>

  // Tidy up.
  p->chan = 0;
    800013ac:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013b0:	8526                	mv	a0,s1
    800013b2:	5b6040ef          	jal	80005968 <release>
  acquire(lk);
    800013b6:	854a                	mv	a0,s2
    800013b8:	518040ef          	jal	800058d0 <acquire>
}
    800013bc:	70a2                	ld	ra,40(sp)
    800013be:	7402                	ld	s0,32(sp)
    800013c0:	64e2                	ld	s1,24(sp)
    800013c2:	6942                	ld	s2,16(sp)
    800013c4:	69a2                	ld	s3,8(sp)
    800013c6:	6145                	addi	sp,sp,48
    800013c8:	8082                	ret

00000000800013ca <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800013ca:	7139                	addi	sp,sp,-64
    800013cc:	fc06                	sd	ra,56(sp)
    800013ce:	f822                	sd	s0,48(sp)
    800013d0:	f426                	sd	s1,40(sp)
    800013d2:	f04a                	sd	s2,32(sp)
    800013d4:	ec4e                	sd	s3,24(sp)
    800013d6:	e852                	sd	s4,16(sp)
    800013d8:	e456                	sd	s5,8(sp)
    800013da:	0080                	addi	s0,sp,64
    800013dc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013de:	00007497          	auipc	s1,0x7
    800013e2:	b3248493          	addi	s1,s1,-1230 # 80007f10 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013e6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013e8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013ea:	0000c917          	auipc	s2,0xc
    800013ee:	52690913          	addi	s2,s2,1318 # 8000d910 <tickslock>
    800013f2:	a801                	j	80001402 <wakeup+0x38>
      }
      release(&p->lock);
    800013f4:	8526                	mv	a0,s1
    800013f6:	572040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	16848493          	addi	s1,s1,360
    800013fe:	03248263          	beq	s1,s2,80001422 <wakeup+0x58>
    if(p != myproc()){
    80001402:	9a7ff0ef          	jal	80000da8 <myproc>
    80001406:	fea48ae3          	beq	s1,a0,800013fa <wakeup+0x30>
      acquire(&p->lock);
    8000140a:	8526                	mv	a0,s1
    8000140c:	4c4040ef          	jal	800058d0 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001410:	4c9c                	lw	a5,24(s1)
    80001412:	ff3791e3          	bne	a5,s3,800013f4 <wakeup+0x2a>
    80001416:	709c                	ld	a5,32(s1)
    80001418:	fd479ee3          	bne	a5,s4,800013f4 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000141c:	0154ac23          	sw	s5,24(s1)
    80001420:	bfd1                	j	800013f4 <wakeup+0x2a>
    }
  }
}
    80001422:	70e2                	ld	ra,56(sp)
    80001424:	7442                	ld	s0,48(sp)
    80001426:	74a2                	ld	s1,40(sp)
    80001428:	7902                	ld	s2,32(sp)
    8000142a:	69e2                	ld	s3,24(sp)
    8000142c:	6a42                	ld	s4,16(sp)
    8000142e:	6aa2                	ld	s5,8(sp)
    80001430:	6121                	addi	sp,sp,64
    80001432:	8082                	ret

0000000080001434 <reparent>:
{
    80001434:	7179                	addi	sp,sp,-48
    80001436:	f406                	sd	ra,40(sp)
    80001438:	f022                	sd	s0,32(sp)
    8000143a:	ec26                	sd	s1,24(sp)
    8000143c:	e84a                	sd	s2,16(sp)
    8000143e:	e44e                	sd	s3,8(sp)
    80001440:	e052                	sd	s4,0(sp)
    80001442:	1800                	addi	s0,sp,48
    80001444:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001446:	00007497          	auipc	s1,0x7
    8000144a:	aca48493          	addi	s1,s1,-1334 # 80007f10 <proc>
      pp->parent = initproc;
    8000144e:	00006a17          	auipc	s4,0x6
    80001452:	652a0a13          	addi	s4,s4,1618 # 80007aa0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001456:	0000c997          	auipc	s3,0xc
    8000145a:	4ba98993          	addi	s3,s3,1210 # 8000d910 <tickslock>
    8000145e:	a029                	j	80001468 <reparent+0x34>
    80001460:	16848493          	addi	s1,s1,360
    80001464:	01348b63          	beq	s1,s3,8000147a <reparent+0x46>
    if(pp->parent == p){
    80001468:	7c9c                	ld	a5,56(s1)
    8000146a:	ff279be3          	bne	a5,s2,80001460 <reparent+0x2c>
      pp->parent = initproc;
    8000146e:	000a3503          	ld	a0,0(s4)
    80001472:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001474:	f57ff0ef          	jal	800013ca <wakeup>
    80001478:	b7e5                	j	80001460 <reparent+0x2c>
}
    8000147a:	70a2                	ld	ra,40(sp)
    8000147c:	7402                	ld	s0,32(sp)
    8000147e:	64e2                	ld	s1,24(sp)
    80001480:	6942                	ld	s2,16(sp)
    80001482:	69a2                	ld	s3,8(sp)
    80001484:	6a02                	ld	s4,0(sp)
    80001486:	6145                	addi	sp,sp,48
    80001488:	8082                	ret

000000008000148a <exit>:
{
    8000148a:	7179                	addi	sp,sp,-48
    8000148c:	f406                	sd	ra,40(sp)
    8000148e:	f022                	sd	s0,32(sp)
    80001490:	ec26                	sd	s1,24(sp)
    80001492:	e84a                	sd	s2,16(sp)
    80001494:	e44e                	sd	s3,8(sp)
    80001496:	e052                	sd	s4,0(sp)
    80001498:	1800                	addi	s0,sp,48
    8000149a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000149c:	90dff0ef          	jal	80000da8 <myproc>
    800014a0:	89aa                	mv	s3,a0
  if(p == initproc)
    800014a2:	00006797          	auipc	a5,0x6
    800014a6:	5fe7b783          	ld	a5,1534(a5) # 80007aa0 <initproc>
    800014aa:	0d050493          	addi	s1,a0,208
    800014ae:	15050913          	addi	s2,a0,336
    800014b2:	00a79f63          	bne	a5,a0,800014d0 <exit+0x46>
    panic("init exiting");
    800014b6:	00006517          	auipc	a0,0x6
    800014ba:	d6a50513          	addi	a0,a0,-662 # 80007220 <etext+0x220>
    800014be:	0e4040ef          	jal	800055a2 <panic>
      fileclose(f);
    800014c2:	789010ef          	jal	8000344a <fileclose>
      p->ofile[fd] = 0;
    800014c6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800014ca:	04a1                	addi	s1,s1,8
    800014cc:	01248563          	beq	s1,s2,800014d6 <exit+0x4c>
    if(p->ofile[fd]){
    800014d0:	6088                	ld	a0,0(s1)
    800014d2:	f965                	bnez	a0,800014c2 <exit+0x38>
    800014d4:	bfdd                	j	800014ca <exit+0x40>
  begin_op();
    800014d6:	35b010ef          	jal	80003030 <begin_op>
  iput(p->cwd);
    800014da:	1509b503          	ld	a0,336(s3)
    800014de:	43e010ef          	jal	8000291c <iput>
  end_op();
    800014e2:	3b9010ef          	jal	8000309a <end_op>
  p->cwd = 0;
    800014e6:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014ea:	00006497          	auipc	s1,0x6
    800014ee:	60e48493          	addi	s1,s1,1550 # 80007af8 <wait_lock>
    800014f2:	8526                	mv	a0,s1
    800014f4:	3dc040ef          	jal	800058d0 <acquire>
  reparent(p);
    800014f8:	854e                	mv	a0,s3
    800014fa:	f3bff0ef          	jal	80001434 <reparent>
  wakeup(p->parent);
    800014fe:	0389b503          	ld	a0,56(s3)
    80001502:	ec9ff0ef          	jal	800013ca <wakeup>
  acquire(&p->lock);
    80001506:	854e                	mv	a0,s3
    80001508:	3c8040ef          	jal	800058d0 <acquire>
  p->xstate = status;
    8000150c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001510:	4795                	li	a5,5
    80001512:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001516:	8526                	mv	a0,s1
    80001518:	450040ef          	jal	80005968 <release>
  sched();
    8000151c:	d7dff0ef          	jal	80001298 <sched>
  panic("zombie exit");
    80001520:	00006517          	auipc	a0,0x6
    80001524:	d1050513          	addi	a0,a0,-752 # 80007230 <etext+0x230>
    80001528:	07a040ef          	jal	800055a2 <panic>

000000008000152c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000152c:	7179                	addi	sp,sp,-48
    8000152e:	f406                	sd	ra,40(sp)
    80001530:	f022                	sd	s0,32(sp)
    80001532:	ec26                	sd	s1,24(sp)
    80001534:	e84a                	sd	s2,16(sp)
    80001536:	e44e                	sd	s3,8(sp)
    80001538:	1800                	addi	s0,sp,48
    8000153a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000153c:	00007497          	auipc	s1,0x7
    80001540:	9d448493          	addi	s1,s1,-1580 # 80007f10 <proc>
    80001544:	0000c997          	auipc	s3,0xc
    80001548:	3cc98993          	addi	s3,s3,972 # 8000d910 <tickslock>
    acquire(&p->lock);
    8000154c:	8526                	mv	a0,s1
    8000154e:	382040ef          	jal	800058d0 <acquire>
    if(p->pid == pid){
    80001552:	589c                	lw	a5,48(s1)
    80001554:	01278b63          	beq	a5,s2,8000156a <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001558:	8526                	mv	a0,s1
    8000155a:	40e040ef          	jal	80005968 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000155e:	16848493          	addi	s1,s1,360
    80001562:	ff3495e3          	bne	s1,s3,8000154c <kill+0x20>
  }
  return -1;
    80001566:	557d                	li	a0,-1
    80001568:	a819                	j	8000157e <kill+0x52>
      p->killed = 1;
    8000156a:	4785                	li	a5,1
    8000156c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000156e:	4c98                	lw	a4,24(s1)
    80001570:	4789                	li	a5,2
    80001572:	00f70d63          	beq	a4,a5,8000158c <kill+0x60>
      release(&p->lock);
    80001576:	8526                	mv	a0,s1
    80001578:	3f0040ef          	jal	80005968 <release>
      return 0;
    8000157c:	4501                	li	a0,0
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6145                	addi	sp,sp,48
    8000158a:	8082                	ret
        p->state = RUNNABLE;
    8000158c:	478d                	li	a5,3
    8000158e:	cc9c                	sw	a5,24(s1)
    80001590:	b7dd                	j	80001576 <kill+0x4a>

0000000080001592 <setkilled>:

void
setkilled(struct proc *p)
{
    80001592:	1101                	addi	sp,sp,-32
    80001594:	ec06                	sd	ra,24(sp)
    80001596:	e822                	sd	s0,16(sp)
    80001598:	e426                	sd	s1,8(sp)
    8000159a:	1000                	addi	s0,sp,32
    8000159c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000159e:	332040ef          	jal	800058d0 <acquire>
  p->killed = 1;
    800015a2:	4785                	li	a5,1
    800015a4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015a6:	8526                	mv	a0,s1
    800015a8:	3c0040ef          	jal	80005968 <release>
}
    800015ac:	60e2                	ld	ra,24(sp)
    800015ae:	6442                	ld	s0,16(sp)
    800015b0:	64a2                	ld	s1,8(sp)
    800015b2:	6105                	addi	sp,sp,32
    800015b4:	8082                	ret

00000000800015b6 <killed>:

int
killed(struct proc *p)
{
    800015b6:	1101                	addi	sp,sp,-32
    800015b8:	ec06                	sd	ra,24(sp)
    800015ba:	e822                	sd	s0,16(sp)
    800015bc:	e426                	sd	s1,8(sp)
    800015be:	e04a                	sd	s2,0(sp)
    800015c0:	1000                	addi	s0,sp,32
    800015c2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015c4:	30c040ef          	jal	800058d0 <acquire>
  k = p->killed;
    800015c8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800015cc:	8526                	mv	a0,s1
    800015ce:	39a040ef          	jal	80005968 <release>
  return k;
}
    800015d2:	854a                	mv	a0,s2
    800015d4:	60e2                	ld	ra,24(sp)
    800015d6:	6442                	ld	s0,16(sp)
    800015d8:	64a2                	ld	s1,8(sp)
    800015da:	6902                	ld	s2,0(sp)
    800015dc:	6105                	addi	sp,sp,32
    800015de:	8082                	ret

00000000800015e0 <wait>:
{
    800015e0:	715d                	addi	sp,sp,-80
    800015e2:	e486                	sd	ra,72(sp)
    800015e4:	e0a2                	sd	s0,64(sp)
    800015e6:	fc26                	sd	s1,56(sp)
    800015e8:	f84a                	sd	s2,48(sp)
    800015ea:	f44e                	sd	s3,40(sp)
    800015ec:	f052                	sd	s4,32(sp)
    800015ee:	ec56                	sd	s5,24(sp)
    800015f0:	e85a                	sd	s6,16(sp)
    800015f2:	e45e                	sd	s7,8(sp)
    800015f4:	e062                	sd	s8,0(sp)
    800015f6:	0880                	addi	s0,sp,80
    800015f8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800015fa:	faeff0ef          	jal	80000da8 <myproc>
    800015fe:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001600:	00006517          	auipc	a0,0x6
    80001604:	4f850513          	addi	a0,a0,1272 # 80007af8 <wait_lock>
    80001608:	2c8040ef          	jal	800058d0 <acquire>
    havekids = 0;
    8000160c:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000160e:	4a15                	li	s4,5
        havekids = 1;
    80001610:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001612:	0000c997          	auipc	s3,0xc
    80001616:	2fe98993          	addi	s3,s3,766 # 8000d910 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000161a:	00006c17          	auipc	s8,0x6
    8000161e:	4dec0c13          	addi	s8,s8,1246 # 80007af8 <wait_lock>
    80001622:	a871                	j	800016be <wait+0xde>
          pid = pp->pid;
    80001624:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001628:	000b0c63          	beqz	s6,80001640 <wait+0x60>
    8000162c:	4691                	li	a3,4
    8000162e:	02c48613          	addi	a2,s1,44
    80001632:	85da                	mv	a1,s6
    80001634:	05093503          	ld	a0,80(s2)
    80001638:	be2ff0ef          	jal	80000a1a <copyout>
    8000163c:	02054b63          	bltz	a0,80001672 <wait+0x92>
          freeproc(pp);
    80001640:	8526                	mv	a0,s1
    80001642:	8d9ff0ef          	jal	80000f1a <freeproc>
          release(&pp->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	320040ef          	jal	80005968 <release>
          release(&wait_lock);
    8000164c:	00006517          	auipc	a0,0x6
    80001650:	4ac50513          	addi	a0,a0,1196 # 80007af8 <wait_lock>
    80001654:	314040ef          	jal	80005968 <release>
}
    80001658:	854e                	mv	a0,s3
    8000165a:	60a6                	ld	ra,72(sp)
    8000165c:	6406                	ld	s0,64(sp)
    8000165e:	74e2                	ld	s1,56(sp)
    80001660:	7942                	ld	s2,48(sp)
    80001662:	79a2                	ld	s3,40(sp)
    80001664:	7a02                	ld	s4,32(sp)
    80001666:	6ae2                	ld	s5,24(sp)
    80001668:	6b42                	ld	s6,16(sp)
    8000166a:	6ba2                	ld	s7,8(sp)
    8000166c:	6c02                	ld	s8,0(sp)
    8000166e:	6161                	addi	sp,sp,80
    80001670:	8082                	ret
            release(&pp->lock);
    80001672:	8526                	mv	a0,s1
    80001674:	2f4040ef          	jal	80005968 <release>
            release(&wait_lock);
    80001678:	00006517          	auipc	a0,0x6
    8000167c:	48050513          	addi	a0,a0,1152 # 80007af8 <wait_lock>
    80001680:	2e8040ef          	jal	80005968 <release>
            return -1;
    80001684:	59fd                	li	s3,-1
    80001686:	bfc9                	j	80001658 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001688:	16848493          	addi	s1,s1,360
    8000168c:	03348063          	beq	s1,s3,800016ac <wait+0xcc>
      if(pp->parent == p){
    80001690:	7c9c                	ld	a5,56(s1)
    80001692:	ff279be3          	bne	a5,s2,80001688 <wait+0xa8>
        acquire(&pp->lock);
    80001696:	8526                	mv	a0,s1
    80001698:	238040ef          	jal	800058d0 <acquire>
        if(pp->state == ZOMBIE){
    8000169c:	4c9c                	lw	a5,24(s1)
    8000169e:	f94783e3          	beq	a5,s4,80001624 <wait+0x44>
        release(&pp->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	2c4040ef          	jal	80005968 <release>
        havekids = 1;
    800016a8:	8756                	mv	a4,s5
    800016aa:	bff9                	j	80001688 <wait+0xa8>
    if(!havekids || killed(p)){
    800016ac:	cf19                	beqz	a4,800016ca <wait+0xea>
    800016ae:	854a                	mv	a0,s2
    800016b0:	f07ff0ef          	jal	800015b6 <killed>
    800016b4:	e919                	bnez	a0,800016ca <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016b6:	85e2                	mv	a1,s8
    800016b8:	854a                	mv	a0,s2
    800016ba:	cc5ff0ef          	jal	8000137e <sleep>
    havekids = 0;
    800016be:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c0:	00007497          	auipc	s1,0x7
    800016c4:	85048493          	addi	s1,s1,-1968 # 80007f10 <proc>
    800016c8:	b7e1                	j	80001690 <wait+0xb0>
      release(&wait_lock);
    800016ca:	00006517          	auipc	a0,0x6
    800016ce:	42e50513          	addi	a0,a0,1070 # 80007af8 <wait_lock>
    800016d2:	296040ef          	jal	80005968 <release>
      return -1;
    800016d6:	59fd                	li	s3,-1
    800016d8:	b741                	j	80001658 <wait+0x78>

00000000800016da <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016da:	7179                	addi	sp,sp,-48
    800016dc:	f406                	sd	ra,40(sp)
    800016de:	f022                	sd	s0,32(sp)
    800016e0:	ec26                	sd	s1,24(sp)
    800016e2:	e84a                	sd	s2,16(sp)
    800016e4:	e44e                	sd	s3,8(sp)
    800016e6:	e052                	sd	s4,0(sp)
    800016e8:	1800                	addi	s0,sp,48
    800016ea:	84aa                	mv	s1,a0
    800016ec:	892e                	mv	s2,a1
    800016ee:	89b2                	mv	s3,a2
    800016f0:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016f2:	eb6ff0ef          	jal	80000da8 <myproc>
  if(user_dst){
    800016f6:	cc99                	beqz	s1,80001714 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800016f8:	86d2                	mv	a3,s4
    800016fa:	864e                	mv	a2,s3
    800016fc:	85ca                	mv	a1,s2
    800016fe:	6928                	ld	a0,80(a0)
    80001700:	b1aff0ef          	jal	80000a1a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001704:	70a2                	ld	ra,40(sp)
    80001706:	7402                	ld	s0,32(sp)
    80001708:	64e2                	ld	s1,24(sp)
    8000170a:	6942                	ld	s2,16(sp)
    8000170c:	69a2                	ld	s3,8(sp)
    8000170e:	6a02                	ld	s4,0(sp)
    80001710:	6145                	addi	sp,sp,48
    80001712:	8082                	ret
    memmove((char *)dst, src, len);
    80001714:	000a061b          	sext.w	a2,s4
    80001718:	85ce                	mv	a1,s3
    8000171a:	854a                	mv	a0,s2
    8000171c:	ad1fe0ef          	jal	800001ec <memmove>
    return 0;
    80001720:	8526                	mv	a0,s1
    80001722:	b7cd                	j	80001704 <either_copyout+0x2a>

0000000080001724 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001724:	7179                	addi	sp,sp,-48
    80001726:	f406                	sd	ra,40(sp)
    80001728:	f022                	sd	s0,32(sp)
    8000172a:	ec26                	sd	s1,24(sp)
    8000172c:	e84a                	sd	s2,16(sp)
    8000172e:	e44e                	sd	s3,8(sp)
    80001730:	e052                	sd	s4,0(sp)
    80001732:	1800                	addi	s0,sp,48
    80001734:	892a                	mv	s2,a0
    80001736:	84ae                	mv	s1,a1
    80001738:	89b2                	mv	s3,a2
    8000173a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000173c:	e6cff0ef          	jal	80000da8 <myproc>
  if(user_src){
    80001740:	cc99                	beqz	s1,8000175e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001742:	86d2                	mv	a3,s4
    80001744:	864e                	mv	a2,s3
    80001746:	85ca                	mv	a1,s2
    80001748:	6928                	ld	a0,80(a0)
    8000174a:	ba6ff0ef          	jal	80000af0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    8000174e:	70a2                	ld	ra,40(sp)
    80001750:	7402                	ld	s0,32(sp)
    80001752:	64e2                	ld	s1,24(sp)
    80001754:	6942                	ld	s2,16(sp)
    80001756:	69a2                	ld	s3,8(sp)
    80001758:	6a02                	ld	s4,0(sp)
    8000175a:	6145                	addi	sp,sp,48
    8000175c:	8082                	ret
    memmove(dst, (char*)src, len);
    8000175e:	000a061b          	sext.w	a2,s4
    80001762:	85ce                	mv	a1,s3
    80001764:	854a                	mv	a0,s2
    80001766:	a87fe0ef          	jal	800001ec <memmove>
    return 0;
    8000176a:	8526                	mv	a0,s1
    8000176c:	b7cd                	j	8000174e <either_copyin+0x2a>

000000008000176e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000176e:	715d                	addi	sp,sp,-80
    80001770:	e486                	sd	ra,72(sp)
    80001772:	e0a2                	sd	s0,64(sp)
    80001774:	fc26                	sd	s1,56(sp)
    80001776:	f84a                	sd	s2,48(sp)
    80001778:	f44e                	sd	s3,40(sp)
    8000177a:	f052                	sd	s4,32(sp)
    8000177c:	ec56                	sd	s5,24(sp)
    8000177e:	e85a                	sd	s6,16(sp)
    80001780:	e45e                	sd	s7,8(sp)
    80001782:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001784:	00006517          	auipc	a0,0x6
    80001788:	89450513          	addi	a0,a0,-1900 # 80007018 <etext+0x18>
    8000178c:	345030ef          	jal	800052d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001790:	00007497          	auipc	s1,0x7
    80001794:	8d848493          	addi	s1,s1,-1832 # 80008068 <proc+0x158>
    80001798:	0000c917          	auipc	s2,0xc
    8000179c:	2d090913          	addi	s2,s2,720 # 8000da68 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017a0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017a2:	00006997          	auipc	s3,0x6
    800017a6:	a9e98993          	addi	s3,s3,-1378 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    800017aa:	00006a97          	auipc	s5,0x6
    800017ae:	a9ea8a93          	addi	s5,s5,-1378 # 80007248 <etext+0x248>
    printf("\n");
    800017b2:	00006a17          	auipc	s4,0x6
    800017b6:	866a0a13          	addi	s4,s4,-1946 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ba:	00006b97          	auipc	s7,0x6
    800017be:	08eb8b93          	addi	s7,s7,142 # 80007848 <states.0>
    800017c2:	a829                	j	800017dc <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017c4:	ed86a583          	lw	a1,-296(a3)
    800017c8:	8556                	mv	a0,s5
    800017ca:	307030ef          	jal	800052d0 <printf>
    printf("\n");
    800017ce:	8552                	mv	a0,s4
    800017d0:	301030ef          	jal	800052d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017d4:	16848493          	addi	s1,s1,360
    800017d8:	03248263          	beq	s1,s2,800017fc <procdump+0x8e>
    if(p->state == UNUSED)
    800017dc:	86a6                	mv	a3,s1
    800017de:	ec04a783          	lw	a5,-320(s1)
    800017e2:	dbed                	beqz	a5,800017d4 <procdump+0x66>
      state = "???";
    800017e4:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017e6:	fcfb6fe3          	bltu	s6,a5,800017c4 <procdump+0x56>
    800017ea:	02079713          	slli	a4,a5,0x20
    800017ee:	01d75793          	srli	a5,a4,0x1d
    800017f2:	97de                	add	a5,a5,s7
    800017f4:	6390                	ld	a2,0(a5)
    800017f6:	f679                	bnez	a2,800017c4 <procdump+0x56>
      state = "???";
    800017f8:	864e                	mv	a2,s3
    800017fa:	b7e9                	j	800017c4 <procdump+0x56>
  }
}
    800017fc:	60a6                	ld	ra,72(sp)
    800017fe:	6406                	ld	s0,64(sp)
    80001800:	74e2                	ld	s1,56(sp)
    80001802:	7942                	ld	s2,48(sp)
    80001804:	79a2                	ld	s3,40(sp)
    80001806:	7a02                	ld	s4,32(sp)
    80001808:	6ae2                	ld	s5,24(sp)
    8000180a:	6b42                	ld	s6,16(sp)
    8000180c:	6ba2                	ld	s7,8(sp)
    8000180e:	6161                	addi	sp,sp,80
    80001810:	8082                	ret

0000000080001812 <count_nproc>:

uint64 count_nproc(void) {
    80001812:	7179                	addi	sp,sp,-48
    80001814:	f406                	sd	ra,40(sp)
    80001816:	f022                	sd	s0,32(sp)
    80001818:	ec26                	sd	s1,24(sp)
    8000181a:	e84a                	sd	s2,16(sp)
    8000181c:	e44e                	sd	s3,8(sp)
    8000181e:	1800                	addi	s0,sp,48
    struct proc *p;
    int count = 0;
    80001820:	4901                	li	s2,0

    for (p = proc; p < &proc[NPROC]; p++) {
    80001822:	00006497          	auipc	s1,0x6
    80001826:	6ee48493          	addi	s1,s1,1774 # 80007f10 <proc>
    8000182a:	0000c997          	auipc	s3,0xc
    8000182e:	0e698993          	addi	s3,s3,230 # 8000d910 <tickslock>
    80001832:	a801                	j	80001842 <count_nproc+0x30>
        acquire(&p->lock);
        if (p->state != UNUSED)  // Count non-UNUSED processes
            count++;
        release(&p->lock);
    80001834:	8526                	mv	a0,s1
    80001836:	132040ef          	jal	80005968 <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    8000183a:	16848493          	addi	s1,s1,360
    8000183e:	01348963          	beq	s1,s3,80001850 <count_nproc+0x3e>
        acquire(&p->lock);
    80001842:	8526                	mv	a0,s1
    80001844:	08c040ef          	jal	800058d0 <acquire>
        if (p->state != UNUSED)  // Count non-UNUSED processes
    80001848:	4c9c                	lw	a5,24(s1)
    8000184a:	d7ed                	beqz	a5,80001834 <count_nproc+0x22>
            count++;
    8000184c:	2905                	addiw	s2,s2,1
    8000184e:	b7dd                	j	80001834 <count_nproc+0x22>
    }

    return count;
}
    80001850:	854a                	mv	a0,s2
    80001852:	70a2                	ld	ra,40(sp)
    80001854:	7402                	ld	s0,32(sp)
    80001856:	64e2                	ld	s1,24(sp)
    80001858:	6942                	ld	s2,16(sp)
    8000185a:	69a2                	ld	s3,8(sp)
    8000185c:	6145                	addi	sp,sp,48
    8000185e:	8082                	ret

0000000080001860 <swtch>:
    80001860:	00153023          	sd	ra,0(a0)
    80001864:	00253423          	sd	sp,8(a0)
    80001868:	e900                	sd	s0,16(a0)
    8000186a:	ed04                	sd	s1,24(a0)
    8000186c:	03253023          	sd	s2,32(a0)
    80001870:	03353423          	sd	s3,40(a0)
    80001874:	03453823          	sd	s4,48(a0)
    80001878:	03553c23          	sd	s5,56(a0)
    8000187c:	05653023          	sd	s6,64(a0)
    80001880:	05753423          	sd	s7,72(a0)
    80001884:	05853823          	sd	s8,80(a0)
    80001888:	05953c23          	sd	s9,88(a0)
    8000188c:	07a53023          	sd	s10,96(a0)
    80001890:	07b53423          	sd	s11,104(a0)
    80001894:	0005b083          	ld	ra,0(a1)
    80001898:	0085b103          	ld	sp,8(a1)
    8000189c:	6980                	ld	s0,16(a1)
    8000189e:	6d84                	ld	s1,24(a1)
    800018a0:	0205b903          	ld	s2,32(a1)
    800018a4:	0285b983          	ld	s3,40(a1)
    800018a8:	0305ba03          	ld	s4,48(a1)
    800018ac:	0385ba83          	ld	s5,56(a1)
    800018b0:	0405bb03          	ld	s6,64(a1)
    800018b4:	0485bb83          	ld	s7,72(a1)
    800018b8:	0505bc03          	ld	s8,80(a1)
    800018bc:	0585bc83          	ld	s9,88(a1)
    800018c0:	0605bd03          	ld	s10,96(a1)
    800018c4:	0685bd83          	ld	s11,104(a1)
    800018c8:	8082                	ret

00000000800018ca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018ca:	1141                	addi	sp,sp,-16
    800018cc:	e406                	sd	ra,8(sp)
    800018ce:	e022                	sd	s0,0(sp)
    800018d0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018d2:	00006597          	auipc	a1,0x6
    800018d6:	9b658593          	addi	a1,a1,-1610 # 80007288 <etext+0x288>
    800018da:	0000c517          	auipc	a0,0xc
    800018de:	03650513          	addi	a0,a0,54 # 8000d910 <tickslock>
    800018e2:	76f030ef          	jal	80005850 <initlock>
}
    800018e6:	60a2                	ld	ra,8(sp)
    800018e8:	6402                	ld	s0,0(sp)
    800018ea:	0141                	addi	sp,sp,16
    800018ec:	8082                	ret

00000000800018ee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ee:	1141                	addi	sp,sp,-16
    800018f0:	e422                	sd	s0,8(sp)
    800018f2:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018f4:	00003797          	auipc	a5,0x3
    800018f8:	f1c78793          	addi	a5,a5,-228 # 80004810 <kernelvec>
    800018fc:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001900:	6422                	ld	s0,8(sp)
    80001902:	0141                	addi	sp,sp,16
    80001904:	8082                	ret

0000000080001906 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001906:	1141                	addi	sp,sp,-16
    80001908:	e406                	sd	ra,8(sp)
    8000190a:	e022                	sd	s0,0(sp)
    8000190c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000190e:	c9aff0ef          	jal	80000da8 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001912:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001916:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001918:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000191c:	00004697          	auipc	a3,0x4
    80001920:	6e468693          	addi	a3,a3,1764 # 80006000 <_trampoline>
    80001924:	00004717          	auipc	a4,0x4
    80001928:	6dc70713          	addi	a4,a4,1756 # 80006000 <_trampoline>
    8000192c:	8f15                	sub	a4,a4,a3
    8000192e:	040007b7          	lui	a5,0x4000
    80001932:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001934:	07b2                	slli	a5,a5,0xc
    80001936:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001938:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000193c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000193e:	18002673          	csrr	a2,satp
    80001942:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001944:	6d30                	ld	a2,88(a0)
    80001946:	6138                	ld	a4,64(a0)
    80001948:	6585                	lui	a1,0x1
    8000194a:	972e                	add	a4,a4,a1
    8000194c:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000194e:	6d38                	ld	a4,88(a0)
    80001950:	00000617          	auipc	a2,0x0
    80001954:	11060613          	addi	a2,a2,272 # 80001a60 <usertrap>
    80001958:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000195a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000195c:	8612                	mv	a2,tp
    8000195e:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001960:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001964:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001968:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000196c:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001970:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001972:	6f18                	ld	a4,24(a4)
    80001974:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001978:	6928                	ld	a0,80(a0)
    8000197a:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000197c:	00004717          	auipc	a4,0x4
    80001980:	72070713          	addi	a4,a4,1824 # 8000609c <userret>
    80001984:	8f15                	sub	a4,a4,a3
    80001986:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001988:	577d                	li	a4,-1
    8000198a:	177e                	slli	a4,a4,0x3f
    8000198c:	8d59                	or	a0,a0,a4
    8000198e:	9782                	jalr	a5
}
    80001990:	60a2                	ld	ra,8(sp)
    80001992:	6402                	ld	s0,0(sp)
    80001994:	0141                	addi	sp,sp,16
    80001996:	8082                	ret

0000000080001998 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001998:	1101                	addi	sp,sp,-32
    8000199a:	ec06                	sd	ra,24(sp)
    8000199c:	e822                	sd	s0,16(sp)
    8000199e:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800019a0:	bdcff0ef          	jal	80000d7c <cpuid>
    800019a4:	cd11                	beqz	a0,800019c0 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019a6:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019aa:	000f4737          	lui	a4,0xf4
    800019ae:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019b2:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019b4:	14d79073          	csrw	stimecmp,a5
}
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	6105                	addi	sp,sp,32
    800019be:	8082                	ret
    800019c0:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    800019c2:	0000c497          	auipc	s1,0xc
    800019c6:	f4e48493          	addi	s1,s1,-178 # 8000d910 <tickslock>
    800019ca:	8526                	mv	a0,s1
    800019cc:	705030ef          	jal	800058d0 <acquire>
    ticks++;
    800019d0:	00006517          	auipc	a0,0x6
    800019d4:	0d850513          	addi	a0,a0,216 # 80007aa8 <ticks>
    800019d8:	411c                	lw	a5,0(a0)
    800019da:	2785                	addiw	a5,a5,1
    800019dc:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800019de:	9edff0ef          	jal	800013ca <wakeup>
    release(&tickslock);
    800019e2:	8526                	mv	a0,s1
    800019e4:	785030ef          	jal	80005968 <release>
    800019e8:	64a2                	ld	s1,8(sp)
    800019ea:	bf75                	j	800019a6 <clockintr+0xe>

00000000800019ec <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019f8:	57fd                	li	a5,-1
    800019fa:	17fe                	slli	a5,a5,0x3f
    800019fc:	07a5                	addi	a5,a5,9
    800019fe:	00f70c63          	beq	a4,a5,80001a16 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a02:	57fd                	li	a5,-1
    80001a04:	17fe                	slli	a5,a5,0x3f
    80001a06:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a0a:	04f70763          	beq	a4,a5,80001a58 <devintr+0x6c>
  }
}
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	6105                	addi	sp,sp,32
    80001a14:	8082                	ret
    80001a16:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a18:	6a5020ef          	jal	800048bc <plic_claim>
    80001a1c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a1e:	47a9                	li	a5,10
    80001a20:	00f50963          	beq	a0,a5,80001a32 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001a24:	4785                	li	a5,1
    80001a26:	00f50963          	beq	a0,a5,80001a38 <devintr+0x4c>
    return 1;
    80001a2a:	4505                	li	a0,1
    } else if(irq){
    80001a2c:	e889                	bnez	s1,80001a3e <devintr+0x52>
    80001a2e:	64a2                	ld	s1,8(sp)
    80001a30:	bff9                	j	80001a0e <devintr+0x22>
      uartintr();
    80001a32:	5e3030ef          	jal	80005814 <uartintr>
    if(irq)
    80001a36:	a819                	j	80001a4c <devintr+0x60>
      virtio_disk_intr();
    80001a38:	34a030ef          	jal	80004d82 <virtio_disk_intr>
    if(irq)
    80001a3c:	a801                	j	80001a4c <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a3e:	85a6                	mv	a1,s1
    80001a40:	00006517          	auipc	a0,0x6
    80001a44:	85050513          	addi	a0,a0,-1968 # 80007290 <etext+0x290>
    80001a48:	089030ef          	jal	800052d0 <printf>
      plic_complete(irq);
    80001a4c:	8526                	mv	a0,s1
    80001a4e:	68f020ef          	jal	800048dc <plic_complete>
    return 1;
    80001a52:	4505                	li	a0,1
    80001a54:	64a2                	ld	s1,8(sp)
    80001a56:	bf65                	j	80001a0e <devintr+0x22>
    clockintr();
    80001a58:	f41ff0ef          	jal	80001998 <clockintr>
    return 2;
    80001a5c:	4509                	li	a0,2
    80001a5e:	bf45                	j	80001a0e <devintr+0x22>

0000000080001a60 <usertrap>:
{
    80001a60:	1101                	addi	sp,sp,-32
    80001a62:	ec06                	sd	ra,24(sp)
    80001a64:	e822                	sd	s0,16(sp)
    80001a66:	e426                	sd	s1,8(sp)
    80001a68:	e04a                	sd	s2,0(sp)
    80001a6a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a6c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a70:	1007f793          	andi	a5,a5,256
    80001a74:	ef85                	bnez	a5,80001aac <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a76:	00003797          	auipc	a5,0x3
    80001a7a:	d9a78793          	addi	a5,a5,-614 # 80004810 <kernelvec>
    80001a7e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a82:	b26ff0ef          	jal	80000da8 <myproc>
    80001a86:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a88:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a8a:	14102773          	csrr	a4,sepc
    80001a8e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a90:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a94:	47a1                	li	a5,8
    80001a96:	02f70163          	beq	a4,a5,80001ab8 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80001a9a:	f53ff0ef          	jal	800019ec <devintr>
    80001a9e:	892a                	mv	s2,a0
    80001aa0:	c135                	beqz	a0,80001b04 <usertrap+0xa4>
  if(killed(p))
    80001aa2:	8526                	mv	a0,s1
    80001aa4:	b13ff0ef          	jal	800015b6 <killed>
    80001aa8:	cd1d                	beqz	a0,80001ae6 <usertrap+0x86>
    80001aaa:	a81d                	j	80001ae0 <usertrap+0x80>
    panic("usertrap: not from user mode");
    80001aac:	00006517          	auipc	a0,0x6
    80001ab0:	80450513          	addi	a0,a0,-2044 # 800072b0 <etext+0x2b0>
    80001ab4:	2ef030ef          	jal	800055a2 <panic>
    if(killed(p))
    80001ab8:	affff0ef          	jal	800015b6 <killed>
    80001abc:	e121                	bnez	a0,80001afc <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001abe:	6cb8                	ld	a4,88(s1)
    80001ac0:	6f1c                	ld	a5,24(a4)
    80001ac2:	0791                	addi	a5,a5,4
    80001ac4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ac6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001aca:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ace:	10079073          	csrw	sstatus,a5
    syscall();
    80001ad2:	248000ef          	jal	80001d1a <syscall>
  if(killed(p))
    80001ad6:	8526                	mv	a0,s1
    80001ad8:	adfff0ef          	jal	800015b6 <killed>
    80001adc:	c901                	beqz	a0,80001aec <usertrap+0x8c>
    80001ade:	4901                	li	s2,0
    exit(-1);
    80001ae0:	557d                	li	a0,-1
    80001ae2:	9a9ff0ef          	jal	8000148a <exit>
  if(which_dev == 2)
    80001ae6:	4789                	li	a5,2
    80001ae8:	04f90563          	beq	s2,a5,80001b32 <usertrap+0xd2>
  usertrapret();
    80001aec:	e1bff0ef          	jal	80001906 <usertrapret>
}
    80001af0:	60e2                	ld	ra,24(sp)
    80001af2:	6442                	ld	s0,16(sp)
    80001af4:	64a2                	ld	s1,8(sp)
    80001af6:	6902                	ld	s2,0(sp)
    80001af8:	6105                	addi	sp,sp,32
    80001afa:	8082                	ret
      exit(-1);
    80001afc:	557d                	li	a0,-1
    80001afe:	98dff0ef          	jal	8000148a <exit>
    80001b02:	bf75                	j	80001abe <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b04:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b08:	5890                	lw	a2,48(s1)
    80001b0a:	00005517          	auipc	a0,0x5
    80001b0e:	7c650513          	addi	a0,a0,1990 # 800072d0 <etext+0x2d0>
    80001b12:	7be030ef          	jal	800052d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b16:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b1a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b1e:	00005517          	auipc	a0,0x5
    80001b22:	7e250513          	addi	a0,a0,2018 # 80007300 <etext+0x300>
    80001b26:	7aa030ef          	jal	800052d0 <printf>
    setkilled(p);
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	a67ff0ef          	jal	80001592 <setkilled>
    80001b30:	b75d                	j	80001ad6 <usertrap+0x76>
    yield();
    80001b32:	821ff0ef          	jal	80001352 <yield>
    80001b36:	bf5d                	j	80001aec <usertrap+0x8c>

0000000080001b38 <kerneltrap>:
{
    80001b38:	7179                	addi	sp,sp,-48
    80001b3a:	f406                	sd	ra,40(sp)
    80001b3c:	f022                	sd	s0,32(sp)
    80001b3e:	ec26                	sd	s1,24(sp)
    80001b40:	e84a                	sd	s2,16(sp)
    80001b42:	e44e                	sd	s3,8(sp)
    80001b44:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b46:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b4e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001b52:	1004f793          	andi	a5,s1,256
    80001b56:	c795                	beqz	a5,80001b82 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b5c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b5e:	eb85                	bnez	a5,80001b8e <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001b60:	e8dff0ef          	jal	800019ec <devintr>
    80001b64:	c91d                	beqz	a0,80001b9a <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001b66:	4789                	li	a5,2
    80001b68:	04f50a63          	beq	a0,a5,80001bbc <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b6c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b70:	10049073          	csrw	sstatus,s1
}
    80001b74:	70a2                	ld	ra,40(sp)
    80001b76:	7402                	ld	s0,32(sp)
    80001b78:	64e2                	ld	s1,24(sp)
    80001b7a:	6942                	ld	s2,16(sp)
    80001b7c:	69a2                	ld	s3,8(sp)
    80001b7e:	6145                	addi	sp,sp,48
    80001b80:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b82:	00005517          	auipc	a0,0x5
    80001b86:	7a650513          	addi	a0,a0,1958 # 80007328 <etext+0x328>
    80001b8a:	219030ef          	jal	800055a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b8e:	00005517          	auipc	a0,0x5
    80001b92:	7c250513          	addi	a0,a0,1986 # 80007350 <etext+0x350>
    80001b96:	20d030ef          	jal	800055a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b9a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b9e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001ba2:	85ce                	mv	a1,s3
    80001ba4:	00005517          	auipc	a0,0x5
    80001ba8:	7cc50513          	addi	a0,a0,1996 # 80007370 <etext+0x370>
    80001bac:	724030ef          	jal	800052d0 <printf>
    panic("kerneltrap");
    80001bb0:	00005517          	auipc	a0,0x5
    80001bb4:	7e850513          	addi	a0,a0,2024 # 80007398 <etext+0x398>
    80001bb8:	1eb030ef          	jal	800055a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bbc:	9ecff0ef          	jal	80000da8 <myproc>
    80001bc0:	d555                	beqz	a0,80001b6c <kerneltrap+0x34>
    yield();
    80001bc2:	f90ff0ef          	jal	80001352 <yield>
    80001bc6:	b75d                	j	80001b6c <kerneltrap+0x34>

0000000080001bc8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bc8:	1101                	addi	sp,sp,-32
    80001bca:	ec06                	sd	ra,24(sp)
    80001bcc:	e822                	sd	s0,16(sp)
    80001bce:	e426                	sd	s1,8(sp)
    80001bd0:	1000                	addi	s0,sp,32
    80001bd2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bd4:	9d4ff0ef          	jal	80000da8 <myproc>
  switch (n) {
    80001bd8:	4795                	li	a5,5
    80001bda:	0497e163          	bltu	a5,s1,80001c1c <argraw+0x54>
    80001bde:	048a                	slli	s1,s1,0x2
    80001be0:	00006717          	auipc	a4,0x6
    80001be4:	c9870713          	addi	a4,a4,-872 # 80007878 <states.0+0x30>
    80001be8:	94ba                	add	s1,s1,a4
    80001bea:	409c                	lw	a5,0(s1)
    80001bec:	97ba                	add	a5,a5,a4
    80001bee:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bf0:	6d3c                	ld	a5,88(a0)
    80001bf2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001bf4:	60e2                	ld	ra,24(sp)
    80001bf6:	6442                	ld	s0,16(sp)
    80001bf8:	64a2                	ld	s1,8(sp)
    80001bfa:	6105                	addi	sp,sp,32
    80001bfc:	8082                	ret
    return p->trapframe->a1;
    80001bfe:	6d3c                	ld	a5,88(a0)
    80001c00:	7fa8                	ld	a0,120(a5)
    80001c02:	bfcd                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a2;
    80001c04:	6d3c                	ld	a5,88(a0)
    80001c06:	63c8                	ld	a0,128(a5)
    80001c08:	b7f5                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a3;
    80001c0a:	6d3c                	ld	a5,88(a0)
    80001c0c:	67c8                	ld	a0,136(a5)
    80001c0e:	b7dd                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a4;
    80001c10:	6d3c                	ld	a5,88(a0)
    80001c12:	6bc8                	ld	a0,144(a5)
    80001c14:	b7c5                	j	80001bf4 <argraw+0x2c>
    return p->trapframe->a5;
    80001c16:	6d3c                	ld	a5,88(a0)
    80001c18:	6fc8                	ld	a0,152(a5)
    80001c1a:	bfe9                	j	80001bf4 <argraw+0x2c>
  panic("argraw");
    80001c1c:	00005517          	auipc	a0,0x5
    80001c20:	78c50513          	addi	a0,a0,1932 # 800073a8 <etext+0x3a8>
    80001c24:	17f030ef          	jal	800055a2 <panic>

0000000080001c28 <fetchaddr>:
{
    80001c28:	1101                	addi	sp,sp,-32
    80001c2a:	ec06                	sd	ra,24(sp)
    80001c2c:	e822                	sd	s0,16(sp)
    80001c2e:	e426                	sd	s1,8(sp)
    80001c30:	e04a                	sd	s2,0(sp)
    80001c32:	1000                	addi	s0,sp,32
    80001c34:	84aa                	mv	s1,a0
    80001c36:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c38:	970ff0ef          	jal	80000da8 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c3c:	653c                	ld	a5,72(a0)
    80001c3e:	02f4f663          	bgeu	s1,a5,80001c6a <fetchaddr+0x42>
    80001c42:	00848713          	addi	a4,s1,8
    80001c46:	02e7e463          	bltu	a5,a4,80001c6e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c4a:	46a1                	li	a3,8
    80001c4c:	8626                	mv	a2,s1
    80001c4e:	85ca                	mv	a1,s2
    80001c50:	6928                	ld	a0,80(a0)
    80001c52:	e9ffe0ef          	jal	80000af0 <copyin>
    80001c56:	00a03533          	snez	a0,a0
    80001c5a:	40a00533          	neg	a0,a0
}
    80001c5e:	60e2                	ld	ra,24(sp)
    80001c60:	6442                	ld	s0,16(sp)
    80001c62:	64a2                	ld	s1,8(sp)
    80001c64:	6902                	ld	s2,0(sp)
    80001c66:	6105                	addi	sp,sp,32
    80001c68:	8082                	ret
    return -1;
    80001c6a:	557d                	li	a0,-1
    80001c6c:	bfcd                	j	80001c5e <fetchaddr+0x36>
    80001c6e:	557d                	li	a0,-1
    80001c70:	b7fd                	j	80001c5e <fetchaddr+0x36>

0000000080001c72 <fetchstr>:
{
    80001c72:	7179                	addi	sp,sp,-48
    80001c74:	f406                	sd	ra,40(sp)
    80001c76:	f022                	sd	s0,32(sp)
    80001c78:	ec26                	sd	s1,24(sp)
    80001c7a:	e84a                	sd	s2,16(sp)
    80001c7c:	e44e                	sd	s3,8(sp)
    80001c7e:	1800                	addi	s0,sp,48
    80001c80:	892a                	mv	s2,a0
    80001c82:	84ae                	mv	s1,a1
    80001c84:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001c86:	922ff0ef          	jal	80000da8 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c8a:	86ce                	mv	a3,s3
    80001c8c:	864a                	mv	a2,s2
    80001c8e:	85a6                	mv	a1,s1
    80001c90:	6928                	ld	a0,80(a0)
    80001c92:	ee5fe0ef          	jal	80000b76 <copyinstr>
    80001c96:	00054c63          	bltz	a0,80001cae <fetchstr+0x3c>
  return strlen(buf);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	e64fe0ef          	jal	80000300 <strlen>
}
    80001ca0:	70a2                	ld	ra,40(sp)
    80001ca2:	7402                	ld	s0,32(sp)
    80001ca4:	64e2                	ld	s1,24(sp)
    80001ca6:	6942                	ld	s2,16(sp)
    80001ca8:	69a2                	ld	s3,8(sp)
    80001caa:	6145                	addi	sp,sp,48
    80001cac:	8082                	ret
    return -1;
    80001cae:	557d                	li	a0,-1
    80001cb0:	bfc5                	j	80001ca0 <fetchstr+0x2e>

0000000080001cb2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001cb2:	1101                	addi	sp,sp,-32
    80001cb4:	ec06                	sd	ra,24(sp)
    80001cb6:	e822                	sd	s0,16(sp)
    80001cb8:	e426                	sd	s1,8(sp)
    80001cba:	1000                	addi	s0,sp,32
    80001cbc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cbe:	f0bff0ef          	jal	80001bc8 <argraw>
    80001cc2:	c088                	sw	a0,0(s1)
}
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6105                	addi	sp,sp,32
    80001ccc:	8082                	ret

0000000080001cce <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cce:	1101                	addi	sp,sp,-32
    80001cd0:	ec06                	sd	ra,24(sp)
    80001cd2:	e822                	sd	s0,16(sp)
    80001cd4:	e426                	sd	s1,8(sp)
    80001cd6:	1000                	addi	s0,sp,32
    80001cd8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cda:	eefff0ef          	jal	80001bc8 <argraw>
    80001cde:	e088                	sd	a0,0(s1)
}
    80001ce0:	60e2                	ld	ra,24(sp)
    80001ce2:	6442                	ld	s0,16(sp)
    80001ce4:	64a2                	ld	s1,8(sp)
    80001ce6:	6105                	addi	sp,sp,32
    80001ce8:	8082                	ret

0000000080001cea <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cea:	7179                	addi	sp,sp,-48
    80001cec:	f406                	sd	ra,40(sp)
    80001cee:	f022                	sd	s0,32(sp)
    80001cf0:	ec26                	sd	s1,24(sp)
    80001cf2:	e84a                	sd	s2,16(sp)
    80001cf4:	1800                	addi	s0,sp,48
    80001cf6:	84ae                	mv	s1,a1
    80001cf8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80001cfa:	fd840593          	addi	a1,s0,-40
    80001cfe:	fd1ff0ef          	jal	80001cce <argaddr>
  return fetchstr(addr, buf, max);
    80001d02:	864a                	mv	a2,s2
    80001d04:	85a6                	mv	a1,s1
    80001d06:	fd843503          	ld	a0,-40(s0)
    80001d0a:	f69ff0ef          	jal	80001c72 <fetchstr>
}
    80001d0e:	70a2                	ld	ra,40(sp)
    80001d10:	7402                	ld	s0,32(sp)
    80001d12:	64e2                	ld	s1,24(sp)
    80001d14:	6942                	ld	s2,16(sp)
    80001d16:	6145                	addi	sp,sp,48
    80001d18:	8082                	ret

0000000080001d1a <syscall>:
[SYS_sysinfo] sys_sysinfo
};

void
syscall(void)
{
    80001d1a:	7179                	addi	sp,sp,-48
    80001d1c:	f406                	sd	ra,40(sp)
    80001d1e:	f022                	sd	s0,32(sp)
    80001d20:	ec26                	sd	s1,24(sp)
    80001d22:	e84a                	sd	s2,16(sp)
    80001d24:	e44e                	sd	s3,8(sp)
    80001d26:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80001d28:	880ff0ef          	jal	80000da8 <myproc>
    80001d2c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d2e:	05853903          	ld	s2,88(a0)
    80001d32:	0a893783          	ld	a5,168(s2)
    80001d36:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d3a:	37fd                	addiw	a5,a5,-1
    80001d3c:	475d                	li	a4,23
    80001d3e:	04f76463          	bltu	a4,a5,80001d86 <syscall+0x6c>
    80001d42:	00399713          	slli	a4,s3,0x3
    80001d46:	00006797          	auipc	a5,0x6
    80001d4a:	b4a78793          	addi	a5,a5,-1206 # 80007890 <syscalls>
    80001d4e:	97ba                	add	a5,a5,a4
    80001d50:	639c                	ld	a5,0(a5)
    80001d52:	cb95                	beqz	a5,80001d86 <syscall+0x6c>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d54:	9782                	jalr	a5
    80001d56:	06a93823          	sd	a0,112(s2)
    // Check if tracing is enabled for this system call
        if (p->trace_mask & (1 << num)) {
    80001d5a:	58dc                	lw	a5,52(s1)
    80001d5c:	4137d7bb          	sraw	a5,a5,s3
    80001d60:	8b85                	andi	a5,a5,1
    80001d62:	cf9d                	beqz	a5,80001da0 <syscall+0x86>
            printf("%d: syscall %s -> %ld\n", p->pid, syscall_names[num], p->trapframe->a0);
    80001d64:	6cb8                	ld	a4,88(s1)
    80001d66:	098e                	slli	s3,s3,0x3
    80001d68:	00006797          	auipc	a5,0x6
    80001d6c:	b2878793          	addi	a5,a5,-1240 # 80007890 <syscalls>
    80001d70:	97ce                	add	a5,a5,s3
    80001d72:	7b34                	ld	a3,112(a4)
    80001d74:	67f0                	ld	a2,200(a5)
    80001d76:	588c                	lw	a1,48(s1)
    80001d78:	00005517          	auipc	a0,0x5
    80001d7c:	63850513          	addi	a0,a0,1592 # 800073b0 <etext+0x3b0>
    80001d80:	550030ef          	jal	800052d0 <printf>
    80001d84:	a831                	j	80001da0 <syscall+0x86>
        }
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d86:	86ce                	mv	a3,s3
    80001d88:	15848613          	addi	a2,s1,344
    80001d8c:	588c                	lw	a1,48(s1)
    80001d8e:	00005517          	auipc	a0,0x5
    80001d92:	63a50513          	addi	a0,a0,1594 # 800073c8 <etext+0x3c8>
    80001d96:	53a030ef          	jal	800052d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d9a:	6cbc                	ld	a5,88(s1)
    80001d9c:	577d                	li	a4,-1
    80001d9e:	fbb8                	sd	a4,112(a5)
  }
}
    80001da0:	70a2                	ld	ra,40(sp)
    80001da2:	7402                	ld	s0,32(sp)
    80001da4:	64e2                	ld	s1,24(sp)
    80001da6:	6942                	ld	s2,16(sp)
    80001da8:	69a2                	ld	s3,8(sp)
    80001daa:	6145                	addi	sp,sp,48
    80001dac:	8082                	ret

0000000080001dae <sys_exit>:
#include "sysinfo.h"


uint64
sys_exit(void)
{
    80001dae:	1101                	addi	sp,sp,-32
    80001db0:	ec06                	sd	ra,24(sp)
    80001db2:	e822                	sd	s0,16(sp)
    80001db4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001db6:	fec40593          	addi	a1,s0,-20
    80001dba:	4501                	li	a0,0
    80001dbc:	ef7ff0ef          	jal	80001cb2 <argint>
  exit(n);
    80001dc0:	fec42503          	lw	a0,-20(s0)
    80001dc4:	ec6ff0ef          	jal	8000148a <exit>
  return 0;  // not reached
}
    80001dc8:	4501                	li	a0,0
    80001dca:	60e2                	ld	ra,24(sp)
    80001dcc:	6442                	ld	s0,16(sp)
    80001dce:	6105                	addi	sp,sp,32
    80001dd0:	8082                	ret

0000000080001dd2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001dd2:	1141                	addi	sp,sp,-16
    80001dd4:	e406                	sd	ra,8(sp)
    80001dd6:	e022                	sd	s0,0(sp)
    80001dd8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dda:	fcffe0ef          	jal	80000da8 <myproc>
}
    80001dde:	5908                	lw	a0,48(a0)
    80001de0:	60a2                	ld	ra,8(sp)
    80001de2:	6402                	ld	s0,0(sp)
    80001de4:	0141                	addi	sp,sp,16
    80001de6:	8082                	ret

0000000080001de8 <sys_fork>:

uint64
sys_fork(void)
{
    80001de8:	1141                	addi	sp,sp,-16
    80001dea:	e406                	sd	ra,8(sp)
    80001dec:	e022                	sd	s0,0(sp)
    80001dee:	0800                	addi	s0,sp,16
  return fork();
    80001df0:	adeff0ef          	jal	800010ce <fork>
}
    80001df4:	60a2                	ld	ra,8(sp)
    80001df6:	6402                	ld	s0,0(sp)
    80001df8:	0141                	addi	sp,sp,16
    80001dfa:	8082                	ret

0000000080001dfc <sys_wait>:

uint64
sys_wait(void)
{
    80001dfc:	1101                	addi	sp,sp,-32
    80001dfe:	ec06                	sd	ra,24(sp)
    80001e00:	e822                	sd	s0,16(sp)
    80001e02:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e04:	fe840593          	addi	a1,s0,-24
    80001e08:	4501                	li	a0,0
    80001e0a:	ec5ff0ef          	jal	80001cce <argaddr>
  return wait(p);
    80001e0e:	fe843503          	ld	a0,-24(s0)
    80001e12:	fceff0ef          	jal	800015e0 <wait>
}
    80001e16:	60e2                	ld	ra,24(sp)
    80001e18:	6442                	ld	s0,16(sp)
    80001e1a:	6105                	addi	sp,sp,32
    80001e1c:	8082                	ret

0000000080001e1e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e1e:	7179                	addi	sp,sp,-48
    80001e20:	f406                	sd	ra,40(sp)
    80001e22:	f022                	sd	s0,32(sp)
    80001e24:	ec26                	sd	s1,24(sp)
    80001e26:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001e28:	fdc40593          	addi	a1,s0,-36
    80001e2c:	4501                	li	a0,0
    80001e2e:	e85ff0ef          	jal	80001cb2 <argint>
  addr = myproc()->sz;
    80001e32:	f77fe0ef          	jal	80000da8 <myproc>
    80001e36:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001e38:	fdc42503          	lw	a0,-36(s0)
    80001e3c:	a42ff0ef          	jal	8000107e <growproc>
    80001e40:	00054863          	bltz	a0,80001e50 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001e44:	8526                	mv	a0,s1
    80001e46:	70a2                	ld	ra,40(sp)
    80001e48:	7402                	ld	s0,32(sp)
    80001e4a:	64e2                	ld	s1,24(sp)
    80001e4c:	6145                	addi	sp,sp,48
    80001e4e:	8082                	ret
    return -1;
    80001e50:	54fd                	li	s1,-1
    80001e52:	bfcd                	j	80001e44 <sys_sbrk+0x26>

0000000080001e54 <sys_sleep>:

uint64
sys_sleep(void)
{
    80001e54:	7139                	addi	sp,sp,-64
    80001e56:	fc06                	sd	ra,56(sp)
    80001e58:	f822                	sd	s0,48(sp)
    80001e5a:	f04a                	sd	s2,32(sp)
    80001e5c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e5e:	fcc40593          	addi	a1,s0,-52
    80001e62:	4501                	li	a0,0
    80001e64:	e4fff0ef          	jal	80001cb2 <argint>
  if(n < 0)
    80001e68:	fcc42783          	lw	a5,-52(s0)
    80001e6c:	0607c763          	bltz	a5,80001eda <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001e70:	0000c517          	auipc	a0,0xc
    80001e74:	aa050513          	addi	a0,a0,-1376 # 8000d910 <tickslock>
    80001e78:	259030ef          	jal	800058d0 <acquire>
  ticks0 = ticks;
    80001e7c:	00006917          	auipc	s2,0x6
    80001e80:	c2c92903          	lw	s2,-980(s2) # 80007aa8 <ticks>
  while(ticks - ticks0 < n){
    80001e84:	fcc42783          	lw	a5,-52(s0)
    80001e88:	cf8d                	beqz	a5,80001ec2 <sys_sleep+0x6e>
    80001e8a:	f426                	sd	s1,40(sp)
    80001e8c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e8e:	0000c997          	auipc	s3,0xc
    80001e92:	a8298993          	addi	s3,s3,-1406 # 8000d910 <tickslock>
    80001e96:	00006497          	auipc	s1,0x6
    80001e9a:	c1248493          	addi	s1,s1,-1006 # 80007aa8 <ticks>
    if(killed(myproc())){
    80001e9e:	f0bfe0ef          	jal	80000da8 <myproc>
    80001ea2:	f14ff0ef          	jal	800015b6 <killed>
    80001ea6:	ed0d                	bnez	a0,80001ee0 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001ea8:	85ce                	mv	a1,s3
    80001eaa:	8526                	mv	a0,s1
    80001eac:	cd2ff0ef          	jal	8000137e <sleep>
  while(ticks - ticks0 < n){
    80001eb0:	409c                	lw	a5,0(s1)
    80001eb2:	412787bb          	subw	a5,a5,s2
    80001eb6:	fcc42703          	lw	a4,-52(s0)
    80001eba:	fee7e2e3          	bltu	a5,a4,80001e9e <sys_sleep+0x4a>
    80001ebe:	74a2                	ld	s1,40(sp)
    80001ec0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ec2:	0000c517          	auipc	a0,0xc
    80001ec6:	a4e50513          	addi	a0,a0,-1458 # 8000d910 <tickslock>
    80001eca:	29f030ef          	jal	80005968 <release>
  return 0;
    80001ece:	4501                	li	a0,0
}
    80001ed0:	70e2                	ld	ra,56(sp)
    80001ed2:	7442                	ld	s0,48(sp)
    80001ed4:	7902                	ld	s2,32(sp)
    80001ed6:	6121                	addi	sp,sp,64
    80001ed8:	8082                	ret
    n = 0;
    80001eda:	fc042623          	sw	zero,-52(s0)
    80001ede:	bf49                	j	80001e70 <sys_sleep+0x1c>
      release(&tickslock);
    80001ee0:	0000c517          	auipc	a0,0xc
    80001ee4:	a3050513          	addi	a0,a0,-1488 # 8000d910 <tickslock>
    80001ee8:	281030ef          	jal	80005968 <release>
      return -1;
    80001eec:	557d                	li	a0,-1
    80001eee:	74a2                	ld	s1,40(sp)
    80001ef0:	69e2                	ld	s3,24(sp)
    80001ef2:	bff9                	j	80001ed0 <sys_sleep+0x7c>

0000000080001ef4 <sys_kill>:

uint64
sys_kill(void)
{
    80001ef4:	1101                	addi	sp,sp,-32
    80001ef6:	ec06                	sd	ra,24(sp)
    80001ef8:	e822                	sd	s0,16(sp)
    80001efa:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001efc:	fec40593          	addi	a1,s0,-20
    80001f00:	4501                	li	a0,0
    80001f02:	db1ff0ef          	jal	80001cb2 <argint>
  return kill(pid);
    80001f06:	fec42503          	lw	a0,-20(s0)
    80001f0a:	e22ff0ef          	jal	8000152c <kill>
}
    80001f0e:	60e2                	ld	ra,24(sp)
    80001f10:	6442                	ld	s0,16(sp)
    80001f12:	6105                	addi	sp,sp,32
    80001f14:	8082                	ret

0000000080001f16 <sys_hello>:

uint64 sys_hello(void)
{
    80001f16:	1141                	addi	sp,sp,-16
    80001f18:	e406                	sd	ra,8(sp)
    80001f1a:	e022                	sd	s0,0(sp)
    80001f1c:	0800                	addi	s0,sp,16
  printf("Hello, world!\n");
    80001f1e:	00005517          	auipc	a0,0x5
    80001f22:	58250513          	addi	a0,a0,1410 # 800074a0 <etext+0x4a0>
    80001f26:	3aa030ef          	jal	800052d0 <printf>
  return 0;
}
    80001f2a:	4501                	li	a0,0
    80001f2c:	60a2                	ld	ra,8(sp)
    80001f2e:	6402                	ld	s0,0(sp)
    80001f30:	0141                	addi	sp,sp,16
    80001f32:	8082                	ret

0000000080001f34 <sys_trace>:

uint64 sys_trace(void) {
    80001f34:	1101                	addi	sp,sp,-32
    80001f36:	ec06                	sd	ra,24(sp)
    80001f38:	e822                	sd	s0,16(sp)
    80001f3a:	1000                	addi	s0,sp,32
    int mask;
    argint(0, &mask);
    80001f3c:	fec40593          	addi	a1,s0,-20
    80001f40:	4501                	li	a0,0
    80001f42:	d71ff0ef          	jal	80001cb2 <argint>
    myproc()->trace_mask = mask;  // Store trace mask in the process
    80001f46:	e63fe0ef          	jal	80000da8 <myproc>
    80001f4a:	fec42783          	lw	a5,-20(s0)
    80001f4e:	d95c                	sw	a5,52(a0)
    return 0;
}
    80001f50:	4501                	li	a0,0
    80001f52:	60e2                	ld	ra,24(sp)
    80001f54:	6442                	ld	s0,16(sp)
    80001f56:	6105                	addi	sp,sp,32
    80001f58:	8082                	ret

0000000080001f5a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f5a:	1101                	addi	sp,sp,-32
    80001f5c:	ec06                	sd	ra,24(sp)
    80001f5e:	e822                	sd	s0,16(sp)
    80001f60:	e426                	sd	s1,8(sp)
    80001f62:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f64:	0000c517          	auipc	a0,0xc
    80001f68:	9ac50513          	addi	a0,a0,-1620 # 8000d910 <tickslock>
    80001f6c:	165030ef          	jal	800058d0 <acquire>
  xticks = ticks;
    80001f70:	00006497          	auipc	s1,0x6
    80001f74:	b384a483          	lw	s1,-1224(s1) # 80007aa8 <ticks>
  release(&tickslock);
    80001f78:	0000c517          	auipc	a0,0xc
    80001f7c:	99850513          	addi	a0,a0,-1640 # 8000d910 <tickslock>
    80001f80:	1e9030ef          	jal	80005968 <release>
  return xticks;
}
    80001f84:	02049513          	slli	a0,s1,0x20
    80001f88:	9101                	srli	a0,a0,0x20
    80001f8a:	60e2                	ld	ra,24(sp)
    80001f8c:	6442                	ld	s0,16(sp)
    80001f8e:	64a2                	ld	s1,8(sp)
    80001f90:	6105                	addi	sp,sp,32
    80001f92:	8082                	ret

0000000080001f94 <sys_sysinfo>:

uint64 count_freemem(void);
uint64 count_nproc(void);
uint64 count_openfiles(void);

uint64 sys_sysinfo(void) {
    80001f94:	7179                	addi	sp,sp,-48
    80001f96:	f406                	sd	ra,40(sp)
    80001f98:	f022                	sd	s0,32(sp)
    80001f9a:	1800                	addi	s0,sp,48
    struct sysinfo info;
    uint64 addr;
    
    // Just call argaddr() without checking return value
    argaddr(0, &addr);
    80001f9c:	fd040593          	addi	a1,s0,-48
    80001fa0:	4501                	li	a0,0
    80001fa2:	d2dff0ef          	jal	80001cce <argaddr>

    //Fill sysinfo struct
    info.freemem = count_freemem();
    80001fa6:	9a8fe0ef          	jal	8000014e <count_freemem>
    80001faa:	fca43c23          	sd	a0,-40(s0)
    info.nproc = count_nproc();
    80001fae:	865ff0ef          	jal	80001812 <count_nproc>
    80001fb2:	fea43023          	sd	a0,-32(s0)
    info.nopenfiles = count_openfiles();
    80001fb6:	79e010ef          	jal	80003754 <count_openfiles>
    80001fba:	fea43423          	sd	a0,-24(s0)

    // Copy struct to user space
    if (copyout(myproc()->pagetable, addr, (char*)&info, sizeof(info)) < 0)
    80001fbe:	debfe0ef          	jal	80000da8 <myproc>
    80001fc2:	46e1                	li	a3,24
    80001fc4:	fd840613          	addi	a2,s0,-40
    80001fc8:	fd043583          	ld	a1,-48(s0)
    80001fcc:	6928                	ld	a0,80(a0)
    80001fce:	a4dfe0ef          	jal	80000a1a <copyout>
        return -1;

    return 0;
}
    80001fd2:	957d                	srai	a0,a0,0x3f
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	6145                	addi	sp,sp,48
    80001fda:	8082                	ret

0000000080001fdc <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fdc:	7179                	addi	sp,sp,-48
    80001fde:	f406                	sd	ra,40(sp)
    80001fe0:	f022                	sd	s0,32(sp)
    80001fe2:	ec26                	sd	s1,24(sp)
    80001fe4:	e84a                	sd	s2,16(sp)
    80001fe6:	e44e                	sd	s3,8(sp)
    80001fe8:	e052                	sd	s4,0(sp)
    80001fea:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001fec:	00005597          	auipc	a1,0x5
    80001ff0:	4c458593          	addi	a1,a1,1220 # 800074b0 <etext+0x4b0>
    80001ff4:	0000c517          	auipc	a0,0xc
    80001ff8:	93450513          	addi	a0,a0,-1740 # 8000d928 <bcache>
    80001ffc:	055030ef          	jal	80005850 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002000:	00014797          	auipc	a5,0x14
    80002004:	92878793          	addi	a5,a5,-1752 # 80015928 <bcache+0x8000>
    80002008:	00014717          	auipc	a4,0x14
    8000200c:	b8870713          	addi	a4,a4,-1144 # 80015b90 <bcache+0x8268>
    80002010:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002014:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002018:	0000c497          	auipc	s1,0xc
    8000201c:	92848493          	addi	s1,s1,-1752 # 8000d940 <bcache+0x18>
    b->next = bcache.head.next;
    80002020:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002022:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002024:	00005a17          	auipc	s4,0x5
    80002028:	494a0a13          	addi	s4,s4,1172 # 800074b8 <etext+0x4b8>
    b->next = bcache.head.next;
    8000202c:	2b893783          	ld	a5,696(s2)
    80002030:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002032:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002036:	85d2                	mv	a1,s4
    80002038:	01048513          	addi	a0,s1,16
    8000203c:	248010ef          	jal	80003284 <initsleeplock>
    bcache.head.next->prev = b;
    80002040:	2b893783          	ld	a5,696(s2)
    80002044:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002046:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000204a:	45848493          	addi	s1,s1,1112
    8000204e:	fd349fe3          	bne	s1,s3,8000202c <binit+0x50>
  }
}
    80002052:	70a2                	ld	ra,40(sp)
    80002054:	7402                	ld	s0,32(sp)
    80002056:	64e2                	ld	s1,24(sp)
    80002058:	6942                	ld	s2,16(sp)
    8000205a:	69a2                	ld	s3,8(sp)
    8000205c:	6a02                	ld	s4,0(sp)
    8000205e:	6145                	addi	sp,sp,48
    80002060:	8082                	ret

0000000080002062 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	1800                	addi	s0,sp,48
    80002070:	892a                	mv	s2,a0
    80002072:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002074:	0000c517          	auipc	a0,0xc
    80002078:	8b450513          	addi	a0,a0,-1868 # 8000d928 <bcache>
    8000207c:	055030ef          	jal	800058d0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002080:	00014497          	auipc	s1,0x14
    80002084:	b604b483          	ld	s1,-1184(s1) # 80015be0 <bcache+0x82b8>
    80002088:	00014797          	auipc	a5,0x14
    8000208c:	b0878793          	addi	a5,a5,-1272 # 80015b90 <bcache+0x8268>
    80002090:	02f48b63          	beq	s1,a5,800020c6 <bread+0x64>
    80002094:	873e                	mv	a4,a5
    80002096:	a021                	j	8000209e <bread+0x3c>
    80002098:	68a4                	ld	s1,80(s1)
    8000209a:	02e48663          	beq	s1,a4,800020c6 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000209e:	449c                	lw	a5,8(s1)
    800020a0:	ff279ce3          	bne	a5,s2,80002098 <bread+0x36>
    800020a4:	44dc                	lw	a5,12(s1)
    800020a6:	ff3799e3          	bne	a5,s3,80002098 <bread+0x36>
      b->refcnt++;
    800020aa:	40bc                	lw	a5,64(s1)
    800020ac:	2785                	addiw	a5,a5,1
    800020ae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020b0:	0000c517          	auipc	a0,0xc
    800020b4:	87850513          	addi	a0,a0,-1928 # 8000d928 <bcache>
    800020b8:	0b1030ef          	jal	80005968 <release>
      acquiresleep(&b->lock);
    800020bc:	01048513          	addi	a0,s1,16
    800020c0:	1fa010ef          	jal	800032ba <acquiresleep>
      return b;
    800020c4:	a889                	j	80002116 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020c6:	00014497          	auipc	s1,0x14
    800020ca:	b124b483          	ld	s1,-1262(s1) # 80015bd8 <bcache+0x82b0>
    800020ce:	00014797          	auipc	a5,0x14
    800020d2:	ac278793          	addi	a5,a5,-1342 # 80015b90 <bcache+0x8268>
    800020d6:	00f48863          	beq	s1,a5,800020e6 <bread+0x84>
    800020da:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020dc:	40bc                	lw	a5,64(s1)
    800020de:	cb91                	beqz	a5,800020f2 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020e0:	64a4                	ld	s1,72(s1)
    800020e2:	fee49de3          	bne	s1,a4,800020dc <bread+0x7a>
  panic("bget: no buffers");
    800020e6:	00005517          	auipc	a0,0x5
    800020ea:	3da50513          	addi	a0,a0,986 # 800074c0 <etext+0x4c0>
    800020ee:	4b4030ef          	jal	800055a2 <panic>
      b->dev = dev;
    800020f2:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020f6:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020fa:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020fe:	4785                	li	a5,1
    80002100:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002102:	0000c517          	auipc	a0,0xc
    80002106:	82650513          	addi	a0,a0,-2010 # 8000d928 <bcache>
    8000210a:	05f030ef          	jal	80005968 <release>
      acquiresleep(&b->lock);
    8000210e:	01048513          	addi	a0,s1,16
    80002112:	1a8010ef          	jal	800032ba <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002116:	409c                	lw	a5,0(s1)
    80002118:	cb89                	beqz	a5,8000212a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000211a:	8526                	mv	a0,s1
    8000211c:	70a2                	ld	ra,40(sp)
    8000211e:	7402                	ld	s0,32(sp)
    80002120:	64e2                	ld	s1,24(sp)
    80002122:	6942                	ld	s2,16(sp)
    80002124:	69a2                	ld	s3,8(sp)
    80002126:	6145                	addi	sp,sp,48
    80002128:	8082                	ret
    virtio_disk_rw(b, 0);
    8000212a:	4581                	li	a1,0
    8000212c:	8526                	mv	a0,s1
    8000212e:	243020ef          	jal	80004b70 <virtio_disk_rw>
    b->valid = 1;
    80002132:	4785                	li	a5,1
    80002134:	c09c                	sw	a5,0(s1)
  return b;
    80002136:	b7d5                	j	8000211a <bread+0xb8>

0000000080002138 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002138:	1101                	addi	sp,sp,-32
    8000213a:	ec06                	sd	ra,24(sp)
    8000213c:	e822                	sd	s0,16(sp)
    8000213e:	e426                	sd	s1,8(sp)
    80002140:	1000                	addi	s0,sp,32
    80002142:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002144:	0541                	addi	a0,a0,16
    80002146:	1f2010ef          	jal	80003338 <holdingsleep>
    8000214a:	c911                	beqz	a0,8000215e <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000214c:	4585                	li	a1,1
    8000214e:	8526                	mv	a0,s1
    80002150:	221020ef          	jal	80004b70 <virtio_disk_rw>
}
    80002154:	60e2                	ld	ra,24(sp)
    80002156:	6442                	ld	s0,16(sp)
    80002158:	64a2                	ld	s1,8(sp)
    8000215a:	6105                	addi	sp,sp,32
    8000215c:	8082                	ret
    panic("bwrite");
    8000215e:	00005517          	auipc	a0,0x5
    80002162:	37a50513          	addi	a0,a0,890 # 800074d8 <etext+0x4d8>
    80002166:	43c030ef          	jal	800055a2 <panic>

000000008000216a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000216a:	1101                	addi	sp,sp,-32
    8000216c:	ec06                	sd	ra,24(sp)
    8000216e:	e822                	sd	s0,16(sp)
    80002170:	e426                	sd	s1,8(sp)
    80002172:	e04a                	sd	s2,0(sp)
    80002174:	1000                	addi	s0,sp,32
    80002176:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002178:	01050913          	addi	s2,a0,16
    8000217c:	854a                	mv	a0,s2
    8000217e:	1ba010ef          	jal	80003338 <holdingsleep>
    80002182:	c135                	beqz	a0,800021e6 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002184:	854a                	mv	a0,s2
    80002186:	17a010ef          	jal	80003300 <releasesleep>

  acquire(&bcache.lock);
    8000218a:	0000b517          	auipc	a0,0xb
    8000218e:	79e50513          	addi	a0,a0,1950 # 8000d928 <bcache>
    80002192:	73e030ef          	jal	800058d0 <acquire>
  b->refcnt--;
    80002196:	40bc                	lw	a5,64(s1)
    80002198:	37fd                	addiw	a5,a5,-1
    8000219a:	0007871b          	sext.w	a4,a5
    8000219e:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021a0:	e71d                	bnez	a4,800021ce <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021a2:	68b8                	ld	a4,80(s1)
    800021a4:	64bc                	ld	a5,72(s1)
    800021a6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021a8:	68b8                	ld	a4,80(s1)
    800021aa:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021ac:	00013797          	auipc	a5,0x13
    800021b0:	77c78793          	addi	a5,a5,1916 # 80015928 <bcache+0x8000>
    800021b4:	2b87b703          	ld	a4,696(a5)
    800021b8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800021ba:	00014717          	auipc	a4,0x14
    800021be:	9d670713          	addi	a4,a4,-1578 # 80015b90 <bcache+0x8268>
    800021c2:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021c4:	2b87b703          	ld	a4,696(a5)
    800021c8:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021ca:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021ce:	0000b517          	auipc	a0,0xb
    800021d2:	75a50513          	addi	a0,a0,1882 # 8000d928 <bcache>
    800021d6:	792030ef          	jal	80005968 <release>
}
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6902                	ld	s2,0(sp)
    800021e2:	6105                	addi	sp,sp,32
    800021e4:	8082                	ret
    panic("brelse");
    800021e6:	00005517          	auipc	a0,0x5
    800021ea:	2fa50513          	addi	a0,a0,762 # 800074e0 <etext+0x4e0>
    800021ee:	3b4030ef          	jal	800055a2 <panic>

00000000800021f2 <bpin>:

void
bpin(struct buf *b) {
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	e426                	sd	s1,8(sp)
    800021fa:	1000                	addi	s0,sp,32
    800021fc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021fe:	0000b517          	auipc	a0,0xb
    80002202:	72a50513          	addi	a0,a0,1834 # 8000d928 <bcache>
    80002206:	6ca030ef          	jal	800058d0 <acquire>
  b->refcnt++;
    8000220a:	40bc                	lw	a5,64(s1)
    8000220c:	2785                	addiw	a5,a5,1
    8000220e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002210:	0000b517          	auipc	a0,0xb
    80002214:	71850513          	addi	a0,a0,1816 # 8000d928 <bcache>
    80002218:	750030ef          	jal	80005968 <release>
}
    8000221c:	60e2                	ld	ra,24(sp)
    8000221e:	6442                	ld	s0,16(sp)
    80002220:	64a2                	ld	s1,8(sp)
    80002222:	6105                	addi	sp,sp,32
    80002224:	8082                	ret

0000000080002226 <bunpin>:

void
bunpin(struct buf *b) {
    80002226:	1101                	addi	sp,sp,-32
    80002228:	ec06                	sd	ra,24(sp)
    8000222a:	e822                	sd	s0,16(sp)
    8000222c:	e426                	sd	s1,8(sp)
    8000222e:	1000                	addi	s0,sp,32
    80002230:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002232:	0000b517          	auipc	a0,0xb
    80002236:	6f650513          	addi	a0,a0,1782 # 8000d928 <bcache>
    8000223a:	696030ef          	jal	800058d0 <acquire>
  b->refcnt--;
    8000223e:	40bc                	lw	a5,64(s1)
    80002240:	37fd                	addiw	a5,a5,-1
    80002242:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002244:	0000b517          	auipc	a0,0xb
    80002248:	6e450513          	addi	a0,a0,1764 # 8000d928 <bcache>
    8000224c:	71c030ef          	jal	80005968 <release>
}
    80002250:	60e2                	ld	ra,24(sp)
    80002252:	6442                	ld	s0,16(sp)
    80002254:	64a2                	ld	s1,8(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	e04a                	sd	s2,0(sp)
    80002264:	1000                	addi	s0,sp,32
    80002266:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002268:	00d5d59b          	srliw	a1,a1,0xd
    8000226c:	00014797          	auipc	a5,0x14
    80002270:	d987a783          	lw	a5,-616(a5) # 80016004 <sb+0x1c>
    80002274:	9dbd                	addw	a1,a1,a5
    80002276:	dedff0ef          	jal	80002062 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000227a:	0074f713          	andi	a4,s1,7
    8000227e:	4785                	li	a5,1
    80002280:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002284:	14ce                	slli	s1,s1,0x33
    80002286:	90d9                	srli	s1,s1,0x36
    80002288:	00950733          	add	a4,a0,s1
    8000228c:	05874703          	lbu	a4,88(a4)
    80002290:	00e7f6b3          	and	a3,a5,a4
    80002294:	c29d                	beqz	a3,800022ba <bfree+0x60>
    80002296:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002298:	94aa                	add	s1,s1,a0
    8000229a:	fff7c793          	not	a5,a5
    8000229e:	8f7d                	and	a4,a4,a5
    800022a0:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022a4:	711000ef          	jal	800031b4 <log_write>
  brelse(bp);
    800022a8:	854a                	mv	a0,s2
    800022aa:	ec1ff0ef          	jal	8000216a <brelse>
}
    800022ae:	60e2                	ld	ra,24(sp)
    800022b0:	6442                	ld	s0,16(sp)
    800022b2:	64a2                	ld	s1,8(sp)
    800022b4:	6902                	ld	s2,0(sp)
    800022b6:	6105                	addi	sp,sp,32
    800022b8:	8082                	ret
    panic("freeing free block");
    800022ba:	00005517          	auipc	a0,0x5
    800022be:	22e50513          	addi	a0,a0,558 # 800074e8 <etext+0x4e8>
    800022c2:	2e0030ef          	jal	800055a2 <panic>

00000000800022c6 <balloc>:
{
    800022c6:	711d                	addi	sp,sp,-96
    800022c8:	ec86                	sd	ra,88(sp)
    800022ca:	e8a2                	sd	s0,80(sp)
    800022cc:	e4a6                	sd	s1,72(sp)
    800022ce:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800022d0:	00014797          	auipc	a5,0x14
    800022d4:	d1c7a783          	lw	a5,-740(a5) # 80015fec <sb+0x4>
    800022d8:	0e078f63          	beqz	a5,800023d6 <balloc+0x110>
    800022dc:	e0ca                	sd	s2,64(sp)
    800022de:	fc4e                	sd	s3,56(sp)
    800022e0:	f852                	sd	s4,48(sp)
    800022e2:	f456                	sd	s5,40(sp)
    800022e4:	f05a                	sd	s6,32(sp)
    800022e6:	ec5e                	sd	s7,24(sp)
    800022e8:	e862                	sd	s8,16(sp)
    800022ea:	e466                	sd	s9,8(sp)
    800022ec:	8baa                	mv	s7,a0
    800022ee:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022f0:	00014b17          	auipc	s6,0x14
    800022f4:	cf8b0b13          	addi	s6,s6,-776 # 80015fe8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022f8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800022fa:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022fc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022fe:	6c89                	lui	s9,0x2
    80002300:	a0b5                	j	8000236c <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002302:	97ca                	add	a5,a5,s2
    80002304:	8e55                	or	a2,a2,a3
    80002306:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000230a:	854a                	mv	a0,s2
    8000230c:	6a9000ef          	jal	800031b4 <log_write>
        brelse(bp);
    80002310:	854a                	mv	a0,s2
    80002312:	e59ff0ef          	jal	8000216a <brelse>
  bp = bread(dev, bno);
    80002316:	85a6                	mv	a1,s1
    80002318:	855e                	mv	a0,s7
    8000231a:	d49ff0ef          	jal	80002062 <bread>
    8000231e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002320:	40000613          	li	a2,1024
    80002324:	4581                	li	a1,0
    80002326:	05850513          	addi	a0,a0,88
    8000232a:	e67fd0ef          	jal	80000190 <memset>
  log_write(bp);
    8000232e:	854a                	mv	a0,s2
    80002330:	685000ef          	jal	800031b4 <log_write>
  brelse(bp);
    80002334:	854a                	mv	a0,s2
    80002336:	e35ff0ef          	jal	8000216a <brelse>
}
    8000233a:	6906                	ld	s2,64(sp)
    8000233c:	79e2                	ld	s3,56(sp)
    8000233e:	7a42                	ld	s4,48(sp)
    80002340:	7aa2                	ld	s5,40(sp)
    80002342:	7b02                	ld	s6,32(sp)
    80002344:	6be2                	ld	s7,24(sp)
    80002346:	6c42                	ld	s8,16(sp)
    80002348:	6ca2                	ld	s9,8(sp)
}
    8000234a:	8526                	mv	a0,s1
    8000234c:	60e6                	ld	ra,88(sp)
    8000234e:	6446                	ld	s0,80(sp)
    80002350:	64a6                	ld	s1,72(sp)
    80002352:	6125                	addi	sp,sp,96
    80002354:	8082                	ret
    brelse(bp);
    80002356:	854a                	mv	a0,s2
    80002358:	e13ff0ef          	jal	8000216a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000235c:	015c87bb          	addw	a5,s9,s5
    80002360:	00078a9b          	sext.w	s5,a5
    80002364:	004b2703          	lw	a4,4(s6)
    80002368:	04eaff63          	bgeu	s5,a4,800023c6 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    8000236c:	41fad79b          	sraiw	a5,s5,0x1f
    80002370:	0137d79b          	srliw	a5,a5,0x13
    80002374:	015787bb          	addw	a5,a5,s5
    80002378:	40d7d79b          	sraiw	a5,a5,0xd
    8000237c:	01cb2583          	lw	a1,28(s6)
    80002380:	9dbd                	addw	a1,a1,a5
    80002382:	855e                	mv	a0,s7
    80002384:	cdfff0ef          	jal	80002062 <bread>
    80002388:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000238a:	004b2503          	lw	a0,4(s6)
    8000238e:	000a849b          	sext.w	s1,s5
    80002392:	8762                	mv	a4,s8
    80002394:	fca4f1e3          	bgeu	s1,a0,80002356 <balloc+0x90>
      m = 1 << (bi % 8);
    80002398:	00777693          	andi	a3,a4,7
    8000239c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023a0:	41f7579b          	sraiw	a5,a4,0x1f
    800023a4:	01d7d79b          	srliw	a5,a5,0x1d
    800023a8:	9fb9                	addw	a5,a5,a4
    800023aa:	4037d79b          	sraiw	a5,a5,0x3
    800023ae:	00f90633          	add	a2,s2,a5
    800023b2:	05864603          	lbu	a2,88(a2)
    800023b6:	00c6f5b3          	and	a1,a3,a2
    800023ba:	d5a1                	beqz	a1,80002302 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023bc:	2705                	addiw	a4,a4,1
    800023be:	2485                	addiw	s1,s1,1
    800023c0:	fd471ae3          	bne	a4,s4,80002394 <balloc+0xce>
    800023c4:	bf49                	j	80002356 <balloc+0x90>
    800023c6:	6906                	ld	s2,64(sp)
    800023c8:	79e2                	ld	s3,56(sp)
    800023ca:	7a42                	ld	s4,48(sp)
    800023cc:	7aa2                	ld	s5,40(sp)
    800023ce:	7b02                	ld	s6,32(sp)
    800023d0:	6be2                	ld	s7,24(sp)
    800023d2:	6c42                	ld	s8,16(sp)
    800023d4:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800023d6:	00005517          	auipc	a0,0x5
    800023da:	12a50513          	addi	a0,a0,298 # 80007500 <etext+0x500>
    800023de:	6f3020ef          	jal	800052d0 <printf>
  return 0;
    800023e2:	4481                	li	s1,0
    800023e4:	b79d                	j	8000234a <balloc+0x84>

00000000800023e6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023e6:	7179                	addi	sp,sp,-48
    800023e8:	f406                	sd	ra,40(sp)
    800023ea:	f022                	sd	s0,32(sp)
    800023ec:	ec26                	sd	s1,24(sp)
    800023ee:	e84a                	sd	s2,16(sp)
    800023f0:	e44e                	sd	s3,8(sp)
    800023f2:	1800                	addi	s0,sp,48
    800023f4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023f6:	47ad                	li	a5,11
    800023f8:	02b7e663          	bltu	a5,a1,80002424 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800023fc:	02059793          	slli	a5,a1,0x20
    80002400:	01e7d593          	srli	a1,a5,0x1e
    80002404:	00b504b3          	add	s1,a0,a1
    80002408:	0504a903          	lw	s2,80(s1)
    8000240c:	06091a63          	bnez	s2,80002480 <bmap+0x9a>
      addr = balloc(ip->dev);
    80002410:	4108                	lw	a0,0(a0)
    80002412:	eb5ff0ef          	jal	800022c6 <balloc>
    80002416:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000241a:	06090363          	beqz	s2,80002480 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000241e:	0524a823          	sw	s2,80(s1)
    80002422:	a8b9                	j	80002480 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002424:	ff45849b          	addiw	s1,a1,-12
    80002428:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000242c:	0ff00793          	li	a5,255
    80002430:	06e7ee63          	bltu	a5,a4,800024ac <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002434:	08052903          	lw	s2,128(a0)
    80002438:	00091d63          	bnez	s2,80002452 <bmap+0x6c>
      addr = balloc(ip->dev);
    8000243c:	4108                	lw	a0,0(a0)
    8000243e:	e89ff0ef          	jal	800022c6 <balloc>
    80002442:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002446:	02090d63          	beqz	s2,80002480 <bmap+0x9a>
    8000244a:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000244c:	0929a023          	sw	s2,128(s3)
    80002450:	a011                	j	80002454 <bmap+0x6e>
    80002452:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002454:	85ca                	mv	a1,s2
    80002456:	0009a503          	lw	a0,0(s3)
    8000245a:	c09ff0ef          	jal	80002062 <bread>
    8000245e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002460:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002464:	02049713          	slli	a4,s1,0x20
    80002468:	01e75593          	srli	a1,a4,0x1e
    8000246c:	00b784b3          	add	s1,a5,a1
    80002470:	0004a903          	lw	s2,0(s1)
    80002474:	00090e63          	beqz	s2,80002490 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002478:	8552                	mv	a0,s4
    8000247a:	cf1ff0ef          	jal	8000216a <brelse>
    return addr;
    8000247e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002480:	854a                	mv	a0,s2
    80002482:	70a2                	ld	ra,40(sp)
    80002484:	7402                	ld	s0,32(sp)
    80002486:	64e2                	ld	s1,24(sp)
    80002488:	6942                	ld	s2,16(sp)
    8000248a:	69a2                	ld	s3,8(sp)
    8000248c:	6145                	addi	sp,sp,48
    8000248e:	8082                	ret
      addr = balloc(ip->dev);
    80002490:	0009a503          	lw	a0,0(s3)
    80002494:	e33ff0ef          	jal	800022c6 <balloc>
    80002498:	0005091b          	sext.w	s2,a0
      if(addr){
    8000249c:	fc090ee3          	beqz	s2,80002478 <bmap+0x92>
        a[bn] = addr;
    800024a0:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800024a4:	8552                	mv	a0,s4
    800024a6:	50f000ef          	jal	800031b4 <log_write>
    800024aa:	b7f9                	j	80002478 <bmap+0x92>
    800024ac:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800024ae:	00005517          	auipc	a0,0x5
    800024b2:	06a50513          	addi	a0,a0,106 # 80007518 <etext+0x518>
    800024b6:	0ec030ef          	jal	800055a2 <panic>

00000000800024ba <iget>:
{
    800024ba:	7179                	addi	sp,sp,-48
    800024bc:	f406                	sd	ra,40(sp)
    800024be:	f022                	sd	s0,32(sp)
    800024c0:	ec26                	sd	s1,24(sp)
    800024c2:	e84a                	sd	s2,16(sp)
    800024c4:	e44e                	sd	s3,8(sp)
    800024c6:	e052                	sd	s4,0(sp)
    800024c8:	1800                	addi	s0,sp,48
    800024ca:	89aa                	mv	s3,a0
    800024cc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024ce:	00014517          	auipc	a0,0x14
    800024d2:	b3a50513          	addi	a0,a0,-1222 # 80016008 <itable>
    800024d6:	3fa030ef          	jal	800058d0 <acquire>
  empty = 0;
    800024da:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024dc:	00014497          	auipc	s1,0x14
    800024e0:	b4448493          	addi	s1,s1,-1212 # 80016020 <itable+0x18>
    800024e4:	00015697          	auipc	a3,0x15
    800024e8:	5cc68693          	addi	a3,a3,1484 # 80017ab0 <log>
    800024ec:	a039                	j	800024fa <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ee:	02090963          	beqz	s2,80002520 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024f2:	08848493          	addi	s1,s1,136
    800024f6:	02d48863          	beq	s1,a3,80002526 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024fa:	449c                	lw	a5,8(s1)
    800024fc:	fef059e3          	blez	a5,800024ee <iget+0x34>
    80002500:	4098                	lw	a4,0(s1)
    80002502:	ff3716e3          	bne	a4,s3,800024ee <iget+0x34>
    80002506:	40d8                	lw	a4,4(s1)
    80002508:	ff4713e3          	bne	a4,s4,800024ee <iget+0x34>
      ip->ref++;
    8000250c:	2785                	addiw	a5,a5,1
    8000250e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002510:	00014517          	auipc	a0,0x14
    80002514:	af850513          	addi	a0,a0,-1288 # 80016008 <itable>
    80002518:	450030ef          	jal	80005968 <release>
      return ip;
    8000251c:	8926                	mv	s2,s1
    8000251e:	a02d                	j	80002548 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002520:	fbe9                	bnez	a5,800024f2 <iget+0x38>
      empty = ip;
    80002522:	8926                	mv	s2,s1
    80002524:	b7f9                	j	800024f2 <iget+0x38>
  if(empty == 0)
    80002526:	02090a63          	beqz	s2,8000255a <iget+0xa0>
  ip->dev = dev;
    8000252a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000252e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002532:	4785                	li	a5,1
    80002534:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002538:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000253c:	00014517          	auipc	a0,0x14
    80002540:	acc50513          	addi	a0,a0,-1332 # 80016008 <itable>
    80002544:	424030ef          	jal	80005968 <release>
}
    80002548:	854a                	mv	a0,s2
    8000254a:	70a2                	ld	ra,40(sp)
    8000254c:	7402                	ld	s0,32(sp)
    8000254e:	64e2                	ld	s1,24(sp)
    80002550:	6942                	ld	s2,16(sp)
    80002552:	69a2                	ld	s3,8(sp)
    80002554:	6a02                	ld	s4,0(sp)
    80002556:	6145                	addi	sp,sp,48
    80002558:	8082                	ret
    panic("iget: no inodes");
    8000255a:	00005517          	auipc	a0,0x5
    8000255e:	fd650513          	addi	a0,a0,-42 # 80007530 <etext+0x530>
    80002562:	040030ef          	jal	800055a2 <panic>

0000000080002566 <fsinit>:
fsinit(int dev) {
    80002566:	7179                	addi	sp,sp,-48
    80002568:	f406                	sd	ra,40(sp)
    8000256a:	f022                	sd	s0,32(sp)
    8000256c:	ec26                	sd	s1,24(sp)
    8000256e:	e84a                	sd	s2,16(sp)
    80002570:	e44e                	sd	s3,8(sp)
    80002572:	1800                	addi	s0,sp,48
    80002574:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002576:	4585                	li	a1,1
    80002578:	aebff0ef          	jal	80002062 <bread>
    8000257c:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000257e:	00014997          	auipc	s3,0x14
    80002582:	a6a98993          	addi	s3,s3,-1430 # 80015fe8 <sb>
    80002586:	02000613          	li	a2,32
    8000258a:	05850593          	addi	a1,a0,88
    8000258e:	854e                	mv	a0,s3
    80002590:	c5dfd0ef          	jal	800001ec <memmove>
  brelse(bp);
    80002594:	8526                	mv	a0,s1
    80002596:	bd5ff0ef          	jal	8000216a <brelse>
  if(sb.magic != FSMAGIC)
    8000259a:	0009a703          	lw	a4,0(s3)
    8000259e:	102037b7          	lui	a5,0x10203
    800025a2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800025a6:	02f71063          	bne	a4,a5,800025c6 <fsinit+0x60>
  initlog(dev, &sb);
    800025aa:	00014597          	auipc	a1,0x14
    800025ae:	a3e58593          	addi	a1,a1,-1474 # 80015fe8 <sb>
    800025b2:	854a                	mv	a0,s2
    800025b4:	1f9000ef          	jal	80002fac <initlog>
}
    800025b8:	70a2                	ld	ra,40(sp)
    800025ba:	7402                	ld	s0,32(sp)
    800025bc:	64e2                	ld	s1,24(sp)
    800025be:	6942                	ld	s2,16(sp)
    800025c0:	69a2                	ld	s3,8(sp)
    800025c2:	6145                	addi	sp,sp,48
    800025c4:	8082                	ret
    panic("invalid file system");
    800025c6:	00005517          	auipc	a0,0x5
    800025ca:	f7a50513          	addi	a0,a0,-134 # 80007540 <etext+0x540>
    800025ce:	7d5020ef          	jal	800055a2 <panic>

00000000800025d2 <iinit>:
{
    800025d2:	7179                	addi	sp,sp,-48
    800025d4:	f406                	sd	ra,40(sp)
    800025d6:	f022                	sd	s0,32(sp)
    800025d8:	ec26                	sd	s1,24(sp)
    800025da:	e84a                	sd	s2,16(sp)
    800025dc:	e44e                	sd	s3,8(sp)
    800025de:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025e0:	00005597          	auipc	a1,0x5
    800025e4:	f7858593          	addi	a1,a1,-136 # 80007558 <etext+0x558>
    800025e8:	00014517          	auipc	a0,0x14
    800025ec:	a2050513          	addi	a0,a0,-1504 # 80016008 <itable>
    800025f0:	260030ef          	jal	80005850 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025f4:	00014497          	auipc	s1,0x14
    800025f8:	a3c48493          	addi	s1,s1,-1476 # 80016030 <itable+0x28>
    800025fc:	00015997          	auipc	s3,0x15
    80002600:	4c498993          	addi	s3,s3,1220 # 80017ac0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002604:	00005917          	auipc	s2,0x5
    80002608:	f5c90913          	addi	s2,s2,-164 # 80007560 <etext+0x560>
    8000260c:	85ca                	mv	a1,s2
    8000260e:	8526                	mv	a0,s1
    80002610:	475000ef          	jal	80003284 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002614:	08848493          	addi	s1,s1,136
    80002618:	ff349ae3          	bne	s1,s3,8000260c <iinit+0x3a>
}
    8000261c:	70a2                	ld	ra,40(sp)
    8000261e:	7402                	ld	s0,32(sp)
    80002620:	64e2                	ld	s1,24(sp)
    80002622:	6942                	ld	s2,16(sp)
    80002624:	69a2                	ld	s3,8(sp)
    80002626:	6145                	addi	sp,sp,48
    80002628:	8082                	ret

000000008000262a <ialloc>:
{
    8000262a:	7139                	addi	sp,sp,-64
    8000262c:	fc06                	sd	ra,56(sp)
    8000262e:	f822                	sd	s0,48(sp)
    80002630:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002632:	00014717          	auipc	a4,0x14
    80002636:	9c272703          	lw	a4,-1598(a4) # 80015ff4 <sb+0xc>
    8000263a:	4785                	li	a5,1
    8000263c:	06e7f063          	bgeu	a5,a4,8000269c <ialloc+0x72>
    80002640:	f426                	sd	s1,40(sp)
    80002642:	f04a                	sd	s2,32(sp)
    80002644:	ec4e                	sd	s3,24(sp)
    80002646:	e852                	sd	s4,16(sp)
    80002648:	e456                	sd	s5,8(sp)
    8000264a:	e05a                	sd	s6,0(sp)
    8000264c:	8aaa                	mv	s5,a0
    8000264e:	8b2e                	mv	s6,a1
    80002650:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002652:	00014a17          	auipc	s4,0x14
    80002656:	996a0a13          	addi	s4,s4,-1642 # 80015fe8 <sb>
    8000265a:	00495593          	srli	a1,s2,0x4
    8000265e:	018a2783          	lw	a5,24(s4)
    80002662:	9dbd                	addw	a1,a1,a5
    80002664:	8556                	mv	a0,s5
    80002666:	9fdff0ef          	jal	80002062 <bread>
    8000266a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000266c:	05850993          	addi	s3,a0,88
    80002670:	00f97793          	andi	a5,s2,15
    80002674:	079a                	slli	a5,a5,0x6
    80002676:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002678:	00099783          	lh	a5,0(s3)
    8000267c:	cb9d                	beqz	a5,800026b2 <ialloc+0x88>
    brelse(bp);
    8000267e:	aedff0ef          	jal	8000216a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002682:	0905                	addi	s2,s2,1
    80002684:	00ca2703          	lw	a4,12(s4)
    80002688:	0009079b          	sext.w	a5,s2
    8000268c:	fce7e7e3          	bltu	a5,a4,8000265a <ialloc+0x30>
    80002690:	74a2                	ld	s1,40(sp)
    80002692:	7902                	ld	s2,32(sp)
    80002694:	69e2                	ld	s3,24(sp)
    80002696:	6a42                	ld	s4,16(sp)
    80002698:	6aa2                	ld	s5,8(sp)
    8000269a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000269c:	00005517          	auipc	a0,0x5
    800026a0:	ecc50513          	addi	a0,a0,-308 # 80007568 <etext+0x568>
    800026a4:	42d020ef          	jal	800052d0 <printf>
  return 0;
    800026a8:	4501                	li	a0,0
}
    800026aa:	70e2                	ld	ra,56(sp)
    800026ac:	7442                	ld	s0,48(sp)
    800026ae:	6121                	addi	sp,sp,64
    800026b0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800026b2:	04000613          	li	a2,64
    800026b6:	4581                	li	a1,0
    800026b8:	854e                	mv	a0,s3
    800026ba:	ad7fd0ef          	jal	80000190 <memset>
      dip->type = type;
    800026be:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800026c2:	8526                	mv	a0,s1
    800026c4:	2f1000ef          	jal	800031b4 <log_write>
      brelse(bp);
    800026c8:	8526                	mv	a0,s1
    800026ca:	aa1ff0ef          	jal	8000216a <brelse>
      return iget(dev, inum);
    800026ce:	0009059b          	sext.w	a1,s2
    800026d2:	8556                	mv	a0,s5
    800026d4:	de7ff0ef          	jal	800024ba <iget>
    800026d8:	74a2                	ld	s1,40(sp)
    800026da:	7902                	ld	s2,32(sp)
    800026dc:	69e2                	ld	s3,24(sp)
    800026de:	6a42                	ld	s4,16(sp)
    800026e0:	6aa2                	ld	s5,8(sp)
    800026e2:	6b02                	ld	s6,0(sp)
    800026e4:	b7d9                	j	800026aa <ialloc+0x80>

00000000800026e6 <iupdate>:
{
    800026e6:	1101                	addi	sp,sp,-32
    800026e8:	ec06                	sd	ra,24(sp)
    800026ea:	e822                	sd	s0,16(sp)
    800026ec:	e426                	sd	s1,8(sp)
    800026ee:	e04a                	sd	s2,0(sp)
    800026f0:	1000                	addi	s0,sp,32
    800026f2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026f4:	415c                	lw	a5,4(a0)
    800026f6:	0047d79b          	srliw	a5,a5,0x4
    800026fa:	00014597          	auipc	a1,0x14
    800026fe:	9065a583          	lw	a1,-1786(a1) # 80016000 <sb+0x18>
    80002702:	9dbd                	addw	a1,a1,a5
    80002704:	4108                	lw	a0,0(a0)
    80002706:	95dff0ef          	jal	80002062 <bread>
    8000270a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000270c:	05850793          	addi	a5,a0,88
    80002710:	40d8                	lw	a4,4(s1)
    80002712:	8b3d                	andi	a4,a4,15
    80002714:	071a                	slli	a4,a4,0x6
    80002716:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002718:	04449703          	lh	a4,68(s1)
    8000271c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002720:	04649703          	lh	a4,70(s1)
    80002724:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002728:	04849703          	lh	a4,72(s1)
    8000272c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002730:	04a49703          	lh	a4,74(s1)
    80002734:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002738:	44f8                	lw	a4,76(s1)
    8000273a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000273c:	03400613          	li	a2,52
    80002740:	05048593          	addi	a1,s1,80
    80002744:	00c78513          	addi	a0,a5,12
    80002748:	aa5fd0ef          	jal	800001ec <memmove>
  log_write(bp);
    8000274c:	854a                	mv	a0,s2
    8000274e:	267000ef          	jal	800031b4 <log_write>
  brelse(bp);
    80002752:	854a                	mv	a0,s2
    80002754:	a17ff0ef          	jal	8000216a <brelse>
}
    80002758:	60e2                	ld	ra,24(sp)
    8000275a:	6442                	ld	s0,16(sp)
    8000275c:	64a2                	ld	s1,8(sp)
    8000275e:	6902                	ld	s2,0(sp)
    80002760:	6105                	addi	sp,sp,32
    80002762:	8082                	ret

0000000080002764 <idup>:
{
    80002764:	1101                	addi	sp,sp,-32
    80002766:	ec06                	sd	ra,24(sp)
    80002768:	e822                	sd	s0,16(sp)
    8000276a:	e426                	sd	s1,8(sp)
    8000276c:	1000                	addi	s0,sp,32
    8000276e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002770:	00014517          	auipc	a0,0x14
    80002774:	89850513          	addi	a0,a0,-1896 # 80016008 <itable>
    80002778:	158030ef          	jal	800058d0 <acquire>
  ip->ref++;
    8000277c:	449c                	lw	a5,8(s1)
    8000277e:	2785                	addiw	a5,a5,1
    80002780:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002782:	00014517          	auipc	a0,0x14
    80002786:	88650513          	addi	a0,a0,-1914 # 80016008 <itable>
    8000278a:	1de030ef          	jal	80005968 <release>
}
    8000278e:	8526                	mv	a0,s1
    80002790:	60e2                	ld	ra,24(sp)
    80002792:	6442                	ld	s0,16(sp)
    80002794:	64a2                	ld	s1,8(sp)
    80002796:	6105                	addi	sp,sp,32
    80002798:	8082                	ret

000000008000279a <ilock>:
{
    8000279a:	1101                	addi	sp,sp,-32
    8000279c:	ec06                	sd	ra,24(sp)
    8000279e:	e822                	sd	s0,16(sp)
    800027a0:	e426                	sd	s1,8(sp)
    800027a2:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800027a4:	cd19                	beqz	a0,800027c2 <ilock+0x28>
    800027a6:	84aa                	mv	s1,a0
    800027a8:	451c                	lw	a5,8(a0)
    800027aa:	00f05c63          	blez	a5,800027c2 <ilock+0x28>
  acquiresleep(&ip->lock);
    800027ae:	0541                	addi	a0,a0,16
    800027b0:	30b000ef          	jal	800032ba <acquiresleep>
  if(ip->valid == 0){
    800027b4:	40bc                	lw	a5,64(s1)
    800027b6:	cf89                	beqz	a5,800027d0 <ilock+0x36>
}
    800027b8:	60e2                	ld	ra,24(sp)
    800027ba:	6442                	ld	s0,16(sp)
    800027bc:	64a2                	ld	s1,8(sp)
    800027be:	6105                	addi	sp,sp,32
    800027c0:	8082                	ret
    800027c2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027c4:	00005517          	auipc	a0,0x5
    800027c8:	dbc50513          	addi	a0,a0,-580 # 80007580 <etext+0x580>
    800027cc:	5d7020ef          	jal	800055a2 <panic>
    800027d0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027d2:	40dc                	lw	a5,4(s1)
    800027d4:	0047d79b          	srliw	a5,a5,0x4
    800027d8:	00014597          	auipc	a1,0x14
    800027dc:	8285a583          	lw	a1,-2008(a1) # 80016000 <sb+0x18>
    800027e0:	9dbd                	addw	a1,a1,a5
    800027e2:	4088                	lw	a0,0(s1)
    800027e4:	87fff0ef          	jal	80002062 <bread>
    800027e8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027ea:	05850593          	addi	a1,a0,88
    800027ee:	40dc                	lw	a5,4(s1)
    800027f0:	8bbd                	andi	a5,a5,15
    800027f2:	079a                	slli	a5,a5,0x6
    800027f4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027f6:	00059783          	lh	a5,0(a1)
    800027fa:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027fe:	00259783          	lh	a5,2(a1)
    80002802:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002806:	00459783          	lh	a5,4(a1)
    8000280a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000280e:	00659783          	lh	a5,6(a1)
    80002812:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002816:	459c                	lw	a5,8(a1)
    80002818:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000281a:	03400613          	li	a2,52
    8000281e:	05b1                	addi	a1,a1,12
    80002820:	05048513          	addi	a0,s1,80
    80002824:	9c9fd0ef          	jal	800001ec <memmove>
    brelse(bp);
    80002828:	854a                	mv	a0,s2
    8000282a:	941ff0ef          	jal	8000216a <brelse>
    ip->valid = 1;
    8000282e:	4785                	li	a5,1
    80002830:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002832:	04449783          	lh	a5,68(s1)
    80002836:	c399                	beqz	a5,8000283c <ilock+0xa2>
    80002838:	6902                	ld	s2,0(sp)
    8000283a:	bfbd                	j	800027b8 <ilock+0x1e>
      panic("ilock: no type");
    8000283c:	00005517          	auipc	a0,0x5
    80002840:	d4c50513          	addi	a0,a0,-692 # 80007588 <etext+0x588>
    80002844:	55f020ef          	jal	800055a2 <panic>

0000000080002848 <iunlock>:
{
    80002848:	1101                	addi	sp,sp,-32
    8000284a:	ec06                	sd	ra,24(sp)
    8000284c:	e822                	sd	s0,16(sp)
    8000284e:	e426                	sd	s1,8(sp)
    80002850:	e04a                	sd	s2,0(sp)
    80002852:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002854:	c505                	beqz	a0,8000287c <iunlock+0x34>
    80002856:	84aa                	mv	s1,a0
    80002858:	01050913          	addi	s2,a0,16
    8000285c:	854a                	mv	a0,s2
    8000285e:	2db000ef          	jal	80003338 <holdingsleep>
    80002862:	cd09                	beqz	a0,8000287c <iunlock+0x34>
    80002864:	449c                	lw	a5,8(s1)
    80002866:	00f05b63          	blez	a5,8000287c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000286a:	854a                	mv	a0,s2
    8000286c:	295000ef          	jal	80003300 <releasesleep>
}
    80002870:	60e2                	ld	ra,24(sp)
    80002872:	6442                	ld	s0,16(sp)
    80002874:	64a2                	ld	s1,8(sp)
    80002876:	6902                	ld	s2,0(sp)
    80002878:	6105                	addi	sp,sp,32
    8000287a:	8082                	ret
    panic("iunlock");
    8000287c:	00005517          	auipc	a0,0x5
    80002880:	d1c50513          	addi	a0,a0,-740 # 80007598 <etext+0x598>
    80002884:	51f020ef          	jal	800055a2 <panic>

0000000080002888 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002888:	7179                	addi	sp,sp,-48
    8000288a:	f406                	sd	ra,40(sp)
    8000288c:	f022                	sd	s0,32(sp)
    8000288e:	ec26                	sd	s1,24(sp)
    80002890:	e84a                	sd	s2,16(sp)
    80002892:	e44e                	sd	s3,8(sp)
    80002894:	1800                	addi	s0,sp,48
    80002896:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002898:	05050493          	addi	s1,a0,80
    8000289c:	08050913          	addi	s2,a0,128
    800028a0:	a021                	j	800028a8 <itrunc+0x20>
    800028a2:	0491                	addi	s1,s1,4
    800028a4:	01248b63          	beq	s1,s2,800028ba <itrunc+0x32>
    if(ip->addrs[i]){
    800028a8:	408c                	lw	a1,0(s1)
    800028aa:	dde5                	beqz	a1,800028a2 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800028ac:	0009a503          	lw	a0,0(s3)
    800028b0:	9abff0ef          	jal	8000225a <bfree>
      ip->addrs[i] = 0;
    800028b4:	0004a023          	sw	zero,0(s1)
    800028b8:	b7ed                	j	800028a2 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800028ba:	0809a583          	lw	a1,128(s3)
    800028be:	ed89                	bnez	a1,800028d8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800028c0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800028c4:	854e                	mv	a0,s3
    800028c6:	e21ff0ef          	jal	800026e6 <iupdate>
}
    800028ca:	70a2                	ld	ra,40(sp)
    800028cc:	7402                	ld	s0,32(sp)
    800028ce:	64e2                	ld	s1,24(sp)
    800028d0:	6942                	ld	s2,16(sp)
    800028d2:	69a2                	ld	s3,8(sp)
    800028d4:	6145                	addi	sp,sp,48
    800028d6:	8082                	ret
    800028d8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028da:	0009a503          	lw	a0,0(s3)
    800028de:	f84ff0ef          	jal	80002062 <bread>
    800028e2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028e4:	05850493          	addi	s1,a0,88
    800028e8:	45850913          	addi	s2,a0,1112
    800028ec:	a021                	j	800028f4 <itrunc+0x6c>
    800028ee:	0491                	addi	s1,s1,4
    800028f0:	01248963          	beq	s1,s2,80002902 <itrunc+0x7a>
      if(a[j])
    800028f4:	408c                	lw	a1,0(s1)
    800028f6:	dde5                	beqz	a1,800028ee <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028f8:	0009a503          	lw	a0,0(s3)
    800028fc:	95fff0ef          	jal	8000225a <bfree>
    80002900:	b7fd                	j	800028ee <itrunc+0x66>
    brelse(bp);
    80002902:	8552                	mv	a0,s4
    80002904:	867ff0ef          	jal	8000216a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002908:	0809a583          	lw	a1,128(s3)
    8000290c:	0009a503          	lw	a0,0(s3)
    80002910:	94bff0ef          	jal	8000225a <bfree>
    ip->addrs[NDIRECT] = 0;
    80002914:	0809a023          	sw	zero,128(s3)
    80002918:	6a02                	ld	s4,0(sp)
    8000291a:	b75d                	j	800028c0 <itrunc+0x38>

000000008000291c <iput>:
{
    8000291c:	1101                	addi	sp,sp,-32
    8000291e:	ec06                	sd	ra,24(sp)
    80002920:	e822                	sd	s0,16(sp)
    80002922:	e426                	sd	s1,8(sp)
    80002924:	1000                	addi	s0,sp,32
    80002926:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002928:	00013517          	auipc	a0,0x13
    8000292c:	6e050513          	addi	a0,a0,1760 # 80016008 <itable>
    80002930:	7a1020ef          	jal	800058d0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002934:	4498                	lw	a4,8(s1)
    80002936:	4785                	li	a5,1
    80002938:	02f70063          	beq	a4,a5,80002958 <iput+0x3c>
  ip->ref--;
    8000293c:	449c                	lw	a5,8(s1)
    8000293e:	37fd                	addiw	a5,a5,-1
    80002940:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002942:	00013517          	auipc	a0,0x13
    80002946:	6c650513          	addi	a0,a0,1734 # 80016008 <itable>
    8000294a:	01e030ef          	jal	80005968 <release>
}
    8000294e:	60e2                	ld	ra,24(sp)
    80002950:	6442                	ld	s0,16(sp)
    80002952:	64a2                	ld	s1,8(sp)
    80002954:	6105                	addi	sp,sp,32
    80002956:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002958:	40bc                	lw	a5,64(s1)
    8000295a:	d3ed                	beqz	a5,8000293c <iput+0x20>
    8000295c:	04a49783          	lh	a5,74(s1)
    80002960:	fff1                	bnez	a5,8000293c <iput+0x20>
    80002962:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002964:	01048913          	addi	s2,s1,16
    80002968:	854a                	mv	a0,s2
    8000296a:	151000ef          	jal	800032ba <acquiresleep>
    release(&itable.lock);
    8000296e:	00013517          	auipc	a0,0x13
    80002972:	69a50513          	addi	a0,a0,1690 # 80016008 <itable>
    80002976:	7f3020ef          	jal	80005968 <release>
    itrunc(ip);
    8000297a:	8526                	mv	a0,s1
    8000297c:	f0dff0ef          	jal	80002888 <itrunc>
    ip->type = 0;
    80002980:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002984:	8526                	mv	a0,s1
    80002986:	d61ff0ef          	jal	800026e6 <iupdate>
    ip->valid = 0;
    8000298a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000298e:	854a                	mv	a0,s2
    80002990:	171000ef          	jal	80003300 <releasesleep>
    acquire(&itable.lock);
    80002994:	00013517          	auipc	a0,0x13
    80002998:	67450513          	addi	a0,a0,1652 # 80016008 <itable>
    8000299c:	735020ef          	jal	800058d0 <acquire>
    800029a0:	6902                	ld	s2,0(sp)
    800029a2:	bf69                	j	8000293c <iput+0x20>

00000000800029a4 <iunlockput>:
{
    800029a4:	1101                	addi	sp,sp,-32
    800029a6:	ec06                	sd	ra,24(sp)
    800029a8:	e822                	sd	s0,16(sp)
    800029aa:	e426                	sd	s1,8(sp)
    800029ac:	1000                	addi	s0,sp,32
    800029ae:	84aa                	mv	s1,a0
  iunlock(ip);
    800029b0:	e99ff0ef          	jal	80002848 <iunlock>
  iput(ip);
    800029b4:	8526                	mv	a0,s1
    800029b6:	f67ff0ef          	jal	8000291c <iput>
}
    800029ba:	60e2                	ld	ra,24(sp)
    800029bc:	6442                	ld	s0,16(sp)
    800029be:	64a2                	ld	s1,8(sp)
    800029c0:	6105                	addi	sp,sp,32
    800029c2:	8082                	ret

00000000800029c4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029c4:	1141                	addi	sp,sp,-16
    800029c6:	e422                	sd	s0,8(sp)
    800029c8:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029ca:	411c                	lw	a5,0(a0)
    800029cc:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029ce:	415c                	lw	a5,4(a0)
    800029d0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029d2:	04451783          	lh	a5,68(a0)
    800029d6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029da:	04a51783          	lh	a5,74(a0)
    800029de:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029e2:	04c56783          	lwu	a5,76(a0)
    800029e6:	e99c                	sd	a5,16(a1)
}
    800029e8:	6422                	ld	s0,8(sp)
    800029ea:	0141                	addi	sp,sp,16
    800029ec:	8082                	ret

00000000800029ee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029ee:	457c                	lw	a5,76(a0)
    800029f0:	0ed7eb63          	bltu	a5,a3,80002ae6 <readi+0xf8>
{
    800029f4:	7159                	addi	sp,sp,-112
    800029f6:	f486                	sd	ra,104(sp)
    800029f8:	f0a2                	sd	s0,96(sp)
    800029fa:	eca6                	sd	s1,88(sp)
    800029fc:	e0d2                	sd	s4,64(sp)
    800029fe:	fc56                	sd	s5,56(sp)
    80002a00:	f85a                	sd	s6,48(sp)
    80002a02:	f45e                	sd	s7,40(sp)
    80002a04:	1880                	addi	s0,sp,112
    80002a06:	8b2a                	mv	s6,a0
    80002a08:	8bae                	mv	s7,a1
    80002a0a:	8a32                	mv	s4,a2
    80002a0c:	84b6                	mv	s1,a3
    80002a0e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a10:	9f35                	addw	a4,a4,a3
    return 0;
    80002a12:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a14:	0cd76063          	bltu	a4,a3,80002ad4 <readi+0xe6>
    80002a18:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a1a:	00e7f463          	bgeu	a5,a4,80002a22 <readi+0x34>
    n = ip->size - off;
    80002a1e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a22:	080a8f63          	beqz	s5,80002ac0 <readi+0xd2>
    80002a26:	e8ca                	sd	s2,80(sp)
    80002a28:	f062                	sd	s8,32(sp)
    80002a2a:	ec66                	sd	s9,24(sp)
    80002a2c:	e86a                	sd	s10,16(sp)
    80002a2e:	e46e                	sd	s11,8(sp)
    80002a30:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a32:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a36:	5c7d                	li	s8,-1
    80002a38:	a80d                	j	80002a6a <readi+0x7c>
    80002a3a:	020d1d93          	slli	s11,s10,0x20
    80002a3e:	020ddd93          	srli	s11,s11,0x20
    80002a42:	05890613          	addi	a2,s2,88
    80002a46:	86ee                	mv	a3,s11
    80002a48:	963a                	add	a2,a2,a4
    80002a4a:	85d2                	mv	a1,s4
    80002a4c:	855e                	mv	a0,s7
    80002a4e:	c8dfe0ef          	jal	800016da <either_copyout>
    80002a52:	05850763          	beq	a0,s8,80002aa0 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a56:	854a                	mv	a0,s2
    80002a58:	f12ff0ef          	jal	8000216a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a5c:	013d09bb          	addw	s3,s10,s3
    80002a60:	009d04bb          	addw	s1,s10,s1
    80002a64:	9a6e                	add	s4,s4,s11
    80002a66:	0559f763          	bgeu	s3,s5,80002ab4 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80002a6a:	00a4d59b          	srliw	a1,s1,0xa
    80002a6e:	855a                	mv	a0,s6
    80002a70:	977ff0ef          	jal	800023e6 <bmap>
    80002a74:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002a78:	c5b1                	beqz	a1,80002ac4 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80002a7a:	000b2503          	lw	a0,0(s6)
    80002a7e:	de4ff0ef          	jal	80002062 <bread>
    80002a82:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a84:	3ff4f713          	andi	a4,s1,1023
    80002a88:	40ec87bb          	subw	a5,s9,a4
    80002a8c:	413a86bb          	subw	a3,s5,s3
    80002a90:	8d3e                	mv	s10,a5
    80002a92:	2781                	sext.w	a5,a5
    80002a94:	0006861b          	sext.w	a2,a3
    80002a98:	faf671e3          	bgeu	a2,a5,80002a3a <readi+0x4c>
    80002a9c:	8d36                	mv	s10,a3
    80002a9e:	bf71                	j	80002a3a <readi+0x4c>
      brelse(bp);
    80002aa0:	854a                	mv	a0,s2
    80002aa2:	ec8ff0ef          	jal	8000216a <brelse>
      tot = -1;
    80002aa6:	59fd                	li	s3,-1
      break;
    80002aa8:	6946                	ld	s2,80(sp)
    80002aaa:	7c02                	ld	s8,32(sp)
    80002aac:	6ce2                	ld	s9,24(sp)
    80002aae:	6d42                	ld	s10,16(sp)
    80002ab0:	6da2                	ld	s11,8(sp)
    80002ab2:	a831                	j	80002ace <readi+0xe0>
    80002ab4:	6946                	ld	s2,80(sp)
    80002ab6:	7c02                	ld	s8,32(sp)
    80002ab8:	6ce2                	ld	s9,24(sp)
    80002aba:	6d42                	ld	s10,16(sp)
    80002abc:	6da2                	ld	s11,8(sp)
    80002abe:	a801                	j	80002ace <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ac0:	89d6                	mv	s3,s5
    80002ac2:	a031                	j	80002ace <readi+0xe0>
    80002ac4:	6946                	ld	s2,80(sp)
    80002ac6:	7c02                	ld	s8,32(sp)
    80002ac8:	6ce2                	ld	s9,24(sp)
    80002aca:	6d42                	ld	s10,16(sp)
    80002acc:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ace:	0009851b          	sext.w	a0,s3
    80002ad2:	69a6                	ld	s3,72(sp)
}
    80002ad4:	70a6                	ld	ra,104(sp)
    80002ad6:	7406                	ld	s0,96(sp)
    80002ad8:	64e6                	ld	s1,88(sp)
    80002ada:	6a06                	ld	s4,64(sp)
    80002adc:	7ae2                	ld	s5,56(sp)
    80002ade:	7b42                	ld	s6,48(sp)
    80002ae0:	7ba2                	ld	s7,40(sp)
    80002ae2:	6165                	addi	sp,sp,112
    80002ae4:	8082                	ret
    return 0;
    80002ae6:	4501                	li	a0,0
}
    80002ae8:	8082                	ret

0000000080002aea <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002aea:	457c                	lw	a5,76(a0)
    80002aec:	10d7e063          	bltu	a5,a3,80002bec <writei+0x102>
{
    80002af0:	7159                	addi	sp,sp,-112
    80002af2:	f486                	sd	ra,104(sp)
    80002af4:	f0a2                	sd	s0,96(sp)
    80002af6:	e8ca                	sd	s2,80(sp)
    80002af8:	e0d2                	sd	s4,64(sp)
    80002afa:	fc56                	sd	s5,56(sp)
    80002afc:	f85a                	sd	s6,48(sp)
    80002afe:	f45e                	sd	s7,40(sp)
    80002b00:	1880                	addi	s0,sp,112
    80002b02:	8aaa                	mv	s5,a0
    80002b04:	8bae                	mv	s7,a1
    80002b06:	8a32                	mv	s4,a2
    80002b08:	8936                	mv	s2,a3
    80002b0a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b0c:	00e687bb          	addw	a5,a3,a4
    80002b10:	0ed7e063          	bltu	a5,a3,80002bf0 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b14:	00043737          	lui	a4,0x43
    80002b18:	0cf76e63          	bltu	a4,a5,80002bf4 <writei+0x10a>
    80002b1c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b1e:	0a0b0f63          	beqz	s6,80002bdc <writei+0xf2>
    80002b22:	eca6                	sd	s1,88(sp)
    80002b24:	f062                	sd	s8,32(sp)
    80002b26:	ec66                	sd	s9,24(sp)
    80002b28:	e86a                	sd	s10,16(sp)
    80002b2a:	e46e                	sd	s11,8(sp)
    80002b2c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b2e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b32:	5c7d                	li	s8,-1
    80002b34:	a825                	j	80002b6c <writei+0x82>
    80002b36:	020d1d93          	slli	s11,s10,0x20
    80002b3a:	020ddd93          	srli	s11,s11,0x20
    80002b3e:	05848513          	addi	a0,s1,88
    80002b42:	86ee                	mv	a3,s11
    80002b44:	8652                	mv	a2,s4
    80002b46:	85de                	mv	a1,s7
    80002b48:	953a                	add	a0,a0,a4
    80002b4a:	bdbfe0ef          	jal	80001724 <either_copyin>
    80002b4e:	05850a63          	beq	a0,s8,80002ba2 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b52:	8526                	mv	a0,s1
    80002b54:	660000ef          	jal	800031b4 <log_write>
    brelse(bp);
    80002b58:	8526                	mv	a0,s1
    80002b5a:	e10ff0ef          	jal	8000216a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b5e:	013d09bb          	addw	s3,s10,s3
    80002b62:	012d093b          	addw	s2,s10,s2
    80002b66:	9a6e                	add	s4,s4,s11
    80002b68:	0569f063          	bgeu	s3,s6,80002ba8 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b6c:	00a9559b          	srliw	a1,s2,0xa
    80002b70:	8556                	mv	a0,s5
    80002b72:	875ff0ef          	jal	800023e6 <bmap>
    80002b76:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002b7a:	c59d                	beqz	a1,80002ba8 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80002b7c:	000aa503          	lw	a0,0(s5)
    80002b80:	ce2ff0ef          	jal	80002062 <bread>
    80002b84:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b86:	3ff97713          	andi	a4,s2,1023
    80002b8a:	40ec87bb          	subw	a5,s9,a4
    80002b8e:	413b06bb          	subw	a3,s6,s3
    80002b92:	8d3e                	mv	s10,a5
    80002b94:	2781                	sext.w	a5,a5
    80002b96:	0006861b          	sext.w	a2,a3
    80002b9a:	f8f67ee3          	bgeu	a2,a5,80002b36 <writei+0x4c>
    80002b9e:	8d36                	mv	s10,a3
    80002ba0:	bf59                	j	80002b36 <writei+0x4c>
      brelse(bp);
    80002ba2:	8526                	mv	a0,s1
    80002ba4:	dc6ff0ef          	jal	8000216a <brelse>
  }

  if(off > ip->size)
    80002ba8:	04caa783          	lw	a5,76(s5)
    80002bac:	0327fa63          	bgeu	a5,s2,80002be0 <writei+0xf6>
    ip->size = off;
    80002bb0:	052aa623          	sw	s2,76(s5)
    80002bb4:	64e6                	ld	s1,88(sp)
    80002bb6:	7c02                	ld	s8,32(sp)
    80002bb8:	6ce2                	ld	s9,24(sp)
    80002bba:	6d42                	ld	s10,16(sp)
    80002bbc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bbe:	8556                	mv	a0,s5
    80002bc0:	b27ff0ef          	jal	800026e6 <iupdate>

  return tot;
    80002bc4:	0009851b          	sext.w	a0,s3
    80002bc8:	69a6                	ld	s3,72(sp)
}
    80002bca:	70a6                	ld	ra,104(sp)
    80002bcc:	7406                	ld	s0,96(sp)
    80002bce:	6946                	ld	s2,80(sp)
    80002bd0:	6a06                	ld	s4,64(sp)
    80002bd2:	7ae2                	ld	s5,56(sp)
    80002bd4:	7b42                	ld	s6,48(sp)
    80002bd6:	7ba2                	ld	s7,40(sp)
    80002bd8:	6165                	addi	sp,sp,112
    80002bda:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bdc:	89da                	mv	s3,s6
    80002bde:	b7c5                	j	80002bbe <writei+0xd4>
    80002be0:	64e6                	ld	s1,88(sp)
    80002be2:	7c02                	ld	s8,32(sp)
    80002be4:	6ce2                	ld	s9,24(sp)
    80002be6:	6d42                	ld	s10,16(sp)
    80002be8:	6da2                	ld	s11,8(sp)
    80002bea:	bfd1                	j	80002bbe <writei+0xd4>
    return -1;
    80002bec:	557d                	li	a0,-1
}
    80002bee:	8082                	ret
    return -1;
    80002bf0:	557d                	li	a0,-1
    80002bf2:	bfe1                	j	80002bca <writei+0xe0>
    return -1;
    80002bf4:	557d                	li	a0,-1
    80002bf6:	bfd1                	j	80002bca <writei+0xe0>

0000000080002bf8 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002bf8:	1141                	addi	sp,sp,-16
    80002bfa:	e406                	sd	ra,8(sp)
    80002bfc:	e022                	sd	s0,0(sp)
    80002bfe:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c00:	4639                	li	a2,14
    80002c02:	e5afd0ef          	jal	8000025c <strncmp>
}
    80002c06:	60a2                	ld	ra,8(sp)
    80002c08:	6402                	ld	s0,0(sp)
    80002c0a:	0141                	addi	sp,sp,16
    80002c0c:	8082                	ret

0000000080002c0e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c0e:	7139                	addi	sp,sp,-64
    80002c10:	fc06                	sd	ra,56(sp)
    80002c12:	f822                	sd	s0,48(sp)
    80002c14:	f426                	sd	s1,40(sp)
    80002c16:	f04a                	sd	s2,32(sp)
    80002c18:	ec4e                	sd	s3,24(sp)
    80002c1a:	e852                	sd	s4,16(sp)
    80002c1c:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c1e:	04451703          	lh	a4,68(a0)
    80002c22:	4785                	li	a5,1
    80002c24:	00f71a63          	bne	a4,a5,80002c38 <dirlookup+0x2a>
    80002c28:	892a                	mv	s2,a0
    80002c2a:	89ae                	mv	s3,a1
    80002c2c:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c2e:	457c                	lw	a5,76(a0)
    80002c30:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c32:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c34:	e39d                	bnez	a5,80002c5a <dirlookup+0x4c>
    80002c36:	a095                	j	80002c9a <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80002c38:	00005517          	auipc	a0,0x5
    80002c3c:	96850513          	addi	a0,a0,-1688 # 800075a0 <etext+0x5a0>
    80002c40:	163020ef          	jal	800055a2 <panic>
      panic("dirlookup read");
    80002c44:	00005517          	auipc	a0,0x5
    80002c48:	97450513          	addi	a0,a0,-1676 # 800075b8 <etext+0x5b8>
    80002c4c:	157020ef          	jal	800055a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c50:	24c1                	addiw	s1,s1,16
    80002c52:	04c92783          	lw	a5,76(s2)
    80002c56:	04f4f163          	bgeu	s1,a5,80002c98 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c5a:	4741                	li	a4,16
    80002c5c:	86a6                	mv	a3,s1
    80002c5e:	fc040613          	addi	a2,s0,-64
    80002c62:	4581                	li	a1,0
    80002c64:	854a                	mv	a0,s2
    80002c66:	d89ff0ef          	jal	800029ee <readi>
    80002c6a:	47c1                	li	a5,16
    80002c6c:	fcf51ce3          	bne	a0,a5,80002c44 <dirlookup+0x36>
    if(de.inum == 0)
    80002c70:	fc045783          	lhu	a5,-64(s0)
    80002c74:	dff1                	beqz	a5,80002c50 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80002c76:	fc240593          	addi	a1,s0,-62
    80002c7a:	854e                	mv	a0,s3
    80002c7c:	f7dff0ef          	jal	80002bf8 <namecmp>
    80002c80:	f961                	bnez	a0,80002c50 <dirlookup+0x42>
      if(poff)
    80002c82:	000a0463          	beqz	s4,80002c8a <dirlookup+0x7c>
        *poff = off;
    80002c86:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80002c8a:	fc045583          	lhu	a1,-64(s0)
    80002c8e:	00092503          	lw	a0,0(s2)
    80002c92:	829ff0ef          	jal	800024ba <iget>
    80002c96:	a011                	j	80002c9a <dirlookup+0x8c>
  return 0;
    80002c98:	4501                	li	a0,0
}
    80002c9a:	70e2                	ld	ra,56(sp)
    80002c9c:	7442                	ld	s0,48(sp)
    80002c9e:	74a2                	ld	s1,40(sp)
    80002ca0:	7902                	ld	s2,32(sp)
    80002ca2:	69e2                	ld	s3,24(sp)
    80002ca4:	6a42                	ld	s4,16(sp)
    80002ca6:	6121                	addi	sp,sp,64
    80002ca8:	8082                	ret

0000000080002caa <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002caa:	711d                	addi	sp,sp,-96
    80002cac:	ec86                	sd	ra,88(sp)
    80002cae:	e8a2                	sd	s0,80(sp)
    80002cb0:	e4a6                	sd	s1,72(sp)
    80002cb2:	e0ca                	sd	s2,64(sp)
    80002cb4:	fc4e                	sd	s3,56(sp)
    80002cb6:	f852                	sd	s4,48(sp)
    80002cb8:	f456                	sd	s5,40(sp)
    80002cba:	f05a                	sd	s6,32(sp)
    80002cbc:	ec5e                	sd	s7,24(sp)
    80002cbe:	e862                	sd	s8,16(sp)
    80002cc0:	e466                	sd	s9,8(sp)
    80002cc2:	1080                	addi	s0,sp,96
    80002cc4:	84aa                	mv	s1,a0
    80002cc6:	8b2e                	mv	s6,a1
    80002cc8:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cca:	00054703          	lbu	a4,0(a0)
    80002cce:	02f00793          	li	a5,47
    80002cd2:	00f70e63          	beq	a4,a5,80002cee <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002cd6:	8d2fe0ef          	jal	80000da8 <myproc>
    80002cda:	15053503          	ld	a0,336(a0)
    80002cde:	a87ff0ef          	jal	80002764 <idup>
    80002ce2:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002ce4:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002ce8:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002cea:	4b85                	li	s7,1
    80002cec:	a871                	j	80002d88 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80002cee:	4585                	li	a1,1
    80002cf0:	4505                	li	a0,1
    80002cf2:	fc8ff0ef          	jal	800024ba <iget>
    80002cf6:	8a2a                	mv	s4,a0
    80002cf8:	b7f5                	j	80002ce4 <namex+0x3a>
      iunlockput(ip);
    80002cfa:	8552                	mv	a0,s4
    80002cfc:	ca9ff0ef          	jal	800029a4 <iunlockput>
      return 0;
    80002d00:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d02:	8552                	mv	a0,s4
    80002d04:	60e6                	ld	ra,88(sp)
    80002d06:	6446                	ld	s0,80(sp)
    80002d08:	64a6                	ld	s1,72(sp)
    80002d0a:	6906                	ld	s2,64(sp)
    80002d0c:	79e2                	ld	s3,56(sp)
    80002d0e:	7a42                	ld	s4,48(sp)
    80002d10:	7aa2                	ld	s5,40(sp)
    80002d12:	7b02                	ld	s6,32(sp)
    80002d14:	6be2                	ld	s7,24(sp)
    80002d16:	6c42                	ld	s8,16(sp)
    80002d18:	6ca2                	ld	s9,8(sp)
    80002d1a:	6125                	addi	sp,sp,96
    80002d1c:	8082                	ret
      iunlock(ip);
    80002d1e:	8552                	mv	a0,s4
    80002d20:	b29ff0ef          	jal	80002848 <iunlock>
      return ip;
    80002d24:	bff9                	j	80002d02 <namex+0x58>
      iunlockput(ip);
    80002d26:	8552                	mv	a0,s4
    80002d28:	c7dff0ef          	jal	800029a4 <iunlockput>
      return 0;
    80002d2c:	8a4e                	mv	s4,s3
    80002d2e:	bfd1                	j	80002d02 <namex+0x58>
  len = path - s;
    80002d30:	40998633          	sub	a2,s3,s1
    80002d34:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80002d38:	099c5063          	bge	s8,s9,80002db8 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80002d3c:	4639                	li	a2,14
    80002d3e:	85a6                	mv	a1,s1
    80002d40:	8556                	mv	a0,s5
    80002d42:	caafd0ef          	jal	800001ec <memmove>
    80002d46:	84ce                	mv	s1,s3
  while(*path == '/')
    80002d48:	0004c783          	lbu	a5,0(s1)
    80002d4c:	01279763          	bne	a5,s2,80002d5a <namex+0xb0>
    path++;
    80002d50:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d52:	0004c783          	lbu	a5,0(s1)
    80002d56:	ff278de3          	beq	a5,s2,80002d50 <namex+0xa6>
    ilock(ip);
    80002d5a:	8552                	mv	a0,s4
    80002d5c:	a3fff0ef          	jal	8000279a <ilock>
    if(ip->type != T_DIR){
    80002d60:	044a1783          	lh	a5,68(s4)
    80002d64:	f9779be3          	bne	a5,s7,80002cfa <namex+0x50>
    if(nameiparent && *path == '\0'){
    80002d68:	000b0563          	beqz	s6,80002d72 <namex+0xc8>
    80002d6c:	0004c783          	lbu	a5,0(s1)
    80002d70:	d7dd                	beqz	a5,80002d1e <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d72:	4601                	li	a2,0
    80002d74:	85d6                	mv	a1,s5
    80002d76:	8552                	mv	a0,s4
    80002d78:	e97ff0ef          	jal	80002c0e <dirlookup>
    80002d7c:	89aa                	mv	s3,a0
    80002d7e:	d545                	beqz	a0,80002d26 <namex+0x7c>
    iunlockput(ip);
    80002d80:	8552                	mv	a0,s4
    80002d82:	c23ff0ef          	jal	800029a4 <iunlockput>
    ip = next;
    80002d86:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d88:	0004c783          	lbu	a5,0(s1)
    80002d8c:	01279763          	bne	a5,s2,80002d9a <namex+0xf0>
    path++;
    80002d90:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d92:	0004c783          	lbu	a5,0(s1)
    80002d96:	ff278de3          	beq	a5,s2,80002d90 <namex+0xe6>
  if(*path == 0)
    80002d9a:	cb8d                	beqz	a5,80002dcc <namex+0x122>
  while(*path != '/' && *path != 0)
    80002d9c:	0004c783          	lbu	a5,0(s1)
    80002da0:	89a6                	mv	s3,s1
  len = path - s;
    80002da2:	4c81                	li	s9,0
    80002da4:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002da6:	01278963          	beq	a5,s2,80002db8 <namex+0x10e>
    80002daa:	d3d9                	beqz	a5,80002d30 <namex+0x86>
    path++;
    80002dac:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002dae:	0009c783          	lbu	a5,0(s3)
    80002db2:	ff279ce3          	bne	a5,s2,80002daa <namex+0x100>
    80002db6:	bfad                	j	80002d30 <namex+0x86>
    memmove(name, s, len);
    80002db8:	2601                	sext.w	a2,a2
    80002dba:	85a6                	mv	a1,s1
    80002dbc:	8556                	mv	a0,s5
    80002dbe:	c2efd0ef          	jal	800001ec <memmove>
    name[len] = 0;
    80002dc2:	9cd6                	add	s9,s9,s5
    80002dc4:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80002dc8:	84ce                	mv	s1,s3
    80002dca:	bfbd                	j	80002d48 <namex+0x9e>
  if(nameiparent){
    80002dcc:	f20b0be3          	beqz	s6,80002d02 <namex+0x58>
    iput(ip);
    80002dd0:	8552                	mv	a0,s4
    80002dd2:	b4bff0ef          	jal	8000291c <iput>
    return 0;
    80002dd6:	4a01                	li	s4,0
    80002dd8:	b72d                	j	80002d02 <namex+0x58>

0000000080002dda <dirlink>:
{
    80002dda:	7139                	addi	sp,sp,-64
    80002ddc:	fc06                	sd	ra,56(sp)
    80002dde:	f822                	sd	s0,48(sp)
    80002de0:	f04a                	sd	s2,32(sp)
    80002de2:	ec4e                	sd	s3,24(sp)
    80002de4:	e852                	sd	s4,16(sp)
    80002de6:	0080                	addi	s0,sp,64
    80002de8:	892a                	mv	s2,a0
    80002dea:	8a2e                	mv	s4,a1
    80002dec:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002dee:	4601                	li	a2,0
    80002df0:	e1fff0ef          	jal	80002c0e <dirlookup>
    80002df4:	e535                	bnez	a0,80002e60 <dirlink+0x86>
    80002df6:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002df8:	04c92483          	lw	s1,76(s2)
    80002dfc:	c48d                	beqz	s1,80002e26 <dirlink+0x4c>
    80002dfe:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e00:	4741                	li	a4,16
    80002e02:	86a6                	mv	a3,s1
    80002e04:	fc040613          	addi	a2,s0,-64
    80002e08:	4581                	li	a1,0
    80002e0a:	854a                	mv	a0,s2
    80002e0c:	be3ff0ef          	jal	800029ee <readi>
    80002e10:	47c1                	li	a5,16
    80002e12:	04f51b63          	bne	a0,a5,80002e68 <dirlink+0x8e>
    if(de.inum == 0)
    80002e16:	fc045783          	lhu	a5,-64(s0)
    80002e1a:	c791                	beqz	a5,80002e26 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e1c:	24c1                	addiw	s1,s1,16
    80002e1e:	04c92783          	lw	a5,76(s2)
    80002e22:	fcf4efe3          	bltu	s1,a5,80002e00 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80002e26:	4639                	li	a2,14
    80002e28:	85d2                	mv	a1,s4
    80002e2a:	fc240513          	addi	a0,s0,-62
    80002e2e:	c64fd0ef          	jal	80000292 <strncpy>
  de.inum = inum;
    80002e32:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e36:	4741                	li	a4,16
    80002e38:	86a6                	mv	a3,s1
    80002e3a:	fc040613          	addi	a2,s0,-64
    80002e3e:	4581                	li	a1,0
    80002e40:	854a                	mv	a0,s2
    80002e42:	ca9ff0ef          	jal	80002aea <writei>
    80002e46:	1541                	addi	a0,a0,-16
    80002e48:	00a03533          	snez	a0,a0
    80002e4c:	40a00533          	neg	a0,a0
    80002e50:	74a2                	ld	s1,40(sp)
}
    80002e52:	70e2                	ld	ra,56(sp)
    80002e54:	7442                	ld	s0,48(sp)
    80002e56:	7902                	ld	s2,32(sp)
    80002e58:	69e2                	ld	s3,24(sp)
    80002e5a:	6a42                	ld	s4,16(sp)
    80002e5c:	6121                	addi	sp,sp,64
    80002e5e:	8082                	ret
    iput(ip);
    80002e60:	abdff0ef          	jal	8000291c <iput>
    return -1;
    80002e64:	557d                	li	a0,-1
    80002e66:	b7f5                	j	80002e52 <dirlink+0x78>
      panic("dirlink read");
    80002e68:	00004517          	auipc	a0,0x4
    80002e6c:	76050513          	addi	a0,a0,1888 # 800075c8 <etext+0x5c8>
    80002e70:	732020ef          	jal	800055a2 <panic>

0000000080002e74 <namei>:

struct inode*
namei(char *path)
{
    80002e74:	1101                	addi	sp,sp,-32
    80002e76:	ec06                	sd	ra,24(sp)
    80002e78:	e822                	sd	s0,16(sp)
    80002e7a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e7c:	fe040613          	addi	a2,s0,-32
    80002e80:	4581                	li	a1,0
    80002e82:	e29ff0ef          	jal	80002caa <namex>
}
    80002e86:	60e2                	ld	ra,24(sp)
    80002e88:	6442                	ld	s0,16(sp)
    80002e8a:	6105                	addi	sp,sp,32
    80002e8c:	8082                	ret

0000000080002e8e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e8e:	1141                	addi	sp,sp,-16
    80002e90:	e406                	sd	ra,8(sp)
    80002e92:	e022                	sd	s0,0(sp)
    80002e94:	0800                	addi	s0,sp,16
    80002e96:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e98:	4585                	li	a1,1
    80002e9a:	e11ff0ef          	jal	80002caa <namex>
}
    80002e9e:	60a2                	ld	ra,8(sp)
    80002ea0:	6402                	ld	s0,0(sp)
    80002ea2:	0141                	addi	sp,sp,16
    80002ea4:	8082                	ret

0000000080002ea6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ea6:	1101                	addi	sp,sp,-32
    80002ea8:	ec06                	sd	ra,24(sp)
    80002eaa:	e822                	sd	s0,16(sp)
    80002eac:	e426                	sd	s1,8(sp)
    80002eae:	e04a                	sd	s2,0(sp)
    80002eb0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002eb2:	00015917          	auipc	s2,0x15
    80002eb6:	bfe90913          	addi	s2,s2,-1026 # 80017ab0 <log>
    80002eba:	01892583          	lw	a1,24(s2)
    80002ebe:	02892503          	lw	a0,40(s2)
    80002ec2:	9a0ff0ef          	jal	80002062 <bread>
    80002ec6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002ec8:	02c92603          	lw	a2,44(s2)
    80002ecc:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002ece:	00c05f63          	blez	a2,80002eec <write_head+0x46>
    80002ed2:	00015717          	auipc	a4,0x15
    80002ed6:	c0e70713          	addi	a4,a4,-1010 # 80017ae0 <log+0x30>
    80002eda:	87aa                	mv	a5,a0
    80002edc:	060a                	slli	a2,a2,0x2
    80002ede:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ee0:	4314                	lw	a3,0(a4)
    80002ee2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ee4:	0711                	addi	a4,a4,4
    80002ee6:	0791                	addi	a5,a5,4
    80002ee8:	fec79ce3          	bne	a5,a2,80002ee0 <write_head+0x3a>
  }
  bwrite(buf);
    80002eec:	8526                	mv	a0,s1
    80002eee:	a4aff0ef          	jal	80002138 <bwrite>
  brelse(buf);
    80002ef2:	8526                	mv	a0,s1
    80002ef4:	a76ff0ef          	jal	8000216a <brelse>
}
    80002ef8:	60e2                	ld	ra,24(sp)
    80002efa:	6442                	ld	s0,16(sp)
    80002efc:	64a2                	ld	s1,8(sp)
    80002efe:	6902                	ld	s2,0(sp)
    80002f00:	6105                	addi	sp,sp,32
    80002f02:	8082                	ret

0000000080002f04 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f04:	00015797          	auipc	a5,0x15
    80002f08:	bd87a783          	lw	a5,-1064(a5) # 80017adc <log+0x2c>
    80002f0c:	08f05f63          	blez	a5,80002faa <install_trans+0xa6>
{
    80002f10:	7139                	addi	sp,sp,-64
    80002f12:	fc06                	sd	ra,56(sp)
    80002f14:	f822                	sd	s0,48(sp)
    80002f16:	f426                	sd	s1,40(sp)
    80002f18:	f04a                	sd	s2,32(sp)
    80002f1a:	ec4e                	sd	s3,24(sp)
    80002f1c:	e852                	sd	s4,16(sp)
    80002f1e:	e456                	sd	s5,8(sp)
    80002f20:	e05a                	sd	s6,0(sp)
    80002f22:	0080                	addi	s0,sp,64
    80002f24:	8b2a                	mv	s6,a0
    80002f26:	00015a97          	auipc	s5,0x15
    80002f2a:	bbaa8a93          	addi	s5,s5,-1094 # 80017ae0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f2e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f30:	00015997          	auipc	s3,0x15
    80002f34:	b8098993          	addi	s3,s3,-1152 # 80017ab0 <log>
    80002f38:	a829                	j	80002f52 <install_trans+0x4e>
    brelse(lbuf);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	a2eff0ef          	jal	8000216a <brelse>
    brelse(dbuf);
    80002f40:	8526                	mv	a0,s1
    80002f42:	a28ff0ef          	jal	8000216a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f46:	2a05                	addiw	s4,s4,1
    80002f48:	0a91                	addi	s5,s5,4
    80002f4a:	02c9a783          	lw	a5,44(s3)
    80002f4e:	04fa5463          	bge	s4,a5,80002f96 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f52:	0189a583          	lw	a1,24(s3)
    80002f56:	014585bb          	addw	a1,a1,s4
    80002f5a:	2585                	addiw	a1,a1,1
    80002f5c:	0289a503          	lw	a0,40(s3)
    80002f60:	902ff0ef          	jal	80002062 <bread>
    80002f64:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f66:	000aa583          	lw	a1,0(s5)
    80002f6a:	0289a503          	lw	a0,40(s3)
    80002f6e:	8f4ff0ef          	jal	80002062 <bread>
    80002f72:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f74:	40000613          	li	a2,1024
    80002f78:	05890593          	addi	a1,s2,88
    80002f7c:	05850513          	addi	a0,a0,88
    80002f80:	a6cfd0ef          	jal	800001ec <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f84:	8526                	mv	a0,s1
    80002f86:	9b2ff0ef          	jal	80002138 <bwrite>
    if(recovering == 0)
    80002f8a:	fa0b18e3          	bnez	s6,80002f3a <install_trans+0x36>
      bunpin(dbuf);
    80002f8e:	8526                	mv	a0,s1
    80002f90:	a96ff0ef          	jal	80002226 <bunpin>
    80002f94:	b75d                	j	80002f3a <install_trans+0x36>
}
    80002f96:	70e2                	ld	ra,56(sp)
    80002f98:	7442                	ld	s0,48(sp)
    80002f9a:	74a2                	ld	s1,40(sp)
    80002f9c:	7902                	ld	s2,32(sp)
    80002f9e:	69e2                	ld	s3,24(sp)
    80002fa0:	6a42                	ld	s4,16(sp)
    80002fa2:	6aa2                	ld	s5,8(sp)
    80002fa4:	6b02                	ld	s6,0(sp)
    80002fa6:	6121                	addi	sp,sp,64
    80002fa8:	8082                	ret
    80002faa:	8082                	ret

0000000080002fac <initlog>:
{
    80002fac:	7179                	addi	sp,sp,-48
    80002fae:	f406                	sd	ra,40(sp)
    80002fb0:	f022                	sd	s0,32(sp)
    80002fb2:	ec26                	sd	s1,24(sp)
    80002fb4:	e84a                	sd	s2,16(sp)
    80002fb6:	e44e                	sd	s3,8(sp)
    80002fb8:	1800                	addi	s0,sp,48
    80002fba:	892a                	mv	s2,a0
    80002fbc:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002fbe:	00015497          	auipc	s1,0x15
    80002fc2:	af248493          	addi	s1,s1,-1294 # 80017ab0 <log>
    80002fc6:	00004597          	auipc	a1,0x4
    80002fca:	61258593          	addi	a1,a1,1554 # 800075d8 <etext+0x5d8>
    80002fce:	8526                	mv	a0,s1
    80002fd0:	081020ef          	jal	80005850 <initlock>
  log.start = sb->logstart;
    80002fd4:	0149a583          	lw	a1,20(s3)
    80002fd8:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002fda:	0109a783          	lw	a5,16(s3)
    80002fde:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fe0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fe4:	854a                	mv	a0,s2
    80002fe6:	87cff0ef          	jal	80002062 <bread>
  log.lh.n = lh->n;
    80002fea:	4d30                	lw	a2,88(a0)
    80002fec:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fee:	00c05f63          	blez	a2,8000300c <initlog+0x60>
    80002ff2:	87aa                	mv	a5,a0
    80002ff4:	00015717          	auipc	a4,0x15
    80002ff8:	aec70713          	addi	a4,a4,-1300 # 80017ae0 <log+0x30>
    80002ffc:	060a                	slli	a2,a2,0x2
    80002ffe:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003000:	4ff4                	lw	a3,92(a5)
    80003002:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003004:	0791                	addi	a5,a5,4
    80003006:	0711                	addi	a4,a4,4
    80003008:	fec79ce3          	bne	a5,a2,80003000 <initlog+0x54>
  brelse(buf);
    8000300c:	95eff0ef          	jal	8000216a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003010:	4505                	li	a0,1
    80003012:	ef3ff0ef          	jal	80002f04 <install_trans>
  log.lh.n = 0;
    80003016:	00015797          	auipc	a5,0x15
    8000301a:	ac07a323          	sw	zero,-1338(a5) # 80017adc <log+0x2c>
  write_head(); // clear the log
    8000301e:	e89ff0ef          	jal	80002ea6 <write_head>
}
    80003022:	70a2                	ld	ra,40(sp)
    80003024:	7402                	ld	s0,32(sp)
    80003026:	64e2                	ld	s1,24(sp)
    80003028:	6942                	ld	s2,16(sp)
    8000302a:	69a2                	ld	s3,8(sp)
    8000302c:	6145                	addi	sp,sp,48
    8000302e:	8082                	ret

0000000080003030 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003030:	1101                	addi	sp,sp,-32
    80003032:	ec06                	sd	ra,24(sp)
    80003034:	e822                	sd	s0,16(sp)
    80003036:	e426                	sd	s1,8(sp)
    80003038:	e04a                	sd	s2,0(sp)
    8000303a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000303c:	00015517          	auipc	a0,0x15
    80003040:	a7450513          	addi	a0,a0,-1420 # 80017ab0 <log>
    80003044:	08d020ef          	jal	800058d0 <acquire>
  while(1){
    if(log.committing){
    80003048:	00015497          	auipc	s1,0x15
    8000304c:	a6848493          	addi	s1,s1,-1432 # 80017ab0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003050:	4979                	li	s2,30
    80003052:	a029                	j	8000305c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003054:	85a6                	mv	a1,s1
    80003056:	8526                	mv	a0,s1
    80003058:	b26fe0ef          	jal	8000137e <sleep>
    if(log.committing){
    8000305c:	50dc                	lw	a5,36(s1)
    8000305e:	fbfd                	bnez	a5,80003054 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003060:	5098                	lw	a4,32(s1)
    80003062:	2705                	addiw	a4,a4,1
    80003064:	0027179b          	slliw	a5,a4,0x2
    80003068:	9fb9                	addw	a5,a5,a4
    8000306a:	0017979b          	slliw	a5,a5,0x1
    8000306e:	54d4                	lw	a3,44(s1)
    80003070:	9fb5                	addw	a5,a5,a3
    80003072:	00f95763          	bge	s2,a5,80003080 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003076:	85a6                	mv	a1,s1
    80003078:	8526                	mv	a0,s1
    8000307a:	b04fe0ef          	jal	8000137e <sleep>
    8000307e:	bff9                	j	8000305c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003080:	00015517          	auipc	a0,0x15
    80003084:	a3050513          	addi	a0,a0,-1488 # 80017ab0 <log>
    80003088:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000308a:	0df020ef          	jal	80005968 <release>
      break;
    }
  }
}
    8000308e:	60e2                	ld	ra,24(sp)
    80003090:	6442                	ld	s0,16(sp)
    80003092:	64a2                	ld	s1,8(sp)
    80003094:	6902                	ld	s2,0(sp)
    80003096:	6105                	addi	sp,sp,32
    80003098:	8082                	ret

000000008000309a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000309a:	7139                	addi	sp,sp,-64
    8000309c:	fc06                	sd	ra,56(sp)
    8000309e:	f822                	sd	s0,48(sp)
    800030a0:	f426                	sd	s1,40(sp)
    800030a2:	f04a                	sd	s2,32(sp)
    800030a4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030a6:	00015497          	auipc	s1,0x15
    800030aa:	a0a48493          	addi	s1,s1,-1526 # 80017ab0 <log>
    800030ae:	8526                	mv	a0,s1
    800030b0:	021020ef          	jal	800058d0 <acquire>
  log.outstanding -= 1;
    800030b4:	509c                	lw	a5,32(s1)
    800030b6:	37fd                	addiw	a5,a5,-1
    800030b8:	0007891b          	sext.w	s2,a5
    800030bc:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800030be:	50dc                	lw	a5,36(s1)
    800030c0:	ef9d                	bnez	a5,800030fe <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800030c2:	04091763          	bnez	s2,80003110 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800030c6:	00015497          	auipc	s1,0x15
    800030ca:	9ea48493          	addi	s1,s1,-1558 # 80017ab0 <log>
    800030ce:	4785                	li	a5,1
    800030d0:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800030d2:	8526                	mv	a0,s1
    800030d4:	095020ef          	jal	80005968 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800030d8:	54dc                	lw	a5,44(s1)
    800030da:	04f04b63          	bgtz	a5,80003130 <end_op+0x96>
    acquire(&log.lock);
    800030de:	00015497          	auipc	s1,0x15
    800030e2:	9d248493          	addi	s1,s1,-1582 # 80017ab0 <log>
    800030e6:	8526                	mv	a0,s1
    800030e8:	7e8020ef          	jal	800058d0 <acquire>
    log.committing = 0;
    800030ec:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030f0:	8526                	mv	a0,s1
    800030f2:	ad8fe0ef          	jal	800013ca <wakeup>
    release(&log.lock);
    800030f6:	8526                	mv	a0,s1
    800030f8:	071020ef          	jal	80005968 <release>
}
    800030fc:	a025                	j	80003124 <end_op+0x8a>
    800030fe:	ec4e                	sd	s3,24(sp)
    80003100:	e852                	sd	s4,16(sp)
    80003102:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003104:	00004517          	auipc	a0,0x4
    80003108:	4dc50513          	addi	a0,a0,1244 # 800075e0 <etext+0x5e0>
    8000310c:	496020ef          	jal	800055a2 <panic>
    wakeup(&log);
    80003110:	00015497          	auipc	s1,0x15
    80003114:	9a048493          	addi	s1,s1,-1632 # 80017ab0 <log>
    80003118:	8526                	mv	a0,s1
    8000311a:	ab0fe0ef          	jal	800013ca <wakeup>
  release(&log.lock);
    8000311e:	8526                	mv	a0,s1
    80003120:	049020ef          	jal	80005968 <release>
}
    80003124:	70e2                	ld	ra,56(sp)
    80003126:	7442                	ld	s0,48(sp)
    80003128:	74a2                	ld	s1,40(sp)
    8000312a:	7902                	ld	s2,32(sp)
    8000312c:	6121                	addi	sp,sp,64
    8000312e:	8082                	ret
    80003130:	ec4e                	sd	s3,24(sp)
    80003132:	e852                	sd	s4,16(sp)
    80003134:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003136:	00015a97          	auipc	s5,0x15
    8000313a:	9aaa8a93          	addi	s5,s5,-1622 # 80017ae0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000313e:	00015a17          	auipc	s4,0x15
    80003142:	972a0a13          	addi	s4,s4,-1678 # 80017ab0 <log>
    80003146:	018a2583          	lw	a1,24(s4)
    8000314a:	012585bb          	addw	a1,a1,s2
    8000314e:	2585                	addiw	a1,a1,1
    80003150:	028a2503          	lw	a0,40(s4)
    80003154:	f0ffe0ef          	jal	80002062 <bread>
    80003158:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000315a:	000aa583          	lw	a1,0(s5)
    8000315e:	028a2503          	lw	a0,40(s4)
    80003162:	f01fe0ef          	jal	80002062 <bread>
    80003166:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003168:	40000613          	li	a2,1024
    8000316c:	05850593          	addi	a1,a0,88
    80003170:	05848513          	addi	a0,s1,88
    80003174:	878fd0ef          	jal	800001ec <memmove>
    bwrite(to);  // write the log
    80003178:	8526                	mv	a0,s1
    8000317a:	fbffe0ef          	jal	80002138 <bwrite>
    brelse(from);
    8000317e:	854e                	mv	a0,s3
    80003180:	febfe0ef          	jal	8000216a <brelse>
    brelse(to);
    80003184:	8526                	mv	a0,s1
    80003186:	fe5fe0ef          	jal	8000216a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000318a:	2905                	addiw	s2,s2,1
    8000318c:	0a91                	addi	s5,s5,4
    8000318e:	02ca2783          	lw	a5,44(s4)
    80003192:	faf94ae3          	blt	s2,a5,80003146 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003196:	d11ff0ef          	jal	80002ea6 <write_head>
    install_trans(0); // Now install writes to home locations
    8000319a:	4501                	li	a0,0
    8000319c:	d69ff0ef          	jal	80002f04 <install_trans>
    log.lh.n = 0;
    800031a0:	00015797          	auipc	a5,0x15
    800031a4:	9207ae23          	sw	zero,-1732(a5) # 80017adc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800031a8:	cffff0ef          	jal	80002ea6 <write_head>
    800031ac:	69e2                	ld	s3,24(sp)
    800031ae:	6a42                	ld	s4,16(sp)
    800031b0:	6aa2                	ld	s5,8(sp)
    800031b2:	b735                	j	800030de <end_op+0x44>

00000000800031b4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800031b4:	1101                	addi	sp,sp,-32
    800031b6:	ec06                	sd	ra,24(sp)
    800031b8:	e822                	sd	s0,16(sp)
    800031ba:	e426                	sd	s1,8(sp)
    800031bc:	e04a                	sd	s2,0(sp)
    800031be:	1000                	addi	s0,sp,32
    800031c0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800031c2:	00015917          	auipc	s2,0x15
    800031c6:	8ee90913          	addi	s2,s2,-1810 # 80017ab0 <log>
    800031ca:	854a                	mv	a0,s2
    800031cc:	704020ef          	jal	800058d0 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800031d0:	02c92603          	lw	a2,44(s2)
    800031d4:	47f5                	li	a5,29
    800031d6:	06c7c363          	blt	a5,a2,8000323c <log_write+0x88>
    800031da:	00015797          	auipc	a5,0x15
    800031de:	8f27a783          	lw	a5,-1806(a5) # 80017acc <log+0x1c>
    800031e2:	37fd                	addiw	a5,a5,-1
    800031e4:	04f65c63          	bge	a2,a5,8000323c <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031e8:	00015797          	auipc	a5,0x15
    800031ec:	8e87a783          	lw	a5,-1816(a5) # 80017ad0 <log+0x20>
    800031f0:	04f05c63          	blez	a5,80003248 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031f4:	4781                	li	a5,0
    800031f6:	04c05f63          	blez	a2,80003254 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031fa:	44cc                	lw	a1,12(s1)
    800031fc:	00015717          	auipc	a4,0x15
    80003200:	8e470713          	addi	a4,a4,-1820 # 80017ae0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003204:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003206:	4314                	lw	a3,0(a4)
    80003208:	04b68663          	beq	a3,a1,80003254 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000320c:	2785                	addiw	a5,a5,1
    8000320e:	0711                	addi	a4,a4,4
    80003210:	fef61be3          	bne	a2,a5,80003206 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003214:	0621                	addi	a2,a2,8
    80003216:	060a                	slli	a2,a2,0x2
    80003218:	00015797          	auipc	a5,0x15
    8000321c:	89878793          	addi	a5,a5,-1896 # 80017ab0 <log>
    80003220:	97b2                	add	a5,a5,a2
    80003222:	44d8                	lw	a4,12(s1)
    80003224:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003226:	8526                	mv	a0,s1
    80003228:	fcbfe0ef          	jal	800021f2 <bpin>
    log.lh.n++;
    8000322c:	00015717          	auipc	a4,0x15
    80003230:	88470713          	addi	a4,a4,-1916 # 80017ab0 <log>
    80003234:	575c                	lw	a5,44(a4)
    80003236:	2785                	addiw	a5,a5,1
    80003238:	d75c                	sw	a5,44(a4)
    8000323a:	a80d                	j	8000326c <log_write+0xb8>
    panic("too big a transaction");
    8000323c:	00004517          	auipc	a0,0x4
    80003240:	3b450513          	addi	a0,a0,948 # 800075f0 <etext+0x5f0>
    80003244:	35e020ef          	jal	800055a2 <panic>
    panic("log_write outside of trans");
    80003248:	00004517          	auipc	a0,0x4
    8000324c:	3c050513          	addi	a0,a0,960 # 80007608 <etext+0x608>
    80003250:	352020ef          	jal	800055a2 <panic>
  log.lh.block[i] = b->blockno;
    80003254:	00878693          	addi	a3,a5,8
    80003258:	068a                	slli	a3,a3,0x2
    8000325a:	00015717          	auipc	a4,0x15
    8000325e:	85670713          	addi	a4,a4,-1962 # 80017ab0 <log>
    80003262:	9736                	add	a4,a4,a3
    80003264:	44d4                	lw	a3,12(s1)
    80003266:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003268:	faf60fe3          	beq	a2,a5,80003226 <log_write+0x72>
  }
  release(&log.lock);
    8000326c:	00015517          	auipc	a0,0x15
    80003270:	84450513          	addi	a0,a0,-1980 # 80017ab0 <log>
    80003274:	6f4020ef          	jal	80005968 <release>
}
    80003278:	60e2                	ld	ra,24(sp)
    8000327a:	6442                	ld	s0,16(sp)
    8000327c:	64a2                	ld	s1,8(sp)
    8000327e:	6902                	ld	s2,0(sp)
    80003280:	6105                	addi	sp,sp,32
    80003282:	8082                	ret

0000000080003284 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003284:	1101                	addi	sp,sp,-32
    80003286:	ec06                	sd	ra,24(sp)
    80003288:	e822                	sd	s0,16(sp)
    8000328a:	e426                	sd	s1,8(sp)
    8000328c:	e04a                	sd	s2,0(sp)
    8000328e:	1000                	addi	s0,sp,32
    80003290:	84aa                	mv	s1,a0
    80003292:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003294:	00004597          	auipc	a1,0x4
    80003298:	39458593          	addi	a1,a1,916 # 80007628 <etext+0x628>
    8000329c:	0521                	addi	a0,a0,8
    8000329e:	5b2020ef          	jal	80005850 <initlock>
  lk->name = name;
    800032a2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032a6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032aa:	0204a423          	sw	zero,40(s1)
}
    800032ae:	60e2                	ld	ra,24(sp)
    800032b0:	6442                	ld	s0,16(sp)
    800032b2:	64a2                	ld	s1,8(sp)
    800032b4:	6902                	ld	s2,0(sp)
    800032b6:	6105                	addi	sp,sp,32
    800032b8:	8082                	ret

00000000800032ba <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032ba:	1101                	addi	sp,sp,-32
    800032bc:	ec06                	sd	ra,24(sp)
    800032be:	e822                	sd	s0,16(sp)
    800032c0:	e426                	sd	s1,8(sp)
    800032c2:	e04a                	sd	s2,0(sp)
    800032c4:	1000                	addi	s0,sp,32
    800032c6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032c8:	00850913          	addi	s2,a0,8
    800032cc:	854a                	mv	a0,s2
    800032ce:	602020ef          	jal	800058d0 <acquire>
  while (lk->locked) {
    800032d2:	409c                	lw	a5,0(s1)
    800032d4:	c799                	beqz	a5,800032e2 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800032d6:	85ca                	mv	a1,s2
    800032d8:	8526                	mv	a0,s1
    800032da:	8a4fe0ef          	jal	8000137e <sleep>
  while (lk->locked) {
    800032de:	409c                	lw	a5,0(s1)
    800032e0:	fbfd                	bnez	a5,800032d6 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032e2:	4785                	li	a5,1
    800032e4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032e6:	ac3fd0ef          	jal	80000da8 <myproc>
    800032ea:	591c                	lw	a5,48(a0)
    800032ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032ee:	854a                	mv	a0,s2
    800032f0:	678020ef          	jal	80005968 <release>
}
    800032f4:	60e2                	ld	ra,24(sp)
    800032f6:	6442                	ld	s0,16(sp)
    800032f8:	64a2                	ld	s1,8(sp)
    800032fa:	6902                	ld	s2,0(sp)
    800032fc:	6105                	addi	sp,sp,32
    800032fe:	8082                	ret

0000000080003300 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003300:	1101                	addi	sp,sp,-32
    80003302:	ec06                	sd	ra,24(sp)
    80003304:	e822                	sd	s0,16(sp)
    80003306:	e426                	sd	s1,8(sp)
    80003308:	e04a                	sd	s2,0(sp)
    8000330a:	1000                	addi	s0,sp,32
    8000330c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000330e:	00850913          	addi	s2,a0,8
    80003312:	854a                	mv	a0,s2
    80003314:	5bc020ef          	jal	800058d0 <acquire>
  lk->locked = 0;
    80003318:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000331c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003320:	8526                	mv	a0,s1
    80003322:	8a8fe0ef          	jal	800013ca <wakeup>
  release(&lk->lk);
    80003326:	854a                	mv	a0,s2
    80003328:	640020ef          	jal	80005968 <release>
}
    8000332c:	60e2                	ld	ra,24(sp)
    8000332e:	6442                	ld	s0,16(sp)
    80003330:	64a2                	ld	s1,8(sp)
    80003332:	6902                	ld	s2,0(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret

0000000080003338 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003338:	7179                	addi	sp,sp,-48
    8000333a:	f406                	sd	ra,40(sp)
    8000333c:	f022                	sd	s0,32(sp)
    8000333e:	ec26                	sd	s1,24(sp)
    80003340:	e84a                	sd	s2,16(sp)
    80003342:	1800                	addi	s0,sp,48
    80003344:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003346:	00850913          	addi	s2,a0,8
    8000334a:	854a                	mv	a0,s2
    8000334c:	584020ef          	jal	800058d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003350:	409c                	lw	a5,0(s1)
    80003352:	ef81                	bnez	a5,8000336a <holdingsleep+0x32>
    80003354:	4481                	li	s1,0
  release(&lk->lk);
    80003356:	854a                	mv	a0,s2
    80003358:	610020ef          	jal	80005968 <release>
  return r;
}
    8000335c:	8526                	mv	a0,s1
    8000335e:	70a2                	ld	ra,40(sp)
    80003360:	7402                	ld	s0,32(sp)
    80003362:	64e2                	ld	s1,24(sp)
    80003364:	6942                	ld	s2,16(sp)
    80003366:	6145                	addi	sp,sp,48
    80003368:	8082                	ret
    8000336a:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000336c:	0284a983          	lw	s3,40(s1)
    80003370:	a39fd0ef          	jal	80000da8 <myproc>
    80003374:	5904                	lw	s1,48(a0)
    80003376:	413484b3          	sub	s1,s1,s3
    8000337a:	0014b493          	seqz	s1,s1
    8000337e:	69a2                	ld	s3,8(sp)
    80003380:	bfd9                	j	80003356 <holdingsleep+0x1e>

0000000080003382 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003382:	1141                	addi	sp,sp,-16
    80003384:	e406                	sd	ra,8(sp)
    80003386:	e022                	sd	s0,0(sp)
    80003388:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000338a:	00004597          	auipc	a1,0x4
    8000338e:	2ae58593          	addi	a1,a1,686 # 80007638 <etext+0x638>
    80003392:	00015517          	auipc	a0,0x15
    80003396:	86650513          	addi	a0,a0,-1946 # 80017bf8 <ftable>
    8000339a:	4b6020ef          	jal	80005850 <initlock>
}
    8000339e:	60a2                	ld	ra,8(sp)
    800033a0:	6402                	ld	s0,0(sp)
    800033a2:	0141                	addi	sp,sp,16
    800033a4:	8082                	ret

00000000800033a6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033a6:	1101                	addi	sp,sp,-32
    800033a8:	ec06                	sd	ra,24(sp)
    800033aa:	e822                	sd	s0,16(sp)
    800033ac:	e426                	sd	s1,8(sp)
    800033ae:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033b0:	00015517          	auipc	a0,0x15
    800033b4:	84850513          	addi	a0,a0,-1976 # 80017bf8 <ftable>
    800033b8:	518020ef          	jal	800058d0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033bc:	00015497          	auipc	s1,0x15
    800033c0:	85448493          	addi	s1,s1,-1964 # 80017c10 <ftable+0x18>
    800033c4:	00015717          	auipc	a4,0x15
    800033c8:	7ec70713          	addi	a4,a4,2028 # 80018bb0 <disk>
    if(f->ref == 0){
    800033cc:	40dc                	lw	a5,4(s1)
    800033ce:	cf89                	beqz	a5,800033e8 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033d0:	02848493          	addi	s1,s1,40
    800033d4:	fee49ce3          	bne	s1,a4,800033cc <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800033d8:	00015517          	auipc	a0,0x15
    800033dc:	82050513          	addi	a0,a0,-2016 # 80017bf8 <ftable>
    800033e0:	588020ef          	jal	80005968 <release>
  return 0;
    800033e4:	4481                	li	s1,0
    800033e6:	a809                	j	800033f8 <filealloc+0x52>
      f->ref = 1;
    800033e8:	4785                	li	a5,1
    800033ea:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033ec:	00015517          	auipc	a0,0x15
    800033f0:	80c50513          	addi	a0,a0,-2036 # 80017bf8 <ftable>
    800033f4:	574020ef          	jal	80005968 <release>
}
    800033f8:	8526                	mv	a0,s1
    800033fa:	60e2                	ld	ra,24(sp)
    800033fc:	6442                	ld	s0,16(sp)
    800033fe:	64a2                	ld	s1,8(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret

0000000080003404 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003404:	1101                	addi	sp,sp,-32
    80003406:	ec06                	sd	ra,24(sp)
    80003408:	e822                	sd	s0,16(sp)
    8000340a:	e426                	sd	s1,8(sp)
    8000340c:	1000                	addi	s0,sp,32
    8000340e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003410:	00014517          	auipc	a0,0x14
    80003414:	7e850513          	addi	a0,a0,2024 # 80017bf8 <ftable>
    80003418:	4b8020ef          	jal	800058d0 <acquire>
  if(f->ref < 1)
    8000341c:	40dc                	lw	a5,4(s1)
    8000341e:	02f05063          	blez	a5,8000343e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003422:	2785                	addiw	a5,a5,1
    80003424:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003426:	00014517          	auipc	a0,0x14
    8000342a:	7d250513          	addi	a0,a0,2002 # 80017bf8 <ftable>
    8000342e:	53a020ef          	jal	80005968 <release>
  return f;
}
    80003432:	8526                	mv	a0,s1
    80003434:	60e2                	ld	ra,24(sp)
    80003436:	6442                	ld	s0,16(sp)
    80003438:	64a2                	ld	s1,8(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret
    panic("filedup");
    8000343e:	00004517          	auipc	a0,0x4
    80003442:	20250513          	addi	a0,a0,514 # 80007640 <etext+0x640>
    80003446:	15c020ef          	jal	800055a2 <panic>

000000008000344a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000344a:	7139                	addi	sp,sp,-64
    8000344c:	fc06                	sd	ra,56(sp)
    8000344e:	f822                	sd	s0,48(sp)
    80003450:	f426                	sd	s1,40(sp)
    80003452:	0080                	addi	s0,sp,64
    80003454:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003456:	00014517          	auipc	a0,0x14
    8000345a:	7a250513          	addi	a0,a0,1954 # 80017bf8 <ftable>
    8000345e:	472020ef          	jal	800058d0 <acquire>
  if(f->ref < 1)
    80003462:	40dc                	lw	a5,4(s1)
    80003464:	04f05a63          	blez	a5,800034b8 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003468:	37fd                	addiw	a5,a5,-1
    8000346a:	0007871b          	sext.w	a4,a5
    8000346e:	c0dc                	sw	a5,4(s1)
    80003470:	04e04e63          	bgtz	a4,800034cc <fileclose+0x82>
    80003474:	f04a                	sd	s2,32(sp)
    80003476:	ec4e                	sd	s3,24(sp)
    80003478:	e852                	sd	s4,16(sp)
    8000347a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000347c:	0004a903          	lw	s2,0(s1)
    80003480:	0094ca83          	lbu	s5,9(s1)
    80003484:	0104ba03          	ld	s4,16(s1)
    80003488:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000348c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003490:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003494:	00014517          	auipc	a0,0x14
    80003498:	76450513          	addi	a0,a0,1892 # 80017bf8 <ftable>
    8000349c:	4cc020ef          	jal	80005968 <release>

  if(ff.type == FD_PIPE){
    800034a0:	4785                	li	a5,1
    800034a2:	04f90063          	beq	s2,a5,800034e2 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034a6:	3979                	addiw	s2,s2,-2
    800034a8:	4785                	li	a5,1
    800034aa:	0527f563          	bgeu	a5,s2,800034f4 <fileclose+0xaa>
    800034ae:	7902                	ld	s2,32(sp)
    800034b0:	69e2                	ld	s3,24(sp)
    800034b2:	6a42                	ld	s4,16(sp)
    800034b4:	6aa2                	ld	s5,8(sp)
    800034b6:	a00d                	j	800034d8 <fileclose+0x8e>
    800034b8:	f04a                	sd	s2,32(sp)
    800034ba:	ec4e                	sd	s3,24(sp)
    800034bc:	e852                	sd	s4,16(sp)
    800034be:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800034c0:	00004517          	auipc	a0,0x4
    800034c4:	18850513          	addi	a0,a0,392 # 80007648 <etext+0x648>
    800034c8:	0da020ef          	jal	800055a2 <panic>
    release(&ftable.lock);
    800034cc:	00014517          	auipc	a0,0x14
    800034d0:	72c50513          	addi	a0,a0,1836 # 80017bf8 <ftable>
    800034d4:	494020ef          	jal	80005968 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800034d8:	70e2                	ld	ra,56(sp)
    800034da:	7442                	ld	s0,48(sp)
    800034dc:	74a2                	ld	s1,40(sp)
    800034de:	6121                	addi	sp,sp,64
    800034e0:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034e2:	85d6                	mv	a1,s5
    800034e4:	8552                	mv	a0,s4
    800034e6:	38a000ef          	jal	80003870 <pipeclose>
    800034ea:	7902                	ld	s2,32(sp)
    800034ec:	69e2                	ld	s3,24(sp)
    800034ee:	6a42                	ld	s4,16(sp)
    800034f0:	6aa2                	ld	s5,8(sp)
    800034f2:	b7dd                	j	800034d8 <fileclose+0x8e>
    begin_op();
    800034f4:	b3dff0ef          	jal	80003030 <begin_op>
    iput(ff.ip);
    800034f8:	854e                	mv	a0,s3
    800034fa:	c22ff0ef          	jal	8000291c <iput>
    end_op();
    800034fe:	b9dff0ef          	jal	8000309a <end_op>
    80003502:	7902                	ld	s2,32(sp)
    80003504:	69e2                	ld	s3,24(sp)
    80003506:	6a42                	ld	s4,16(sp)
    80003508:	6aa2                	ld	s5,8(sp)
    8000350a:	b7f9                	j	800034d8 <fileclose+0x8e>

000000008000350c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000350c:	715d                	addi	sp,sp,-80
    8000350e:	e486                	sd	ra,72(sp)
    80003510:	e0a2                	sd	s0,64(sp)
    80003512:	fc26                	sd	s1,56(sp)
    80003514:	f44e                	sd	s3,40(sp)
    80003516:	0880                	addi	s0,sp,80
    80003518:	84aa                	mv	s1,a0
    8000351a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000351c:	88dfd0ef          	jal	80000da8 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003520:	409c                	lw	a5,0(s1)
    80003522:	37f9                	addiw	a5,a5,-2
    80003524:	4705                	li	a4,1
    80003526:	04f76063          	bltu	a4,a5,80003566 <filestat+0x5a>
    8000352a:	f84a                	sd	s2,48(sp)
    8000352c:	892a                	mv	s2,a0
    ilock(f->ip);
    8000352e:	6c88                	ld	a0,24(s1)
    80003530:	a6aff0ef          	jal	8000279a <ilock>
    stati(f->ip, &st);
    80003534:	fb840593          	addi	a1,s0,-72
    80003538:	6c88                	ld	a0,24(s1)
    8000353a:	c8aff0ef          	jal	800029c4 <stati>
    iunlock(f->ip);
    8000353e:	6c88                	ld	a0,24(s1)
    80003540:	b08ff0ef          	jal	80002848 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003544:	46e1                	li	a3,24
    80003546:	fb840613          	addi	a2,s0,-72
    8000354a:	85ce                	mv	a1,s3
    8000354c:	05093503          	ld	a0,80(s2)
    80003550:	ccafd0ef          	jal	80000a1a <copyout>
    80003554:	41f5551b          	sraiw	a0,a0,0x1f
    80003558:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000355a:	60a6                	ld	ra,72(sp)
    8000355c:	6406                	ld	s0,64(sp)
    8000355e:	74e2                	ld	s1,56(sp)
    80003560:	79a2                	ld	s3,40(sp)
    80003562:	6161                	addi	sp,sp,80
    80003564:	8082                	ret
  return -1;
    80003566:	557d                	li	a0,-1
    80003568:	bfcd                	j	8000355a <filestat+0x4e>

000000008000356a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000356a:	7179                	addi	sp,sp,-48
    8000356c:	f406                	sd	ra,40(sp)
    8000356e:	f022                	sd	s0,32(sp)
    80003570:	e84a                	sd	s2,16(sp)
    80003572:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003574:	00854783          	lbu	a5,8(a0)
    80003578:	cfd1                	beqz	a5,80003614 <fileread+0xaa>
    8000357a:	ec26                	sd	s1,24(sp)
    8000357c:	e44e                	sd	s3,8(sp)
    8000357e:	84aa                	mv	s1,a0
    80003580:	89ae                	mv	s3,a1
    80003582:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003584:	411c                	lw	a5,0(a0)
    80003586:	4705                	li	a4,1
    80003588:	04e78363          	beq	a5,a4,800035ce <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000358c:	470d                	li	a4,3
    8000358e:	04e78763          	beq	a5,a4,800035dc <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003592:	4709                	li	a4,2
    80003594:	06e79a63          	bne	a5,a4,80003608 <fileread+0x9e>
    ilock(f->ip);
    80003598:	6d08                	ld	a0,24(a0)
    8000359a:	a00ff0ef          	jal	8000279a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000359e:	874a                	mv	a4,s2
    800035a0:	5094                	lw	a3,32(s1)
    800035a2:	864e                	mv	a2,s3
    800035a4:	4585                	li	a1,1
    800035a6:	6c88                	ld	a0,24(s1)
    800035a8:	c46ff0ef          	jal	800029ee <readi>
    800035ac:	892a                	mv	s2,a0
    800035ae:	00a05563          	blez	a0,800035b8 <fileread+0x4e>
      f->off += r;
    800035b2:	509c                	lw	a5,32(s1)
    800035b4:	9fa9                	addw	a5,a5,a0
    800035b6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035b8:	6c88                	ld	a0,24(s1)
    800035ba:	a8eff0ef          	jal	80002848 <iunlock>
    800035be:	64e2                	ld	s1,24(sp)
    800035c0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800035c2:	854a                	mv	a0,s2
    800035c4:	70a2                	ld	ra,40(sp)
    800035c6:	7402                	ld	s0,32(sp)
    800035c8:	6942                	ld	s2,16(sp)
    800035ca:	6145                	addi	sp,sp,48
    800035cc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800035ce:	6908                	ld	a0,16(a0)
    800035d0:	3dc000ef          	jal	800039ac <piperead>
    800035d4:	892a                	mv	s2,a0
    800035d6:	64e2                	ld	s1,24(sp)
    800035d8:	69a2                	ld	s3,8(sp)
    800035da:	b7e5                	j	800035c2 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035dc:	02451783          	lh	a5,36(a0)
    800035e0:	03079693          	slli	a3,a5,0x30
    800035e4:	92c1                	srli	a3,a3,0x30
    800035e6:	4725                	li	a4,9
    800035e8:	02d76863          	bltu	a4,a3,80003618 <fileread+0xae>
    800035ec:	0792                	slli	a5,a5,0x4
    800035ee:	00014717          	auipc	a4,0x14
    800035f2:	56a70713          	addi	a4,a4,1386 # 80017b58 <devsw>
    800035f6:	97ba                	add	a5,a5,a4
    800035f8:	639c                	ld	a5,0(a5)
    800035fa:	c39d                	beqz	a5,80003620 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035fc:	4505                	li	a0,1
    800035fe:	9782                	jalr	a5
    80003600:	892a                	mv	s2,a0
    80003602:	64e2                	ld	s1,24(sp)
    80003604:	69a2                	ld	s3,8(sp)
    80003606:	bf75                	j	800035c2 <fileread+0x58>
    panic("fileread");
    80003608:	00004517          	auipc	a0,0x4
    8000360c:	05050513          	addi	a0,a0,80 # 80007658 <etext+0x658>
    80003610:	793010ef          	jal	800055a2 <panic>
    return -1;
    80003614:	597d                	li	s2,-1
    80003616:	b775                	j	800035c2 <fileread+0x58>
      return -1;
    80003618:	597d                	li	s2,-1
    8000361a:	64e2                	ld	s1,24(sp)
    8000361c:	69a2                	ld	s3,8(sp)
    8000361e:	b755                	j	800035c2 <fileread+0x58>
    80003620:	597d                	li	s2,-1
    80003622:	64e2                	ld	s1,24(sp)
    80003624:	69a2                	ld	s3,8(sp)
    80003626:	bf71                	j	800035c2 <fileread+0x58>

0000000080003628 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003628:	00954783          	lbu	a5,9(a0)
    8000362c:	10078b63          	beqz	a5,80003742 <filewrite+0x11a>
{
    80003630:	715d                	addi	sp,sp,-80
    80003632:	e486                	sd	ra,72(sp)
    80003634:	e0a2                	sd	s0,64(sp)
    80003636:	f84a                	sd	s2,48(sp)
    80003638:	f052                	sd	s4,32(sp)
    8000363a:	e85a                	sd	s6,16(sp)
    8000363c:	0880                	addi	s0,sp,80
    8000363e:	892a                	mv	s2,a0
    80003640:	8b2e                	mv	s6,a1
    80003642:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003644:	411c                	lw	a5,0(a0)
    80003646:	4705                	li	a4,1
    80003648:	02e78763          	beq	a5,a4,80003676 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000364c:	470d                	li	a4,3
    8000364e:	02e78863          	beq	a5,a4,8000367e <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003652:	4709                	li	a4,2
    80003654:	0ce79c63          	bne	a5,a4,8000372c <filewrite+0x104>
    80003658:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    8000365a:	0ac05863          	blez	a2,8000370a <filewrite+0xe2>
    8000365e:	fc26                	sd	s1,56(sp)
    80003660:	ec56                	sd	s5,24(sp)
    80003662:	e45e                	sd	s7,8(sp)
    80003664:	e062                	sd	s8,0(sp)
    int i = 0;
    80003666:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003668:	6b85                	lui	s7,0x1
    8000366a:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000366e:	6c05                	lui	s8,0x1
    80003670:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003674:	a8b5                	j	800036f0 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80003676:	6908                	ld	a0,16(a0)
    80003678:	250000ef          	jal	800038c8 <pipewrite>
    8000367c:	a04d                	j	8000371e <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000367e:	02451783          	lh	a5,36(a0)
    80003682:	03079693          	slli	a3,a5,0x30
    80003686:	92c1                	srli	a3,a3,0x30
    80003688:	4725                	li	a4,9
    8000368a:	0ad76e63          	bltu	a4,a3,80003746 <filewrite+0x11e>
    8000368e:	0792                	slli	a5,a5,0x4
    80003690:	00014717          	auipc	a4,0x14
    80003694:	4c870713          	addi	a4,a4,1224 # 80017b58 <devsw>
    80003698:	97ba                	add	a5,a5,a4
    8000369a:	679c                	ld	a5,8(a5)
    8000369c:	c7dd                	beqz	a5,8000374a <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000369e:	4505                	li	a0,1
    800036a0:	9782                	jalr	a5
    800036a2:	a8b5                	j	8000371e <filewrite+0xf6>
      if(n1 > max)
    800036a4:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800036a8:	989ff0ef          	jal	80003030 <begin_op>
      ilock(f->ip);
    800036ac:	01893503          	ld	a0,24(s2)
    800036b0:	8eaff0ef          	jal	8000279a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036b4:	8756                	mv	a4,s5
    800036b6:	02092683          	lw	a3,32(s2)
    800036ba:	01698633          	add	a2,s3,s6
    800036be:	4585                	li	a1,1
    800036c0:	01893503          	ld	a0,24(s2)
    800036c4:	c26ff0ef          	jal	80002aea <writei>
    800036c8:	84aa                	mv	s1,a0
    800036ca:	00a05763          	blez	a0,800036d8 <filewrite+0xb0>
        f->off += r;
    800036ce:	02092783          	lw	a5,32(s2)
    800036d2:	9fa9                	addw	a5,a5,a0
    800036d4:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036d8:	01893503          	ld	a0,24(s2)
    800036dc:	96cff0ef          	jal	80002848 <iunlock>
      end_op();
    800036e0:	9bbff0ef          	jal	8000309a <end_op>

      if(r != n1){
    800036e4:	029a9563          	bne	s5,s1,8000370e <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800036e8:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800036ec:	0149da63          	bge	s3,s4,80003700 <filewrite+0xd8>
      int n1 = n - i;
    800036f0:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    800036f4:	0004879b          	sext.w	a5,s1
    800036f8:	fafbd6e3          	bge	s7,a5,800036a4 <filewrite+0x7c>
    800036fc:	84e2                	mv	s1,s8
    800036fe:	b75d                	j	800036a4 <filewrite+0x7c>
    80003700:	74e2                	ld	s1,56(sp)
    80003702:	6ae2                	ld	s5,24(sp)
    80003704:	6ba2                	ld	s7,8(sp)
    80003706:	6c02                	ld	s8,0(sp)
    80003708:	a039                	j	80003716 <filewrite+0xee>
    int i = 0;
    8000370a:	4981                	li	s3,0
    8000370c:	a029                	j	80003716 <filewrite+0xee>
    8000370e:	74e2                	ld	s1,56(sp)
    80003710:	6ae2                	ld	s5,24(sp)
    80003712:	6ba2                	ld	s7,8(sp)
    80003714:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003716:	033a1c63          	bne	s4,s3,8000374e <filewrite+0x126>
    8000371a:	8552                	mv	a0,s4
    8000371c:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000371e:	60a6                	ld	ra,72(sp)
    80003720:	6406                	ld	s0,64(sp)
    80003722:	7942                	ld	s2,48(sp)
    80003724:	7a02                	ld	s4,32(sp)
    80003726:	6b42                	ld	s6,16(sp)
    80003728:	6161                	addi	sp,sp,80
    8000372a:	8082                	ret
    8000372c:	fc26                	sd	s1,56(sp)
    8000372e:	f44e                	sd	s3,40(sp)
    80003730:	ec56                	sd	s5,24(sp)
    80003732:	e45e                	sd	s7,8(sp)
    80003734:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003736:	00004517          	auipc	a0,0x4
    8000373a:	f3250513          	addi	a0,a0,-206 # 80007668 <etext+0x668>
    8000373e:	665010ef          	jal	800055a2 <panic>
    return -1;
    80003742:	557d                	li	a0,-1
}
    80003744:	8082                	ret
      return -1;
    80003746:	557d                	li	a0,-1
    80003748:	bfd9                	j	8000371e <filewrite+0xf6>
    8000374a:	557d                	li	a0,-1
    8000374c:	bfc9                	j	8000371e <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000374e:	557d                	li	a0,-1
    80003750:	79a2                	ld	s3,40(sp)
    80003752:	b7f1                	j	8000371e <filewrite+0xf6>

0000000080003754 <count_openfiles>:

uint64 count_openfiles(void) {
    80003754:	1101                	addi	sp,sp,-32
    80003756:	ec06                	sd	ra,24(sp)
    80003758:	e822                	sd	s0,16(sp)
    8000375a:	e426                	sd	s1,8(sp)
    8000375c:	1000                	addi	s0,sp,32
    struct file *f;
    int count = 0;

    acquire(&ftable.lock);
    8000375e:	00014517          	auipc	a0,0x14
    80003762:	49a50513          	addi	a0,a0,1178 # 80017bf8 <ftable>
    80003766:	16a020ef          	jal	800058d0 <acquire>
    int count = 0;
    8000376a:	4481                	li	s1,0
    for (f = ftable.file; f < &ftable.file[NFILE]; f++) {
    8000376c:	00014797          	auipc	a5,0x14
    80003770:	4a478793          	addi	a5,a5,1188 # 80017c10 <ftable+0x18>
    80003774:	00015697          	auipc	a3,0x15
    80003778:	43c68693          	addi	a3,a3,1084 # 80018bb0 <disk>
    8000377c:	a029                	j	80003786 <count_openfiles+0x32>
    8000377e:	02878793          	addi	a5,a5,40
    80003782:	00d78763          	beq	a5,a3,80003790 <count_openfiles+0x3c>
        if (f->ref > 0)  // Count files with active references
    80003786:	43d8                	lw	a4,4(a5)
    80003788:	fee05be3          	blez	a4,8000377e <count_openfiles+0x2a>
            count++;
    8000378c:	2485                	addiw	s1,s1,1
    8000378e:	bfc5                	j	8000377e <count_openfiles+0x2a>
    }
    release(&ftable.lock);
    80003790:	00014517          	auipc	a0,0x14
    80003794:	46850513          	addi	a0,a0,1128 # 80017bf8 <ftable>
    80003798:	1d0020ef          	jal	80005968 <release>

    return count;
}
    8000379c:	8526                	mv	a0,s1
    8000379e:	60e2                	ld	ra,24(sp)
    800037a0:	6442                	ld	s0,16(sp)
    800037a2:	64a2                	ld	s1,8(sp)
    800037a4:	6105                	addi	sp,sp,32
    800037a6:	8082                	ret

00000000800037a8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037a8:	7179                	addi	sp,sp,-48
    800037aa:	f406                	sd	ra,40(sp)
    800037ac:	f022                	sd	s0,32(sp)
    800037ae:	ec26                	sd	s1,24(sp)
    800037b0:	e052                	sd	s4,0(sp)
    800037b2:	1800                	addi	s0,sp,48
    800037b4:	84aa                	mv	s1,a0
    800037b6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037b8:	0005b023          	sd	zero,0(a1)
    800037bc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037c0:	be7ff0ef          	jal	800033a6 <filealloc>
    800037c4:	e088                	sd	a0,0(s1)
    800037c6:	c549                	beqz	a0,80003850 <pipealloc+0xa8>
    800037c8:	bdfff0ef          	jal	800033a6 <filealloc>
    800037cc:	00aa3023          	sd	a0,0(s4)
    800037d0:	cd25                	beqz	a0,80003848 <pipealloc+0xa0>
    800037d2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037d4:	92bfc0ef          	jal	800000fe <kalloc>
    800037d8:	892a                	mv	s2,a0
    800037da:	c12d                	beqz	a0,8000383c <pipealloc+0x94>
    800037dc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037de:	4985                	li	s3,1
    800037e0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037e4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037e8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037ec:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037f0:	00004597          	auipc	a1,0x4
    800037f4:	c1058593          	addi	a1,a1,-1008 # 80007400 <etext+0x400>
    800037f8:	058020ef          	jal	80005850 <initlock>
  (*f0)->type = FD_PIPE;
    800037fc:	609c                	ld	a5,0(s1)
    800037fe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003802:	609c                	ld	a5,0(s1)
    80003804:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003808:	609c                	ld	a5,0(s1)
    8000380a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000380e:	609c                	ld	a5,0(s1)
    80003810:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003814:	000a3783          	ld	a5,0(s4)
    80003818:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000381c:	000a3783          	ld	a5,0(s4)
    80003820:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003824:	000a3783          	ld	a5,0(s4)
    80003828:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000382c:	000a3783          	ld	a5,0(s4)
    80003830:	0127b823          	sd	s2,16(a5)
  return 0;
    80003834:	4501                	li	a0,0
    80003836:	6942                	ld	s2,16(sp)
    80003838:	69a2                	ld	s3,8(sp)
    8000383a:	a01d                	j	80003860 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000383c:	6088                	ld	a0,0(s1)
    8000383e:	c119                	beqz	a0,80003844 <pipealloc+0x9c>
    80003840:	6942                	ld	s2,16(sp)
    80003842:	a029                	j	8000384c <pipealloc+0xa4>
    80003844:	6942                	ld	s2,16(sp)
    80003846:	a029                	j	80003850 <pipealloc+0xa8>
    80003848:	6088                	ld	a0,0(s1)
    8000384a:	c10d                	beqz	a0,8000386c <pipealloc+0xc4>
    fileclose(*f0);
    8000384c:	bffff0ef          	jal	8000344a <fileclose>
  if(*f1)
    80003850:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003854:	557d                	li	a0,-1
  if(*f1)
    80003856:	c789                	beqz	a5,80003860 <pipealloc+0xb8>
    fileclose(*f1);
    80003858:	853e                	mv	a0,a5
    8000385a:	bf1ff0ef          	jal	8000344a <fileclose>
  return -1;
    8000385e:	557d                	li	a0,-1
}
    80003860:	70a2                	ld	ra,40(sp)
    80003862:	7402                	ld	s0,32(sp)
    80003864:	64e2                	ld	s1,24(sp)
    80003866:	6a02                	ld	s4,0(sp)
    80003868:	6145                	addi	sp,sp,48
    8000386a:	8082                	ret
  return -1;
    8000386c:	557d                	li	a0,-1
    8000386e:	bfcd                	j	80003860 <pipealloc+0xb8>

0000000080003870 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003870:	1101                	addi	sp,sp,-32
    80003872:	ec06                	sd	ra,24(sp)
    80003874:	e822                	sd	s0,16(sp)
    80003876:	e426                	sd	s1,8(sp)
    80003878:	e04a                	sd	s2,0(sp)
    8000387a:	1000                	addi	s0,sp,32
    8000387c:	84aa                	mv	s1,a0
    8000387e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003880:	050020ef          	jal	800058d0 <acquire>
  if(writable){
    80003884:	02090763          	beqz	s2,800038b2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003888:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000388c:	21848513          	addi	a0,s1,536
    80003890:	b3bfd0ef          	jal	800013ca <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003894:	2204b783          	ld	a5,544(s1)
    80003898:	e785                	bnez	a5,800038c0 <pipeclose+0x50>
    release(&pi->lock);
    8000389a:	8526                	mv	a0,s1
    8000389c:	0cc020ef          	jal	80005968 <release>
    kfree((char*)pi);
    800038a0:	8526                	mv	a0,s1
    800038a2:	f7afc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret
    pi->readopen = 0;
    800038b2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038b6:	21c48513          	addi	a0,s1,540
    800038ba:	b11fd0ef          	jal	800013ca <wakeup>
    800038be:	bfd9                	j	80003894 <pipeclose+0x24>
    release(&pi->lock);
    800038c0:	8526                	mv	a0,s1
    800038c2:	0a6020ef          	jal	80005968 <release>
}
    800038c6:	b7c5                	j	800038a6 <pipeclose+0x36>

00000000800038c8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038c8:	711d                	addi	sp,sp,-96
    800038ca:	ec86                	sd	ra,88(sp)
    800038cc:	e8a2                	sd	s0,80(sp)
    800038ce:	e4a6                	sd	s1,72(sp)
    800038d0:	e0ca                	sd	s2,64(sp)
    800038d2:	fc4e                	sd	s3,56(sp)
    800038d4:	f852                	sd	s4,48(sp)
    800038d6:	f456                	sd	s5,40(sp)
    800038d8:	1080                	addi	s0,sp,96
    800038da:	84aa                	mv	s1,a0
    800038dc:	8aae                	mv	s5,a1
    800038de:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038e0:	cc8fd0ef          	jal	80000da8 <myproc>
    800038e4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038e6:	8526                	mv	a0,s1
    800038e8:	7e9010ef          	jal	800058d0 <acquire>
  while(i < n){
    800038ec:	0b405a63          	blez	s4,800039a0 <pipewrite+0xd8>
    800038f0:	f05a                	sd	s6,32(sp)
    800038f2:	ec5e                	sd	s7,24(sp)
    800038f4:	e862                	sd	s8,16(sp)
  int i = 0;
    800038f6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038f8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800038fa:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800038fe:	21c48b93          	addi	s7,s1,540
    80003902:	a81d                	j	80003938 <pipewrite+0x70>
      release(&pi->lock);
    80003904:	8526                	mv	a0,s1
    80003906:	062020ef          	jal	80005968 <release>
      return -1;
    8000390a:	597d                	li	s2,-1
    8000390c:	7b02                	ld	s6,32(sp)
    8000390e:	6be2                	ld	s7,24(sp)
    80003910:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003912:	854a                	mv	a0,s2
    80003914:	60e6                	ld	ra,88(sp)
    80003916:	6446                	ld	s0,80(sp)
    80003918:	64a6                	ld	s1,72(sp)
    8000391a:	6906                	ld	s2,64(sp)
    8000391c:	79e2                	ld	s3,56(sp)
    8000391e:	7a42                	ld	s4,48(sp)
    80003920:	7aa2                	ld	s5,40(sp)
    80003922:	6125                	addi	sp,sp,96
    80003924:	8082                	ret
      wakeup(&pi->nread);
    80003926:	8562                	mv	a0,s8
    80003928:	aa3fd0ef          	jal	800013ca <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000392c:	85a6                	mv	a1,s1
    8000392e:	855e                	mv	a0,s7
    80003930:	a4ffd0ef          	jal	8000137e <sleep>
  while(i < n){
    80003934:	05495b63          	bge	s2,s4,8000398a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80003938:	2204a783          	lw	a5,544(s1)
    8000393c:	d7e1                	beqz	a5,80003904 <pipewrite+0x3c>
    8000393e:	854e                	mv	a0,s3
    80003940:	c77fd0ef          	jal	800015b6 <killed>
    80003944:	f161                	bnez	a0,80003904 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003946:	2184a783          	lw	a5,536(s1)
    8000394a:	21c4a703          	lw	a4,540(s1)
    8000394e:	2007879b          	addiw	a5,a5,512
    80003952:	fcf70ae3          	beq	a4,a5,80003926 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003956:	4685                	li	a3,1
    80003958:	01590633          	add	a2,s2,s5
    8000395c:	faf40593          	addi	a1,s0,-81
    80003960:	0509b503          	ld	a0,80(s3)
    80003964:	98cfd0ef          	jal	80000af0 <copyin>
    80003968:	03650e63          	beq	a0,s6,800039a4 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000396c:	21c4a783          	lw	a5,540(s1)
    80003970:	0017871b          	addiw	a4,a5,1
    80003974:	20e4ae23          	sw	a4,540(s1)
    80003978:	1ff7f793          	andi	a5,a5,511
    8000397c:	97a6                	add	a5,a5,s1
    8000397e:	faf44703          	lbu	a4,-81(s0)
    80003982:	00e78c23          	sb	a4,24(a5)
      i++;
    80003986:	2905                	addiw	s2,s2,1
    80003988:	b775                	j	80003934 <pipewrite+0x6c>
    8000398a:	7b02                	ld	s6,32(sp)
    8000398c:	6be2                	ld	s7,24(sp)
    8000398e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80003990:	21848513          	addi	a0,s1,536
    80003994:	a37fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    80003998:	8526                	mv	a0,s1
    8000399a:	7cf010ef          	jal	80005968 <release>
  return i;
    8000399e:	bf95                	j	80003912 <pipewrite+0x4a>
  int i = 0;
    800039a0:	4901                	li	s2,0
    800039a2:	b7fd                	j	80003990 <pipewrite+0xc8>
    800039a4:	7b02                	ld	s6,32(sp)
    800039a6:	6be2                	ld	s7,24(sp)
    800039a8:	6c42                	ld	s8,16(sp)
    800039aa:	b7dd                	j	80003990 <pipewrite+0xc8>

00000000800039ac <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039ac:	715d                	addi	sp,sp,-80
    800039ae:	e486                	sd	ra,72(sp)
    800039b0:	e0a2                	sd	s0,64(sp)
    800039b2:	fc26                	sd	s1,56(sp)
    800039b4:	f84a                	sd	s2,48(sp)
    800039b6:	f44e                	sd	s3,40(sp)
    800039b8:	f052                	sd	s4,32(sp)
    800039ba:	ec56                	sd	s5,24(sp)
    800039bc:	0880                	addi	s0,sp,80
    800039be:	84aa                	mv	s1,a0
    800039c0:	892e                	mv	s2,a1
    800039c2:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039c4:	be4fd0ef          	jal	80000da8 <myproc>
    800039c8:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039ca:	8526                	mv	a0,s1
    800039cc:	705010ef          	jal	800058d0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039d0:	2184a703          	lw	a4,536(s1)
    800039d4:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039d8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039dc:	02f71563          	bne	a4,a5,80003a06 <piperead+0x5a>
    800039e0:	2244a783          	lw	a5,548(s1)
    800039e4:	cb85                	beqz	a5,80003a14 <piperead+0x68>
    if(killed(pr)){
    800039e6:	8552                	mv	a0,s4
    800039e8:	bcffd0ef          	jal	800015b6 <killed>
    800039ec:	ed19                	bnez	a0,80003a0a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039ee:	85a6                	mv	a1,s1
    800039f0:	854e                	mv	a0,s3
    800039f2:	98dfd0ef          	jal	8000137e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039f6:	2184a703          	lw	a4,536(s1)
    800039fa:	21c4a783          	lw	a5,540(s1)
    800039fe:	fef701e3          	beq	a4,a5,800039e0 <piperead+0x34>
    80003a02:	e85a                	sd	s6,16(sp)
    80003a04:	a809                	j	80003a16 <piperead+0x6a>
    80003a06:	e85a                	sd	s6,16(sp)
    80003a08:	a039                	j	80003a16 <piperead+0x6a>
      release(&pi->lock);
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	75d010ef          	jal	80005968 <release>
      return -1;
    80003a10:	59fd                	li	s3,-1
    80003a12:	a8b1                	j	80003a6e <piperead+0xc2>
    80003a14:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a16:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a18:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a1a:	05505263          	blez	s5,80003a5e <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80003a1e:	2184a783          	lw	a5,536(s1)
    80003a22:	21c4a703          	lw	a4,540(s1)
    80003a26:	02f70c63          	beq	a4,a5,80003a5e <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a2a:	0017871b          	addiw	a4,a5,1
    80003a2e:	20e4ac23          	sw	a4,536(s1)
    80003a32:	1ff7f793          	andi	a5,a5,511
    80003a36:	97a6                	add	a5,a5,s1
    80003a38:	0187c783          	lbu	a5,24(a5)
    80003a3c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a40:	4685                	li	a3,1
    80003a42:	fbf40613          	addi	a2,s0,-65
    80003a46:	85ca                	mv	a1,s2
    80003a48:	050a3503          	ld	a0,80(s4)
    80003a4c:	fcffc0ef          	jal	80000a1a <copyout>
    80003a50:	01650763          	beq	a0,s6,80003a5e <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a54:	2985                	addiw	s3,s3,1
    80003a56:	0905                	addi	s2,s2,1
    80003a58:	fd3a93e3          	bne	s5,s3,80003a1e <piperead+0x72>
    80003a5c:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a5e:	21c48513          	addi	a0,s1,540
    80003a62:	969fd0ef          	jal	800013ca <wakeup>
  release(&pi->lock);
    80003a66:	8526                	mv	a0,s1
    80003a68:	701010ef          	jal	80005968 <release>
    80003a6c:	6b42                	ld	s6,16(sp)
  return i;
}
    80003a6e:	854e                	mv	a0,s3
    80003a70:	60a6                	ld	ra,72(sp)
    80003a72:	6406                	ld	s0,64(sp)
    80003a74:	74e2                	ld	s1,56(sp)
    80003a76:	7942                	ld	s2,48(sp)
    80003a78:	79a2                	ld	s3,40(sp)
    80003a7a:	7a02                	ld	s4,32(sp)
    80003a7c:	6ae2                	ld	s5,24(sp)
    80003a7e:	6161                	addi	sp,sp,80
    80003a80:	8082                	ret

0000000080003a82 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a82:	1141                	addi	sp,sp,-16
    80003a84:	e422                	sd	s0,8(sp)
    80003a86:	0800                	addi	s0,sp,16
    80003a88:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a8a:	8905                	andi	a0,a0,1
    80003a8c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80003a8e:	8b89                	andi	a5,a5,2
    80003a90:	c399                	beqz	a5,80003a96 <flags2perm+0x14>
      perm |= PTE_W;
    80003a92:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a96:	6422                	ld	s0,8(sp)
    80003a98:	0141                	addi	sp,sp,16
    80003a9a:	8082                	ret

0000000080003a9c <exec>:

int
exec(char *path, char **argv)
{
    80003a9c:	df010113          	addi	sp,sp,-528
    80003aa0:	20113423          	sd	ra,520(sp)
    80003aa4:	20813023          	sd	s0,512(sp)
    80003aa8:	ffa6                	sd	s1,504(sp)
    80003aaa:	fbca                	sd	s2,496(sp)
    80003aac:	0c00                	addi	s0,sp,528
    80003aae:	892a                	mv	s2,a0
    80003ab0:	dea43c23          	sd	a0,-520(s0)
    80003ab4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003ab8:	af0fd0ef          	jal	80000da8 <myproc>
    80003abc:	84aa                	mv	s1,a0

  begin_op();
    80003abe:	d72ff0ef          	jal	80003030 <begin_op>

  if((ip = namei(path)) == 0){
    80003ac2:	854a                	mv	a0,s2
    80003ac4:	bb0ff0ef          	jal	80002e74 <namei>
    80003ac8:	c931                	beqz	a0,80003b1c <exec+0x80>
    80003aca:	f3d2                	sd	s4,480(sp)
    80003acc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003ace:	ccdfe0ef          	jal	8000279a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003ad2:	04000713          	li	a4,64
    80003ad6:	4681                	li	a3,0
    80003ad8:	e5040613          	addi	a2,s0,-432
    80003adc:	4581                	li	a1,0
    80003ade:	8552                	mv	a0,s4
    80003ae0:	f0ffe0ef          	jal	800029ee <readi>
    80003ae4:	04000793          	li	a5,64
    80003ae8:	00f51a63          	bne	a0,a5,80003afc <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003aec:	e5042703          	lw	a4,-432(s0)
    80003af0:	464c47b7          	lui	a5,0x464c4
    80003af4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003af8:	02f70663          	beq	a4,a5,80003b24 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003afc:	8552                	mv	a0,s4
    80003afe:	ea7fe0ef          	jal	800029a4 <iunlockput>
    end_op();
    80003b02:	d98ff0ef          	jal	8000309a <end_op>
  }
  return -1;
    80003b06:	557d                	li	a0,-1
    80003b08:	7a1e                	ld	s4,480(sp)
}
    80003b0a:	20813083          	ld	ra,520(sp)
    80003b0e:	20013403          	ld	s0,512(sp)
    80003b12:	74fe                	ld	s1,504(sp)
    80003b14:	795e                	ld	s2,496(sp)
    80003b16:	21010113          	addi	sp,sp,528
    80003b1a:	8082                	ret
    end_op();
    80003b1c:	d7eff0ef          	jal	8000309a <end_op>
    return -1;
    80003b20:	557d                	li	a0,-1
    80003b22:	b7e5                	j	80003b0a <exec+0x6e>
    80003b24:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b26:	8526                	mv	a0,s1
    80003b28:	b28fd0ef          	jal	80000e50 <proc_pagetable>
    80003b2c:	8b2a                	mv	s6,a0
    80003b2e:	2c050b63          	beqz	a0,80003e04 <exec+0x368>
    80003b32:	f7ce                	sd	s3,488(sp)
    80003b34:	efd6                	sd	s5,472(sp)
    80003b36:	e7de                	sd	s7,456(sp)
    80003b38:	e3e2                	sd	s8,448(sp)
    80003b3a:	ff66                	sd	s9,440(sp)
    80003b3c:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b3e:	e7042d03          	lw	s10,-400(s0)
    80003b42:	e8845783          	lhu	a5,-376(s0)
    80003b46:	12078963          	beqz	a5,80003c78 <exec+0x1dc>
    80003b4a:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b4c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b4e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80003b50:	6c85                	lui	s9,0x1
    80003b52:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b56:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b5a:	6a85                	lui	s5,0x1
    80003b5c:	a085                	j	80003bbc <exec+0x120>
      panic("loadseg: address should exist");
    80003b5e:	00004517          	auipc	a0,0x4
    80003b62:	b1a50513          	addi	a0,a0,-1254 # 80007678 <etext+0x678>
    80003b66:	23d010ef          	jal	800055a2 <panic>
    if(sz - i < PGSIZE)
    80003b6a:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b6c:	8726                	mv	a4,s1
    80003b6e:	012c06bb          	addw	a3,s8,s2
    80003b72:	4581                	li	a1,0
    80003b74:	8552                	mv	a0,s4
    80003b76:	e79fe0ef          	jal	800029ee <readi>
    80003b7a:	2501                	sext.w	a0,a0
    80003b7c:	24a49a63          	bne	s1,a0,80003dd0 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80003b80:	012a893b          	addw	s2,s5,s2
    80003b84:	03397363          	bgeu	s2,s3,80003baa <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80003b88:	02091593          	slli	a1,s2,0x20
    80003b8c:	9181                	srli	a1,a1,0x20
    80003b8e:	95de                	add	a1,a1,s7
    80003b90:	855a                	mv	a0,s6
    80003b92:	90dfc0ef          	jal	8000049e <walkaddr>
    80003b96:	862a                	mv	a2,a0
    if(pa == 0)
    80003b98:	d179                	beqz	a0,80003b5e <exec+0xc2>
    if(sz - i < PGSIZE)
    80003b9a:	412984bb          	subw	s1,s3,s2
    80003b9e:	0004879b          	sext.w	a5,s1
    80003ba2:	fcfcf4e3          	bgeu	s9,a5,80003b6a <exec+0xce>
    80003ba6:	84d6                	mv	s1,s5
    80003ba8:	b7c9                	j	80003b6a <exec+0xce>
    sz = sz1;
    80003baa:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bae:	2d85                	addiw	s11,s11,1
    80003bb0:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80003bb4:	e8845783          	lhu	a5,-376(s0)
    80003bb8:	08fdd063          	bge	s11,a5,80003c38 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bbc:	2d01                	sext.w	s10,s10
    80003bbe:	03800713          	li	a4,56
    80003bc2:	86ea                	mv	a3,s10
    80003bc4:	e1840613          	addi	a2,s0,-488
    80003bc8:	4581                	li	a1,0
    80003bca:	8552                	mv	a0,s4
    80003bcc:	e23fe0ef          	jal	800029ee <readi>
    80003bd0:	03800793          	li	a5,56
    80003bd4:	1cf51663          	bne	a0,a5,80003da0 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80003bd8:	e1842783          	lw	a5,-488(s0)
    80003bdc:	4705                	li	a4,1
    80003bde:	fce798e3          	bne	a5,a4,80003bae <exec+0x112>
    if(ph.memsz < ph.filesz)
    80003be2:	e4043483          	ld	s1,-448(s0)
    80003be6:	e3843783          	ld	a5,-456(s0)
    80003bea:	1af4ef63          	bltu	s1,a5,80003da8 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003bee:	e2843783          	ld	a5,-472(s0)
    80003bf2:	94be                	add	s1,s1,a5
    80003bf4:	1af4ee63          	bltu	s1,a5,80003db0 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80003bf8:	df043703          	ld	a4,-528(s0)
    80003bfc:	8ff9                	and	a5,a5,a4
    80003bfe:	1a079d63          	bnez	a5,80003db8 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c02:	e1c42503          	lw	a0,-484(s0)
    80003c06:	e7dff0ef          	jal	80003a82 <flags2perm>
    80003c0a:	86aa                	mv	a3,a0
    80003c0c:	8626                	mv	a2,s1
    80003c0e:	85ca                	mv	a1,s2
    80003c10:	855a                	mv	a0,s6
    80003c12:	bf5fc0ef          	jal	80000806 <uvmalloc>
    80003c16:	e0a43423          	sd	a0,-504(s0)
    80003c1a:	1a050363          	beqz	a0,80003dc0 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c1e:	e2843b83          	ld	s7,-472(s0)
    80003c22:	e2042c03          	lw	s8,-480(s0)
    80003c26:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c2a:	00098463          	beqz	s3,80003c32 <exec+0x196>
    80003c2e:	4901                	li	s2,0
    80003c30:	bfa1                	j	80003b88 <exec+0xec>
    sz = sz1;
    80003c32:	e0843903          	ld	s2,-504(s0)
    80003c36:	bfa5                	j	80003bae <exec+0x112>
    80003c38:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80003c3a:	8552                	mv	a0,s4
    80003c3c:	d69fe0ef          	jal	800029a4 <iunlockput>
  end_op();
    80003c40:	c5aff0ef          	jal	8000309a <end_op>
  p = myproc();
    80003c44:	964fd0ef          	jal	80000da8 <myproc>
    80003c48:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c4a:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80003c4e:	6985                	lui	s3,0x1
    80003c50:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c52:	99ca                	add	s3,s3,s2
    80003c54:	77fd                	lui	a5,0xfffff
    80003c56:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c5a:	4691                	li	a3,4
    80003c5c:	660d                	lui	a2,0x3
    80003c5e:	964e                	add	a2,a2,s3
    80003c60:	85ce                	mv	a1,s3
    80003c62:	855a                	mv	a0,s6
    80003c64:	ba3fc0ef          	jal	80000806 <uvmalloc>
    80003c68:	892a                	mv	s2,a0
    80003c6a:	e0a43423          	sd	a0,-504(s0)
    80003c6e:	e519                	bnez	a0,80003c7c <exec+0x1e0>
  if(pagetable)
    80003c70:	e1343423          	sd	s3,-504(s0)
    80003c74:	4a01                	li	s4,0
    80003c76:	aab1                	j	80003dd2 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c78:	4901                	li	s2,0
    80003c7a:	b7c1                	j	80003c3a <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c7c:	75f5                	lui	a1,0xffffd
    80003c7e:	95aa                	add	a1,a1,a0
    80003c80:	855a                	mv	a0,s6
    80003c82:	d6ffc0ef          	jal	800009f0 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c86:	7bf9                	lui	s7,0xffffe
    80003c88:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80003c8a:	e0043783          	ld	a5,-512(s0)
    80003c8e:	6388                	ld	a0,0(a5)
    80003c90:	cd39                	beqz	a0,80003cee <exec+0x252>
    80003c92:	e9040993          	addi	s3,s0,-368
    80003c96:	f9040c13          	addi	s8,s0,-112
    80003c9a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80003c9c:	e64fc0ef          	jal	80000300 <strlen>
    80003ca0:	0015079b          	addiw	a5,a0,1
    80003ca4:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003ca8:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cac:	11796e63          	bltu	s2,s7,80003dc8 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003cb0:	e0043d03          	ld	s10,-512(s0)
    80003cb4:	000d3a03          	ld	s4,0(s10)
    80003cb8:	8552                	mv	a0,s4
    80003cba:	e46fc0ef          	jal	80000300 <strlen>
    80003cbe:	0015069b          	addiw	a3,a0,1
    80003cc2:	8652                	mv	a2,s4
    80003cc4:	85ca                	mv	a1,s2
    80003cc6:	855a                	mv	a0,s6
    80003cc8:	d53fc0ef          	jal	80000a1a <copyout>
    80003ccc:	10054063          	bltz	a0,80003dcc <exec+0x330>
    ustack[argc] = sp;
    80003cd0:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80003cd4:	0485                	addi	s1,s1,1
    80003cd6:	008d0793          	addi	a5,s10,8
    80003cda:	e0f43023          	sd	a5,-512(s0)
    80003cde:	008d3503          	ld	a0,8(s10)
    80003ce2:	c909                	beqz	a0,80003cf4 <exec+0x258>
    if(argc >= MAXARG)
    80003ce4:	09a1                	addi	s3,s3,8
    80003ce6:	fb899be3          	bne	s3,s8,80003c9c <exec+0x200>
  ip = 0;
    80003cea:	4a01                	li	s4,0
    80003cec:	a0dd                	j	80003dd2 <exec+0x336>
  sp = sz;
    80003cee:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80003cf2:	4481                	li	s1,0
  ustack[argc] = 0;
    80003cf4:	00349793          	slli	a5,s1,0x3
    80003cf8:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffde1a0>
    80003cfc:	97a2                	add	a5,a5,s0
    80003cfe:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d02:	00148693          	addi	a3,s1,1
    80003d06:	068e                	slli	a3,a3,0x3
    80003d08:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d0c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d10:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80003d14:	f5796ee3          	bltu	s2,s7,80003c70 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d18:	e9040613          	addi	a2,s0,-368
    80003d1c:	85ca                	mv	a1,s2
    80003d1e:	855a                	mv	a0,s6
    80003d20:	cfbfc0ef          	jal	80000a1a <copyout>
    80003d24:	0e054263          	bltz	a0,80003e08 <exec+0x36c>
  p->trapframe->a1 = sp;
    80003d28:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d2c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d30:	df843783          	ld	a5,-520(s0)
    80003d34:	0007c703          	lbu	a4,0(a5)
    80003d38:	cf11                	beqz	a4,80003d54 <exec+0x2b8>
    80003d3a:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d3c:	02f00693          	li	a3,47
    80003d40:	a039                	j	80003d4e <exec+0x2b2>
      last = s+1;
    80003d42:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80003d46:	0785                	addi	a5,a5,1
    80003d48:	fff7c703          	lbu	a4,-1(a5)
    80003d4c:	c701                	beqz	a4,80003d54 <exec+0x2b8>
    if(*s == '/')
    80003d4e:	fed71ce3          	bne	a4,a3,80003d46 <exec+0x2aa>
    80003d52:	bfc5                	j	80003d42 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d54:	4641                	li	a2,16
    80003d56:	df843583          	ld	a1,-520(s0)
    80003d5a:	158a8513          	addi	a0,s5,344
    80003d5e:	d70fc0ef          	jal	800002ce <safestrcpy>
  oldpagetable = p->pagetable;
    80003d62:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d66:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d6a:	e0843783          	ld	a5,-504(s0)
    80003d6e:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d72:	058ab783          	ld	a5,88(s5)
    80003d76:	e6843703          	ld	a4,-408(s0)
    80003d7a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d7c:	058ab783          	ld	a5,88(s5)
    80003d80:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d84:	85e6                	mv	a1,s9
    80003d86:	94efd0ef          	jal	80000ed4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d8a:	0004851b          	sext.w	a0,s1
    80003d8e:	79be                	ld	s3,488(sp)
    80003d90:	7a1e                	ld	s4,480(sp)
    80003d92:	6afe                	ld	s5,472(sp)
    80003d94:	6b5e                	ld	s6,464(sp)
    80003d96:	6bbe                	ld	s7,456(sp)
    80003d98:	6c1e                	ld	s8,448(sp)
    80003d9a:	7cfa                	ld	s9,440(sp)
    80003d9c:	7d5a                	ld	s10,432(sp)
    80003d9e:	b3b5                	j	80003b0a <exec+0x6e>
    80003da0:	e1243423          	sd	s2,-504(s0)
    80003da4:	7dba                	ld	s11,424(sp)
    80003da6:	a035                	j	80003dd2 <exec+0x336>
    80003da8:	e1243423          	sd	s2,-504(s0)
    80003dac:	7dba                	ld	s11,424(sp)
    80003dae:	a015                	j	80003dd2 <exec+0x336>
    80003db0:	e1243423          	sd	s2,-504(s0)
    80003db4:	7dba                	ld	s11,424(sp)
    80003db6:	a831                	j	80003dd2 <exec+0x336>
    80003db8:	e1243423          	sd	s2,-504(s0)
    80003dbc:	7dba                	ld	s11,424(sp)
    80003dbe:	a811                	j	80003dd2 <exec+0x336>
    80003dc0:	e1243423          	sd	s2,-504(s0)
    80003dc4:	7dba                	ld	s11,424(sp)
    80003dc6:	a031                	j	80003dd2 <exec+0x336>
  ip = 0;
    80003dc8:	4a01                	li	s4,0
    80003dca:	a021                	j	80003dd2 <exec+0x336>
    80003dcc:	4a01                	li	s4,0
  if(pagetable)
    80003dce:	a011                	j	80003dd2 <exec+0x336>
    80003dd0:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80003dd2:	e0843583          	ld	a1,-504(s0)
    80003dd6:	855a                	mv	a0,s6
    80003dd8:	8fcfd0ef          	jal	80000ed4 <proc_freepagetable>
  return -1;
    80003ddc:	557d                	li	a0,-1
  if(ip){
    80003dde:	000a1b63          	bnez	s4,80003df4 <exec+0x358>
    80003de2:	79be                	ld	s3,488(sp)
    80003de4:	7a1e                	ld	s4,480(sp)
    80003de6:	6afe                	ld	s5,472(sp)
    80003de8:	6b5e                	ld	s6,464(sp)
    80003dea:	6bbe                	ld	s7,456(sp)
    80003dec:	6c1e                	ld	s8,448(sp)
    80003dee:	7cfa                	ld	s9,440(sp)
    80003df0:	7d5a                	ld	s10,432(sp)
    80003df2:	bb21                	j	80003b0a <exec+0x6e>
    80003df4:	79be                	ld	s3,488(sp)
    80003df6:	6afe                	ld	s5,472(sp)
    80003df8:	6b5e                	ld	s6,464(sp)
    80003dfa:	6bbe                	ld	s7,456(sp)
    80003dfc:	6c1e                	ld	s8,448(sp)
    80003dfe:	7cfa                	ld	s9,440(sp)
    80003e00:	7d5a                	ld	s10,432(sp)
    80003e02:	b9ed                	j	80003afc <exec+0x60>
    80003e04:	6b5e                	ld	s6,464(sp)
    80003e06:	b9dd                	j	80003afc <exec+0x60>
  sz = sz1;
    80003e08:	e0843983          	ld	s3,-504(s0)
    80003e0c:	b595                	j	80003c70 <exec+0x1d4>

0000000080003e0e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e0e:	7179                	addi	sp,sp,-48
    80003e10:	f406                	sd	ra,40(sp)
    80003e12:	f022                	sd	s0,32(sp)
    80003e14:	ec26                	sd	s1,24(sp)
    80003e16:	e84a                	sd	s2,16(sp)
    80003e18:	1800                	addi	s0,sp,48
    80003e1a:	892e                	mv	s2,a1
    80003e1c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e1e:	fdc40593          	addi	a1,s0,-36
    80003e22:	e91fd0ef          	jal	80001cb2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e26:	fdc42703          	lw	a4,-36(s0)
    80003e2a:	47bd                	li	a5,15
    80003e2c:	02e7e963          	bltu	a5,a4,80003e5e <argfd+0x50>
    80003e30:	f79fc0ef          	jal	80000da8 <myproc>
    80003e34:	fdc42703          	lw	a4,-36(s0)
    80003e38:	01a70793          	addi	a5,a4,26
    80003e3c:	078e                	slli	a5,a5,0x3
    80003e3e:	953e                	add	a0,a0,a5
    80003e40:	611c                	ld	a5,0(a0)
    80003e42:	c385                	beqz	a5,80003e62 <argfd+0x54>
    return -1;
  if(pfd)
    80003e44:	00090463          	beqz	s2,80003e4c <argfd+0x3e>
    *pfd = fd;
    80003e48:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e4c:	4501                	li	a0,0
  if(pf)
    80003e4e:	c091                	beqz	s1,80003e52 <argfd+0x44>
    *pf = f;
    80003e50:	e09c                	sd	a5,0(s1)
}
    80003e52:	70a2                	ld	ra,40(sp)
    80003e54:	7402                	ld	s0,32(sp)
    80003e56:	64e2                	ld	s1,24(sp)
    80003e58:	6942                	ld	s2,16(sp)
    80003e5a:	6145                	addi	sp,sp,48
    80003e5c:	8082                	ret
    return -1;
    80003e5e:	557d                	li	a0,-1
    80003e60:	bfcd                	j	80003e52 <argfd+0x44>
    80003e62:	557d                	li	a0,-1
    80003e64:	b7fd                	j	80003e52 <argfd+0x44>

0000000080003e66 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e66:	1101                	addi	sp,sp,-32
    80003e68:	ec06                	sd	ra,24(sp)
    80003e6a:	e822                	sd	s0,16(sp)
    80003e6c:	e426                	sd	s1,8(sp)
    80003e6e:	1000                	addi	s0,sp,32
    80003e70:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e72:	f37fc0ef          	jal	80000da8 <myproc>
    80003e76:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e78:	0d050793          	addi	a5,a0,208
    80003e7c:	4501                	li	a0,0
    80003e7e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e80:	6398                	ld	a4,0(a5)
    80003e82:	cb19                	beqz	a4,80003e98 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e84:	2505                	addiw	a0,a0,1
    80003e86:	07a1                	addi	a5,a5,8
    80003e88:	fed51ce3          	bne	a0,a3,80003e80 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e8c:	557d                	li	a0,-1
}
    80003e8e:	60e2                	ld	ra,24(sp)
    80003e90:	6442                	ld	s0,16(sp)
    80003e92:	64a2                	ld	s1,8(sp)
    80003e94:	6105                	addi	sp,sp,32
    80003e96:	8082                	ret
      p->ofile[fd] = f;
    80003e98:	01a50793          	addi	a5,a0,26
    80003e9c:	078e                	slli	a5,a5,0x3
    80003e9e:	963e                	add	a2,a2,a5
    80003ea0:	e204                	sd	s1,0(a2)
      return fd;
    80003ea2:	b7f5                	j	80003e8e <fdalloc+0x28>

0000000080003ea4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003ea4:	715d                	addi	sp,sp,-80
    80003ea6:	e486                	sd	ra,72(sp)
    80003ea8:	e0a2                	sd	s0,64(sp)
    80003eaa:	fc26                	sd	s1,56(sp)
    80003eac:	f84a                	sd	s2,48(sp)
    80003eae:	f44e                	sd	s3,40(sp)
    80003eb0:	ec56                	sd	s5,24(sp)
    80003eb2:	e85a                	sd	s6,16(sp)
    80003eb4:	0880                	addi	s0,sp,80
    80003eb6:	8b2e                	mv	s6,a1
    80003eb8:	89b2                	mv	s3,a2
    80003eba:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003ebc:	fb040593          	addi	a1,s0,-80
    80003ec0:	fcffe0ef          	jal	80002e8e <nameiparent>
    80003ec4:	84aa                	mv	s1,a0
    80003ec6:	10050a63          	beqz	a0,80003fda <create+0x136>
    return 0;

  ilock(dp);
    80003eca:	8d1fe0ef          	jal	8000279a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ece:	4601                	li	a2,0
    80003ed0:	fb040593          	addi	a1,s0,-80
    80003ed4:	8526                	mv	a0,s1
    80003ed6:	d39fe0ef          	jal	80002c0e <dirlookup>
    80003eda:	8aaa                	mv	s5,a0
    80003edc:	c129                	beqz	a0,80003f1e <create+0x7a>
    iunlockput(dp);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	ac5fe0ef          	jal	800029a4 <iunlockput>
    ilock(ip);
    80003ee4:	8556                	mv	a0,s5
    80003ee6:	8b5fe0ef          	jal	8000279a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003eea:	4789                	li	a5,2
    80003eec:	02fb1463          	bne	s6,a5,80003f14 <create+0x70>
    80003ef0:	044ad783          	lhu	a5,68(s5)
    80003ef4:	37f9                	addiw	a5,a5,-2
    80003ef6:	17c2                	slli	a5,a5,0x30
    80003ef8:	93c1                	srli	a5,a5,0x30
    80003efa:	4705                	li	a4,1
    80003efc:	00f76c63          	bltu	a4,a5,80003f14 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f00:	8556                	mv	a0,s5
    80003f02:	60a6                	ld	ra,72(sp)
    80003f04:	6406                	ld	s0,64(sp)
    80003f06:	74e2                	ld	s1,56(sp)
    80003f08:	7942                	ld	s2,48(sp)
    80003f0a:	79a2                	ld	s3,40(sp)
    80003f0c:	6ae2                	ld	s5,24(sp)
    80003f0e:	6b42                	ld	s6,16(sp)
    80003f10:	6161                	addi	sp,sp,80
    80003f12:	8082                	ret
    iunlockput(ip);
    80003f14:	8556                	mv	a0,s5
    80003f16:	a8ffe0ef          	jal	800029a4 <iunlockput>
    return 0;
    80003f1a:	4a81                	li	s5,0
    80003f1c:	b7d5                	j	80003f00 <create+0x5c>
    80003f1e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f20:	85da                	mv	a1,s6
    80003f22:	4088                	lw	a0,0(s1)
    80003f24:	f06fe0ef          	jal	8000262a <ialloc>
    80003f28:	8a2a                	mv	s4,a0
    80003f2a:	cd15                	beqz	a0,80003f66 <create+0xc2>
  ilock(ip);
    80003f2c:	86ffe0ef          	jal	8000279a <ilock>
  ip->major = major;
    80003f30:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003f34:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003f38:	4905                	li	s2,1
    80003f3a:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003f3e:	8552                	mv	a0,s4
    80003f40:	fa6fe0ef          	jal	800026e6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f44:	032b0763          	beq	s6,s2,80003f72 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f48:	004a2603          	lw	a2,4(s4)
    80003f4c:	fb040593          	addi	a1,s0,-80
    80003f50:	8526                	mv	a0,s1
    80003f52:	e89fe0ef          	jal	80002dda <dirlink>
    80003f56:	06054563          	bltz	a0,80003fc0 <create+0x11c>
  iunlockput(dp);
    80003f5a:	8526                	mv	a0,s1
    80003f5c:	a49fe0ef          	jal	800029a4 <iunlockput>
  return ip;
    80003f60:	8ad2                	mv	s5,s4
    80003f62:	7a02                	ld	s4,32(sp)
    80003f64:	bf71                	j	80003f00 <create+0x5c>
    iunlockput(dp);
    80003f66:	8526                	mv	a0,s1
    80003f68:	a3dfe0ef          	jal	800029a4 <iunlockput>
    return 0;
    80003f6c:	8ad2                	mv	s5,s4
    80003f6e:	7a02                	ld	s4,32(sp)
    80003f70:	bf41                	j	80003f00 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f72:	004a2603          	lw	a2,4(s4)
    80003f76:	00003597          	auipc	a1,0x3
    80003f7a:	72258593          	addi	a1,a1,1826 # 80007698 <etext+0x698>
    80003f7e:	8552                	mv	a0,s4
    80003f80:	e5bfe0ef          	jal	80002dda <dirlink>
    80003f84:	02054e63          	bltz	a0,80003fc0 <create+0x11c>
    80003f88:	40d0                	lw	a2,4(s1)
    80003f8a:	00003597          	auipc	a1,0x3
    80003f8e:	71658593          	addi	a1,a1,1814 # 800076a0 <etext+0x6a0>
    80003f92:	8552                	mv	a0,s4
    80003f94:	e47fe0ef          	jal	80002dda <dirlink>
    80003f98:	02054463          	bltz	a0,80003fc0 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f9c:	004a2603          	lw	a2,4(s4)
    80003fa0:	fb040593          	addi	a1,s0,-80
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	e35fe0ef          	jal	80002dda <dirlink>
    80003faa:	00054b63          	bltz	a0,80003fc0 <create+0x11c>
    dp->nlink++;  // for ".."
    80003fae:	04a4d783          	lhu	a5,74(s1)
    80003fb2:	2785                	addiw	a5,a5,1
    80003fb4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fb8:	8526                	mv	a0,s1
    80003fba:	f2cfe0ef          	jal	800026e6 <iupdate>
    80003fbe:	bf71                	j	80003f5a <create+0xb6>
  ip->nlink = 0;
    80003fc0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003fc4:	8552                	mv	a0,s4
    80003fc6:	f20fe0ef          	jal	800026e6 <iupdate>
  iunlockput(ip);
    80003fca:	8552                	mv	a0,s4
    80003fcc:	9d9fe0ef          	jal	800029a4 <iunlockput>
  iunlockput(dp);
    80003fd0:	8526                	mv	a0,s1
    80003fd2:	9d3fe0ef          	jal	800029a4 <iunlockput>
  return 0;
    80003fd6:	7a02                	ld	s4,32(sp)
    80003fd8:	b725                	j	80003f00 <create+0x5c>
    return 0;
    80003fda:	8aaa                	mv	s5,a0
    80003fdc:	b715                	j	80003f00 <create+0x5c>

0000000080003fde <sys_dup>:
{
    80003fde:	7179                	addi	sp,sp,-48
    80003fe0:	f406                	sd	ra,40(sp)
    80003fe2:	f022                	sd	s0,32(sp)
    80003fe4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003fe6:	fd840613          	addi	a2,s0,-40
    80003fea:	4581                	li	a1,0
    80003fec:	4501                	li	a0,0
    80003fee:	e21ff0ef          	jal	80003e0e <argfd>
    return -1;
    80003ff2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003ff4:	02054363          	bltz	a0,8000401a <sys_dup+0x3c>
    80003ff8:	ec26                	sd	s1,24(sp)
    80003ffa:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003ffc:	fd843903          	ld	s2,-40(s0)
    80004000:	854a                	mv	a0,s2
    80004002:	e65ff0ef          	jal	80003e66 <fdalloc>
    80004006:	84aa                	mv	s1,a0
    return -1;
    80004008:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000400a:	00054d63          	bltz	a0,80004024 <sys_dup+0x46>
  filedup(f);
    8000400e:	854a                	mv	a0,s2
    80004010:	bf4ff0ef          	jal	80003404 <filedup>
  return fd;
    80004014:	87a6                	mv	a5,s1
    80004016:	64e2                	ld	s1,24(sp)
    80004018:	6942                	ld	s2,16(sp)
}
    8000401a:	853e                	mv	a0,a5
    8000401c:	70a2                	ld	ra,40(sp)
    8000401e:	7402                	ld	s0,32(sp)
    80004020:	6145                	addi	sp,sp,48
    80004022:	8082                	ret
    80004024:	64e2                	ld	s1,24(sp)
    80004026:	6942                	ld	s2,16(sp)
    80004028:	bfcd                	j	8000401a <sys_dup+0x3c>

000000008000402a <sys_read>:
{
    8000402a:	7179                	addi	sp,sp,-48
    8000402c:	f406                	sd	ra,40(sp)
    8000402e:	f022                	sd	s0,32(sp)
    80004030:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004032:	fd840593          	addi	a1,s0,-40
    80004036:	4505                	li	a0,1
    80004038:	c97fd0ef          	jal	80001cce <argaddr>
  argint(2, &n);
    8000403c:	fe440593          	addi	a1,s0,-28
    80004040:	4509                	li	a0,2
    80004042:	c71fd0ef          	jal	80001cb2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004046:	fe840613          	addi	a2,s0,-24
    8000404a:	4581                	li	a1,0
    8000404c:	4501                	li	a0,0
    8000404e:	dc1ff0ef          	jal	80003e0e <argfd>
    80004052:	87aa                	mv	a5,a0
    return -1;
    80004054:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004056:	0007ca63          	bltz	a5,8000406a <sys_read+0x40>
  return fileread(f, p, n);
    8000405a:	fe442603          	lw	a2,-28(s0)
    8000405e:	fd843583          	ld	a1,-40(s0)
    80004062:	fe843503          	ld	a0,-24(s0)
    80004066:	d04ff0ef          	jal	8000356a <fileread>
}
    8000406a:	70a2                	ld	ra,40(sp)
    8000406c:	7402                	ld	s0,32(sp)
    8000406e:	6145                	addi	sp,sp,48
    80004070:	8082                	ret

0000000080004072 <sys_write>:
{
    80004072:	7179                	addi	sp,sp,-48
    80004074:	f406                	sd	ra,40(sp)
    80004076:	f022                	sd	s0,32(sp)
    80004078:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000407a:	fd840593          	addi	a1,s0,-40
    8000407e:	4505                	li	a0,1
    80004080:	c4ffd0ef          	jal	80001cce <argaddr>
  argint(2, &n);
    80004084:	fe440593          	addi	a1,s0,-28
    80004088:	4509                	li	a0,2
    8000408a:	c29fd0ef          	jal	80001cb2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000408e:	fe840613          	addi	a2,s0,-24
    80004092:	4581                	li	a1,0
    80004094:	4501                	li	a0,0
    80004096:	d79ff0ef          	jal	80003e0e <argfd>
    8000409a:	87aa                	mv	a5,a0
    return -1;
    8000409c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000409e:	0007ca63          	bltz	a5,800040b2 <sys_write+0x40>
  return filewrite(f, p, n);
    800040a2:	fe442603          	lw	a2,-28(s0)
    800040a6:	fd843583          	ld	a1,-40(s0)
    800040aa:	fe843503          	ld	a0,-24(s0)
    800040ae:	d7aff0ef          	jal	80003628 <filewrite>
}
    800040b2:	70a2                	ld	ra,40(sp)
    800040b4:	7402                	ld	s0,32(sp)
    800040b6:	6145                	addi	sp,sp,48
    800040b8:	8082                	ret

00000000800040ba <sys_close>:
{
    800040ba:	1101                	addi	sp,sp,-32
    800040bc:	ec06                	sd	ra,24(sp)
    800040be:	e822                	sd	s0,16(sp)
    800040c0:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040c2:	fe040613          	addi	a2,s0,-32
    800040c6:	fec40593          	addi	a1,s0,-20
    800040ca:	4501                	li	a0,0
    800040cc:	d43ff0ef          	jal	80003e0e <argfd>
    return -1;
    800040d0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040d2:	02054063          	bltz	a0,800040f2 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    800040d6:	cd3fc0ef          	jal	80000da8 <myproc>
    800040da:	fec42783          	lw	a5,-20(s0)
    800040de:	07e9                	addi	a5,a5,26
    800040e0:	078e                	slli	a5,a5,0x3
    800040e2:	953e                	add	a0,a0,a5
    800040e4:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800040e8:	fe043503          	ld	a0,-32(s0)
    800040ec:	b5eff0ef          	jal	8000344a <fileclose>
  return 0;
    800040f0:	4781                	li	a5,0
}
    800040f2:	853e                	mv	a0,a5
    800040f4:	60e2                	ld	ra,24(sp)
    800040f6:	6442                	ld	s0,16(sp)
    800040f8:	6105                	addi	sp,sp,32
    800040fa:	8082                	ret

00000000800040fc <sys_fstat>:
{
    800040fc:	1101                	addi	sp,sp,-32
    800040fe:	ec06                	sd	ra,24(sp)
    80004100:	e822                	sd	s0,16(sp)
    80004102:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004104:	fe040593          	addi	a1,s0,-32
    80004108:	4505                	li	a0,1
    8000410a:	bc5fd0ef          	jal	80001cce <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000410e:	fe840613          	addi	a2,s0,-24
    80004112:	4581                	li	a1,0
    80004114:	4501                	li	a0,0
    80004116:	cf9ff0ef          	jal	80003e0e <argfd>
    8000411a:	87aa                	mv	a5,a0
    return -1;
    8000411c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000411e:	0007c863          	bltz	a5,8000412e <sys_fstat+0x32>
  return filestat(f, st);
    80004122:	fe043583          	ld	a1,-32(s0)
    80004126:	fe843503          	ld	a0,-24(s0)
    8000412a:	be2ff0ef          	jal	8000350c <filestat>
}
    8000412e:	60e2                	ld	ra,24(sp)
    80004130:	6442                	ld	s0,16(sp)
    80004132:	6105                	addi	sp,sp,32
    80004134:	8082                	ret

0000000080004136 <sys_link>:
{
    80004136:	7169                	addi	sp,sp,-304
    80004138:	f606                	sd	ra,296(sp)
    8000413a:	f222                	sd	s0,288(sp)
    8000413c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000413e:	08000613          	li	a2,128
    80004142:	ed040593          	addi	a1,s0,-304
    80004146:	4501                	li	a0,0
    80004148:	ba3fd0ef          	jal	80001cea <argstr>
    return -1;
    8000414c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000414e:	0c054e63          	bltz	a0,8000422a <sys_link+0xf4>
    80004152:	08000613          	li	a2,128
    80004156:	f5040593          	addi	a1,s0,-176
    8000415a:	4505                	li	a0,1
    8000415c:	b8ffd0ef          	jal	80001cea <argstr>
    return -1;
    80004160:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004162:	0c054463          	bltz	a0,8000422a <sys_link+0xf4>
    80004166:	ee26                	sd	s1,280(sp)
  begin_op();
    80004168:	ec9fe0ef          	jal	80003030 <begin_op>
  if((ip = namei(old)) == 0){
    8000416c:	ed040513          	addi	a0,s0,-304
    80004170:	d05fe0ef          	jal	80002e74 <namei>
    80004174:	84aa                	mv	s1,a0
    80004176:	c53d                	beqz	a0,800041e4 <sys_link+0xae>
  ilock(ip);
    80004178:	e22fe0ef          	jal	8000279a <ilock>
  if(ip->type == T_DIR){
    8000417c:	04449703          	lh	a4,68(s1)
    80004180:	4785                	li	a5,1
    80004182:	06f70663          	beq	a4,a5,800041ee <sys_link+0xb8>
    80004186:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004188:	04a4d783          	lhu	a5,74(s1)
    8000418c:	2785                	addiw	a5,a5,1
    8000418e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004192:	8526                	mv	a0,s1
    80004194:	d52fe0ef          	jal	800026e6 <iupdate>
  iunlock(ip);
    80004198:	8526                	mv	a0,s1
    8000419a:	eaefe0ef          	jal	80002848 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000419e:	fd040593          	addi	a1,s0,-48
    800041a2:	f5040513          	addi	a0,s0,-176
    800041a6:	ce9fe0ef          	jal	80002e8e <nameiparent>
    800041aa:	892a                	mv	s2,a0
    800041ac:	cd21                	beqz	a0,80004204 <sys_link+0xce>
  ilock(dp);
    800041ae:	decfe0ef          	jal	8000279a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041b2:	00092703          	lw	a4,0(s2)
    800041b6:	409c                	lw	a5,0(s1)
    800041b8:	04f71363          	bne	a4,a5,800041fe <sys_link+0xc8>
    800041bc:	40d0                	lw	a2,4(s1)
    800041be:	fd040593          	addi	a1,s0,-48
    800041c2:	854a                	mv	a0,s2
    800041c4:	c17fe0ef          	jal	80002dda <dirlink>
    800041c8:	02054b63          	bltz	a0,800041fe <sys_link+0xc8>
  iunlockput(dp);
    800041cc:	854a                	mv	a0,s2
    800041ce:	fd6fe0ef          	jal	800029a4 <iunlockput>
  iput(ip);
    800041d2:	8526                	mv	a0,s1
    800041d4:	f48fe0ef          	jal	8000291c <iput>
  end_op();
    800041d8:	ec3fe0ef          	jal	8000309a <end_op>
  return 0;
    800041dc:	4781                	li	a5,0
    800041de:	64f2                	ld	s1,280(sp)
    800041e0:	6952                	ld	s2,272(sp)
    800041e2:	a0a1                	j	8000422a <sys_link+0xf4>
    end_op();
    800041e4:	eb7fe0ef          	jal	8000309a <end_op>
    return -1;
    800041e8:	57fd                	li	a5,-1
    800041ea:	64f2                	ld	s1,280(sp)
    800041ec:	a83d                	j	8000422a <sys_link+0xf4>
    iunlockput(ip);
    800041ee:	8526                	mv	a0,s1
    800041f0:	fb4fe0ef          	jal	800029a4 <iunlockput>
    end_op();
    800041f4:	ea7fe0ef          	jal	8000309a <end_op>
    return -1;
    800041f8:	57fd                	li	a5,-1
    800041fa:	64f2                	ld	s1,280(sp)
    800041fc:	a03d                	j	8000422a <sys_link+0xf4>
    iunlockput(dp);
    800041fe:	854a                	mv	a0,s2
    80004200:	fa4fe0ef          	jal	800029a4 <iunlockput>
  ilock(ip);
    80004204:	8526                	mv	a0,s1
    80004206:	d94fe0ef          	jal	8000279a <ilock>
  ip->nlink--;
    8000420a:	04a4d783          	lhu	a5,74(s1)
    8000420e:	37fd                	addiw	a5,a5,-1
    80004210:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004214:	8526                	mv	a0,s1
    80004216:	cd0fe0ef          	jal	800026e6 <iupdate>
  iunlockput(ip);
    8000421a:	8526                	mv	a0,s1
    8000421c:	f88fe0ef          	jal	800029a4 <iunlockput>
  end_op();
    80004220:	e7bfe0ef          	jal	8000309a <end_op>
  return -1;
    80004224:	57fd                	li	a5,-1
    80004226:	64f2                	ld	s1,280(sp)
    80004228:	6952                	ld	s2,272(sp)
}
    8000422a:	853e                	mv	a0,a5
    8000422c:	70b2                	ld	ra,296(sp)
    8000422e:	7412                	ld	s0,288(sp)
    80004230:	6155                	addi	sp,sp,304
    80004232:	8082                	ret

0000000080004234 <sys_unlink>:
{
    80004234:	7151                	addi	sp,sp,-240
    80004236:	f586                	sd	ra,232(sp)
    80004238:	f1a2                	sd	s0,224(sp)
    8000423a:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000423c:	08000613          	li	a2,128
    80004240:	f3040593          	addi	a1,s0,-208
    80004244:	4501                	li	a0,0
    80004246:	aa5fd0ef          	jal	80001cea <argstr>
    8000424a:	16054063          	bltz	a0,800043aa <sys_unlink+0x176>
    8000424e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004250:	de1fe0ef          	jal	80003030 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004254:	fb040593          	addi	a1,s0,-80
    80004258:	f3040513          	addi	a0,s0,-208
    8000425c:	c33fe0ef          	jal	80002e8e <nameiparent>
    80004260:	84aa                	mv	s1,a0
    80004262:	c945                	beqz	a0,80004312 <sys_unlink+0xde>
  ilock(dp);
    80004264:	d36fe0ef          	jal	8000279a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004268:	00003597          	auipc	a1,0x3
    8000426c:	43058593          	addi	a1,a1,1072 # 80007698 <etext+0x698>
    80004270:	fb040513          	addi	a0,s0,-80
    80004274:	985fe0ef          	jal	80002bf8 <namecmp>
    80004278:	10050e63          	beqz	a0,80004394 <sys_unlink+0x160>
    8000427c:	00003597          	auipc	a1,0x3
    80004280:	42458593          	addi	a1,a1,1060 # 800076a0 <etext+0x6a0>
    80004284:	fb040513          	addi	a0,s0,-80
    80004288:	971fe0ef          	jal	80002bf8 <namecmp>
    8000428c:	10050463          	beqz	a0,80004394 <sys_unlink+0x160>
    80004290:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004292:	f2c40613          	addi	a2,s0,-212
    80004296:	fb040593          	addi	a1,s0,-80
    8000429a:	8526                	mv	a0,s1
    8000429c:	973fe0ef          	jal	80002c0e <dirlookup>
    800042a0:	892a                	mv	s2,a0
    800042a2:	0e050863          	beqz	a0,80004392 <sys_unlink+0x15e>
  ilock(ip);
    800042a6:	cf4fe0ef          	jal	8000279a <ilock>
  if(ip->nlink < 1)
    800042aa:	04a91783          	lh	a5,74(s2)
    800042ae:	06f05763          	blez	a5,8000431c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042b2:	04491703          	lh	a4,68(s2)
    800042b6:	4785                	li	a5,1
    800042b8:	06f70963          	beq	a4,a5,8000432a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800042bc:	4641                	li	a2,16
    800042be:	4581                	li	a1,0
    800042c0:	fc040513          	addi	a0,s0,-64
    800042c4:	ecdfb0ef          	jal	80000190 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042c8:	4741                	li	a4,16
    800042ca:	f2c42683          	lw	a3,-212(s0)
    800042ce:	fc040613          	addi	a2,s0,-64
    800042d2:	4581                	li	a1,0
    800042d4:	8526                	mv	a0,s1
    800042d6:	815fe0ef          	jal	80002aea <writei>
    800042da:	47c1                	li	a5,16
    800042dc:	08f51b63          	bne	a0,a5,80004372 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    800042e0:	04491703          	lh	a4,68(s2)
    800042e4:	4785                	li	a5,1
    800042e6:	08f70d63          	beq	a4,a5,80004380 <sys_unlink+0x14c>
  iunlockput(dp);
    800042ea:	8526                	mv	a0,s1
    800042ec:	eb8fe0ef          	jal	800029a4 <iunlockput>
  ip->nlink--;
    800042f0:	04a95783          	lhu	a5,74(s2)
    800042f4:	37fd                	addiw	a5,a5,-1
    800042f6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800042fa:	854a                	mv	a0,s2
    800042fc:	beafe0ef          	jal	800026e6 <iupdate>
  iunlockput(ip);
    80004300:	854a                	mv	a0,s2
    80004302:	ea2fe0ef          	jal	800029a4 <iunlockput>
  end_op();
    80004306:	d95fe0ef          	jal	8000309a <end_op>
  return 0;
    8000430a:	4501                	li	a0,0
    8000430c:	64ee                	ld	s1,216(sp)
    8000430e:	694e                	ld	s2,208(sp)
    80004310:	a849                	j	800043a2 <sys_unlink+0x16e>
    end_op();
    80004312:	d89fe0ef          	jal	8000309a <end_op>
    return -1;
    80004316:	557d                	li	a0,-1
    80004318:	64ee                	ld	s1,216(sp)
    8000431a:	a061                	j	800043a2 <sys_unlink+0x16e>
    8000431c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000431e:	00003517          	auipc	a0,0x3
    80004322:	38a50513          	addi	a0,a0,906 # 800076a8 <etext+0x6a8>
    80004326:	27c010ef          	jal	800055a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000432a:	04c92703          	lw	a4,76(s2)
    8000432e:	02000793          	li	a5,32
    80004332:	f8e7f5e3          	bgeu	a5,a4,800042bc <sys_unlink+0x88>
    80004336:	e5ce                	sd	s3,200(sp)
    80004338:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000433c:	4741                	li	a4,16
    8000433e:	86ce                	mv	a3,s3
    80004340:	f1840613          	addi	a2,s0,-232
    80004344:	4581                	li	a1,0
    80004346:	854a                	mv	a0,s2
    80004348:	ea6fe0ef          	jal	800029ee <readi>
    8000434c:	47c1                	li	a5,16
    8000434e:	00f51c63          	bne	a0,a5,80004366 <sys_unlink+0x132>
    if(de.inum != 0)
    80004352:	f1845783          	lhu	a5,-232(s0)
    80004356:	efa1                	bnez	a5,800043ae <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004358:	29c1                	addiw	s3,s3,16
    8000435a:	04c92783          	lw	a5,76(s2)
    8000435e:	fcf9efe3          	bltu	s3,a5,8000433c <sys_unlink+0x108>
    80004362:	69ae                	ld	s3,200(sp)
    80004364:	bfa1                	j	800042bc <sys_unlink+0x88>
      panic("isdirempty: readi");
    80004366:	00003517          	auipc	a0,0x3
    8000436a:	35a50513          	addi	a0,a0,858 # 800076c0 <etext+0x6c0>
    8000436e:	234010ef          	jal	800055a2 <panic>
    80004372:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004374:	00003517          	auipc	a0,0x3
    80004378:	36450513          	addi	a0,a0,868 # 800076d8 <etext+0x6d8>
    8000437c:	226010ef          	jal	800055a2 <panic>
    dp->nlink--;
    80004380:	04a4d783          	lhu	a5,74(s1)
    80004384:	37fd                	addiw	a5,a5,-1
    80004386:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000438a:	8526                	mv	a0,s1
    8000438c:	b5afe0ef          	jal	800026e6 <iupdate>
    80004390:	bfa9                	j	800042ea <sys_unlink+0xb6>
    80004392:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004394:	8526                	mv	a0,s1
    80004396:	e0efe0ef          	jal	800029a4 <iunlockput>
  end_op();
    8000439a:	d01fe0ef          	jal	8000309a <end_op>
  return -1;
    8000439e:	557d                	li	a0,-1
    800043a0:	64ee                	ld	s1,216(sp)
}
    800043a2:	70ae                	ld	ra,232(sp)
    800043a4:	740e                	ld	s0,224(sp)
    800043a6:	616d                	addi	sp,sp,240
    800043a8:	8082                	ret
    return -1;
    800043aa:	557d                	li	a0,-1
    800043ac:	bfdd                	j	800043a2 <sys_unlink+0x16e>
    iunlockput(ip);
    800043ae:	854a                	mv	a0,s2
    800043b0:	df4fe0ef          	jal	800029a4 <iunlockput>
    goto bad;
    800043b4:	694e                	ld	s2,208(sp)
    800043b6:	69ae                	ld	s3,200(sp)
    800043b8:	bff1                	j	80004394 <sys_unlink+0x160>

00000000800043ba <sys_open>:

uint64
sys_open(void)
{
    800043ba:	7131                	addi	sp,sp,-192
    800043bc:	fd06                	sd	ra,184(sp)
    800043be:	f922                	sd	s0,176(sp)
    800043c0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043c2:	f4c40593          	addi	a1,s0,-180
    800043c6:	4505                	li	a0,1
    800043c8:	8ebfd0ef          	jal	80001cb2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043cc:	08000613          	li	a2,128
    800043d0:	f5040593          	addi	a1,s0,-176
    800043d4:	4501                	li	a0,0
    800043d6:	915fd0ef          	jal	80001cea <argstr>
    800043da:	87aa                	mv	a5,a0
    return -1;
    800043dc:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043de:	0a07c263          	bltz	a5,80004482 <sys_open+0xc8>
    800043e2:	f526                	sd	s1,168(sp)

  begin_op();
    800043e4:	c4dfe0ef          	jal	80003030 <begin_op>

  if(omode & O_CREATE){
    800043e8:	f4c42783          	lw	a5,-180(s0)
    800043ec:	2007f793          	andi	a5,a5,512
    800043f0:	c3d5                	beqz	a5,80004494 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    800043f2:	4681                	li	a3,0
    800043f4:	4601                	li	a2,0
    800043f6:	4589                	li	a1,2
    800043f8:	f5040513          	addi	a0,s0,-176
    800043fc:	aa9ff0ef          	jal	80003ea4 <create>
    80004400:	84aa                	mv	s1,a0
    if(ip == 0){
    80004402:	c541                	beqz	a0,8000448a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004404:	04449703          	lh	a4,68(s1)
    80004408:	478d                	li	a5,3
    8000440a:	00f71763          	bne	a4,a5,80004418 <sys_open+0x5e>
    8000440e:	0464d703          	lhu	a4,70(s1)
    80004412:	47a5                	li	a5,9
    80004414:	0ae7ed63          	bltu	a5,a4,800044ce <sys_open+0x114>
    80004418:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000441a:	f8dfe0ef          	jal	800033a6 <filealloc>
    8000441e:	892a                	mv	s2,a0
    80004420:	c179                	beqz	a0,800044e6 <sys_open+0x12c>
    80004422:	ed4e                	sd	s3,152(sp)
    80004424:	a43ff0ef          	jal	80003e66 <fdalloc>
    80004428:	89aa                	mv	s3,a0
    8000442a:	0a054a63          	bltz	a0,800044de <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000442e:	04449703          	lh	a4,68(s1)
    80004432:	478d                	li	a5,3
    80004434:	0cf70263          	beq	a4,a5,800044f8 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004438:	4789                	li	a5,2
    8000443a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000443e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004442:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004446:	f4c42783          	lw	a5,-180(s0)
    8000444a:	0017c713          	xori	a4,a5,1
    8000444e:	8b05                	andi	a4,a4,1
    80004450:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004454:	0037f713          	andi	a4,a5,3
    80004458:	00e03733          	snez	a4,a4
    8000445c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004460:	4007f793          	andi	a5,a5,1024
    80004464:	c791                	beqz	a5,80004470 <sys_open+0xb6>
    80004466:	04449703          	lh	a4,68(s1)
    8000446a:	4789                	li	a5,2
    8000446c:	08f70d63          	beq	a4,a5,80004506 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80004470:	8526                	mv	a0,s1
    80004472:	bd6fe0ef          	jal	80002848 <iunlock>
  end_op();
    80004476:	c25fe0ef          	jal	8000309a <end_op>

  return fd;
    8000447a:	854e                	mv	a0,s3
    8000447c:	74aa                	ld	s1,168(sp)
    8000447e:	790a                	ld	s2,160(sp)
    80004480:	69ea                	ld	s3,152(sp)
}
    80004482:	70ea                	ld	ra,184(sp)
    80004484:	744a                	ld	s0,176(sp)
    80004486:	6129                	addi	sp,sp,192
    80004488:	8082                	ret
      end_op();
    8000448a:	c11fe0ef          	jal	8000309a <end_op>
      return -1;
    8000448e:	557d                	li	a0,-1
    80004490:	74aa                	ld	s1,168(sp)
    80004492:	bfc5                	j	80004482 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80004494:	f5040513          	addi	a0,s0,-176
    80004498:	9ddfe0ef          	jal	80002e74 <namei>
    8000449c:	84aa                	mv	s1,a0
    8000449e:	c11d                	beqz	a0,800044c4 <sys_open+0x10a>
    ilock(ip);
    800044a0:	afafe0ef          	jal	8000279a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044a4:	04449703          	lh	a4,68(s1)
    800044a8:	4785                	li	a5,1
    800044aa:	f4f71de3          	bne	a4,a5,80004404 <sys_open+0x4a>
    800044ae:	f4c42783          	lw	a5,-180(s0)
    800044b2:	d3bd                	beqz	a5,80004418 <sys_open+0x5e>
      iunlockput(ip);
    800044b4:	8526                	mv	a0,s1
    800044b6:	ceefe0ef          	jal	800029a4 <iunlockput>
      end_op();
    800044ba:	be1fe0ef          	jal	8000309a <end_op>
      return -1;
    800044be:	557d                	li	a0,-1
    800044c0:	74aa                	ld	s1,168(sp)
    800044c2:	b7c1                	j	80004482 <sys_open+0xc8>
      end_op();
    800044c4:	bd7fe0ef          	jal	8000309a <end_op>
      return -1;
    800044c8:	557d                	li	a0,-1
    800044ca:	74aa                	ld	s1,168(sp)
    800044cc:	bf5d                	j	80004482 <sys_open+0xc8>
    iunlockput(ip);
    800044ce:	8526                	mv	a0,s1
    800044d0:	cd4fe0ef          	jal	800029a4 <iunlockput>
    end_op();
    800044d4:	bc7fe0ef          	jal	8000309a <end_op>
    return -1;
    800044d8:	557d                	li	a0,-1
    800044da:	74aa                	ld	s1,168(sp)
    800044dc:	b75d                	j	80004482 <sys_open+0xc8>
      fileclose(f);
    800044de:	854a                	mv	a0,s2
    800044e0:	f6bfe0ef          	jal	8000344a <fileclose>
    800044e4:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044e6:	8526                	mv	a0,s1
    800044e8:	cbcfe0ef          	jal	800029a4 <iunlockput>
    end_op();
    800044ec:	baffe0ef          	jal	8000309a <end_op>
    return -1;
    800044f0:	557d                	li	a0,-1
    800044f2:	74aa                	ld	s1,168(sp)
    800044f4:	790a                	ld	s2,160(sp)
    800044f6:	b771                	j	80004482 <sys_open+0xc8>
    f->type = FD_DEVICE;
    800044f8:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    800044fc:	04649783          	lh	a5,70(s1)
    80004500:	02f91223          	sh	a5,36(s2)
    80004504:	bf3d                	j	80004442 <sys_open+0x88>
    itrunc(ip);
    80004506:	8526                	mv	a0,s1
    80004508:	b80fe0ef          	jal	80002888 <itrunc>
    8000450c:	b795                	j	80004470 <sys_open+0xb6>

000000008000450e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000450e:	7175                	addi	sp,sp,-144
    80004510:	e506                	sd	ra,136(sp)
    80004512:	e122                	sd	s0,128(sp)
    80004514:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004516:	b1bfe0ef          	jal	80003030 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000451a:	08000613          	li	a2,128
    8000451e:	f7040593          	addi	a1,s0,-144
    80004522:	4501                	li	a0,0
    80004524:	fc6fd0ef          	jal	80001cea <argstr>
    80004528:	02054363          	bltz	a0,8000454e <sys_mkdir+0x40>
    8000452c:	4681                	li	a3,0
    8000452e:	4601                	li	a2,0
    80004530:	4585                	li	a1,1
    80004532:	f7040513          	addi	a0,s0,-144
    80004536:	96fff0ef          	jal	80003ea4 <create>
    8000453a:	c911                	beqz	a0,8000454e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000453c:	c68fe0ef          	jal	800029a4 <iunlockput>
  end_op();
    80004540:	b5bfe0ef          	jal	8000309a <end_op>
  return 0;
    80004544:	4501                	li	a0,0
}
    80004546:	60aa                	ld	ra,136(sp)
    80004548:	640a                	ld	s0,128(sp)
    8000454a:	6149                	addi	sp,sp,144
    8000454c:	8082                	ret
    end_op();
    8000454e:	b4dfe0ef          	jal	8000309a <end_op>
    return -1;
    80004552:	557d                	li	a0,-1
    80004554:	bfcd                	j	80004546 <sys_mkdir+0x38>

0000000080004556 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004556:	7135                	addi	sp,sp,-160
    80004558:	ed06                	sd	ra,152(sp)
    8000455a:	e922                	sd	s0,144(sp)
    8000455c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000455e:	ad3fe0ef          	jal	80003030 <begin_op>
  argint(1, &major);
    80004562:	f6c40593          	addi	a1,s0,-148
    80004566:	4505                	li	a0,1
    80004568:	f4afd0ef          	jal	80001cb2 <argint>
  argint(2, &minor);
    8000456c:	f6840593          	addi	a1,s0,-152
    80004570:	4509                	li	a0,2
    80004572:	f40fd0ef          	jal	80001cb2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004576:	08000613          	li	a2,128
    8000457a:	f7040593          	addi	a1,s0,-144
    8000457e:	4501                	li	a0,0
    80004580:	f6afd0ef          	jal	80001cea <argstr>
    80004584:	02054563          	bltz	a0,800045ae <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004588:	f6841683          	lh	a3,-152(s0)
    8000458c:	f6c41603          	lh	a2,-148(s0)
    80004590:	458d                	li	a1,3
    80004592:	f7040513          	addi	a0,s0,-144
    80004596:	90fff0ef          	jal	80003ea4 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000459a:	c911                	beqz	a0,800045ae <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000459c:	c08fe0ef          	jal	800029a4 <iunlockput>
  end_op();
    800045a0:	afbfe0ef          	jal	8000309a <end_op>
  return 0;
    800045a4:	4501                	li	a0,0
}
    800045a6:	60ea                	ld	ra,152(sp)
    800045a8:	644a                	ld	s0,144(sp)
    800045aa:	610d                	addi	sp,sp,160
    800045ac:	8082                	ret
    end_op();
    800045ae:	aedfe0ef          	jal	8000309a <end_op>
    return -1;
    800045b2:	557d                	li	a0,-1
    800045b4:	bfcd                	j	800045a6 <sys_mknod+0x50>

00000000800045b6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045b6:	7135                	addi	sp,sp,-160
    800045b8:	ed06                	sd	ra,152(sp)
    800045ba:	e922                	sd	s0,144(sp)
    800045bc:	e14a                	sd	s2,128(sp)
    800045be:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045c0:	fe8fc0ef          	jal	80000da8 <myproc>
    800045c4:	892a                	mv	s2,a0
  
  begin_op();
    800045c6:	a6bfe0ef          	jal	80003030 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045ca:	08000613          	li	a2,128
    800045ce:	f6040593          	addi	a1,s0,-160
    800045d2:	4501                	li	a0,0
    800045d4:	f16fd0ef          	jal	80001cea <argstr>
    800045d8:	04054363          	bltz	a0,8000461e <sys_chdir+0x68>
    800045dc:	e526                	sd	s1,136(sp)
    800045de:	f6040513          	addi	a0,s0,-160
    800045e2:	893fe0ef          	jal	80002e74 <namei>
    800045e6:	84aa                	mv	s1,a0
    800045e8:	c915                	beqz	a0,8000461c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800045ea:	9b0fe0ef          	jal	8000279a <ilock>
  if(ip->type != T_DIR){
    800045ee:	04449703          	lh	a4,68(s1)
    800045f2:	4785                	li	a5,1
    800045f4:	02f71963          	bne	a4,a5,80004626 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800045f8:	8526                	mv	a0,s1
    800045fa:	a4efe0ef          	jal	80002848 <iunlock>
  iput(p->cwd);
    800045fe:	15093503          	ld	a0,336(s2)
    80004602:	b1afe0ef          	jal	8000291c <iput>
  end_op();
    80004606:	a95fe0ef          	jal	8000309a <end_op>
  p->cwd = ip;
    8000460a:	14993823          	sd	s1,336(s2)
  return 0;
    8000460e:	4501                	li	a0,0
    80004610:	64aa                	ld	s1,136(sp)
}
    80004612:	60ea                	ld	ra,152(sp)
    80004614:	644a                	ld	s0,144(sp)
    80004616:	690a                	ld	s2,128(sp)
    80004618:	610d                	addi	sp,sp,160
    8000461a:	8082                	ret
    8000461c:	64aa                	ld	s1,136(sp)
    end_op();
    8000461e:	a7dfe0ef          	jal	8000309a <end_op>
    return -1;
    80004622:	557d                	li	a0,-1
    80004624:	b7fd                	j	80004612 <sys_chdir+0x5c>
    iunlockput(ip);
    80004626:	8526                	mv	a0,s1
    80004628:	b7cfe0ef          	jal	800029a4 <iunlockput>
    end_op();
    8000462c:	a6ffe0ef          	jal	8000309a <end_op>
    return -1;
    80004630:	557d                	li	a0,-1
    80004632:	64aa                	ld	s1,136(sp)
    80004634:	bff9                	j	80004612 <sys_chdir+0x5c>

0000000080004636 <sys_exec>:

uint64
sys_exec(void)
{
    80004636:	7121                	addi	sp,sp,-448
    80004638:	ff06                	sd	ra,440(sp)
    8000463a:	fb22                	sd	s0,432(sp)
    8000463c:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000463e:	e4840593          	addi	a1,s0,-440
    80004642:	4505                	li	a0,1
    80004644:	e8afd0ef          	jal	80001cce <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004648:	08000613          	li	a2,128
    8000464c:	f5040593          	addi	a1,s0,-176
    80004650:	4501                	li	a0,0
    80004652:	e98fd0ef          	jal	80001cea <argstr>
    80004656:	87aa                	mv	a5,a0
    return -1;
    80004658:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000465a:	0c07c463          	bltz	a5,80004722 <sys_exec+0xec>
    8000465e:	f726                	sd	s1,424(sp)
    80004660:	f34a                	sd	s2,416(sp)
    80004662:	ef4e                	sd	s3,408(sp)
    80004664:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004666:	10000613          	li	a2,256
    8000466a:	4581                	li	a1,0
    8000466c:	e5040513          	addi	a0,s0,-432
    80004670:	b21fb0ef          	jal	80000190 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004674:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004678:	89a6                	mv	s3,s1
    8000467a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000467c:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004680:	00391513          	slli	a0,s2,0x3
    80004684:	e4040593          	addi	a1,s0,-448
    80004688:	e4843783          	ld	a5,-440(s0)
    8000468c:	953e                	add	a0,a0,a5
    8000468e:	d9afd0ef          	jal	80001c28 <fetchaddr>
    80004692:	02054663          	bltz	a0,800046be <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80004696:	e4043783          	ld	a5,-448(s0)
    8000469a:	c3a9                	beqz	a5,800046dc <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000469c:	a63fb0ef          	jal	800000fe <kalloc>
    800046a0:	85aa                	mv	a1,a0
    800046a2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046a6:	cd01                	beqz	a0,800046be <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046a8:	6605                	lui	a2,0x1
    800046aa:	e4043503          	ld	a0,-448(s0)
    800046ae:	dc4fd0ef          	jal	80001c72 <fetchstr>
    800046b2:	00054663          	bltz	a0,800046be <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800046b6:	0905                	addi	s2,s2,1
    800046b8:	09a1                	addi	s3,s3,8
    800046ba:	fd4913e3          	bne	s2,s4,80004680 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046be:	f5040913          	addi	s2,s0,-176
    800046c2:	6088                	ld	a0,0(s1)
    800046c4:	c931                	beqz	a0,80004718 <sys_exec+0xe2>
    kfree(argv[i]);
    800046c6:	957fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ca:	04a1                	addi	s1,s1,8
    800046cc:	ff249be3          	bne	s1,s2,800046c2 <sys_exec+0x8c>
  return -1;
    800046d0:	557d                	li	a0,-1
    800046d2:	74ba                	ld	s1,424(sp)
    800046d4:	791a                	ld	s2,416(sp)
    800046d6:	69fa                	ld	s3,408(sp)
    800046d8:	6a5a                	ld	s4,400(sp)
    800046da:	a0a1                	j	80004722 <sys_exec+0xec>
      argv[i] = 0;
    800046dc:	0009079b          	sext.w	a5,s2
    800046e0:	078e                	slli	a5,a5,0x3
    800046e2:	fd078793          	addi	a5,a5,-48
    800046e6:	97a2                	add	a5,a5,s0
    800046e8:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    800046ec:	e5040593          	addi	a1,s0,-432
    800046f0:	f5040513          	addi	a0,s0,-176
    800046f4:	ba8ff0ef          	jal	80003a9c <exec>
    800046f8:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046fa:	f5040993          	addi	s3,s0,-176
    800046fe:	6088                	ld	a0,0(s1)
    80004700:	c511                	beqz	a0,8000470c <sys_exec+0xd6>
    kfree(argv[i]);
    80004702:	91bfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004706:	04a1                	addi	s1,s1,8
    80004708:	ff349be3          	bne	s1,s3,800046fe <sys_exec+0xc8>
  return ret;
    8000470c:	854a                	mv	a0,s2
    8000470e:	74ba                	ld	s1,424(sp)
    80004710:	791a                	ld	s2,416(sp)
    80004712:	69fa                	ld	s3,408(sp)
    80004714:	6a5a                	ld	s4,400(sp)
    80004716:	a031                	j	80004722 <sys_exec+0xec>
  return -1;
    80004718:	557d                	li	a0,-1
    8000471a:	74ba                	ld	s1,424(sp)
    8000471c:	791a                	ld	s2,416(sp)
    8000471e:	69fa                	ld	s3,408(sp)
    80004720:	6a5a                	ld	s4,400(sp)
}
    80004722:	70fa                	ld	ra,440(sp)
    80004724:	745a                	ld	s0,432(sp)
    80004726:	6139                	addi	sp,sp,448
    80004728:	8082                	ret

000000008000472a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000472a:	7139                	addi	sp,sp,-64
    8000472c:	fc06                	sd	ra,56(sp)
    8000472e:	f822                	sd	s0,48(sp)
    80004730:	f426                	sd	s1,40(sp)
    80004732:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004734:	e74fc0ef          	jal	80000da8 <myproc>
    80004738:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000473a:	fd840593          	addi	a1,s0,-40
    8000473e:	4501                	li	a0,0
    80004740:	d8efd0ef          	jal	80001cce <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004744:	fc840593          	addi	a1,s0,-56
    80004748:	fd040513          	addi	a0,s0,-48
    8000474c:	85cff0ef          	jal	800037a8 <pipealloc>
    return -1;
    80004750:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004752:	0a054463          	bltz	a0,800047fa <sys_pipe+0xd0>
  fd0 = -1;
    80004756:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000475a:	fd043503          	ld	a0,-48(s0)
    8000475e:	f08ff0ef          	jal	80003e66 <fdalloc>
    80004762:	fca42223          	sw	a0,-60(s0)
    80004766:	08054163          	bltz	a0,800047e8 <sys_pipe+0xbe>
    8000476a:	fc843503          	ld	a0,-56(s0)
    8000476e:	ef8ff0ef          	jal	80003e66 <fdalloc>
    80004772:	fca42023          	sw	a0,-64(s0)
    80004776:	06054063          	bltz	a0,800047d6 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000477a:	4691                	li	a3,4
    8000477c:	fc440613          	addi	a2,s0,-60
    80004780:	fd843583          	ld	a1,-40(s0)
    80004784:	68a8                	ld	a0,80(s1)
    80004786:	a94fc0ef          	jal	80000a1a <copyout>
    8000478a:	00054e63          	bltz	a0,800047a6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000478e:	4691                	li	a3,4
    80004790:	fc040613          	addi	a2,s0,-64
    80004794:	fd843583          	ld	a1,-40(s0)
    80004798:	0591                	addi	a1,a1,4
    8000479a:	68a8                	ld	a0,80(s1)
    8000479c:	a7efc0ef          	jal	80000a1a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047a0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047a2:	04055c63          	bgez	a0,800047fa <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047a6:	fc442783          	lw	a5,-60(s0)
    800047aa:	07e9                	addi	a5,a5,26
    800047ac:	078e                	slli	a5,a5,0x3
    800047ae:	97a6                	add	a5,a5,s1
    800047b0:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047b4:	fc042783          	lw	a5,-64(s0)
    800047b8:	07e9                	addi	a5,a5,26
    800047ba:	078e                	slli	a5,a5,0x3
    800047bc:	94be                	add	s1,s1,a5
    800047be:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800047c2:	fd043503          	ld	a0,-48(s0)
    800047c6:	c85fe0ef          	jal	8000344a <fileclose>
    fileclose(wf);
    800047ca:	fc843503          	ld	a0,-56(s0)
    800047ce:	c7dfe0ef          	jal	8000344a <fileclose>
    return -1;
    800047d2:	57fd                	li	a5,-1
    800047d4:	a01d                	j	800047fa <sys_pipe+0xd0>
    if(fd0 >= 0)
    800047d6:	fc442783          	lw	a5,-60(s0)
    800047da:	0007c763          	bltz	a5,800047e8 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800047de:	07e9                	addi	a5,a5,26
    800047e0:	078e                	slli	a5,a5,0x3
    800047e2:	97a6                	add	a5,a5,s1
    800047e4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047e8:	fd043503          	ld	a0,-48(s0)
    800047ec:	c5ffe0ef          	jal	8000344a <fileclose>
    fileclose(wf);
    800047f0:	fc843503          	ld	a0,-56(s0)
    800047f4:	c57fe0ef          	jal	8000344a <fileclose>
    return -1;
    800047f8:	57fd                	li	a5,-1
}
    800047fa:	853e                	mv	a0,a5
    800047fc:	70e2                	ld	ra,56(sp)
    800047fe:	7442                	ld	s0,48(sp)
    80004800:	74a2                	ld	s1,40(sp)
    80004802:	6121                	addi	sp,sp,64
    80004804:	8082                	ret
	...

0000000080004810 <kernelvec>:
    80004810:	7111                	addi	sp,sp,-256
    80004812:	e006                	sd	ra,0(sp)
    80004814:	e40a                	sd	sp,8(sp)
    80004816:	e80e                	sd	gp,16(sp)
    80004818:	ec12                	sd	tp,24(sp)
    8000481a:	f016                	sd	t0,32(sp)
    8000481c:	f41a                	sd	t1,40(sp)
    8000481e:	f81e                	sd	t2,48(sp)
    80004820:	e4aa                	sd	a0,72(sp)
    80004822:	e8ae                	sd	a1,80(sp)
    80004824:	ecb2                	sd	a2,88(sp)
    80004826:	f0b6                	sd	a3,96(sp)
    80004828:	f4ba                	sd	a4,104(sp)
    8000482a:	f8be                	sd	a5,112(sp)
    8000482c:	fcc2                	sd	a6,120(sp)
    8000482e:	e146                	sd	a7,128(sp)
    80004830:	edf2                	sd	t3,216(sp)
    80004832:	f1f6                	sd	t4,224(sp)
    80004834:	f5fa                	sd	t5,232(sp)
    80004836:	f9fe                	sd	t6,240(sp)
    80004838:	b00fd0ef          	jal	80001b38 <kerneltrap>
    8000483c:	6082                	ld	ra,0(sp)
    8000483e:	6122                	ld	sp,8(sp)
    80004840:	61c2                	ld	gp,16(sp)
    80004842:	7282                	ld	t0,32(sp)
    80004844:	7322                	ld	t1,40(sp)
    80004846:	73c2                	ld	t2,48(sp)
    80004848:	6526                	ld	a0,72(sp)
    8000484a:	65c6                	ld	a1,80(sp)
    8000484c:	6666                	ld	a2,88(sp)
    8000484e:	7686                	ld	a3,96(sp)
    80004850:	7726                	ld	a4,104(sp)
    80004852:	77c6                	ld	a5,112(sp)
    80004854:	7866                	ld	a6,120(sp)
    80004856:	688a                	ld	a7,128(sp)
    80004858:	6e6e                	ld	t3,216(sp)
    8000485a:	7e8e                	ld	t4,224(sp)
    8000485c:	7f2e                	ld	t5,232(sp)
    8000485e:	7fce                	ld	t6,240(sp)
    80004860:	6111                	addi	sp,sp,256
    80004862:	10200073          	sret
	...

000000008000486e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000486e:	1141                	addi	sp,sp,-16
    80004870:	e422                	sd	s0,8(sp)
    80004872:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004874:	0c0007b7          	lui	a5,0xc000
    80004878:	4705                	li	a4,1
    8000487a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000487c:	0c0007b7          	lui	a5,0xc000
    80004880:	c3d8                	sw	a4,4(a5)
}
    80004882:	6422                	ld	s0,8(sp)
    80004884:	0141                	addi	sp,sp,16
    80004886:	8082                	ret

0000000080004888 <plicinithart>:

void
plicinithart(void)
{
    80004888:	1141                	addi	sp,sp,-16
    8000488a:	e406                	sd	ra,8(sp)
    8000488c:	e022                	sd	s0,0(sp)
    8000488e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004890:	cecfc0ef          	jal	80000d7c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004894:	0085171b          	slliw	a4,a0,0x8
    80004898:	0c0027b7          	lui	a5,0xc002
    8000489c:	97ba                	add	a5,a5,a4
    8000489e:	40200713          	li	a4,1026
    800048a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048a6:	00d5151b          	slliw	a0,a0,0xd
    800048aa:	0c2017b7          	lui	a5,0xc201
    800048ae:	97aa                	add	a5,a5,a0
    800048b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048b4:	60a2                	ld	ra,8(sp)
    800048b6:	6402                	ld	s0,0(sp)
    800048b8:	0141                	addi	sp,sp,16
    800048ba:	8082                	ret

00000000800048bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048bc:	1141                	addi	sp,sp,-16
    800048be:	e406                	sd	ra,8(sp)
    800048c0:	e022                	sd	s0,0(sp)
    800048c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048c4:	cb8fc0ef          	jal	80000d7c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048c8:	00d5151b          	slliw	a0,a0,0xd
    800048cc:	0c2017b7          	lui	a5,0xc201
    800048d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800048d2:	43c8                	lw	a0,4(a5)
    800048d4:	60a2                	ld	ra,8(sp)
    800048d6:	6402                	ld	s0,0(sp)
    800048d8:	0141                	addi	sp,sp,16
    800048da:	8082                	ret

00000000800048dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800048dc:	1101                	addi	sp,sp,-32
    800048de:	ec06                	sd	ra,24(sp)
    800048e0:	e822                	sd	s0,16(sp)
    800048e2:	e426                	sd	s1,8(sp)
    800048e4:	1000                	addi	s0,sp,32
    800048e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800048e8:	c94fc0ef          	jal	80000d7c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800048ec:	00d5151b          	slliw	a0,a0,0xd
    800048f0:	0c2017b7          	lui	a5,0xc201
    800048f4:	97aa                	add	a5,a5,a0
    800048f6:	c3c4                	sw	s1,4(a5)
}
    800048f8:	60e2                	ld	ra,24(sp)
    800048fa:	6442                	ld	s0,16(sp)
    800048fc:	64a2                	ld	s1,8(sp)
    800048fe:	6105                	addi	sp,sp,32
    80004900:	8082                	ret

0000000080004902 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004902:	1141                	addi	sp,sp,-16
    80004904:	e406                	sd	ra,8(sp)
    80004906:	e022                	sd	s0,0(sp)
    80004908:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000490a:	479d                	li	a5,7
    8000490c:	04a7ca63          	blt	a5,a0,80004960 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004910:	00014797          	auipc	a5,0x14
    80004914:	2a078793          	addi	a5,a5,672 # 80018bb0 <disk>
    80004918:	97aa                	add	a5,a5,a0
    8000491a:	0187c783          	lbu	a5,24(a5)
    8000491e:	e7b9                	bnez	a5,8000496c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004920:	00451693          	slli	a3,a0,0x4
    80004924:	00014797          	auipc	a5,0x14
    80004928:	28c78793          	addi	a5,a5,652 # 80018bb0 <disk>
    8000492c:	6398                	ld	a4,0(a5)
    8000492e:	9736                	add	a4,a4,a3
    80004930:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80004934:	6398                	ld	a4,0(a5)
    80004936:	9736                	add	a4,a4,a3
    80004938:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000493c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004940:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004944:	97aa                	add	a5,a5,a0
    80004946:	4705                	li	a4,1
    80004948:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000494c:	00014517          	auipc	a0,0x14
    80004950:	27c50513          	addi	a0,a0,636 # 80018bc8 <disk+0x18>
    80004954:	a77fc0ef          	jal	800013ca <wakeup>
}
    80004958:	60a2                	ld	ra,8(sp)
    8000495a:	6402                	ld	s0,0(sp)
    8000495c:	0141                	addi	sp,sp,16
    8000495e:	8082                	ret
    panic("free_desc 1");
    80004960:	00003517          	auipc	a0,0x3
    80004964:	d8850513          	addi	a0,a0,-632 # 800076e8 <etext+0x6e8>
    80004968:	43b000ef          	jal	800055a2 <panic>
    panic("free_desc 2");
    8000496c:	00003517          	auipc	a0,0x3
    80004970:	d8c50513          	addi	a0,a0,-628 # 800076f8 <etext+0x6f8>
    80004974:	42f000ef          	jal	800055a2 <panic>

0000000080004978 <virtio_disk_init>:
{
    80004978:	1101                	addi	sp,sp,-32
    8000497a:	ec06                	sd	ra,24(sp)
    8000497c:	e822                	sd	s0,16(sp)
    8000497e:	e426                	sd	s1,8(sp)
    80004980:	e04a                	sd	s2,0(sp)
    80004982:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004984:	00003597          	auipc	a1,0x3
    80004988:	d8458593          	addi	a1,a1,-636 # 80007708 <etext+0x708>
    8000498c:	00014517          	auipc	a0,0x14
    80004990:	34c50513          	addi	a0,a0,844 # 80018cd8 <disk+0x128>
    80004994:	6bd000ef          	jal	80005850 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004998:	100017b7          	lui	a5,0x10001
    8000499c:	4398                	lw	a4,0(a5)
    8000499e:	2701                	sext.w	a4,a4
    800049a0:	747277b7          	lui	a5,0x74727
    800049a4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049a8:	18f71063          	bne	a4,a5,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049ac:	100017b7          	lui	a5,0x10001
    800049b0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800049b2:	439c                	lw	a5,0(a5)
    800049b4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049b6:	4709                	li	a4,2
    800049b8:	16e79863          	bne	a5,a4,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049bc:	100017b7          	lui	a5,0x10001
    800049c0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800049c2:	439c                	lw	a5,0(a5)
    800049c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049c6:	16e79163          	bne	a5,a4,80004b28 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049ca:	100017b7          	lui	a5,0x10001
    800049ce:	47d8                	lw	a4,12(a5)
    800049d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049d2:	554d47b7          	lui	a5,0x554d4
    800049d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800049da:	14f71763          	bne	a4,a5,80004b28 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049de:	100017b7          	lui	a5,0x10001
    800049e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800049e6:	4705                	li	a4,1
    800049e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800049ea:	470d                	li	a4,3
    800049ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800049ee:	10001737          	lui	a4,0x10001
    800049f2:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800049f4:	c7ffe737          	lui	a4,0xc7ffe
    800049f8:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd96f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800049fc:	8ef9                	and	a3,a3,a4
    800049fe:	10001737          	lui	a4,0x10001
    80004a02:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a04:	472d                	li	a4,11
    80004a06:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a08:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a0c:	439c                	lw	a5,0(a5)
    80004a0e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a12:	8ba1                	andi	a5,a5,8
    80004a14:	12078063          	beqz	a5,80004b34 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a18:	100017b7          	lui	a5,0x10001
    80004a1c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a20:	100017b7          	lui	a5,0x10001
    80004a24:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80004a28:	439c                	lw	a5,0(a5)
    80004a2a:	2781                	sext.w	a5,a5
    80004a2c:	10079a63          	bnez	a5,80004b40 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a30:	100017b7          	lui	a5,0x10001
    80004a34:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80004a38:	439c                	lw	a5,0(a5)
    80004a3a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a3c:	10078863          	beqz	a5,80004b4c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80004a40:	471d                	li	a4,7
    80004a42:	10f77b63          	bgeu	a4,a5,80004b58 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80004a46:	eb8fb0ef          	jal	800000fe <kalloc>
    80004a4a:	00014497          	auipc	s1,0x14
    80004a4e:	16648493          	addi	s1,s1,358 # 80018bb0 <disk>
    80004a52:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a54:	eaafb0ef          	jal	800000fe <kalloc>
    80004a58:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a5a:	ea4fb0ef          	jal	800000fe <kalloc>
    80004a5e:	87aa                	mv	a5,a0
    80004a60:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a62:	6088                	ld	a0,0(s1)
    80004a64:	10050063          	beqz	a0,80004b64 <virtio_disk_init+0x1ec>
    80004a68:	00014717          	auipc	a4,0x14
    80004a6c:	15073703          	ld	a4,336(a4) # 80018bb8 <disk+0x8>
    80004a70:	0e070a63          	beqz	a4,80004b64 <virtio_disk_init+0x1ec>
    80004a74:	0e078863          	beqz	a5,80004b64 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80004a78:	6605                	lui	a2,0x1
    80004a7a:	4581                	li	a1,0
    80004a7c:	f14fb0ef          	jal	80000190 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a80:	00014497          	auipc	s1,0x14
    80004a84:	13048493          	addi	s1,s1,304 # 80018bb0 <disk>
    80004a88:	6605                	lui	a2,0x1
    80004a8a:	4581                	li	a1,0
    80004a8c:	6488                	ld	a0,8(s1)
    80004a8e:	f02fb0ef          	jal	80000190 <memset>
  memset(disk.used, 0, PGSIZE);
    80004a92:	6605                	lui	a2,0x1
    80004a94:	4581                	li	a1,0
    80004a96:	6888                	ld	a0,16(s1)
    80004a98:	ef8fb0ef          	jal	80000190 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004a9c:	100017b7          	lui	a5,0x10001
    80004aa0:	4721                	li	a4,8
    80004aa2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004aa4:	4098                	lw	a4,0(s1)
    80004aa6:	100017b7          	lui	a5,0x10001
    80004aaa:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004aae:	40d8                	lw	a4,4(s1)
    80004ab0:	100017b7          	lui	a5,0x10001
    80004ab4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004ab8:	649c                	ld	a5,8(s1)
    80004aba:	0007869b          	sext.w	a3,a5
    80004abe:	10001737          	lui	a4,0x10001
    80004ac2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004ac6:	9781                	srai	a5,a5,0x20
    80004ac8:	10001737          	lui	a4,0x10001
    80004acc:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004ad0:	689c                	ld	a5,16(s1)
    80004ad2:	0007869b          	sext.w	a3,a5
    80004ad6:	10001737          	lui	a4,0x10001
    80004ada:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004ade:	9781                	srai	a5,a5,0x20
    80004ae0:	10001737          	lui	a4,0x10001
    80004ae4:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004ae8:	10001737          	lui	a4,0x10001
    80004aec:	4785                	li	a5,1
    80004aee:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004af0:	00f48c23          	sb	a5,24(s1)
    80004af4:	00f48ca3          	sb	a5,25(s1)
    80004af8:	00f48d23          	sb	a5,26(s1)
    80004afc:	00f48da3          	sb	a5,27(s1)
    80004b00:	00f48e23          	sb	a5,28(s1)
    80004b04:	00f48ea3          	sb	a5,29(s1)
    80004b08:	00f48f23          	sb	a5,30(s1)
    80004b0c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b10:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b14:	100017b7          	lui	a5,0x10001
    80004b18:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80004b1c:	60e2                	ld	ra,24(sp)
    80004b1e:	6442                	ld	s0,16(sp)
    80004b20:	64a2                	ld	s1,8(sp)
    80004b22:	6902                	ld	s2,0(sp)
    80004b24:	6105                	addi	sp,sp,32
    80004b26:	8082                	ret
    panic("could not find virtio disk");
    80004b28:	00003517          	auipc	a0,0x3
    80004b2c:	bf050513          	addi	a0,a0,-1040 # 80007718 <etext+0x718>
    80004b30:	273000ef          	jal	800055a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b34:	00003517          	auipc	a0,0x3
    80004b38:	c0450513          	addi	a0,a0,-1020 # 80007738 <etext+0x738>
    80004b3c:	267000ef          	jal	800055a2 <panic>
    panic("virtio disk should not be ready");
    80004b40:	00003517          	auipc	a0,0x3
    80004b44:	c1850513          	addi	a0,a0,-1000 # 80007758 <etext+0x758>
    80004b48:	25b000ef          	jal	800055a2 <panic>
    panic("virtio disk has no queue 0");
    80004b4c:	00003517          	auipc	a0,0x3
    80004b50:	c2c50513          	addi	a0,a0,-980 # 80007778 <etext+0x778>
    80004b54:	24f000ef          	jal	800055a2 <panic>
    panic("virtio disk max queue too short");
    80004b58:	00003517          	auipc	a0,0x3
    80004b5c:	c4050513          	addi	a0,a0,-960 # 80007798 <etext+0x798>
    80004b60:	243000ef          	jal	800055a2 <panic>
    panic("virtio disk kalloc");
    80004b64:	00003517          	auipc	a0,0x3
    80004b68:	c5450513          	addi	a0,a0,-940 # 800077b8 <etext+0x7b8>
    80004b6c:	237000ef          	jal	800055a2 <panic>

0000000080004b70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b70:	7159                	addi	sp,sp,-112
    80004b72:	f486                	sd	ra,104(sp)
    80004b74:	f0a2                	sd	s0,96(sp)
    80004b76:	eca6                	sd	s1,88(sp)
    80004b78:	e8ca                	sd	s2,80(sp)
    80004b7a:	e4ce                	sd	s3,72(sp)
    80004b7c:	e0d2                	sd	s4,64(sp)
    80004b7e:	fc56                	sd	s5,56(sp)
    80004b80:	f85a                	sd	s6,48(sp)
    80004b82:	f45e                	sd	s7,40(sp)
    80004b84:	f062                	sd	s8,32(sp)
    80004b86:	ec66                	sd	s9,24(sp)
    80004b88:	1880                	addi	s0,sp,112
    80004b8a:	8a2a                	mv	s4,a0
    80004b8c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b8e:	00c52c83          	lw	s9,12(a0)
    80004b92:	001c9c9b          	slliw	s9,s9,0x1
    80004b96:	1c82                	slli	s9,s9,0x20
    80004b98:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80004b9c:	00014517          	auipc	a0,0x14
    80004ba0:	13c50513          	addi	a0,a0,316 # 80018cd8 <disk+0x128>
    80004ba4:	52d000ef          	jal	800058d0 <acquire>
  for(int i = 0; i < 3; i++){
    80004ba8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80004baa:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004bac:	00014b17          	auipc	s6,0x14
    80004bb0:	004b0b13          	addi	s6,s6,4 # 80018bb0 <disk>
  for(int i = 0; i < 3; i++){
    80004bb4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004bb6:	00014c17          	auipc	s8,0x14
    80004bba:	122c0c13          	addi	s8,s8,290 # 80018cd8 <disk+0x128>
    80004bbe:	a8b9                	j	80004c1c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80004bc0:	00fb0733          	add	a4,s6,a5
    80004bc4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80004bc8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bca:	0207c563          	bltz	a5,80004bf4 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80004bce:	2905                	addiw	s2,s2,1
    80004bd0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004bd2:	05590963          	beq	s2,s5,80004c24 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80004bd6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004bd8:	00014717          	auipc	a4,0x14
    80004bdc:	fd870713          	addi	a4,a4,-40 # 80018bb0 <disk>
    80004be0:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80004be2:	01874683          	lbu	a3,24(a4)
    80004be6:	fee9                	bnez	a3,80004bc0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80004be8:	2785                	addiw	a5,a5,1
    80004bea:	0705                	addi	a4,a4,1
    80004bec:	fe979be3          	bne	a5,s1,80004be2 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80004bf0:	57fd                	li	a5,-1
    80004bf2:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80004bf4:	01205d63          	blez	s2,80004c0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004bf8:	f9042503          	lw	a0,-112(s0)
    80004bfc:	d07ff0ef          	jal	80004902 <free_desc>
      for(int j = 0; j < i; j++)
    80004c00:	4785                	li	a5,1
    80004c02:	0127d663          	bge	a5,s2,80004c0e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80004c06:	f9442503          	lw	a0,-108(s0)
    80004c0a:	cf9ff0ef          	jal	80004902 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c0e:	85e2                	mv	a1,s8
    80004c10:	00014517          	auipc	a0,0x14
    80004c14:	fb850513          	addi	a0,a0,-72 # 80018bc8 <disk+0x18>
    80004c18:	f66fc0ef          	jal	8000137e <sleep>
  for(int i = 0; i < 3; i++){
    80004c1c:	f9040613          	addi	a2,s0,-112
    80004c20:	894e                	mv	s2,s3
    80004c22:	bf55                	j	80004bd6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c24:	f9042503          	lw	a0,-112(s0)
    80004c28:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c2c:	00014797          	auipc	a5,0x14
    80004c30:	f8478793          	addi	a5,a5,-124 # 80018bb0 <disk>
    80004c34:	00a50713          	addi	a4,a0,10
    80004c38:	0712                	slli	a4,a4,0x4
    80004c3a:	973e                	add	a4,a4,a5
    80004c3c:	01703633          	snez	a2,s7
    80004c40:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c42:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c46:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c4a:	6398                	ld	a4,0(a5)
    80004c4c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c4e:	0a868613          	addi	a2,a3,168
    80004c52:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c54:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c56:	6390                	ld	a2,0(a5)
    80004c58:	00d605b3          	add	a1,a2,a3
    80004c5c:	4741                	li	a4,16
    80004c5e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c60:	4805                	li	a6,1
    80004c62:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004c66:	f9442703          	lw	a4,-108(s0)
    80004c6a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c6e:	0712                	slli	a4,a4,0x4
    80004c70:	963a                	add	a2,a2,a4
    80004c72:	058a0593          	addi	a1,s4,88
    80004c76:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c78:	0007b883          	ld	a7,0(a5)
    80004c7c:	9746                	add	a4,a4,a7
    80004c7e:	40000613          	li	a2,1024
    80004c82:	c710                	sw	a2,8(a4)
  if(write)
    80004c84:	001bb613          	seqz	a2,s7
    80004c88:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c8c:	00166613          	ori	a2,a2,1
    80004c90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c94:	f9842583          	lw	a1,-104(s0)
    80004c98:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c9c:	00250613          	addi	a2,a0,2
    80004ca0:	0612                	slli	a2,a2,0x4
    80004ca2:	963e                	add	a2,a2,a5
    80004ca4:	577d                	li	a4,-1
    80004ca6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004caa:	0592                	slli	a1,a1,0x4
    80004cac:	98ae                	add	a7,a7,a1
    80004cae:	03068713          	addi	a4,a3,48
    80004cb2:	973e                	add	a4,a4,a5
    80004cb4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004cb8:	6398                	ld	a4,0(a5)
    80004cba:	972e                	add	a4,a4,a1
    80004cbc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cc0:	4689                	li	a3,2
    80004cc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cca:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80004cce:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004cd2:	6794                	ld	a3,8(a5)
    80004cd4:	0026d703          	lhu	a4,2(a3)
    80004cd8:	8b1d                	andi	a4,a4,7
    80004cda:	0706                	slli	a4,a4,0x1
    80004cdc:	96ba                	add	a3,a3,a4
    80004cde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004ce2:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004ce6:	6798                	ld	a4,8(a5)
    80004ce8:	00275783          	lhu	a5,2(a4)
    80004cec:	2785                	addiw	a5,a5,1
    80004cee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004cf2:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004cf6:	100017b7          	lui	a5,0x10001
    80004cfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cfe:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80004d02:	00014917          	auipc	s2,0x14
    80004d06:	fd690913          	addi	s2,s2,-42 # 80018cd8 <disk+0x128>
  while(b->disk == 1) {
    80004d0a:	4485                	li	s1,1
    80004d0c:	01079a63          	bne	a5,a6,80004d20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d10:	85ca                	mv	a1,s2
    80004d12:	8552                	mv	a0,s4
    80004d14:	e6afc0ef          	jal	8000137e <sleep>
  while(b->disk == 1) {
    80004d18:	004a2783          	lw	a5,4(s4)
    80004d1c:	fe978ae3          	beq	a5,s1,80004d10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d20:	f9042903          	lw	s2,-112(s0)
    80004d24:	00290713          	addi	a4,s2,2
    80004d28:	0712                	slli	a4,a4,0x4
    80004d2a:	00014797          	auipc	a5,0x14
    80004d2e:	e8678793          	addi	a5,a5,-378 # 80018bb0 <disk>
    80004d32:	97ba                	add	a5,a5,a4
    80004d34:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d38:	00014997          	auipc	s3,0x14
    80004d3c:	e7898993          	addi	s3,s3,-392 # 80018bb0 <disk>
    80004d40:	00491713          	slli	a4,s2,0x4
    80004d44:	0009b783          	ld	a5,0(s3)
    80004d48:	97ba                	add	a5,a5,a4
    80004d4a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d4e:	854a                	mv	a0,s2
    80004d50:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d54:	bafff0ef          	jal	80004902 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d58:	8885                	andi	s1,s1,1
    80004d5a:	f0fd                	bnez	s1,80004d40 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d5c:	00014517          	auipc	a0,0x14
    80004d60:	f7c50513          	addi	a0,a0,-132 # 80018cd8 <disk+0x128>
    80004d64:	405000ef          	jal	80005968 <release>
}
    80004d68:	70a6                	ld	ra,104(sp)
    80004d6a:	7406                	ld	s0,96(sp)
    80004d6c:	64e6                	ld	s1,88(sp)
    80004d6e:	6946                	ld	s2,80(sp)
    80004d70:	69a6                	ld	s3,72(sp)
    80004d72:	6a06                	ld	s4,64(sp)
    80004d74:	7ae2                	ld	s5,56(sp)
    80004d76:	7b42                	ld	s6,48(sp)
    80004d78:	7ba2                	ld	s7,40(sp)
    80004d7a:	7c02                	ld	s8,32(sp)
    80004d7c:	6ce2                	ld	s9,24(sp)
    80004d7e:	6165                	addi	sp,sp,112
    80004d80:	8082                	ret

0000000080004d82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d82:	1101                	addi	sp,sp,-32
    80004d84:	ec06                	sd	ra,24(sp)
    80004d86:	e822                	sd	s0,16(sp)
    80004d88:	e426                	sd	s1,8(sp)
    80004d8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d8c:	00014497          	auipc	s1,0x14
    80004d90:	e2448493          	addi	s1,s1,-476 # 80018bb0 <disk>
    80004d94:	00014517          	auipc	a0,0x14
    80004d98:	f4450513          	addi	a0,a0,-188 # 80018cd8 <disk+0x128>
    80004d9c:	335000ef          	jal	800058d0 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004da0:	100017b7          	lui	a5,0x10001
    80004da4:	53b8                	lw	a4,96(a5)
    80004da6:	8b0d                	andi	a4,a4,3
    80004da8:	100017b7          	lui	a5,0x10001
    80004dac:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80004dae:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004db2:	689c                	ld	a5,16(s1)
    80004db4:	0204d703          	lhu	a4,32(s1)
    80004db8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dbc:	04f70663          	beq	a4,a5,80004e08 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004dc0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004dc4:	6898                	ld	a4,16(s1)
    80004dc6:	0204d783          	lhu	a5,32(s1)
    80004dca:	8b9d                	andi	a5,a5,7
    80004dcc:	078e                	slli	a5,a5,0x3
    80004dce:	97ba                	add	a5,a5,a4
    80004dd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004dd2:	00278713          	addi	a4,a5,2
    80004dd6:	0712                	slli	a4,a4,0x4
    80004dd8:	9726                	add	a4,a4,s1
    80004dda:	01074703          	lbu	a4,16(a4)
    80004dde:	e321                	bnez	a4,80004e1e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004de0:	0789                	addi	a5,a5,2
    80004de2:	0792                	slli	a5,a5,0x4
    80004de4:	97a6                	add	a5,a5,s1
    80004de6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004de8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004dec:	ddefc0ef          	jal	800013ca <wakeup>

    disk.used_idx += 1;
    80004df0:	0204d783          	lhu	a5,32(s1)
    80004df4:	2785                	addiw	a5,a5,1
    80004df6:	17c2                	slli	a5,a5,0x30
    80004df8:	93c1                	srli	a5,a5,0x30
    80004dfa:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004dfe:	6898                	ld	a4,16(s1)
    80004e00:	00275703          	lhu	a4,2(a4)
    80004e04:	faf71ee3          	bne	a4,a5,80004dc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e08:	00014517          	auipc	a0,0x14
    80004e0c:	ed050513          	addi	a0,a0,-304 # 80018cd8 <disk+0x128>
    80004e10:	359000ef          	jal	80005968 <release>
}
    80004e14:	60e2                	ld	ra,24(sp)
    80004e16:	6442                	ld	s0,16(sp)
    80004e18:	64a2                	ld	s1,8(sp)
    80004e1a:	6105                	addi	sp,sp,32
    80004e1c:	8082                	ret
      panic("virtio_disk_intr status");
    80004e1e:	00003517          	auipc	a0,0x3
    80004e22:	9b250513          	addi	a0,a0,-1614 # 800077d0 <etext+0x7d0>
    80004e26:	77c000ef          	jal	800055a2 <panic>

0000000080004e2a <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e2a:	1141                	addi	sp,sp,-16
    80004e2c:	e422                	sd	s0,8(sp)
    80004e2e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e30:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e38:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e3c:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e40:	577d                	li	a4,-1
    80004e42:	177e                	slli	a4,a4,0x3f
    80004e44:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e46:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e4a:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e4e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e52:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e56:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e5a:	000f4737          	lui	a4,0xf4
    80004e5e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e62:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e64:	14d79073          	csrw	stimecmp,a5
}
    80004e68:	6422                	ld	s0,8(sp)
    80004e6a:	0141                	addi	sp,sp,16
    80004e6c:	8082                	ret

0000000080004e6e <start>:
{
    80004e6e:	1141                	addi	sp,sp,-16
    80004e70:	e406                	sd	ra,8(sp)
    80004e72:	e022                	sd	s0,0(sp)
    80004e74:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e76:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e7a:	7779                	lui	a4,0xffffe
    80004e7c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdda0f>
    80004e80:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e82:	6705                	lui	a4,0x1
    80004e84:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e88:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e8a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e8e:	ffffb797          	auipc	a5,0xffffb
    80004e92:	49c78793          	addi	a5,a5,1180 # 8000032a <main>
    80004e96:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004e9a:	4781                	li	a5,0
    80004e9c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ea0:	67c1                	lui	a5,0x10
    80004ea2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004ea4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004ea8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004eac:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004eb0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004eb4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004eb8:	57fd                	li	a5,-1
    80004eba:	83a9                	srli	a5,a5,0xa
    80004ebc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ec0:	47bd                	li	a5,15
    80004ec2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ec6:	f65ff0ef          	jal	80004e2a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004eca:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004ece:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004ed0:	823e                	mv	tp,a5
  asm volatile("mret");
    80004ed2:	30200073          	mret
}
    80004ed6:	60a2                	ld	ra,8(sp)
    80004ed8:	6402                	ld	s0,0(sp)
    80004eda:	0141                	addi	sp,sp,16
    80004edc:	8082                	ret

0000000080004ede <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ede:	715d                	addi	sp,sp,-80
    80004ee0:	e486                	sd	ra,72(sp)
    80004ee2:	e0a2                	sd	s0,64(sp)
    80004ee4:	f84a                	sd	s2,48(sp)
    80004ee6:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80004ee8:	04c05263          	blez	a2,80004f2c <consolewrite+0x4e>
    80004eec:	fc26                	sd	s1,56(sp)
    80004eee:	f44e                	sd	s3,40(sp)
    80004ef0:	f052                	sd	s4,32(sp)
    80004ef2:	ec56                	sd	s5,24(sp)
    80004ef4:	8a2a                	mv	s4,a0
    80004ef6:	84ae                	mv	s1,a1
    80004ef8:	89b2                	mv	s3,a2
    80004efa:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004efc:	5afd                	li	s5,-1
    80004efe:	4685                	li	a3,1
    80004f00:	8626                	mv	a2,s1
    80004f02:	85d2                	mv	a1,s4
    80004f04:	fbf40513          	addi	a0,s0,-65
    80004f08:	81dfc0ef          	jal	80001724 <either_copyin>
    80004f0c:	03550263          	beq	a0,s5,80004f30 <consolewrite+0x52>
      break;
    uartputc(c);
    80004f10:	fbf44503          	lbu	a0,-65(s0)
    80004f14:	035000ef          	jal	80005748 <uartputc>
  for(i = 0; i < n; i++){
    80004f18:	2905                	addiw	s2,s2,1
    80004f1a:	0485                	addi	s1,s1,1
    80004f1c:	ff2991e3          	bne	s3,s2,80004efe <consolewrite+0x20>
    80004f20:	894e                	mv	s2,s3
    80004f22:	74e2                	ld	s1,56(sp)
    80004f24:	79a2                	ld	s3,40(sp)
    80004f26:	7a02                	ld	s4,32(sp)
    80004f28:	6ae2                	ld	s5,24(sp)
    80004f2a:	a039                	j	80004f38 <consolewrite+0x5a>
    80004f2c:	4901                	li	s2,0
    80004f2e:	a029                	j	80004f38 <consolewrite+0x5a>
    80004f30:	74e2                	ld	s1,56(sp)
    80004f32:	79a2                	ld	s3,40(sp)
    80004f34:	7a02                	ld	s4,32(sp)
    80004f36:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80004f38:	854a                	mv	a0,s2
    80004f3a:	60a6                	ld	ra,72(sp)
    80004f3c:	6406                	ld	s0,64(sp)
    80004f3e:	7942                	ld	s2,48(sp)
    80004f40:	6161                	addi	sp,sp,80
    80004f42:	8082                	ret

0000000080004f44 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f44:	711d                	addi	sp,sp,-96
    80004f46:	ec86                	sd	ra,88(sp)
    80004f48:	e8a2                	sd	s0,80(sp)
    80004f4a:	e4a6                	sd	s1,72(sp)
    80004f4c:	e0ca                	sd	s2,64(sp)
    80004f4e:	fc4e                	sd	s3,56(sp)
    80004f50:	f852                	sd	s4,48(sp)
    80004f52:	f456                	sd	s5,40(sp)
    80004f54:	f05a                	sd	s6,32(sp)
    80004f56:	1080                	addi	s0,sp,96
    80004f58:	8aaa                	mv	s5,a0
    80004f5a:	8a2e                	mv	s4,a1
    80004f5c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004f5e:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80004f62:	0001c517          	auipc	a0,0x1c
    80004f66:	d8e50513          	addi	a0,a0,-626 # 80020cf0 <cons>
    80004f6a:	167000ef          	jal	800058d0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004f6e:	0001c497          	auipc	s1,0x1c
    80004f72:	d8248493          	addi	s1,s1,-638 # 80020cf0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004f76:	0001c917          	auipc	s2,0x1c
    80004f7a:	e1290913          	addi	s2,s2,-494 # 80020d88 <cons+0x98>
  while(n > 0){
    80004f7e:	0b305d63          	blez	s3,80005038 <consoleread+0xf4>
    while(cons.r == cons.w){
    80004f82:	0984a783          	lw	a5,152(s1)
    80004f86:	09c4a703          	lw	a4,156(s1)
    80004f8a:	0af71263          	bne	a4,a5,8000502e <consoleread+0xea>
      if(killed(myproc())){
    80004f8e:	e1bfb0ef          	jal	80000da8 <myproc>
    80004f92:	e24fc0ef          	jal	800015b6 <killed>
    80004f96:	e12d                	bnez	a0,80004ff8 <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    80004f98:	85a6                	mv	a1,s1
    80004f9a:	854a                	mv	a0,s2
    80004f9c:	be2fc0ef          	jal	8000137e <sleep>
    while(cons.r == cons.w){
    80004fa0:	0984a783          	lw	a5,152(s1)
    80004fa4:	09c4a703          	lw	a4,156(s1)
    80004fa8:	fef703e3          	beq	a4,a5,80004f8e <consoleread+0x4a>
    80004fac:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004fae:	0001c717          	auipc	a4,0x1c
    80004fb2:	d4270713          	addi	a4,a4,-702 # 80020cf0 <cons>
    80004fb6:	0017869b          	addiw	a3,a5,1
    80004fba:	08d72c23          	sw	a3,152(a4)
    80004fbe:	07f7f693          	andi	a3,a5,127
    80004fc2:	9736                	add	a4,a4,a3
    80004fc4:	01874703          	lbu	a4,24(a4)
    80004fc8:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80004fcc:	4691                	li	a3,4
    80004fce:	04db8663          	beq	s7,a3,8000501a <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80004fd2:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80004fd6:	4685                	li	a3,1
    80004fd8:	faf40613          	addi	a2,s0,-81
    80004fdc:	85d2                	mv	a1,s4
    80004fde:	8556                	mv	a0,s5
    80004fe0:	efafc0ef          	jal	800016da <either_copyout>
    80004fe4:	57fd                	li	a5,-1
    80004fe6:	04f50863          	beq	a0,a5,80005036 <consoleread+0xf2>
      break;

    dst++;
    80004fea:	0a05                	addi	s4,s4,1
    --n;
    80004fec:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80004fee:	47a9                	li	a5,10
    80004ff0:	04fb8d63          	beq	s7,a5,8000504a <consoleread+0x106>
    80004ff4:	6be2                	ld	s7,24(sp)
    80004ff6:	b761                	j	80004f7e <consoleread+0x3a>
        release(&cons.lock);
    80004ff8:	0001c517          	auipc	a0,0x1c
    80004ffc:	cf850513          	addi	a0,a0,-776 # 80020cf0 <cons>
    80005000:	169000ef          	jal	80005968 <release>
        return -1;
    80005004:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005006:	60e6                	ld	ra,88(sp)
    80005008:	6446                	ld	s0,80(sp)
    8000500a:	64a6                	ld	s1,72(sp)
    8000500c:	6906                	ld	s2,64(sp)
    8000500e:	79e2                	ld	s3,56(sp)
    80005010:	7a42                	ld	s4,48(sp)
    80005012:	7aa2                	ld	s5,40(sp)
    80005014:	7b02                	ld	s6,32(sp)
    80005016:	6125                	addi	sp,sp,96
    80005018:	8082                	ret
      if(n < target){
    8000501a:	0009871b          	sext.w	a4,s3
    8000501e:	01677a63          	bgeu	a4,s6,80005032 <consoleread+0xee>
        cons.r--;
    80005022:	0001c717          	auipc	a4,0x1c
    80005026:	d6f72323          	sw	a5,-666(a4) # 80020d88 <cons+0x98>
    8000502a:	6be2                	ld	s7,24(sp)
    8000502c:	a031                	j	80005038 <consoleread+0xf4>
    8000502e:	ec5e                	sd	s7,24(sp)
    80005030:	bfbd                	j	80004fae <consoleread+0x6a>
    80005032:	6be2                	ld	s7,24(sp)
    80005034:	a011                	j	80005038 <consoleread+0xf4>
    80005036:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005038:	0001c517          	auipc	a0,0x1c
    8000503c:	cb850513          	addi	a0,a0,-840 # 80020cf0 <cons>
    80005040:	129000ef          	jal	80005968 <release>
  return target - n;
    80005044:	413b053b          	subw	a0,s6,s3
    80005048:	bf7d                	j	80005006 <consoleread+0xc2>
    8000504a:	6be2                	ld	s7,24(sp)
    8000504c:	b7f5                	j	80005038 <consoleread+0xf4>

000000008000504e <consputc>:
{
    8000504e:	1141                	addi	sp,sp,-16
    80005050:	e406                	sd	ra,8(sp)
    80005052:	e022                	sd	s0,0(sp)
    80005054:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005056:	10000793          	li	a5,256
    8000505a:	00f50863          	beq	a0,a5,8000506a <consputc+0x1c>
    uartputc_sync(c);
    8000505e:	604000ef          	jal	80005662 <uartputc_sync>
}
    80005062:	60a2                	ld	ra,8(sp)
    80005064:	6402                	ld	s0,0(sp)
    80005066:	0141                	addi	sp,sp,16
    80005068:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000506a:	4521                	li	a0,8
    8000506c:	5f6000ef          	jal	80005662 <uartputc_sync>
    80005070:	02000513          	li	a0,32
    80005074:	5ee000ef          	jal	80005662 <uartputc_sync>
    80005078:	4521                	li	a0,8
    8000507a:	5e8000ef          	jal	80005662 <uartputc_sync>
    8000507e:	b7d5                	j	80005062 <consputc+0x14>

0000000080005080 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005080:	1101                	addi	sp,sp,-32
    80005082:	ec06                	sd	ra,24(sp)
    80005084:	e822                	sd	s0,16(sp)
    80005086:	e426                	sd	s1,8(sp)
    80005088:	1000                	addi	s0,sp,32
    8000508a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000508c:	0001c517          	auipc	a0,0x1c
    80005090:	c6450513          	addi	a0,a0,-924 # 80020cf0 <cons>
    80005094:	03d000ef          	jal	800058d0 <acquire>

  switch(c){
    80005098:	47d5                	li	a5,21
    8000509a:	08f48f63          	beq	s1,a5,80005138 <consoleintr+0xb8>
    8000509e:	0297c563          	blt	a5,s1,800050c8 <consoleintr+0x48>
    800050a2:	47a1                	li	a5,8
    800050a4:	0ef48463          	beq	s1,a5,8000518c <consoleintr+0x10c>
    800050a8:	47c1                	li	a5,16
    800050aa:	10f49563          	bne	s1,a5,800051b4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800050ae:	ec0fc0ef          	jal	8000176e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050b2:	0001c517          	auipc	a0,0x1c
    800050b6:	c3e50513          	addi	a0,a0,-962 # 80020cf0 <cons>
    800050ba:	0af000ef          	jal	80005968 <release>
}
    800050be:	60e2                	ld	ra,24(sp)
    800050c0:	6442                	ld	s0,16(sp)
    800050c2:	64a2                	ld	s1,8(sp)
    800050c4:	6105                	addi	sp,sp,32
    800050c6:	8082                	ret
  switch(c){
    800050c8:	07f00793          	li	a5,127
    800050cc:	0cf48063          	beq	s1,a5,8000518c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800050d0:	0001c717          	auipc	a4,0x1c
    800050d4:	c2070713          	addi	a4,a4,-992 # 80020cf0 <cons>
    800050d8:	0a072783          	lw	a5,160(a4)
    800050dc:	09872703          	lw	a4,152(a4)
    800050e0:	9f99                	subw	a5,a5,a4
    800050e2:	07f00713          	li	a4,127
    800050e6:	fcf766e3          	bltu	a4,a5,800050b2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800050ea:	47b5                	li	a5,13
    800050ec:	0cf48763          	beq	s1,a5,800051ba <consoleintr+0x13a>
      consputc(c);
    800050f0:	8526                	mv	a0,s1
    800050f2:	f5dff0ef          	jal	8000504e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800050f6:	0001c797          	auipc	a5,0x1c
    800050fa:	bfa78793          	addi	a5,a5,-1030 # 80020cf0 <cons>
    800050fe:	0a07a683          	lw	a3,160(a5)
    80005102:	0016871b          	addiw	a4,a3,1
    80005106:	0007061b          	sext.w	a2,a4
    8000510a:	0ae7a023          	sw	a4,160(a5)
    8000510e:	07f6f693          	andi	a3,a3,127
    80005112:	97b6                	add	a5,a5,a3
    80005114:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005118:	47a9                	li	a5,10
    8000511a:	0cf48563          	beq	s1,a5,800051e4 <consoleintr+0x164>
    8000511e:	4791                	li	a5,4
    80005120:	0cf48263          	beq	s1,a5,800051e4 <consoleintr+0x164>
    80005124:	0001c797          	auipc	a5,0x1c
    80005128:	c647a783          	lw	a5,-924(a5) # 80020d88 <cons+0x98>
    8000512c:	9f1d                	subw	a4,a4,a5
    8000512e:	08000793          	li	a5,128
    80005132:	f8f710e3          	bne	a4,a5,800050b2 <consoleintr+0x32>
    80005136:	a07d                	j	800051e4 <consoleintr+0x164>
    80005138:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000513a:	0001c717          	auipc	a4,0x1c
    8000513e:	bb670713          	addi	a4,a4,-1098 # 80020cf0 <cons>
    80005142:	0a072783          	lw	a5,160(a4)
    80005146:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000514a:	0001c497          	auipc	s1,0x1c
    8000514e:	ba648493          	addi	s1,s1,-1114 # 80020cf0 <cons>
    while(cons.e != cons.w &&
    80005152:	4929                	li	s2,10
    80005154:	02f70863          	beq	a4,a5,80005184 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005158:	37fd                	addiw	a5,a5,-1
    8000515a:	07f7f713          	andi	a4,a5,127
    8000515e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005160:	01874703          	lbu	a4,24(a4)
    80005164:	03270263          	beq	a4,s2,80005188 <consoleintr+0x108>
      cons.e--;
    80005168:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000516c:	10000513          	li	a0,256
    80005170:	edfff0ef          	jal	8000504e <consputc>
    while(cons.e != cons.w &&
    80005174:	0a04a783          	lw	a5,160(s1)
    80005178:	09c4a703          	lw	a4,156(s1)
    8000517c:	fcf71ee3          	bne	a4,a5,80005158 <consoleintr+0xd8>
    80005180:	6902                	ld	s2,0(sp)
    80005182:	bf05                	j	800050b2 <consoleintr+0x32>
    80005184:	6902                	ld	s2,0(sp)
    80005186:	b735                	j	800050b2 <consoleintr+0x32>
    80005188:	6902                	ld	s2,0(sp)
    8000518a:	b725                	j	800050b2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000518c:	0001c717          	auipc	a4,0x1c
    80005190:	b6470713          	addi	a4,a4,-1180 # 80020cf0 <cons>
    80005194:	0a072783          	lw	a5,160(a4)
    80005198:	09c72703          	lw	a4,156(a4)
    8000519c:	f0f70be3          	beq	a4,a5,800050b2 <consoleintr+0x32>
      cons.e--;
    800051a0:	37fd                	addiw	a5,a5,-1
    800051a2:	0001c717          	auipc	a4,0x1c
    800051a6:	bef72723          	sw	a5,-1042(a4) # 80020d90 <cons+0xa0>
      consputc(BACKSPACE);
    800051aa:	10000513          	li	a0,256
    800051ae:	ea1ff0ef          	jal	8000504e <consputc>
    800051b2:	b701                	j	800050b2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051b4:	ee048fe3          	beqz	s1,800050b2 <consoleintr+0x32>
    800051b8:	bf21                	j	800050d0 <consoleintr+0x50>
      consputc(c);
    800051ba:	4529                	li	a0,10
    800051bc:	e93ff0ef          	jal	8000504e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051c0:	0001c797          	auipc	a5,0x1c
    800051c4:	b3078793          	addi	a5,a5,-1232 # 80020cf0 <cons>
    800051c8:	0a07a703          	lw	a4,160(a5)
    800051cc:	0017069b          	addiw	a3,a4,1
    800051d0:	0006861b          	sext.w	a2,a3
    800051d4:	0ad7a023          	sw	a3,160(a5)
    800051d8:	07f77713          	andi	a4,a4,127
    800051dc:	97ba                	add	a5,a5,a4
    800051de:	4729                	li	a4,10
    800051e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800051e4:	0001c797          	auipc	a5,0x1c
    800051e8:	bac7a423          	sw	a2,-1112(a5) # 80020d8c <cons+0x9c>
        wakeup(&cons.r);
    800051ec:	0001c517          	auipc	a0,0x1c
    800051f0:	b9c50513          	addi	a0,a0,-1124 # 80020d88 <cons+0x98>
    800051f4:	9d6fc0ef          	jal	800013ca <wakeup>
    800051f8:	bd6d                	j	800050b2 <consoleintr+0x32>

00000000800051fa <consoleinit>:

void
consoleinit(void)
{
    800051fa:	1141                	addi	sp,sp,-16
    800051fc:	e406                	sd	ra,8(sp)
    800051fe:	e022                	sd	s0,0(sp)
    80005200:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005202:	00002597          	auipc	a1,0x2
    80005206:	5e658593          	addi	a1,a1,1510 # 800077e8 <etext+0x7e8>
    8000520a:	0001c517          	auipc	a0,0x1c
    8000520e:	ae650513          	addi	a0,a0,-1306 # 80020cf0 <cons>
    80005212:	63e000ef          	jal	80005850 <initlock>

  uartinit();
    80005216:	3f4000ef          	jal	8000560a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000521a:	00013797          	auipc	a5,0x13
    8000521e:	93e78793          	addi	a5,a5,-1730 # 80017b58 <devsw>
    80005222:	00000717          	auipc	a4,0x0
    80005226:	d2270713          	addi	a4,a4,-734 # 80004f44 <consoleread>
    8000522a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000522c:	00000717          	auipc	a4,0x0
    80005230:	cb270713          	addi	a4,a4,-846 # 80004ede <consolewrite>
    80005234:	ef98                	sd	a4,24(a5)
}
    80005236:	60a2                	ld	ra,8(sp)
    80005238:	6402                	ld	s0,0(sp)
    8000523a:	0141                	addi	sp,sp,16
    8000523c:	8082                	ret

000000008000523e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000523e:	7179                	addi	sp,sp,-48
    80005240:	f406                	sd	ra,40(sp)
    80005242:	f022                	sd	s0,32(sp)
    80005244:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005246:	c219                	beqz	a2,8000524c <printint+0xe>
    80005248:	08054063          	bltz	a0,800052c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000524c:	4881                	li	a7,0
    8000524e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005252:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005254:	00002617          	auipc	a2,0x2
    80005258:	7cc60613          	addi	a2,a2,1996 # 80007a20 <digits>
    8000525c:	883e                	mv	a6,a5
    8000525e:	2785                	addiw	a5,a5,1
    80005260:	02b57733          	remu	a4,a0,a1
    80005264:	9732                	add	a4,a4,a2
    80005266:	00074703          	lbu	a4,0(a4)
    8000526a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000526e:	872a                	mv	a4,a0
    80005270:	02b55533          	divu	a0,a0,a1
    80005274:	0685                	addi	a3,a3,1
    80005276:	feb773e3          	bgeu	a4,a1,8000525c <printint+0x1e>

  if(sign)
    8000527a:	00088a63          	beqz	a7,8000528e <printint+0x50>
    buf[i++] = '-';
    8000527e:	1781                	addi	a5,a5,-32
    80005280:	97a2                	add	a5,a5,s0
    80005282:	02d00713          	li	a4,45
    80005286:	fee78823          	sb	a4,-16(a5)
    8000528a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000528e:	02f05963          	blez	a5,800052c0 <printint+0x82>
    80005292:	ec26                	sd	s1,24(sp)
    80005294:	e84a                	sd	s2,16(sp)
    80005296:	fd040713          	addi	a4,s0,-48
    8000529a:	00f704b3          	add	s1,a4,a5
    8000529e:	fff70913          	addi	s2,a4,-1
    800052a2:	993e                	add	s2,s2,a5
    800052a4:	37fd                	addiw	a5,a5,-1
    800052a6:	1782                	slli	a5,a5,0x20
    800052a8:	9381                	srli	a5,a5,0x20
    800052aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800052ae:	fff4c503          	lbu	a0,-1(s1)
    800052b2:	d9dff0ef          	jal	8000504e <consputc>
  while(--i >= 0)
    800052b6:	14fd                	addi	s1,s1,-1
    800052b8:	ff249be3          	bne	s1,s2,800052ae <printint+0x70>
    800052bc:	64e2                	ld	s1,24(sp)
    800052be:	6942                	ld	s2,16(sp)
}
    800052c0:	70a2                	ld	ra,40(sp)
    800052c2:	7402                	ld	s0,32(sp)
    800052c4:	6145                	addi	sp,sp,48
    800052c6:	8082                	ret
    x = -xx;
    800052c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800052cc:	4885                	li	a7,1
    x = -xx;
    800052ce:	b741                	j	8000524e <printint+0x10>

00000000800052d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800052d0:	7155                	addi	sp,sp,-208
    800052d2:	e506                	sd	ra,136(sp)
    800052d4:	e122                	sd	s0,128(sp)
    800052d6:	f0d2                	sd	s4,96(sp)
    800052d8:	0900                	addi	s0,sp,144
    800052da:	8a2a                	mv	s4,a0
    800052dc:	e40c                	sd	a1,8(s0)
    800052de:	e810                	sd	a2,16(s0)
    800052e0:	ec14                	sd	a3,24(s0)
    800052e2:	f018                	sd	a4,32(s0)
    800052e4:	f41c                	sd	a5,40(s0)
    800052e6:	03043823          	sd	a6,48(s0)
    800052ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800052ee:	0001c797          	auipc	a5,0x1c
    800052f2:	ac27a783          	lw	a5,-1342(a5) # 80020db0 <pr+0x18>
    800052f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800052fa:	e3a1                	bnez	a5,8000533a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800052fc:	00840793          	addi	a5,s0,8
    80005300:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005304:	00054503          	lbu	a0,0(a0)
    80005308:	26050763          	beqz	a0,80005576 <printf+0x2a6>
    8000530c:	fca6                	sd	s1,120(sp)
    8000530e:	f8ca                	sd	s2,112(sp)
    80005310:	f4ce                	sd	s3,104(sp)
    80005312:	ecd6                	sd	s5,88(sp)
    80005314:	e8da                	sd	s6,80(sp)
    80005316:	e0e2                	sd	s8,64(sp)
    80005318:	fc66                	sd	s9,56(sp)
    8000531a:	f86a                	sd	s10,48(sp)
    8000531c:	f46e                	sd	s11,40(sp)
    8000531e:	4981                	li	s3,0
    if(cx != '%'){
    80005320:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80005324:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80005328:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000532c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005330:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005334:	07000d93          	li	s11,112
    80005338:	a815                	j	8000536c <printf+0x9c>
    acquire(&pr.lock);
    8000533a:	0001c517          	auipc	a0,0x1c
    8000533e:	a5e50513          	addi	a0,a0,-1442 # 80020d98 <pr>
    80005342:	58e000ef          	jal	800058d0 <acquire>
  va_start(ap, fmt);
    80005346:	00840793          	addi	a5,s0,8
    8000534a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000534e:	000a4503          	lbu	a0,0(s4)
    80005352:	fd4d                	bnez	a0,8000530c <printf+0x3c>
    80005354:	a481                	j	80005594 <printf+0x2c4>
      consputc(cx);
    80005356:	cf9ff0ef          	jal	8000504e <consputc>
      continue;
    8000535a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000535c:	0014899b          	addiw	s3,s1,1
    80005360:	013a07b3          	add	a5,s4,s3
    80005364:	0007c503          	lbu	a0,0(a5)
    80005368:	1e050b63          	beqz	a0,8000555e <printf+0x28e>
    if(cx != '%'){
    8000536c:	ff5515e3          	bne	a0,s5,80005356 <printf+0x86>
    i++;
    80005370:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80005374:	009a07b3          	add	a5,s4,s1
    80005378:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000537c:	1e090163          	beqz	s2,8000555e <printf+0x28e>
    80005380:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80005384:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80005386:	c789                	beqz	a5,80005390 <printf+0xc0>
    80005388:	009a0733          	add	a4,s4,s1
    8000538c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80005390:	03690763          	beq	s2,s6,800053be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80005394:	05890163          	beq	s2,s8,800053d6 <printf+0x106>
    } else if(c0 == 'u'){
    80005398:	0d990b63          	beq	s2,s9,8000546e <printf+0x19e>
    } else if(c0 == 'x'){
    8000539c:	13a90163          	beq	s2,s10,800054be <printf+0x1ee>
    } else if(c0 == 'p'){
    800053a0:	13b90b63          	beq	s2,s11,800054d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800053a4:	07300793          	li	a5,115
    800053a8:	16f90a63          	beq	s2,a5,8000551c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800053ac:	1b590463          	beq	s2,s5,80005554 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800053b0:	8556                	mv	a0,s5
    800053b2:	c9dff0ef          	jal	8000504e <consputc>
      consputc(c0);
    800053b6:	854a                	mv	a0,s2
    800053b8:	c97ff0ef          	jal	8000504e <consputc>
    800053bc:	b745                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800053be:	f8843783          	ld	a5,-120(s0)
    800053c2:	00878713          	addi	a4,a5,8
    800053c6:	f8e43423          	sd	a4,-120(s0)
    800053ca:	4605                	li	a2,1
    800053cc:	45a9                	li	a1,10
    800053ce:	4388                	lw	a0,0(a5)
    800053d0:	e6fff0ef          	jal	8000523e <printint>
    800053d4:	b761                	j	8000535c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800053d6:	03678663          	beq	a5,s6,80005402 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800053da:	05878263          	beq	a5,s8,8000541e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800053de:	0b978463          	beq	a5,s9,80005486 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800053e2:	fda797e3          	bne	a5,s10,800053b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800053e6:	f8843783          	ld	a5,-120(s0)
    800053ea:	00878713          	addi	a4,a5,8
    800053ee:	f8e43423          	sd	a4,-120(s0)
    800053f2:	4601                	li	a2,0
    800053f4:	45c1                	li	a1,16
    800053f6:	6388                	ld	a0,0(a5)
    800053f8:	e47ff0ef          	jal	8000523e <printint>
      i += 1;
    800053fc:	0029849b          	addiw	s1,s3,2
    80005400:	bfb1                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005402:	f8843783          	ld	a5,-120(s0)
    80005406:	00878713          	addi	a4,a5,8
    8000540a:	f8e43423          	sd	a4,-120(s0)
    8000540e:	4605                	li	a2,1
    80005410:	45a9                	li	a1,10
    80005412:	6388                	ld	a0,0(a5)
    80005414:	e2bff0ef          	jal	8000523e <printint>
      i += 1;
    80005418:	0029849b          	addiw	s1,s3,2
    8000541c:	b781                	j	8000535c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000541e:	06400793          	li	a5,100
    80005422:	02f68863          	beq	a3,a5,80005452 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005426:	07500793          	li	a5,117
    8000542a:	06f68c63          	beq	a3,a5,800054a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000542e:	07800793          	li	a5,120
    80005432:	f6f69fe3          	bne	a3,a5,800053b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80005436:	f8843783          	ld	a5,-120(s0)
    8000543a:	00878713          	addi	a4,a5,8
    8000543e:	f8e43423          	sd	a4,-120(s0)
    80005442:	4601                	li	a2,0
    80005444:	45c1                	li	a1,16
    80005446:	6388                	ld	a0,0(a5)
    80005448:	df7ff0ef          	jal	8000523e <printint>
      i += 2;
    8000544c:	0039849b          	addiw	s1,s3,3
    80005450:	b731                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005452:	f8843783          	ld	a5,-120(s0)
    80005456:	00878713          	addi	a4,a5,8
    8000545a:	f8e43423          	sd	a4,-120(s0)
    8000545e:	4605                	li	a2,1
    80005460:	45a9                	li	a1,10
    80005462:	6388                	ld	a0,0(a5)
    80005464:	ddbff0ef          	jal	8000523e <printint>
      i += 2;
    80005468:	0039849b          	addiw	s1,s3,3
    8000546c:	bdc5                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000546e:	f8843783          	ld	a5,-120(s0)
    80005472:	00878713          	addi	a4,a5,8
    80005476:	f8e43423          	sd	a4,-120(s0)
    8000547a:	4601                	li	a2,0
    8000547c:	45a9                	li	a1,10
    8000547e:	4388                	lw	a0,0(a5)
    80005480:	dbfff0ef          	jal	8000523e <printint>
    80005484:	bde1                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80005486:	f8843783          	ld	a5,-120(s0)
    8000548a:	00878713          	addi	a4,a5,8
    8000548e:	f8e43423          	sd	a4,-120(s0)
    80005492:	4601                	li	a2,0
    80005494:	45a9                	li	a1,10
    80005496:	6388                	ld	a0,0(a5)
    80005498:	da7ff0ef          	jal	8000523e <printint>
      i += 1;
    8000549c:	0029849b          	addiw	s1,s3,2
    800054a0:	bd75                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800054a2:	f8843783          	ld	a5,-120(s0)
    800054a6:	00878713          	addi	a4,a5,8
    800054aa:	f8e43423          	sd	a4,-120(s0)
    800054ae:	4601                	li	a2,0
    800054b0:	45a9                	li	a1,10
    800054b2:	6388                	ld	a0,0(a5)
    800054b4:	d8bff0ef          	jal	8000523e <printint>
      i += 2;
    800054b8:	0039849b          	addiw	s1,s3,3
    800054bc:	b545                	j	8000535c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800054be:	f8843783          	ld	a5,-120(s0)
    800054c2:	00878713          	addi	a4,a5,8
    800054c6:	f8e43423          	sd	a4,-120(s0)
    800054ca:	4601                	li	a2,0
    800054cc:	45c1                	li	a1,16
    800054ce:	4388                	lw	a0,0(a5)
    800054d0:	d6fff0ef          	jal	8000523e <printint>
    800054d4:	b561                	j	8000535c <printf+0x8c>
    800054d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800054d8:	f8843783          	ld	a5,-120(s0)
    800054dc:	00878713          	addi	a4,a5,8
    800054e0:	f8e43423          	sd	a4,-120(s0)
    800054e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800054e8:	03000513          	li	a0,48
    800054ec:	b63ff0ef          	jal	8000504e <consputc>
  consputc('x');
    800054f0:	07800513          	li	a0,120
    800054f4:	b5bff0ef          	jal	8000504e <consputc>
    800054f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054fa:	00002b97          	auipc	s7,0x2
    800054fe:	526b8b93          	addi	s7,s7,1318 # 80007a20 <digits>
    80005502:	03c9d793          	srli	a5,s3,0x3c
    80005506:	97de                	add	a5,a5,s7
    80005508:	0007c503          	lbu	a0,0(a5)
    8000550c:	b43ff0ef          	jal	8000504e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005510:	0992                	slli	s3,s3,0x4
    80005512:	397d                	addiw	s2,s2,-1
    80005514:	fe0917e3          	bnez	s2,80005502 <printf+0x232>
    80005518:	6ba6                	ld	s7,72(sp)
    8000551a:	b589                	j	8000535c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000551c:	f8843783          	ld	a5,-120(s0)
    80005520:	00878713          	addi	a4,a5,8
    80005524:	f8e43423          	sd	a4,-120(s0)
    80005528:	0007b903          	ld	s2,0(a5)
    8000552c:	00090d63          	beqz	s2,80005546 <printf+0x276>
      for(; *s; s++)
    80005530:	00094503          	lbu	a0,0(s2)
    80005534:	e20504e3          	beqz	a0,8000535c <printf+0x8c>
        consputc(*s);
    80005538:	b17ff0ef          	jal	8000504e <consputc>
      for(; *s; s++)
    8000553c:	0905                	addi	s2,s2,1
    8000553e:	00094503          	lbu	a0,0(s2)
    80005542:	f97d                	bnez	a0,80005538 <printf+0x268>
    80005544:	bd21                	j	8000535c <printf+0x8c>
        s = "(null)";
    80005546:	00002917          	auipc	s2,0x2
    8000554a:	2aa90913          	addi	s2,s2,682 # 800077f0 <etext+0x7f0>
      for(; *s; s++)
    8000554e:	02800513          	li	a0,40
    80005552:	b7dd                	j	80005538 <printf+0x268>
      consputc('%');
    80005554:	02500513          	li	a0,37
    80005558:	af7ff0ef          	jal	8000504e <consputc>
    8000555c:	b501                	j	8000535c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000555e:	f7843783          	ld	a5,-136(s0)
    80005562:	e385                	bnez	a5,80005582 <printf+0x2b2>
    80005564:	74e6                	ld	s1,120(sp)
    80005566:	7946                	ld	s2,112(sp)
    80005568:	79a6                	ld	s3,104(sp)
    8000556a:	6ae6                	ld	s5,88(sp)
    8000556c:	6b46                	ld	s6,80(sp)
    8000556e:	6c06                	ld	s8,64(sp)
    80005570:	7ce2                	ld	s9,56(sp)
    80005572:	7d42                	ld	s10,48(sp)
    80005574:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80005576:	4501                	li	a0,0
    80005578:	60aa                	ld	ra,136(sp)
    8000557a:	640a                	ld	s0,128(sp)
    8000557c:	7a06                	ld	s4,96(sp)
    8000557e:	6169                	addi	sp,sp,208
    80005580:	8082                	ret
    80005582:	74e6                	ld	s1,120(sp)
    80005584:	7946                	ld	s2,112(sp)
    80005586:	79a6                	ld	s3,104(sp)
    80005588:	6ae6                	ld	s5,88(sp)
    8000558a:	6b46                	ld	s6,80(sp)
    8000558c:	6c06                	ld	s8,64(sp)
    8000558e:	7ce2                	ld	s9,56(sp)
    80005590:	7d42                	ld	s10,48(sp)
    80005592:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005594:	0001c517          	auipc	a0,0x1c
    80005598:	80450513          	addi	a0,a0,-2044 # 80020d98 <pr>
    8000559c:	3cc000ef          	jal	80005968 <release>
    800055a0:	bfd9                	j	80005576 <printf+0x2a6>

00000000800055a2 <panic>:

void
panic(char *s)
{
    800055a2:	1101                	addi	sp,sp,-32
    800055a4:	ec06                	sd	ra,24(sp)
    800055a6:	e822                	sd	s0,16(sp)
    800055a8:	e426                	sd	s1,8(sp)
    800055aa:	1000                	addi	s0,sp,32
    800055ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800055ae:	0001c797          	auipc	a5,0x1c
    800055b2:	8007a123          	sw	zero,-2046(a5) # 80020db0 <pr+0x18>
  printf("panic: ");
    800055b6:	00002517          	auipc	a0,0x2
    800055ba:	24250513          	addi	a0,a0,578 # 800077f8 <etext+0x7f8>
    800055be:	d13ff0ef          	jal	800052d0 <printf>
  printf("%s\n", s);
    800055c2:	85a6                	mv	a1,s1
    800055c4:	00002517          	auipc	a0,0x2
    800055c8:	23c50513          	addi	a0,a0,572 # 80007800 <etext+0x800>
    800055cc:	d05ff0ef          	jal	800052d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800055d0:	4785                	li	a5,1
    800055d2:	00002717          	auipc	a4,0x2
    800055d6:	4cf72d23          	sw	a5,1242(a4) # 80007aac <panicked>
  for(;;)
    800055da:	a001                	j	800055da <panic+0x38>

00000000800055dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800055dc:	1101                	addi	sp,sp,-32
    800055de:	ec06                	sd	ra,24(sp)
    800055e0:	e822                	sd	s0,16(sp)
    800055e2:	e426                	sd	s1,8(sp)
    800055e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800055e6:	0001b497          	auipc	s1,0x1b
    800055ea:	7b248493          	addi	s1,s1,1970 # 80020d98 <pr>
    800055ee:	00002597          	auipc	a1,0x2
    800055f2:	21a58593          	addi	a1,a1,538 # 80007808 <etext+0x808>
    800055f6:	8526                	mv	a0,s1
    800055f8:	258000ef          	jal	80005850 <initlock>
  pr.locking = 1;
    800055fc:	4785                	li	a5,1
    800055fe:	cc9c                	sw	a5,24(s1)
}
    80005600:	60e2                	ld	ra,24(sp)
    80005602:	6442                	ld	s0,16(sp)
    80005604:	64a2                	ld	s1,8(sp)
    80005606:	6105                	addi	sp,sp,32
    80005608:	8082                	ret

000000008000560a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000560a:	1141                	addi	sp,sp,-16
    8000560c:	e406                	sd	ra,8(sp)
    8000560e:	e022                	sd	s0,0(sp)
    80005610:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005612:	100007b7          	lui	a5,0x10000
    80005616:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000561a:	10000737          	lui	a4,0x10000
    8000561e:	f8000693          	li	a3,-128
    80005622:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005626:	468d                	li	a3,3
    80005628:	10000637          	lui	a2,0x10000
    8000562c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005630:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005634:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005638:	10000737          	lui	a4,0x10000
    8000563c:	461d                	li	a2,7
    8000563e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005642:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005646:	00002597          	auipc	a1,0x2
    8000564a:	1ca58593          	addi	a1,a1,458 # 80007810 <etext+0x810>
    8000564e:	0001b517          	auipc	a0,0x1b
    80005652:	76a50513          	addi	a0,a0,1898 # 80020db8 <uart_tx_lock>
    80005656:	1fa000ef          	jal	80005850 <initlock>
}
    8000565a:	60a2                	ld	ra,8(sp)
    8000565c:	6402                	ld	s0,0(sp)
    8000565e:	0141                	addi	sp,sp,16
    80005660:	8082                	ret

0000000080005662 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005662:	1101                	addi	sp,sp,-32
    80005664:	ec06                	sd	ra,24(sp)
    80005666:	e822                	sd	s0,16(sp)
    80005668:	e426                	sd	s1,8(sp)
    8000566a:	1000                	addi	s0,sp,32
    8000566c:	84aa                	mv	s1,a0
  push_off();
    8000566e:	222000ef          	jal	80005890 <push_off>

  if(panicked){
    80005672:	00002797          	auipc	a5,0x2
    80005676:	43a7a783          	lw	a5,1082(a5) # 80007aac <panicked>
    8000567a:	e795                	bnez	a5,800056a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000567c:	10000737          	lui	a4,0x10000
    80005680:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005682:	00074783          	lbu	a5,0(a4)
    80005686:	0207f793          	andi	a5,a5,32
    8000568a:	dfe5                	beqz	a5,80005682 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000568c:	0ff4f513          	zext.b	a0,s1
    80005690:	100007b7          	lui	a5,0x10000
    80005694:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005698:	27c000ef          	jal	80005914 <pop_off>
}
    8000569c:	60e2                	ld	ra,24(sp)
    8000569e:	6442                	ld	s0,16(sp)
    800056a0:	64a2                	ld	s1,8(sp)
    800056a2:	6105                	addi	sp,sp,32
    800056a4:	8082                	ret
    for(;;)
    800056a6:	a001                	j	800056a6 <uartputc_sync+0x44>

00000000800056a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800056a8:	00002797          	auipc	a5,0x2
    800056ac:	4087b783          	ld	a5,1032(a5) # 80007ab0 <uart_tx_r>
    800056b0:	00002717          	auipc	a4,0x2
    800056b4:	40873703          	ld	a4,1032(a4) # 80007ab8 <uart_tx_w>
    800056b8:	08f70263          	beq	a4,a5,8000573c <uartstart+0x94>
{
    800056bc:	7139                	addi	sp,sp,-64
    800056be:	fc06                	sd	ra,56(sp)
    800056c0:	f822                	sd	s0,48(sp)
    800056c2:	f426                	sd	s1,40(sp)
    800056c4:	f04a                	sd	s2,32(sp)
    800056c6:	ec4e                	sd	s3,24(sp)
    800056c8:	e852                	sd	s4,16(sp)
    800056ca:	e456                	sd	s5,8(sp)
    800056cc:	e05a                	sd	s6,0(sp)
    800056ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800056d0:	10000937          	lui	s2,0x10000
    800056d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800056d6:	0001ba97          	auipc	s5,0x1b
    800056da:	6e2a8a93          	addi	s5,s5,1762 # 80020db8 <uart_tx_lock>
    uart_tx_r += 1;
    800056de:	00002497          	auipc	s1,0x2
    800056e2:	3d248493          	addi	s1,s1,978 # 80007ab0 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800056e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800056ea:	00002997          	auipc	s3,0x2
    800056ee:	3ce98993          	addi	s3,s3,974 # 80007ab8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800056f2:	00094703          	lbu	a4,0(s2)
    800056f6:	02077713          	andi	a4,a4,32
    800056fa:	c71d                	beqz	a4,80005728 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800056fc:	01f7f713          	andi	a4,a5,31
    80005700:	9756                	add	a4,a4,s5
    80005702:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005706:	0785                	addi	a5,a5,1
    80005708:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000570a:	8526                	mv	a0,s1
    8000570c:	cbffb0ef          	jal	800013ca <wakeup>
    WriteReg(THR, c);
    80005710:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005714:	609c                	ld	a5,0(s1)
    80005716:	0009b703          	ld	a4,0(s3)
    8000571a:	fcf71ce3          	bne	a4,a5,800056f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000571e:	100007b7          	lui	a5,0x10000
    80005722:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005724:	0007c783          	lbu	a5,0(a5)
  }
}
    80005728:	70e2                	ld	ra,56(sp)
    8000572a:	7442                	ld	s0,48(sp)
    8000572c:	74a2                	ld	s1,40(sp)
    8000572e:	7902                	ld	s2,32(sp)
    80005730:	69e2                	ld	s3,24(sp)
    80005732:	6a42                	ld	s4,16(sp)
    80005734:	6aa2                	ld	s5,8(sp)
    80005736:	6b02                	ld	s6,0(sp)
    80005738:	6121                	addi	sp,sp,64
    8000573a:	8082                	ret
      ReadReg(ISR);
    8000573c:	100007b7          	lui	a5,0x10000
    80005740:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80005742:	0007c783          	lbu	a5,0(a5)
      return;
    80005746:	8082                	ret

0000000080005748 <uartputc>:
{
    80005748:	7179                	addi	sp,sp,-48
    8000574a:	f406                	sd	ra,40(sp)
    8000574c:	f022                	sd	s0,32(sp)
    8000574e:	ec26                	sd	s1,24(sp)
    80005750:	e84a                	sd	s2,16(sp)
    80005752:	e44e                	sd	s3,8(sp)
    80005754:	e052                	sd	s4,0(sp)
    80005756:	1800                	addi	s0,sp,48
    80005758:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000575a:	0001b517          	auipc	a0,0x1b
    8000575e:	65e50513          	addi	a0,a0,1630 # 80020db8 <uart_tx_lock>
    80005762:	16e000ef          	jal	800058d0 <acquire>
  if(panicked){
    80005766:	00002797          	auipc	a5,0x2
    8000576a:	3467a783          	lw	a5,838(a5) # 80007aac <panicked>
    8000576e:	efbd                	bnez	a5,800057ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005770:	00002717          	auipc	a4,0x2
    80005774:	34873703          	ld	a4,840(a4) # 80007ab8 <uart_tx_w>
    80005778:	00002797          	auipc	a5,0x2
    8000577c:	3387b783          	ld	a5,824(a5) # 80007ab0 <uart_tx_r>
    80005780:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005784:	0001b997          	auipc	s3,0x1b
    80005788:	63498993          	addi	s3,s3,1588 # 80020db8 <uart_tx_lock>
    8000578c:	00002497          	auipc	s1,0x2
    80005790:	32448493          	addi	s1,s1,804 # 80007ab0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005794:	00002917          	auipc	s2,0x2
    80005798:	32490913          	addi	s2,s2,804 # 80007ab8 <uart_tx_w>
    8000579c:	00e79d63          	bne	a5,a4,800057b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800057a0:	85ce                	mv	a1,s3
    800057a2:	8526                	mv	a0,s1
    800057a4:	bdbfb0ef          	jal	8000137e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800057a8:	00093703          	ld	a4,0(s2)
    800057ac:	609c                	ld	a5,0(s1)
    800057ae:	02078793          	addi	a5,a5,32
    800057b2:	fee787e3          	beq	a5,a4,800057a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800057b6:	0001b497          	auipc	s1,0x1b
    800057ba:	60248493          	addi	s1,s1,1538 # 80020db8 <uart_tx_lock>
    800057be:	01f77793          	andi	a5,a4,31
    800057c2:	97a6                	add	a5,a5,s1
    800057c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800057c8:	0705                	addi	a4,a4,1
    800057ca:	00002797          	auipc	a5,0x2
    800057ce:	2ee7b723          	sd	a4,750(a5) # 80007ab8 <uart_tx_w>
  uartstart();
    800057d2:	ed7ff0ef          	jal	800056a8 <uartstart>
  release(&uart_tx_lock);
    800057d6:	8526                	mv	a0,s1
    800057d8:	190000ef          	jal	80005968 <release>
}
    800057dc:	70a2                	ld	ra,40(sp)
    800057de:	7402                	ld	s0,32(sp)
    800057e0:	64e2                	ld	s1,24(sp)
    800057e2:	6942                	ld	s2,16(sp)
    800057e4:	69a2                	ld	s3,8(sp)
    800057e6:	6a02                	ld	s4,0(sp)
    800057e8:	6145                	addi	sp,sp,48
    800057ea:	8082                	ret
    for(;;)
    800057ec:	a001                	j	800057ec <uartputc+0xa4>

00000000800057ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057ee:	1141                	addi	sp,sp,-16
    800057f0:	e422                	sd	s0,8(sp)
    800057f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800057f4:	100007b7          	lui	a5,0x10000
    800057f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800057fa:	0007c783          	lbu	a5,0(a5)
    800057fe:	8b85                	andi	a5,a5,1
    80005800:	cb81                	beqz	a5,80005810 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80005802:	100007b7          	lui	a5,0x10000
    80005806:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000580a:	6422                	ld	s0,8(sp)
    8000580c:	0141                	addi	sp,sp,16
    8000580e:	8082                	ret
    return -1;
    80005810:	557d                	li	a0,-1
    80005812:	bfe5                	j	8000580a <uartgetc+0x1c>

0000000080005814 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005814:	1101                	addi	sp,sp,-32
    80005816:	ec06                	sd	ra,24(sp)
    80005818:	e822                	sd	s0,16(sp)
    8000581a:	e426                	sd	s1,8(sp)
    8000581c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000581e:	54fd                	li	s1,-1
    80005820:	a019                	j	80005826 <uartintr+0x12>
      break;
    consoleintr(c);
    80005822:	85fff0ef          	jal	80005080 <consoleintr>
    int c = uartgetc();
    80005826:	fc9ff0ef          	jal	800057ee <uartgetc>
    if(c == -1)
    8000582a:	fe951ce3          	bne	a0,s1,80005822 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000582e:	0001b497          	auipc	s1,0x1b
    80005832:	58a48493          	addi	s1,s1,1418 # 80020db8 <uart_tx_lock>
    80005836:	8526                	mv	a0,s1
    80005838:	098000ef          	jal	800058d0 <acquire>
  uartstart();
    8000583c:	e6dff0ef          	jal	800056a8 <uartstart>
  release(&uart_tx_lock);
    80005840:	8526                	mv	a0,s1
    80005842:	126000ef          	jal	80005968 <release>
}
    80005846:	60e2                	ld	ra,24(sp)
    80005848:	6442                	ld	s0,16(sp)
    8000584a:	64a2                	ld	s1,8(sp)
    8000584c:	6105                	addi	sp,sp,32
    8000584e:	8082                	ret

0000000080005850 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005850:	1141                	addi	sp,sp,-16
    80005852:	e422                	sd	s0,8(sp)
    80005854:	0800                	addi	s0,sp,16
  lk->name = name;
    80005856:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005858:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000585c:	00053823          	sd	zero,16(a0)
}
    80005860:	6422                	ld	s0,8(sp)
    80005862:	0141                	addi	sp,sp,16
    80005864:	8082                	ret

0000000080005866 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005866:	411c                	lw	a5,0(a0)
    80005868:	e399                	bnez	a5,8000586e <holding+0x8>
    8000586a:	4501                	li	a0,0
  return r;
}
    8000586c:	8082                	ret
{
    8000586e:	1101                	addi	sp,sp,-32
    80005870:	ec06                	sd	ra,24(sp)
    80005872:	e822                	sd	s0,16(sp)
    80005874:	e426                	sd	s1,8(sp)
    80005876:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005878:	6904                	ld	s1,16(a0)
    8000587a:	d12fb0ef          	jal	80000d8c <mycpu>
    8000587e:	40a48533          	sub	a0,s1,a0
    80005882:	00153513          	seqz	a0,a0
}
    80005886:	60e2                	ld	ra,24(sp)
    80005888:	6442                	ld	s0,16(sp)
    8000588a:	64a2                	ld	s1,8(sp)
    8000588c:	6105                	addi	sp,sp,32
    8000588e:	8082                	ret

0000000080005890 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000589a:	100024f3          	csrr	s1,sstatus
    8000589e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058a2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058a4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800058a8:	ce4fb0ef          	jal	80000d8c <mycpu>
    800058ac:	5d3c                	lw	a5,120(a0)
    800058ae:	cb99                	beqz	a5,800058c4 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058b0:	cdcfb0ef          	jal	80000d8c <mycpu>
    800058b4:	5d3c                	lw	a5,120(a0)
    800058b6:	2785                	addiw	a5,a5,1
    800058b8:	dd3c                	sw	a5,120(a0)
}
    800058ba:	60e2                	ld	ra,24(sp)
    800058bc:	6442                	ld	s0,16(sp)
    800058be:	64a2                	ld	s1,8(sp)
    800058c0:	6105                	addi	sp,sp,32
    800058c2:	8082                	ret
    mycpu()->intena = old;
    800058c4:	cc8fb0ef          	jal	80000d8c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058c8:	8085                	srli	s1,s1,0x1
    800058ca:	8885                	andi	s1,s1,1
    800058cc:	dd64                	sw	s1,124(a0)
    800058ce:	b7cd                	j	800058b0 <push_off+0x20>

00000000800058d0 <acquire>:
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	e426                	sd	s1,8(sp)
    800058d8:	1000                	addi	s0,sp,32
    800058da:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800058dc:	fb5ff0ef          	jal	80005890 <push_off>
  if(holding(lk))
    800058e0:	8526                	mv	a0,s1
    800058e2:	f85ff0ef          	jal	80005866 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058e6:	4705                	li	a4,1
  if(holding(lk))
    800058e8:	e105                	bnez	a0,80005908 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800058ea:	87ba                	mv	a5,a4
    800058ec:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800058f0:	2781                	sext.w	a5,a5
    800058f2:	ffe5                	bnez	a5,800058ea <acquire+0x1a>
  __sync_synchronize();
    800058f4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800058f8:	c94fb0ef          	jal	80000d8c <mycpu>
    800058fc:	e888                	sd	a0,16(s1)
}
    800058fe:	60e2                	ld	ra,24(sp)
    80005900:	6442                	ld	s0,16(sp)
    80005902:	64a2                	ld	s1,8(sp)
    80005904:	6105                	addi	sp,sp,32
    80005906:	8082                	ret
    panic("acquire");
    80005908:	00002517          	auipc	a0,0x2
    8000590c:	f1050513          	addi	a0,a0,-240 # 80007818 <etext+0x818>
    80005910:	c93ff0ef          	jal	800055a2 <panic>

0000000080005914 <pop_off>:

void
pop_off(void)
{
    80005914:	1141                	addi	sp,sp,-16
    80005916:	e406                	sd	ra,8(sp)
    80005918:	e022                	sd	s0,0(sp)
    8000591a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    8000591c:	c70fb0ef          	jal	80000d8c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005920:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005924:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005926:	e78d                	bnez	a5,80005950 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005928:	5d3c                	lw	a5,120(a0)
    8000592a:	02f05963          	blez	a5,8000595c <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    8000592e:	37fd                	addiw	a5,a5,-1
    80005930:	0007871b          	sext.w	a4,a5
    80005934:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005936:	eb09                	bnez	a4,80005948 <pop_off+0x34>
    80005938:	5d7c                	lw	a5,124(a0)
    8000593a:	c799                	beqz	a5,80005948 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000593c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005940:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005944:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005948:	60a2                	ld	ra,8(sp)
    8000594a:	6402                	ld	s0,0(sp)
    8000594c:	0141                	addi	sp,sp,16
    8000594e:	8082                	ret
    panic("pop_off - interruptible");
    80005950:	00002517          	auipc	a0,0x2
    80005954:	ed050513          	addi	a0,a0,-304 # 80007820 <etext+0x820>
    80005958:	c4bff0ef          	jal	800055a2 <panic>
    panic("pop_off");
    8000595c:	00002517          	auipc	a0,0x2
    80005960:	edc50513          	addi	a0,a0,-292 # 80007838 <etext+0x838>
    80005964:	c3fff0ef          	jal	800055a2 <panic>

0000000080005968 <release>:
{
    80005968:	1101                	addi	sp,sp,-32
    8000596a:	ec06                	sd	ra,24(sp)
    8000596c:	e822                	sd	s0,16(sp)
    8000596e:	e426                	sd	s1,8(sp)
    80005970:	1000                	addi	s0,sp,32
    80005972:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005974:	ef3ff0ef          	jal	80005866 <holding>
    80005978:	c105                	beqz	a0,80005998 <release+0x30>
  lk->cpu = 0;
    8000597a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000597e:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80005982:	0f50000f          	fence	iorw,ow
    80005986:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000598a:	f8bff0ef          	jal	80005914 <pop_off>
}
    8000598e:	60e2                	ld	ra,24(sp)
    80005990:	6442                	ld	s0,16(sp)
    80005992:	64a2                	ld	s1,8(sp)
    80005994:	6105                	addi	sp,sp,32
    80005996:	8082                	ret
    panic("release");
    80005998:	00002517          	auipc	a0,0x2
    8000599c:	ea850513          	addi	a0,a0,-344 # 80007840 <etext+0x840>
    800059a0:	c03ff0ef          	jal	800055a2 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
