#ifndef INC_01_MATH_MATH_H
#define INC_01_MATH_MATH_H

#include <vector>
#include <bitset>
#include <map>
#include <exception>
using namespace std;

// 1. Sum of naturals divisible by 3 and 5
long long sum_div_3_5(long max_number);

// 2. Greatest common divisor
unsigned int gcd(unsigned int first, unsigned int second);

// 3. Least common multiple
unsigned int lcm2(unsigned int first, unsigned int second);

int lcm_poly(vector<int> values);

// 4. Largest prime smaller than given number
bool is_prime(int number);

int largest_prime_smaller_than(int limit);

// 5. Sexy prime pairs
vector<pair<int, int>> sexy_primes(int limit);

// 6. Abundant numbers
int proper_div_sum(int number);

vector<pair<int, int>> abundants(int limit);

// 7. Amicable numbers
vector<pair<int, int>> amicables(int limit);

// 8. Armstrong numbers
inline int cube(int x);

vector<int> armstrong();

// 9. Prime factors
vector<int> prime_factors(int number);

int largest_prime_factor(int number);

// 10. Gray code
typedef bitset<5> bit5;
bit5 dec2bin(unsigned int decimal);
bit5 bin2gray(bit5 bin);
bit5 gray2bin(bit5 gray);

// 11. Converting numerical values to Roman
string dec2roman(unsigned int decimal);

// 12. Largest Collatz sequence
pair<int, long> longest_collatz(int limit);

#endif //INC_01_MATH_MATH_H
