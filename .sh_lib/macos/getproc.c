#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#include <libproc.h>



void show_proc(struct proc_bsdinfo *proc) {
      printf("  flags: %0#10x\n", proc->pbi_flags);              /* 64bit; emulated etc */
      printf(" status: %i\n", proc->pbi_status);
      printf("xstatus: %i\n", proc->pbi_xstatus);
      printf("    pid: %i\n", proc->pbi_pid);
      printf("   ppid: %i\n", proc->pbi_ppid);
      printf("    uid: %i\n", proc->pbi_uid);
      printf("    gid: %i\n", proc->pbi_gid);
      printf("   ruid: %i\n", proc->pbi_ruid);
      printf("   rgid: %i\n", proc->pbi_rgid);
      printf("  svuid: %i\n", proc->pbi_svuid);
      printf("  svgid: %i\n", proc->pbi_svgid);
      printf("  rfu_1: %i\n", proc->rfu_1);                  /* reserved */
      printf("   comm: %s\n", proc->pbi_comm);
      printf("   name: %s\n", proc->pbi_name);  /* empty if no name is registered */
      printf(" nfiles: %i\n", proc->pbi_nfiles);
      printf("   pgid: %i\n", proc->pbi_pgid);
      printf("  pjobc: %i\n", proc->pbi_pjobc);
      printf("   tdev: %i\n", proc->e_tdev);                 /* controlling tty dev */
      printf("  tpgid: %i\n", proc->e_tpgid);                /* tty process group id */
      printf("   nice: %i\n", proc->pbi_nice);
      printf("start s: %llu\n", proc->pbi_start_tvsec);
      printf("start u: %llu\n", proc->pbi_start_tvusec);
}

int main(int argc, char *argv[])
{
    pid_t pid;
    char *error = NULL;
    struct proc_bsdinfo proc;

    if ( argc == 1 ) {
      pid = getpid();
    } else if ( argc == 2 ) {
      pid = strtol(argv[1], &error, 10);
      if ( errno != 0 ) {
        perror(argv[0]);
        return errno;
      } else if ( error[0] != '\0' ) {
        fprintf(stderr, "trailing garbage: %s\n", error);
        return 1;
      }
    } else {
      fprintf(stderr, "usage: %s [PID]\n", argv[0]);
      return 1;
    }

    do {
      int st = proc_pidinfo(
          pid, PROC_PIDTBSDINFO, 0, &proc, PROC_PIDTBSDINFO_SIZE
      );
      if (st != PROC_PIDTBSDINFO_SIZE) {
          perror("Cannot get process info");
          return 1;
      }

      show_proc(&proc);
      printf("---\n");

      pid = proc.pbi_ppid;
    } while ( pid > 0 );

    return 0;
}
