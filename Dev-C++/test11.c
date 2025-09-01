#include<stdio.h>
int main()
{ 
int i= 10;
int *p=&i;
int **pp=&p;

printf(" i : %08x (%08x)\n", &i, i);
printf(" p : %08x (%08x) (%08x)\n", &p, p, *p);
printf("pp : %08x (%08x) \n", &pp, pp);
}
