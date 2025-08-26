#include<stdio.h>
#include<conio.h>

int rectangle (int a, int b);
double triangle (int a, int b);

int main()
{
int x, y;

    printf("(x, y)?"); scanf("%d %d", &x, &y);
    int r = rectangle(x,y);	
    double t = triangle(x,y);

    printf("밑변이 %d이고 높이고 %d인 사각형의 면적은 %d입니다.",x, y, r);
    printf("밑변이 %d이고 높이고 %d인 삼각형의 면적은 %f입니다.",x, y, t);
    getch(); //,없어도 상관없는 코드임 
}
int rectangle(int a, int b)
{
	int xy = a * b;
	return xy;

}
double triangle(int a, int b)
{
	double xy=(double)a * (double)b / 2.0;
	return xy;
}

