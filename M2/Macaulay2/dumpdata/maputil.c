#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include "maputil.h"
  
static unsigned int checksum(unsigned char *p, unsigned int len) {
  unsigned int c = 0;
  while (0 < len--) c = 23 * c + *p++;
  return c;
}

int isCheckable(map m) {
  return !m->w && m->r;
}

static void checkmap(map m) {
  m->checksum = isCheckable(m) ? checksum(m->from, m->to - m->from) : 0;
}

void checkmaps(int nmaps, struct MAP m[nmaps]) {
  int i;
  for (i=0; i<nmaps; i++) {
    checkmap(&m[i]);
  }
}

char mapfmt[] = "%010p-%010p %c%c%c %u\n";

int isStack(map m) {
  void *p = &p;
  return p - m->from >= 0 && m->to - p > 0;
}

int isDumpable(map m) {
  return m->w && m->r && !isStack(m);
}

void sprintmap(char *s, map m) {
  sprintf(s,mapfmt, 
	  m->from, m->to,
	  m->r ? 'r' : '-', m->w ? 'w' : '-', m->x ? 'x' : '-',
	  m->checksum);
}

void fdprintmap(int fd, map m) {
  char buf[200];
  sprintmap(buf,m);
  write(fd,buf,strlen(buf));
}
