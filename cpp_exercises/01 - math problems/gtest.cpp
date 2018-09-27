#include "gtest/gtest.h"
#include "math.h"


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
TEST(math_01_GCD, Positive1){
    EXPECT_EQ(gcd(3, 15), 3);
}

TEST(math_01_GCD, Positive2){
    EXPECT_EQ(gcd(15, 900), 15);
}

TEST(math_01_GCD, Zeros){
    EXPECT_EQ(gcd(0, 0), 0);
}

TEST(math_01_GCD, OneZero){
    EXPECT_EQ(gcd(111, 0), 0);
}

// =====================================================================================================================
// 3. Least common multiple




// =====================================================================================================================
int main(int argc, char **argv) {
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}