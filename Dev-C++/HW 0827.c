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
	
	printf("���� 5���� �Է��ϼ���:");
	for(i=0 ;i<5 ;i++){
		scanf("%d",num+i);
}
		int min1 = f(num,5);
		
		printf("���� ���� ���� %d�Դϴ�.\n",min1);
		
		return 0;
	
}
