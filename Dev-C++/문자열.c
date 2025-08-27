#include<stdio.h>

int main()
{ int i;
char ch;
char str[6]="Hello";

printf("--변경 전 문자열--\n");
printf("%s \n",str);

for(i=0; i<6; i++)
printf("%c |",str[i]);

for(i=0; i<3; i++)
{
	ch=str[4-i];
	str[4-i]=str[i];
	str[i]=ch;
}

printf("\n\n--변경 후 문자열\n");
printf("%s \n",str);
return 0;
}
