#include <kernel/task.h>
#include <kernel/timer.h>
#include <kernel/mem.h>
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
	{
		k_putch(str[i]);
	}
}

int32_t do_getc()
{
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	int32_t retVal = -1;
	extern Task *cur_task;

	switch (syscallno)
	{
	case SYS_fork:
		/* TODO: Lab 5
     * You can reference kernel/task.c, kernel/task.h
     */
		//create process
		retVal = sys_fork(); //In task.c
		break;

	case SYS_getc:
		retVal = do_getc();
		break;

	case SYS_puts:
		do_puts((char*)a1, a2);
		retVal = 0;
		break;

	case SYS_getpid:
		/* TODO: Lab 5
     * Get current task's pid
     */
		//old Lab4: get current task's pid
		retVal = cur_task->task_id;
		break;

	case SYS_sleep:
		/* TODO: Lab 5
     * Yield this task
     * You can reference kernel/sched.c for yielding the task
     */
		//old Lab4 TODO: set task to sleep state and yield this task.
		cur_task->state = TASK_SLEEP;
		cur_task->remind_ticks = a1;
		sched_yield();
		break;

	case SYS_kill:
		/* TODO: Lab 5
     * Kill specific task
     * You can reference kernel/task.c, kernel/task.h
     */
		//old Lab4 TODO: kill task.
		//printk("before sys_kill, %d\n",cur_task->task_id);
		sys_kill(a1);
		break;

  case SYS_get_num_free_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
		retVal = sys_get_num_free_page();
    		break;

  case SYS_get_num_used_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
		retVal = sys_get_num_used_page();
    		break;

  case SYS_get_ticks:
		/* TODO: Lab 5
     * You can reference kernel/timer.c
     */
    retVal = sys_get_ticks();
    break;

  case SYS_settextcolor:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
		sys_settextcolor(a1, 0);
		retVal = 0;
    		break;

  case SYS_cls:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
		sys_cls();
		retVal = 0;
    		break;

	}
	return retVal;
}

static void syscall_handler(struct Trapframe *tf)
{
	/* TODO: Lab5
   * call do_syscall
   * Please remember to fill in the return value
   * HINT: You have to know where to put the return value
   */
	/*        
	uint16_t tf_es;
        uint16_t tf_padding1;
        uint16_t tf_ds;
        uint16_t tf_padding2;
        uint32_t tf_trapno;
        // below here defined by x86 hardware
        uint32_t tf_err;
        uintptr_t tf_eip;
        uint16_t tf_cs;
        uint16_t tf_padding3;
        uint32_t tf_eflags;
        // below here only when crossing rings, such as from user to kernel
        uintptr_t tf_esp;
        uint16_t tf_ss;
        uint16_t tf_padding4;
	*/


	int32_t ret = -1;
	// call do_syscall and pass the parmeters from tf
	ret = do_syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi);

	/* Set system return value */
	tf->tf_regs.reg_eax = ret;

}

void syscall_init()
{
  /* TODO: Lab5
   * Please set gate of system call into IDT
   * You can leverage the API register_handler in kernel/trap.c
   */
	extern void SYSCALL();
//	register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
	register_handler(T_SYSCALL, syscall_handler, SYSCALL, 0, 3);
	// then declare SYSCALL in entry_trap.S

}

