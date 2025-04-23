#include <stdio.h>  
#include <stdlib.h>  
  
int main(int argc, char *argv[]) {  
    if (argc != 3) {  
        printf("Usage: %s <n/s> <n/KB>\n", argv[0]);  
        return 1;  
    }  
  
    size_t time = atoi(argv[1]);  
    size_t megs = atoi(argv[2]);  
    size_t bytes = megs * 1024;  
  
    void *ptr;  
  
    // 注意：我们没有释放内存，这会导致内存泄漏  
    // 在实际应用中，应该在使用完内存后释放它  
  
    printf("Allocated %zu bytes at %p\n", bytes, ptr);  
  
    // 为了使程序持续运行，我们可以进入一个无限循环  
    // 但这通常不是测试内存泄漏的好方法，因为它会阻止系统释放内存  
    // 在这里，我们只是简单地暂停程序以便你可以观察内存使用情况  
    while (1) {  
        sleep(time);  
	ptr = malloc(bytes);
        if (ptr == NULL) {
            printf("内存已耗尽！！！\n");
            break; // 退出循环
        }
    }  
    printf("申请内存失败！！！\n") 
    return 0; // 这行代码实际上永远不会被执行  
}

