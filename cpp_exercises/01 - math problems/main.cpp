#include <iostream>

using namespace std;


// 1. Sum of naturals divisible by 3 and 5
// Write a program that calculates and prints the sum of all the natural numbers
// divisible by either 3 or 5, up to a given limit entered by the user.
long long sum_div_3_5(long max_number){
    long long sum(0);

    for(int number=3; number < max_number; number++){
        if(number % 3 == 0 || number % 5 == 0){
            sum += number;
        }
    }
    return sum;
}

// 2. Greatest common divisor
unsigned int gcd(unsigned int first, unsigned int second){
    // The Euclidean algorithm is based on the principle that GCD does not change if
    // the larger number is replaced by its difference with the smaller number.
    if(first==0 || second==0) return 0;
    return (first == second) ? first :  gcd(max(first, second) - min(first, second), min(first, second));
};

// 3. Least common multiple
// Write a program that will, given two or more positive integers, calculate and print the least
// common multiple of them all. (x*y/GCD)

