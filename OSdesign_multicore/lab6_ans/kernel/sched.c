#include <kernel/task.h>
#include <kernel/cpu.h>
#include <inc/x86.h>

#define ctx_switch(ts) \
  do { env_pop_tf(&((ts)->tf)); } while(0)

/* TODO: Lab5
* Implement a simple round-robin scheduler (Start with the next one)
*
* 1. You have to remember the task you picked last time.
*
* 2. If the next task is in TASK_RUNNABLE state, choose
*    it.
*
* 3. After your choice set cur_task to the picked task
*    and set its state, remind_ticks, and change page
*    directory to its pgdir.
*
* 4. CONTEXT SWITCH, leverage the macro ctx_switch(ts)
*    Please make sure you understand the mechanism.
*/

//
// TODO: Lab6
// Modify your Round-robin scheduler to fit the multi-core
// You should:
//
// 1. Design your Runqueue structure first (in kernel/task.c)
//
// 2. modify sys_fork() in kernel/task.c ( we dispatch a task
//    to cpu runqueue only when we call fork system call )
//
// 3. modify sys_kill() in kernel/task.c ( we remove a task
//    from cpu runqueue when we call kill_self system call
//
// 4. modify your scheduler so that each cpu will do scheduling
//    with its runqueue
//    
//    (cpu can only schedule tasks which in its runqueue!!) 
//    (do not schedule idle task if there are still another process can run)	
//
void sched_yield(void)
{
	extern Task tasks[];
	int i = (thiscpu->cpu_rq.index + 1) % NR_TASKS;
	int idle_index = -1;
	
	if(thiscpu->cpu_task->state == TASK_RUNNING)
	{
		thiscpu->cpu_task->state = TASK_RUNNABLE;
		thiscpu->cpu_task->remind_ticks = TIME_QUANT;
	}

	for(; i != thiscpu->cpu_rq.index; i = (i+1) % NR_TASKS)
	{
		//printk("sched\n");
		if(i == thiscpu->cpu_rq.tail)
		{
			i = thiscpu->cpu_rq.head;
			if(i == thiscpu->cpu_rq.index)
				break;
		}

		if(thiscpu->cpu_rq.queue[i] == thiscpu->cpu_rq.idle_pid)
		{	
			idle_index = i;
			continue;
		}

		if(tasks[thiscpu->cpu_rq.queue[i]].state == TASK_RUNNABLE)
		{
			thiscpu->cpu_task = &(tasks[thiscpu->cpu_rq.queue[i]]);
			break;
		}
	}
	//printk("%d idle_index %d\n", cpunum(), idle_index);
	/*

	if(i == thiscpu->cpu_task->task_id && thiscpu->cpu_task->state == TASK_RUNNABLE)
	{
		thiscpu->cpu_task = &(tasks[i]);
	}
	*/
	if(i == thiscpu->cpu_rq.index )
	{	
		if(tasks[thiscpu->cpu_rq.queue[i]].state == TASK_RUNNABLE)
			thiscpu->cpu_task = &(tasks[thiscpu->cpu_rq.queue[i]]);
		else
		{
			if(idle_index == -1)
				panic("No idle_index\n");
			thiscpu->cpu_task = &(tasks[thiscpu->cpu_rq.idle_pid]);
			i = idle_index;
		}
	}

	
	if(thiscpu->cpu_task->state != TASK_RUNNABLE)
		panic("CPU:%d sched_yield wrong\n",cpunum());
	
	thiscpu->cpu_rq.index = i;	
	thiscpu->cpu_task->state = TASK_RUNNING;
	//print_trapframe(&(cur_task->tf));
	
	//printk("%d switch to %d\n", cpunum(), thiscpu->cpu_task->task_id);
	lcr3(PADDR(thiscpu->cpu_task->pgdir));
	ctx_switch(thiscpu->cpu_task);
}
