#include<stdio.h>

char *s1 ="Good";
char *s2 ="afternoon";
char* ss[] = { s1, s2}; //참조 부분을 쓸데는 필요없음 
int main()
{
	/*char b[100];      //불변영역복사 
	strcpy(b,str);    //복사 
	char *p =b;
	
	printf("before : \"%s %s\"\n", p);
	*(p+4)= '_'; //불변영역에 있는것을 가변영역으로 복사해 온다 
	printf("after  : \"%s\"\n",p);*/
	
	printf ("\"%s %s\"\n",ss[0],ss[1] );
}
