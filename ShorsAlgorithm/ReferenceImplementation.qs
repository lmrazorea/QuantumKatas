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

	operation OrderFindingOracle_Reference (
        generator : Int, modulus : Int, power : Int , target : Qubit[] ) : Unit
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

	operation FindNumeratorOfDyadicFraction_Reference(coprime: Int, modulus: Int, maxConsecutiveRetries: Int) : Int
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
					return numerator;
				}
				set retryCount = retryCount - 1;
			} until (retryCount == 0)
			fixup {
			}
			fail "FindNumeratorOfDyadicFraction_Reference: max retries exceeded.";
		}
	}

	operation FindOrderImpl_Reference(coprime: Int, modulus: Int, maxConsecutiveRetries: Int) : Int
	{
		body(...)
		{
			AssertBoolEqual(
				IsCoprime(coprime, modulus),
				true,
				$"The two inputs, {coprime} and {modulus}, must be coprime."
			);

			mutable result = 1;

			mutable retryCount = maxConsecutiveRetries;
			repeat {
				let dyadicNumerator = FindNumeratorOfDyadicFraction_Reference(coprime, modulus, maxConsecutiveRetries);
				let precision = ComputeControlRegisterPrecision_Reference(modulus, -1.0);
				let (x, y) = (ContinuedFractionConvergent(Fraction(dyadicNumerator, 2 ^ precision), modulus))!;
				let numerator = AbsI(x);
				let period = AbsI(y);
				set result = period * result / GCD(result, period);

				if (ExpMod(coprime, result, modulus) == 1)
				{
					return result;
				}
				set retryCount = retryCount - 1;
			} until (retryCount == 0)
			fixup {
			}
			fail "FindOrderImpl_Reference: max retries exceeded.";
		}
	}

	operation FindProperCoprimeAndItsPeriod_Reference(n: Int, maxConsecutiveRetries: Int) : (Int, Int)
	{
		body(...)
		{
			mutable retryCount = maxConsecutiveRetries;
			repeat {
				let coprime = Coprime_Reference(n, maxConsecutiveRetries);
				let period = FindOrderImpl_Reference(coprime, n, maxConsecutiveRetries);
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

	function Divisor_Reference (n: Int, coprimePower: Int) : Int
	{
		return MaxI(GCD(n, coprimePower - 1), GCD(n, coprimePower + 1));
	}

	operation Shor_Reference (n: Int, maxConsecutiveRetries: Int) : (Int, Int)
	{
		body(...)
		{
			let power = CoprimePower_Reference(n, maxConsecutiveRetries);
			let divisor = Divisor_Reference(n, power);
			return (divisor, n / divisor);
		}
	}
}