#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <libproc.h>
#include <unistd.h>

int main (int argc, char* argv[])
{
  int ret;
  pid_t pid;
  char *error = NULL;
  char pathbuf[PROC_PIDPATHINFO_MAXSIZE];

  if ( argc != 2 ) {
    fprintf(stderr, "usage: %s PID\n", argv[0]);
    return 1;
  }

  pid = strtol(argv[1], &error, 10);
  if ( errno != 0 ) {
    perror(argv[0]);
    return errno;
  } else if ( error[0] != '\0' ) {
    fprintf(stderr, "trailing garbage: %s\n", error);
    return 1;
  }
  ret = proc_pidpath (pid, pathbuf, sizeof(pathbuf));
  if ( errno ) {
    perror("proc_pidpath");
    return errno;
  } else if ( ret < 0 ) {
    fprintf(stderr, "proc_pidpath: unknown error: %i\n", ret);
    return ret;
  } else {
    printf("%s\n", pathbuf);
    return 0;
  }

}
