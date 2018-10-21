// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT license.

namespace Quantum.Kata.ShorsAlgorithm
{
	open Microsoft.Quantum.Extensions.Convert;
    open Microsoft.Quantum.Extensions.Math;
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;

	operation Oracle_AllOnes (queryRegister: Qubit[], target : Qubit) : ()
    {
        body
        {
            (Controlled X)(queryRegister, target);
        }
        adjoint auto;
    }
}