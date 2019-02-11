// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains reference solutions to all tasks. 
// The tasks themselves can be found in Tasks.qs file.
// We recommend that you try to solve the tasks yourself first,
// but feel free to look up the solution if you get stuck.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ShorsAlgorithm
{
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

    function IsEven_Reference(n: Int) : Bool
    {
        return n % 2 == 0;
    }

    operation Coprime_Reference(n: Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            mutable retryCount = maxConsecutiveRetries;
            repeat {
                let coprime = RandomInt(n - 2) + 2;
                if (IsCoprime(coprime, n))
                {
                    return coprime;
                }
                set retryCount = retryCount - 1;
            } until (retryCount == 0)
            fixup {
            }
            fail "Coprime_Reference: max retries exceeded.";
        }
    }

    function ComputeControlRegisterPrecision_Reference(modulus: Int, errorRate: Double) : Int
    {
        if (errorRate < 0.0) {
            return 2 * BitSize(modulus);
        }
        return 2 * BitSize(modulus) + 1 + Ceiling(Log(2.0 + 1.0 / (2.0 * errorRate)));
    }

    operation OrderFindingOracle_Reference(
        generator : Int, modulus : Int, power : Int , target : Qubit[]) : Unit
    {
        body(...)
        {
            ModularMultiplyByConstantLE(
                ExpMod(generator,power,modulus),
                modulus,
                LittleEndian(target)
            );
        }
        adjoint auto;
        controlled auto;
        adjoint controlled auto;
    }

    operation EstimatePhase_Reference(coprime: Int, modulus: Int, maxConsecutiveRetries: Int) : Fraction
    {
        body(...)
        {
            let size = BitSize(modulus);
            let precision = ComputeControlRegisterPrecision_Reference(modulus, -1.0);

            mutable retryCount = maxConsecutiveRetries;
            repeat {
                mutable numerator = 0;
                using (register = Qubit[size])
                {
                    let registerLe = LittleEndian(register);
                    InPlaceXorLE(1, registerLe);
                    let oracle = DiscreteOracle(OrderFindingOracle_Reference(coprime, modulus, _, _));
                    using (controlRegister = Qubit[precision])
                    {
                        let controlRegisterBe = BigEndian(controlRegister);
                        QuantumPhaseEstimation(oracle, registerLe!, controlRegisterBe);
                        set numerator = MeasureIntegerBE(controlRegisterBe);
                    }
                    ResetAll(register);
                }

                if (numerator != 0)
                {
                    return Fraction(numerator, 2 ^ precision);
                }
                set retryCount = retryCount - 1;
            } until (retryCount == 0)
            fixup {
            }
            fail "EstimatePhase_Reference: max retries exceeded.";
        }
    }

    operation FindPeriodOfGenerator_Reference(generator: Int, modulus: Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            AssertBoolEqual(
                IsCoprime(generator, modulus),
                true,
                $"The two inputs, {generator} and {modulus}, must be coprime."
            );

            mutable period = 1;

            mutable retryCount = maxConsecutiveRetries;
            repeat {
                let phase = EstimatePhase_Reference(generator, modulus, maxConsecutiveRetries);
                let (x, y) = (ContinuedFractionConvergent(phase, modulus))!;
                let numerator = AbsI(x);
                let denominator = AbsI(y);
                set period = denominator * period / GCD(period, denominator);

                if (ExpMod(generator, period, modulus) == 1)
                {
                    return period;
                }
                set retryCount = retryCount - 1;
            } until (retryCount == 0)
            fixup {
            }
            fail "FindPeriodOfGenerator_Reference: max retries exceeded.";
        }
    }

    operation FindProperCoprimeAndItsPeriod_Reference(n: Int, maxConsecutiveRetries: Int) : (Int, Int)
    {
        body(...)
        {
            mutable retryCount = maxConsecutiveRetries;
            repeat {
                let coprime = Coprime_Reference(n, maxConsecutiveRetries);
                let period = FindPeriodOfGenerator_Reference(coprime, n, maxConsecutiveRetries);
                if (IsEven_Reference(period))
                {
                    return (coprime, period);
                }
                set retryCount = retryCount - 1;
            } until (retryCount == 0)
            fixup {
            }
            fail "FindProperCoprimeAndItsPeriod_Reference: max retries exceeded.";
        }
    }

    operation CoprimePower_Reference (n : Int, maxConsecutiveRetries: Int) : Int
    {
        body(...)
        {
            mutable retryCount = maxConsecutiveRetries;
            repeat {
                let (coprime, period) = FindProperCoprimeAndItsPeriod_Reference(n, maxConsecutiveRetries);
                let x = ExpMod(coprime, period / 2, n);
                if (x != n - 1)
                {
                    return x;
                }
                set retryCount = retryCount - 1;
            } until (retryCount == 0)
            fixup {
            }
            fail "CoprimePower_Reference: max retries exceeded.";
        }
    }

    function DivisorFromCoprimePower_Reference (n: Int, coprimePower: Int) : Int
    {
        return MaxI(GCD(n, coprimePower - 1), GCD(n, coprimePower + 1));
    }

    operation Shor_Reference (n: Int, maxConsecutiveRetries: Int) : (Int, Int)
    {
        body(...)
        {
            let power = CoprimePower_Reference(n, maxConsecutiveRetries);
            let divisor = DivisorFromCoprimePower_Reference(n, power);
            return (divisor, n / divisor);
        }
    }
}