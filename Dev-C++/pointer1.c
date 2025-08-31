#include<stdio.h>

int main()
{
  int a = 10;   //일반 변수
  int *p;       //포인터 변수 (int형을 가리킴)
  
  p = &a;
  
  printf("a의 값: %d\n",a);             //10
  printf("a의 주소: %p\n",&a);           //주소값
  printf("p에 저장된 값(주소): %p\n",p);   //주소값
  printf("*p가 가리키는 값: %d\n",*p);    //10
  
  return 0;
  
}
