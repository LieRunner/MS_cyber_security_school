#include<stdio.h>

int f(int *arr,int size){
	int min= *arr;
	int i;
	for (i=1;i<size;i++)
	{
		if(*(arr+i)<min){
			min= *(arr +i);
		}
	}
	return min;
}

int main(){
	int num[5];
	int i;
	
	printf("정수 5개를 입력하세요:");
	for(i=0 ;i<5 ;i++){
		scanf("%d",num+i);
}
		int min1 = f(num,5);
		
		printf("가장 작은 수는 %d입니다.\n",min1);
		
		return 0;
	
}
