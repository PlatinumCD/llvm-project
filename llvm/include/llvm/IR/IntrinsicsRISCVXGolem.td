//===- IntrinsicsRISCVXGolem.td - Golem intrinsics -----------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines all of the Golem vendor analog intrinsics for RISC-V.
//
//===----------------------------------------------------------------------===//

// All intrinsics return 0 for success otherwise fail

let TargetPrefix = "riscv" in {

    def int_riscv_golem_analog_mvm_set :
        Intrinsic<
            [llvm_i32_ty],
            [llvm_ptr_ty, llvm_i32_ty],
            [IntrHasSideEffects, IntrWriteMem]
        >; 

    def int_riscv_golem_analog_mvm_load :
        Intrinsic<
            [llvm_i32_ty],
            [llvm_ptr_ty, llvm_i32_ty],
            [IntrHasSideEffects, IntrWriteMem]
        >;

    def int_riscv_golem_analog_mvm :
        Intrinsic<
            [llvm_i32_ty],
            [llvm_i32_ty],
            [IntrHasSideEffects, IntrWriteMem]
        >;

    def int_riscv_golem_analog_mvm_store :
        Intrinsic<
            [llvm_i32_ty],
            [llvm_ptr_ty, llvm_i32_ty],
            [IntrHasSideEffects, IntrWriteMem]
        >;

    def int_riscv_golem_analog_mvm_move :
        Intrinsic<
            [llvm_i32_ty],
            [llvm_i32_ty, llvm_i32_ty],
            [IntrHasSideEffects, IntrWriteMem]
        >;
}
