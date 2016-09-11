
user/main.o:     file format elf32-i386


Disassembly of section .text:

00000000 <user_entry>:
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <inc/shell.h>

int user_entry()
{
   0:	83 ec 1c             	sub    $0x1c,%esp
	//cprintf("in user_entry!\n");

	asm volatile("movl %0,%%eax\n\t" \
   3:	b8 23 00 00 00       	mov    $0x23,%eax
   8:	8e d8                	mov    %eax,%ds
   a:	8e c0                	mov    %eax,%es
   c:	8e e0                	mov    %eax,%fs
   e:	8e e8                	mov    %eax,%gs
    "movw %%ax,%%fs\n\t" \
    "movw %%ax,%%gs" \
    :: "i" (0x20 | 0x03)
  );

  cprintf("Welcome to User Land, cheers!\n");
  10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  17:	e8 fc ff ff ff       	call   18 <user_entry+0x18>
  shell();
  1c:	e8 fc ff ff ff       	call   1d <user_entry+0x1d>
  21:	eb fe                	jmp    21 <user_entry+0x21>
