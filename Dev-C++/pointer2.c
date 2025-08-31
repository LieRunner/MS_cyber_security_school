#include<stdio.h>

int main()
{
  int a=2005;
  int* p;
  p = &a; 
  
  printf("p : %p \n",p);
  printf("&a : %p \n",&a);
  
         
  
  printf("a : %d \n",a);
  printf("*p : %d \n",*p);
  
  return 0;
}
