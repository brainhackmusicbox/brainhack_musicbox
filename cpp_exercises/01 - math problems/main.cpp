#include <iostream>
#include <numeric>
#include <vector>
#include <utility>
#include <cmath>
#include <algorithm>
#include "math_problems.h"

using namespace std;


// 1. Sum of naturals divisible by 3 and 5
// sum of all the natural numbers divisible by either 3 or 5, up to a given limit entered by the user.
long long sum_div_3_5(long max_number){
    long long sum(0);

    for(int number=3; number < max_number; number++){
        if(number % 3 == 0 || number % 5 == 0) sum += number;
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
// given two or more positive integers, calculate and print the least common multiple of them all. (x*y/GCD)
unsigned int lcm2(unsigned int first, unsigned int second){
    // for two values
    return gcd(first, second) ? first*second/gcd(first, second) : 0;
};

int lcm_poly(vector<int> values){
    // for many values
    return accumulate(values.begin(), values.end(), 1, lcm2);
};

// 4. Largest prime smaller than given number
bool is_prime(const int number){
    bool prime = true;

    for(int tmp=2; tmp<number; tmp++){
        if(number % tmp == 0) prime = false;
    };

    return prime;
};

int largest_prime_smaller_than(const int limit){
    if(limit <= 1) return 0;
    for(int tmp = limit-1; tmp > 1; tmp--){
        if(is_prime(tmp)) return tmp;
    };
};


// 5. Sexy prime pairs
//Write a program that prints all the sexy prime pairs up to a limit entered by the user.
vector<pair<int, int>> sexy_primes(const int limit){
    vector<pair<int, int>> result;

    for(int tmp=1; tmp < limit; tmp++){
        if(is_prime(tmp) && is_prime(tmp+6)) result.emplace_back(tmp, tmp+6);
    };

    if(result.empty()) result.emplace_back(0,0);
    return result;

};

// =====================================================================================================================
// 6. Abundant numbers
// Write a program that prints all abundant numbers and their abundance, up to a number entered by the user.
int proper_div_sum(const int number){
    int result = 1;

    // why _prime_ factors and sqrt(number)? Wiki says it's about any divisor without reminder
    for (int current = 2; current < number; current++) {
        if(number % current == 0){
            result += (current == (number % current)) ? current : current + number % current;
        };
    }

    return result;
};

vector<pair<int, int>> abundants(int limit){
    vector<pair<int, int>> result;

    for (int current = 1; current < limit; ++current) {
        int div_sum = proper_div_sum(current);

        if(div_sum > current) result.emplace_back(current, abs(div_sum - current));
    }

    return result;
};

// =====================================================================================================================
// 7. Amicable numbers
// Write a program that prints the list of all pairs of amicable numbers smaller than 1,000,000.
// (sum of the proper divisors of each is equal to the other number.)
vector<pair<int, int>> amicables(int limit){
    vector<pair<int, int>> result;

    for (int current = 4; current < limit; ++current) {
        int div_sum = proper_div_sum(current);
        int div_sum_reverse = proper_div_sum(div_sum);

        // current < div_sum: dumb but efficient duplicates filtering
        if(div_sum_reverse == current && current != div_sum && current < div_sum) result.emplace_back(current, div_sum);
    }

    return result;
};

// =====================================================================================================================
// 8. Armstrong numbers
// Write a program that prints all Armstrong numbers with three digits.
// Armstrong number is a number such that the sum of its digits raised to the third power is equal to the number itself.
// For example, 371 is an Armstrong number, since 3**3 + 7**3 + 1**3 = 371.

inline int cube(int x){ return x*x*x; };

vector<int> armstrong(){
    vector<int> result;

    for (int first_digit = 1; first_digit < 9; ++first_digit) {
        for (int second_digit = 0; second_digit < 9; ++second_digit) {
            for (int third_digit = 0; third_digit < 9; ++third_digit) {
                int cubes_sum = cube(first_digit) + cube(second_digit) + cube(third_digit);

                // XYZ = X*100 + Y*10 + Z
                int number = first_digit*100 + second_digit*10 + third_digit;

                if(cubes_sum == number) result.emplace_back(number);
            }

        }
    }

    return result;
};

// =====================================================================================================================
// 9. Prime factors
// Write a program that prints the prime factors of a number entered by the user.
vector<int> prime_factors(int number){
    vector<int> result;

    while(number % 2 == 0){
        result.emplace_back(2);
        number /= 2;
    };

    for(int tmp=3; tmp <= sqrt(number); tmp+=2){
        while(number % tmp == 0){
            result.emplace_back(tmp);
            number /= tmp;
        };
    };

    if(number>2) result.emplace_back(number);

    return result;
};

int largest_prime_factor(int number){
    vector<int> factors = prime_factors(number);
    return *max_element(factors.begin(), factors.end());
};
// =====================================================================================================================
// 10. Gray code
// Write a program that displays the normal binary representations, Gray code
// representations, and decoded Gray code values for all 5-bit numbers.

// all 5-bit numbers == 1..32
bit5 dec2bin(unsigned int decimal){
    return bit5(decimal);
};


bit5 bin2gray(bit5 bin){
//    cout << "bin: " << bin << "\n";

    bit5 shifted = bin >> 1;
//    cout << "shifted: " << shifted << "\n";

    bit5 gray = bin ^ shifted;
//    cout << "result: " << gray << "\n";
    return gray;
};


bit5 gray2bin(bit5 gray){
    // The Most Significant Bit (MSB) of the gray code is always equal to the MSB of the given binary code.
    // Other bits of the output gray code can be obtained by XORing binary code bit at that index and previous index.
//    cout << "gray: " << gray << "\n";
//    cout << "1U << 5: " << (1U << 5) << "\n";

    for (unsigned int bit = 1U << 5; bit > 0; bit >>= 1) {
//        cout << "bit: " << bit5(bit);
//        cout << "\t gray: "<< gray;
//        cout << "\t\t gray & bit5(" << bit << "):\t" << (gray & bit5(bit));

        if(gray.to_ulong() & bit){
            gray ^= bit >> 1;
//            cout<< "\t True" << "\t result: " << gray << "\n";
        }else{
//            cout<< "\n";
        };
    }

    return gray;
};

// =====================================================================================================================
// 11. Converting numerical values to Roman
// 1994 is MCMXCIV
string dec2roman(unsigned int decimal){
    map<unsigned int, const char*, greater<int>> roman_numbers = {
            {1, "I"},
            {4, "IV"},
            {5, "V"},
            {9, "IX"},
            {10, "X"},
            {40, "XL"},
            {50, "L"},
            {90, "XC"},
            {100, "C"},
            {400, "CD"},
            {500, "D"},
            {900, "CM"},
            {1000, "M"}
        };

    string result;

    for(auto number: roman_numbers){
        while (number.first <= decimal){
            decimal -= number.first;
            result += number.second;
        };
    };
    return result;
};