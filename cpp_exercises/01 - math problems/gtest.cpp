#include "gtest/gtest.h"
#include "math_problems.h"


// 1. Sum of naturals divisible by 3 and 5
TEST(math_01_Sum, Zero){
    EXPECT_EQ(sum_div_3_5(0), 0);
}

TEST(math_01_Sum, One){
    EXPECT_EQ(sum_div_3_5(1), 0);
}

TEST(math_01_Sum, Hundred){
    EXPECT_EQ(sum_div_3_5(100), 2318);
}

TEST(math_01_Sum, EightZeros){
    EXPECT_EQ(sum_div_3_5(100000000), 2333333316666668);
}

TEST(math_01_Sum, Negative){
    EXPECT_EQ(sum_div_3_5(-1), 0);
}

TEST(math_01_Sum, Float){
    EXPECT_EQ(sum_div_3_5(0.25), 0);    // implicit float->int (0.25 -> 0)
}
// =====================================================================================================================
// 2. Greatest common divisor
TEST(math_02_GCD, Positive1){
    EXPECT_EQ(gcd(3, 15), 3);
}

TEST(math_02_GCD, Positive2){
    EXPECT_EQ(gcd(15, 900), 15);
}

TEST(math_02_GCD, Zeros){
    EXPECT_EQ(gcd(0, 0), 0);
}

TEST(math_02_GCD, OneZero){
    EXPECT_EQ(gcd(111, 0), 0);
}

// =====================================================================================================================
// 3. Least common multiple
TEST(math_03_LCM, Zero){
    EXPECT_EQ(lcm2(0, 0), 0);
}

TEST(math_03_LCM, lcm2_Positive_1){
    EXPECT_EQ(lcm2(2, 3), 6);
}

TEST(math_03_LCM, lcm2_Positive_2){
    EXPECT_EQ(lcm2(840, 396), 27720);
}

TEST(math_03_LCM, lcm_poly_1){
    EXPECT_EQ(lcm_poly({1, 2, 3, 4}), 12);
}

TEST(math_03_LCM, lcm_poly_2){
    EXPECT_EQ(lcm_poly({5}), 5);
}

TEST(math_03_LCM, lcm_poly_3){
    EXPECT_EQ(lcm_poly({5, 50}), 50);
}

TEST(math_03_LCM, lcm_poly_Zero){
    EXPECT_EQ(lcm_poly({0}), 0);
}

// =====================================================================================================================
// 4. Largest prime smaller than given number
TEST(math_04_LPN, Positive_1){
    EXPECT_EQ(largest_prime_smaller_than(5), 3);
}

TEST(math_04_LPN, Positive_2){
    EXPECT_EQ(largest_prime_smaller_than(12), 11);
}

TEST(math_04_LPN, Zero){
    EXPECT_EQ(largest_prime_smaller_than(0), 0);
}

TEST(math_04_LPN, One){
    EXPECT_EQ(largest_prime_smaller_than(1), 0);
}

// =====================================================================================================================
// 5. Sexy prime pairs
TEST(math_05_Sexy_prime, Positive){
    vector<pair<int, int>> expected_result = {{1, 7}, {5, 11}, {7, 13}, {11, 17}};

    EXPECT_EQ(sexy_primes(12), expected_result);
}

TEST(math_05_Sexy_prime, One){
    vector<pair<int, int>> expected_result = {{0, 0}};

    EXPECT_EQ(sexy_primes(1), expected_result);
}

// =====================================================================================================================
// 6. Abundant numbers
TEST(math_06_Abundant, Positive_1){
    vector<pair<int, int>> expected_result = {{12, 4}};

    EXPECT_EQ(abundants(13), expected_result);
}

TEST(math_06_Abundant, Positive_2){
    vector<pair<int, int>> expected_result = {{12, 4}, {18, 3}, {20, 2}, {24, 12}};

    EXPECT_EQ(abundants(25), expected_result);
}

// =====================================================================================================================
// 7. Amicable numbers
TEST(math_07_Amicable, Positive_1){
    vector<pair<int, int>> expected_result = {{220, 284}};

    EXPECT_EQ(amicables(1000), expected_result);
}

TEST(math_07_Amicable, Positive_2){
    vector<pair<int, int>> expected_result = {{220, 284}, {1184, 1210}, {2620, 2924}};

    EXPECT_EQ(amicables(5000), expected_result);
}

// =====================================================================================================================
// 8. Armstrong numbers
TEST(math_08_Armstrong, Positive){
    vector<int> expected_result = {153, 370, 371, 407};

    EXPECT_EQ(armstrong(), expected_result);
}

// =====================================================================================================================
// 9. Prime factors
TEST(math_09_Prime_factors, Positive_1){
    vector<int> expected_result = {2, 2, 2};

    EXPECT_EQ(prime_factors(8), expected_result);
}

TEST(math_09_Prime_factors, Positive_2){
    vector<int> expected_result = {5, 5};

    EXPECT_EQ(prime_factors(25), expected_result);
}

TEST(math_09_Prime_factors, Positive_3){
    vector<int> expected_result = {2, 3, 7};

    EXPECT_EQ(prime_factors(42), expected_result);
}

TEST(math_09_Prime_factors, Positive_4){
    vector<int> expected_result = {3, 3, 3, 37};

    EXPECT_EQ(prime_factors(999), expected_result);
}

TEST(math_09_Prime_factors, Max_1){
    EXPECT_EQ(largest_prime_factor(999), 37);
}

TEST(math_09_Prime_factors, Max_2){
    EXPECT_EQ(largest_prime_factor(600), 5);
}

TEST(math_09_Prime_factors, Max_3){
    EXPECT_EQ(largest_prime_factor(851), 37);
}

TEST(math_09_Prime_factors, Max_4){
    EXPECT_EQ(largest_prime_factor(475), 19);
}

TEST(math_09_Prime_factors, Max_5){
    EXPECT_EQ(largest_prime_factor(143), 13);
}
// =====================================================================================================================



// =====================================================================================================================
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}