#include<stdio.h>
int main()
{
	int a = 0x1234;
	char *pc;    //1
	int*pi;       //4
	double *pd;  //8
	printf("&a:%08x  %08x\n\n\n",&a, a); //%08x 16Áø¼ö[before]
	
	pi = &a;
	pc = pi;
	pd = pi;
	
	
	printf("&a :%08x  %08x\n",&a, a); //[after]
	printf("p  :%08x  %08x   %08x\n", pi,pc, pd); 
	printf("p+1:%08x  %08x   %08x\n",++pi,++pc,++pd); 
	printf("p+2:%08x  %08x   %08x\n",pi+2,pc+2,pd+2); 

}
