#include<stdio.h>

char *s1 ="Good";
char *s2 ="afternoon";
char* ss[] = { s1, s2}; //���� �κ��� ������ �ʿ���� 
int main()
{
	/*char b[100];      //�Һ��������� 
	strcpy(b,str);    //���� 
	char *p =b;
	
	printf("before : \"%s %s\"\n", p);
	*(p+4)= '_'; //�Һ������� �ִ°��� ������������ ������ �´� 
	printf("after  : \"%s\"\n",p);*/
	
	printf ("\"%s %s\"\n",ss[0],ss[1] );
}
