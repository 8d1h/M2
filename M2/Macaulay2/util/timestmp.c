/* Unfortunately, the 'date' command doesn't exist on MSDOS, so we provide
   this for generating a timestamp.
   The timestamp is used to distinguish one binary of Macaulay2 from the next.
   This is important to prevent a mismatch between the executable and the
   dumped data file.
*/

#include <stdio.h>
#include <time.h>

main() {
     char buf[100], *p;
     time_t t;
     time(&t);
     strcpy(buf,ctime(&t));
     for (p=buf; *p; p++) if (*p == '\n') *p = 0;
     fputs("char timestamp[] = \"",stdout);
     fputs(buf,stdout);
     fputs("\";\n",stdout);
     return 0;
     }
