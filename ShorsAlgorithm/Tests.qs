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

	// ------------------------------------------------------
    // helper wrapper to represent oracle operation on input and output registers as an operation on an array of qubits
    operation QubitArrayWrapperOperation (op : ((Qubit[], Qubit) => () : Adjoint), qs : Qubit[]) : ()
    {
        body
        {
            op(Most(qs), Tail(qs));
        }
        adjoint auto;
    }

    // ------------------------------------------------------
    // helper wrapper to test for operation equality on various register sizes
    operation AssertRegisterOperationsEqual (testOp : ((Qubit[]) => ()), refOp : ((Qubit[]) => () : Adjoint)) : ()
    {
        body
        {
            for (n in 2..10) {
                AssertOperationsEqualReferenced(testOp, refOp, n);
            }
        }
    }

    // ------------------------------------------------------
    operation T11_Oracle_AllOnes_Test () : ()
    {
        body
        {
            let testOp = QubitArrayWrapperOperation(Oracle_AllOnes, _);
            let refOp = QubitArrayWrapperOperation(Oracle_AllOnes_Reference, _);
            AssertRegisterOperationsEqual(testOp, refOp);
        }
    }
}