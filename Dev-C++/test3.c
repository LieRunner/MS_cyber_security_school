#include<stdio.h>

int main()
{
	int x, y;
	int A, O, X, N;
	printf("x y A O X N\n");
	printf("===========\n");
	x=1, y=1; printf("%d,%d,%d,%d,%d,%d\n",x,y,x&&y,x||y,x^y,!x);
	x=1, y=0; printf("%d,%d,%d,%d,%d,%d\n",x,y,x&&y,x||y,x^y,!x);
	x=0, y=1; printf("%d,%d,%d,%d,%d,%d\n",x,y,x&&y,x||y,x^y,!x);
	x=0, y=0; printf("%d,%d,%d,%d,%d,%d\n",x,y,x&&y,x||y,x^y,!x);
    return 0;

}
