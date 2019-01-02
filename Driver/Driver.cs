// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

using Microsoft.Quantum.Simulation.Simulators;
using Quantum.Kata.ShorsAlgorithm;
using System;
using System.Diagnostics;

namespace Driver
{
    class Driver
    {
        static void Main(string[] args)
        {
            var numbers = new[] { 15, 21, 33 };
            Stopwatch stopwatch = new Stopwatch();

            using (var qsim = new QuantumSimulator())
            {
                foreach (var n in numbers)
                {
                    try
                    {
                        Console.WriteLine($"Factorising {n} ...");
                        stopwatch.Start();
                        var (f1, f2) = Factorize(n, qsim);
                        stopwatch.Stop();
                        Console.WriteLine($"{n} = {f1} * {f2} -- Elapsed time: {stopwatch.Elapsed}");
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }
                }
                Console.Read();
            }
        }

        private static (long, long) Factorize(long compound, QuantumSimulator simulator, int maxRetries = 10)
        {
            if (compound <= 3)
            {
                throw new ArgumentException($"Number to factorize should be greater than 3. Input given: {compound}");
            }

            if (IsEven(compound))
            {
                throw new ArgumentException($"Number to factorize should be odd. Input given: {compound}");
            }

            if (IsPerfectPower(compound, out long a, out int b))
            {
                throw new ArgumentException($"Number to factorize should not be a perfect power. Input given: {compound} = {a}^{b}");
            }
            else
            {
                return Shor_Reference.Run(simulator, compound, maxRetries).Result;
            }
        }

        private static bool IsEven(long n)
        {
            return (n & 1L) == 0;
        }

        private static bool IsPerfectPower(long n, out long baseNumber, out int exponent)
        {
            var maxEponent = (int)Math.Log(n, 2) + 1;
            for (exponent = 2; exponent < maxEponent + 1; exponent++)
            {
                if (IsPerfectPower(n, out baseNumber, exponent, maxEponent))
                    return true;
            }

            baseNumber = -1;
            exponent = -1;
            return false;
        }

        private static bool IsPerfectPower(long n, out long baseNumber, int exponent, int maxEponent)

        {
            var lowBase = 1L;
            var highBase = 1L << (maxEponent / exponent + 1);
            while  (lowBase < highBase - 1)
            {
                var middle = (lowBase + highBase) >> 1;
                var pow = Power(middle, exponent);
                if (pow > n)
                {
                    highBase = middle;
                }
                else if (pow < n)
                {
                    lowBase = middle;
                }
                else
                {
                    baseNumber = middle;
                    return true;
                }
            }

            baseNumber = -1;
            return false;
        }

        private static long Power(long a, long b)
        {
            long result = 1;
            while  (b > 0)
            {
                if ((b & 1L) != 0L)
                    result *= a;
                a *= a;
                b >>= 1;
            }
            return result;
        }
    }
}
