#ifndef INC_01_MATH_MATH_H
#define INC_01_MATH_MATH_H

#include <vector>
using namespace std;

long long sum_div_3_5(long max_number);

unsigned int gcd(unsigned int first, unsigned int second);

unsigned int lcm2(unsigned int first, unsigned int second);

int lcm_poly(vector<int> values);

bool is_prime(int number);

int largest_prime_smaller_than(int limit);

vector<pair<int, int>> sexy_primes(int limit);

int proper_div_sum(int number);

vector<pair<int, int>> abundants(int limit);

vector<pair<int, int>> amicables(int limit);

inline int cube(int x);

vector<int> armstrong();

vector<int> prime_factors(int number);

int largest_prime_factor(int number);
#endif //INC_01_MATH_MATH_H
