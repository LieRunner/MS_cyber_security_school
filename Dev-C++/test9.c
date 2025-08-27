#include<stdio.h>

int main()
{
	int arr[]={1,2,3,4,5,6,7,8,9 }; //;세미콜론 중요함
	int* p = arr;
	
	int i;
	printf("int arr[] = {");
	for(i=0; i<9; i++) //for(int i=0;는 c++용 코드 
	{
	    printf("%d", p[i]); //arr[i]로도 동작함 
	    if(i<8) printf(","); 
    }
    printf("};");
	 return i;
}
