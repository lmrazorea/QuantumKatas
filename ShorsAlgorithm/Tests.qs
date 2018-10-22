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

	operation Shor_Test () : ()
    {
        body
        {
			let compound = 21;
			let maxRetries = 10;
			let (f1, f2) = Shor_Reference(compound, maxRetries);
			Message($"result {compound}: {f1}, {f2}");
        }
    }
}