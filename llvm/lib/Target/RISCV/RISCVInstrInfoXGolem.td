//===-- RISCVInstrInfoXGolem.td ----------------------------*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes the vendor extensions defined by Cameron Durbin.
//
//===----------------------------------------------------------------------===//


//===----------------------------------------------------------------------===//
// Instruction Class Template
//===----------------------------------------------------------------------===//
class MVM_rr<bits<7> funct7, bits<3> funct3, string opcodestr>
    : RVInstR<
        funct7, funct3, OPC_CUSTOM_0, 
        (outs GPR:$rd),
        (ins GPR:$rs1, GPR:$rs2),
        opcodestr, "$rd, $rs1, $rs2"> {
  let isCommutable = 0;
  let hasSideEffects = 1;
  let mayLoad        = 0;
  let mayStore       = 0;
}

class MVM_rrSched : Sched<[WriteIALU, ReadIALU, ReadIALU]>;

//===----------------------------------------------------------------------===//
// XGolemAnalog Instructions
//===----------------------------------------------------------------------===//

let DecoderNamespace = "XGolem" in {
    let Predicates = [HasVendorXGolemAnalog] in {
        def MVMSET : MVM_rr<0b0000001, 0b111, "mvm.set" >, MVM_rrSched { let mayLoad = 1; }
        def MVML   : MVM_rr<0b0000010, 0b111, "mvm.l"   >, MVM_rrSched { let mayLoad = 1; }
        def MVM    : MVM_rr<0b0000011, 0b111, "mvm"     >, MVM_rrSched;
        def MVMS   : MVM_rr<0b0000100, 0b111, "mvm.s"   >, MVM_rrSched { let mayStore = 1; }
        def MVMMV  : MVM_rr<0b0000101, 0b111, "mvm.mv"  >, MVM_rrSched;
    }
}

//===----------------------------------------------------------------------===//
// XGolemAnalog Selection DAG Nodes
//===----------------------------------------------------------------------===//

def analog_mvm_set 
    : RVSDNode<"ANALOG_MVM_SET",
               SDTypeProfile<0, 2, [
                  SDTCisPtrTy<0>,        // ptr
                  SDTCisVT<1, XLenVT>    // rs2
               ]>,
               [SDNPHasChain, SDNPMayLoad]>;

def analog_mvm_load 
    : RVSDNode<"ANALOG_MVM_LOAD",
               SDTypeProfile<0, 2, [
                 SDTCisPtrTy<0>,
                 SDTCisVT<1, XLenVT>
               ]>,
               [SDNPHasChain, SDNPMayLoad]>;

def analog_mvm
    : RVSDNode<"ANALOG_MVM",
               SDTypeProfile<0, 1, [
                 SDTCisVT<0, XLenVT>,
               ]>,
               [SDNPHasChain]>;

def analog_mvm_store
    : RVSDNode<"ANALOG_MVM_STORE",
               SDTypeProfile<0, 2, [
                 SDTCisPtrTy<0>,
                 SDTCisVT<1, XLenVT>
               ]>,
               [SDNPHasChain, SDNPMayStore]>;

def analog_mvm_move
    : RVSDNode<"ANALOG_MVM_MOVE",
               SDTypeProfile<0, 2, [
                 SDTCisVT<0, XLenVT>,
                 SDTCisVT<1, XLenVT>,
               ]>,
               [SDNPHasChain]>;

//===----------------------------------------------------------------------===//
// XGolemAnalog Instruction Pattern Matching
//===----------------------------------------------------------------------===//

def : Pat< (analog_mvm_set   GPR:$rs1, GPR:$rs2), (MVMSET GPR:$rs1, GPR:$rs2 ) >;
def : Pat< (analog_mvm_load  GPR:$rs1, GPR:$rs2), (MVML   GPR:$rs1, GPR:$rs2 ) >;
def : Pat< (analog_mvm       GPR:$rs1          ), (MVM    GPR:$rs1, GPR:$rs1 ) >;
def : Pat< (analog_mvm_store GPR:$rs1, GPR:$rs2), (MVMS   GPR:$rs1, GPR:$rs2 ) >;
def : Pat< (analog_mvm_move  GPR:$rs1, GPR:$rs2), (MVMMV  GPR:$rs1, GPR:$rs2 ) >;
