#include<stdio.h>

int main()
{
  int arr[3] = {10,20,30};
  int *p = arr;
  
  printf("p = %p, *p = %d\n",p, *p);
  p++;
  printf("p = %p, *p = %d\n",p, *p);
  p++;
  printf("p = %p, *p = %d\n",p, *p);
  return 0;
}
