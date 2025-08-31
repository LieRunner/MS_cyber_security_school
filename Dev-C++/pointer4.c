#include<stdio.h>
int main()
{
  int arr[5]={10,20,30,40,50};
  
  //배열요소출력
   
  for(int i = 0;i < 5;i++)
  {
    printf("arr[%d] = %d\n", i, arr[i]);
  }
  printf("   arr  = %p\n",arr);
  printf("&arr[0] = %p\n",&arr[0]);
  
  return 0;
}

