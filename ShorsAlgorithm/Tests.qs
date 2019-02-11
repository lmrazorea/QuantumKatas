// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

//////////////////////////////////////////////////////////////////////
// This file contains testing harness for all tasks. 
// You should not modify anything in this file.
// The tasks themselves can be found in Tasks.qs file.
//////////////////////////////////////////////////////////////////////

namespace Quantum.Kata.ShorsAlgorithm
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Extensions.Testing;

    operation T0_IsEven_Test () : Unit
    {
        body(...)
        {
            for (n in 11..2..20) {
                AssertBoolEqual(IsEven(n), false, $"IsEven check fails for input {n}");
            }
            for (n in 12..2..20) {
                AssertBoolEqual(IsEven(n), true, $"IsEven check fails for input {n}");
            }
        }
    }

    operation T1_Coprime_Test () : Unit
    {
        body(...)
        {
            let maxRetries = 20;
            for (n in 11..20) {
                let testResult = Coprime(n, maxRetries);
                AssertBoolEqual(testResult > 1, true, $"Computed value {testResult} should be greater than 1 in order to be a proper coprime.");
                AssertBoolEqual(IsCoprime(testResult, n), true, $"Computed value {testResult} is not coprime with {n}.");
            }
        }
    }

    operation T2_ComputeControlRegisterPrecision_Test () : Unit
    {
        body(...)
        {
            for (n in 1..20) {
                let resultRef = ComputeControlRegisterPrecision_Reference(n, -1.0);
                let resultSol = ComputeControlRegisterPrecision(n);
                AssertBoolEqual(resultSol >= resultRef, true, $"For input {n} expected result should be greater or equal to {resultRef}. Got {resultSol}.");
            }
        }
    }

    operation T3__Test () : Unit
    {
        body(...)
        {
        
        }
    }

    operation T4__Test () : Unit
    {
        body(...)
        {
        
        }
    }

    operation T5__Test () : Unit
    {
        body(...)
        {
        
        }
    }

    operation T6__Test () : Unit
    {
        body(...)
        {
        
        }
    }

    operation T7__Test () : Unit
    {
        body(...)
        {
        
        }
    }
}