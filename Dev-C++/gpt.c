#include <stdio.h>

// �����͸� �̿��� �ּҰ��� ã�� �Լ�
int f(int *arr, int size) {
    int m = *arr;   // ù ��° ���� �� (*arr)
	int i;            
    for (i = 1; i < size; i++) {
        if (*(arr + i) < m) {  // arr[i] ��� *(arr + i) ���
            m = *(arr + i);
        }
    }
    return m;  // �ּҰ� ��ȯ
}

int main() {
    int numbers[5];
    int i;

    // ���� �Է� �ޱ�
    printf("���� 5���� �Է��ϼ���: ");
    for (i = 0; i < 5; i++) {
        scanf("%d", numbers + i);  // &numbers[i] ��� numbers + i
    }

    // �Լ� ȣ�� (�迭 �̸��� �� �ּ��̹Ƿ� �����ͷ� ���޵�)
    int min1 = f(numbers, 5);

    printf("���� ���� ���� %d�Դϴ�.\n", min1);

    return 0;
}







