#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <unistd.h>

#include <libproc.h>


int main(int argc, char *argv[])
{
    pid_t pid;
    char *error = NULL;
    struct proc_bsdinfo proc;
    int result;

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

#define pidinfo(pid, proc) \
    result = proc_pidinfo( \
        (pid), PROC_PIDTBSDINFO, 0, &(proc), PROC_PIDTBSDINFO_SIZE \
    ); \
    if (errno || result != PROC_PIDTBSDINFO_SIZE) { \
        perror("Cannot get process info"); \
        return 1; \
    } \
;

    // it seems like the macos kernel doesn't keep track of sid...
    // heuristic: my session leader is the pgid of the parent of my pgid
    pidinfo(pid, proc);
    pidinfo(proc.pbi_pgid, proc);
    printf(
        "pid: %i comm: %s sleader: %0#10x\n"
        , proc.pbi_pid
        , proc.pbi_comm
        , ((int)proc.pbi_flags & (int)PROC_FLAG_SLEADER)
    );

    while ((proc.pbi_flags & PROC_FLAG_SLEADER) != PROC_FLAG_SLEADER) {
      // get the process group leader of my parent
      pidinfo(proc.pbi_ppid, proc);
      pidinfo(proc.pbi_pgid, proc);
      printf(
          "pid: %i comm: %s sleader: %0#10x\n"
          , proc.pbi_pid
          , proc.pbi_comm
          , proc.pbi_flags & PROC_FLAG_SLEADER
      );
    }

    printf("%i\n", proc.pbi_pgid);

    return 0;
}
