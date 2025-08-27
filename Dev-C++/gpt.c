#include <stdio.h>

// 포인터를 이용해 최소값을 찾는 함수
int f(int *arr, int size) {
    int min = *arr;   // 첫 번째 원소 값 (*arr)
	int i;            
    for (i = 1; i < size; i++) {
        if (*(arr + i) < min) {  // arr[i] 대신 *(arr + i) 사용
            min = *(arr + i);
        }
    }
    return min;  // 최소값 반환
}

int main() {
    int numbers[5];
    int i;

    // 정수 입력 받기
    printf("정수 5개를 입력하세요: ");
    for (i = 0; i < 5; i++) {
        scanf("%d", numbers + i);  // &numbers[i] 대신 numbers + i
    }

    // 함수 호출 (배열 이름은 곧 주소이므로 포인터로 전달됨)
    int min1 = f(numbers, 5);

    printf("가장 작은 수는 %d입니다.\n", min1);

    return 0;
}







