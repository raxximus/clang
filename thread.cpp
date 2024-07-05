#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <iostream>

// Function to be executed by threads
void* print_message_function(void* ptr) {
    char* message;
    message = (char*) ptr;
    std::cout << message << std::endl;
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    const char* message1 = "Thread 1";
    const char* message2 = "Thread 2";

    // Create threads
    int ret1 = pthread_create(&thread1, NULL, print_message_function, (void*) message1);
    int ret2 = pthread_create(&thread2, NULL, print_message_function, (void*) message2);

    if (ret1) {
        printf("Error - pthread_create() return code: %d\n", ret1);
        exit(EXIT_FAILURE);
    }
    if (ret2) {
        printf("Error - pthread_create() return code: %d\n", ret2);
        exit(EXIT_FAILURE);
    }

    // Wait for threads to complete
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    printf("Threads completed successfully\n");

    return 0;
}
