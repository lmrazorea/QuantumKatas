// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.ShorsAlgorithm
{
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    //////////////////////////////////////////////////////////////////
    // Welcome!
    //////////////////////////////////////////////////////////////////

    // Shor's quantum kata is a series of exercises designed to get you familiar with
    // Shor's integer factoring algorithm.
    // It covers the following topics:
    //  - finding coprimes of an integer number;
    //  - writing an oracle for determining the period of a function;
    //  - phase estimation;
    //  - find the period with the continued fraction technique;
    //  - putting it all together to get an implementation of Shor's algorithm.
    //
    // Each task is wrapped in one function/operation preceded by the description of the task.
    // Each task has a unit test associated with it, which initially fails. Your goal is to 
    // fill in the blank (marked with // ... comment) with some Q# code to make the failing test pass.

    // Task 1.1 
    // Input:
    //		1) An integer to test.
    // Goal: Implement a function to test if an integer number is even.
    function IsEven(n: Int) : Bool
    {
        // ...

        // Currently, this function returns a placeholder value for the sake of being able to compile the code.
        // You will need to remove this return instruction and return a proper result.
        return true;
    }

    // Task 1.2 Finding coprimes
    // Inputs:
    //		1) Integer number, greater than 1, for which we want to find a coprime
    //		2) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic).
    // Goal: Find a coprime for the input integer, n, which is less than n.
    //		One way of accomplishing this is to randomly choose a number out the 
    //		appropriate range of integers for our input, n. Then check if it is coprime with n.
    //		If it is coprime, return it. Otherwise, retry up to the maximum number of attempts 
    //		by randomly choosing a new candidate from the range. 
    operation Coprime(n: Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper coprime value.
            return 1;
        }
    }

    // Task 1.3 Determining the precision for phase estimation.
    // Input:
    //		1) The number we need to factor.
    // Goal:
    //		Determine the size of the qubit vector to use for the phase estimation step in the algorithm.
    //		A size that's twice the number of bits necessary to store the number we need to factor is appropriate.
    function ComputeControlRegisterPrecision(modulus: Int) : Int
    {
        // ...

        // Currently, this function returns a placeholder value for the sake of being able to compile the code.
        // You will need to remove this return instruction and return a proper result.
        return 1;
    }

    // Task 2.1 Order finding oracle (aka. Period finding oracle)
    // Input:
    //		1) A seed for generating the transformation of the order finding oracle. The seed will be a
    //		a coprime of the number we need to factor.
    //		2) The modulus for the transformation of the order finding oracle.
    //		3) The target qubit register on which the oracle operates.
    // Goal:
    //		Implement an oracle that applies the following transformation to a target qubit register |t〉:
    //		|t〉 -> |gᵖ * t (mod N)〉 where N refers to the modulus and g refers to the chosen generator.
    operation OrderFindingOracle(
        generator : Int, modulus : Int, power : Int , target : Qubit[]) : Unit
    {
        body(...)
        {
            // ...
        }
        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    // Task 2.2 Phase estimation
    // Input:
    //		1) A coprime of the modulus.
    //		2) The modulus.
    //		3) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic). 
    // Goal:
    //		Estimate phase for one of the eigenvectors of the order finding oracle. Return the estimated phase
    //		as a fraction of integers.
    // Notes:
    //		a) Create a superposition of all the eigenvectors of the order finding oracle. This superposition
    //		is the state |1〉.
    //		b) You may use the QuantumPhaseEstimation operation from the Q# library to accomplish this task.
    //		c) Measure the result of the quantum phase estimation operation.
    //		b) Return the phase estimate as a fraction of integer values.
    operation EstimatePhase(coprime: Int, modulus: Int, maxConsecutiveRetries: Int) : Fraction
    {
        body(...)
        {
            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper result.
            return Fraction(1, 1);
        }
    }

    // Task 3.1 Period finding based on a generator
    // Input:
    //		1) The chosen generator.
    //		2) The modulus.
    //		3) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic). 
    // Goal:
    //		Find the period of the function f(x) = gˣ mod N where N refers to the modulus and g refers to the
    //		chosen generator. Return the period.
    // Notes:
    //		1) The EstimatePhase operation returns a fraction that is equivalent to s/r where r is the period
    //		for the chosen generator.
    //		2) Use the continued fraction technique to find factors of the period r and reconstruct r from them.
    //		3) You may use the function ContinuedFractionConvergent from the Q# library to accomplish this task.
    operation FindPeriodOfGenerator(generator: Int, modulus: Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            AssertBoolEqual(
                IsCoprime(generator, modulus),
                true,
                $"The two inputs, {generator} and {modulus}, must be coprime."
            );

            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper result.
            return 1;
        }
    }

    // Task 3.2 Coprime and its period
    // Input:
    //		1) The number to factor.
    //		2) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic).
    // Goal:
    //		Find a coprime and its period for the number to factor where the period is an even integer. 
    operation FindProperCoprimeAndItsPeriod(n: Int, maxConsecutiveRetries: Int) : (Int, Int)
    {
        body(...)
        {
            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper result.
            return (1, 1);
        }
    }

    // Task 3.3 Modulo power of the chosen coprime
    // Input:
    //		1) The number to factor.
    //		2) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic).
    // Goal:
    //		Compute coprime of n raised to power period/2 (mod n).
    operation CoprimePower (n : Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper result.
            return 1;
        }
    }

    // Task 4.1 Divisor of n
    // Input:
    //		1) The number to factor.
    //		2) The modulo power of the chosen coprime.
    // Goal:
    //	Compute a divisor of n based on the modulo power of the chosen coprime.
    function DivisorFromCoprimePower (n: Int, coprimePower: Int) : Int
    {
        // ...

        // Currently, this function returns a placeholder value for the sake of being able to compile the code.
        // You will need to remove this return instruction and return a proper result.
        return 1;
    }

    // Task 4.2 Shor's algorithm
    // Input:
    //		1) The number to factor.
    //		2) The upper limit for the number of times to repeat the execution (the algorithm is probabilistic).
    // Goal:
    //		Factor integer n.
    operation Shor (n: Int, maxConsecutiveRetries: Int) : (Int, Int)
    {
        body(...)
        {
            // ...

            // Currently, this operation returns a placeholder value for the sake of being able to compile the code.
            // You will need to remove this return instruction and return a proper result.
            return (1, 1);
        }
    }
}