#include <stdio.h>
#include "submodules/math_utils/math_utils.h"

int main(void) {
    printf("=========================================\n");
    printf("     C Application with Submodule Demo   \n");
    printf("=========================================\n\n");

    // 1. Basic Arithmetic via Submodule
    int a = 24, b = 7;
    printf("[Arithmetic Operations]\n");
    printf("%d + %d = %d\n", a, b, math_add(a, b));
    printf("%d - %d = %d\n", a, b, math_subtract(a, b));
    printf("%d * %d = %d\n", a, b, math_multiply(a, b));

    // Division with error handling
    int status = 0;
    double div_result = math_divide(a, b, &status);
    if (status == MATH_SUCCESS) {
        printf("%d / %d = %.4f\n", a, b, div_result);
    }

    // Testing division by zero
    double zero_div = math_divide(10, 0, &status);
    if (status == MATH_ERR_DIV_BY_ZERO) {
        printf("10 / 0 = Error: Division by zero caught successfully!\n\n");
    }

    // 2. Advanced Math Operations
    printf("[Advanced Math Operations]\n");
    int num = 6;
    long long fact = math_factorial(num, &status);
    if (status == MATH_SUCCESS) {
        printf("Factorial of %d = %lld\n", num, fact);
    }

    double base = 2.0;
    int exp = 8;
    printf("%.1f ^ %d = %.2f\n", base, exp, math_power(base, exp));

    int num1 = 48, num2 = 18;
    printf("GCD of %d and %d = %d\n", num1, num2, math_gcd(num1, num2));

    int fib_n = 10;
    long long fib_val = math_fibonacci(fib_n, &status);
    if (status == MATH_SUCCESS) {
        printf("Fibonacci(%d) = %lld\n", fib_n, fib_val);
    }

    int test_numbers[] = {2, 17, 21, 29, 35};
    int count = sizeof(test_numbers) / sizeof(test_numbers[0]);
    printf("Prime checks: ");
    for (int i = 0; i < count; i++) {
        printf("%d is %s%s", test_numbers[i],
               math_is_prime(test_numbers[i]) ? "prime" : "not prime",
               (i < count - 1) ? ", " : "\n\n");
    }

    // 3. Geometry Operations
    printf("[Geometry Calculations]\n");
    double radius = 4.5;
    double area = math_circle_area(radius, &status);
    if (status == MATH_SUCCESS) {
        printf("Area of circle (radius = %.2f): %.4f\n", radius, area);
    }

    double width = 5.0, height = 8.0;
    double rect_area = math_rectangle_area(width, height, &status);
    if (status == MATH_SUCCESS) {
        printf("Area of rectangle (%.2f x %.2f): %.2f\n", width, height, rect_area);
    }

    printf("\nExecution completed successfully!\n");
    return 0;
}
