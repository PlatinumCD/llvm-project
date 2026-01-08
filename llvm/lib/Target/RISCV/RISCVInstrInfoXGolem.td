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
  let mayStore       = 1;
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
    def MVMS   : MVM_rr<0b0000100, 0b111, "mvm.s"   >, MVM_rrSched;
    def MVMMV  : MVM_rr<0b0000101, 0b111, "mvm.mv"  >, MVM_rrSched;

}

}

//===----------------------------------------------------------------------===//
// XGolemAnalog Selection DAG Nodes
//===----------------------------------------------------------------------===//

def RISCVAnalogMVMSet
    : RVSDNode<"ANALOG_MVM_SET",
               SDTypeProfile<1, 2, [
                 SDTCisVT<0, i32>,
                 SDTCisPtrTy<1>,
                 SDTCisVT<2, i32>
               ]>,
               [SDNPHasChain, SDNPMayStore, SDNPMayLoad]>;

def RISCVAnalogMVMLoad
    : RVSDNode<"ANALOG_MVM_LOAD",
               SDTypeProfile<1, 2, [
                 SDTCisVT<0, i32>,
                 SDTCisPtrTy<1>,
                 SDTCisVT<2, i32>
               ]>,
               [SDNPHasChain, SDNPMayStore, SDNPMayLoad]>;

def RISCVAnalogMVM
    : RVSDNode<"ANALOG_MVM",
               SDTypeProfile<1, 1, [
                 SDTCisVT<0, i32>,
                 SDTCisVT<1, i32>
               ]>,
               [SDNPHasChain, SDNPMayStore]>;

def RISCVAnalogMVMStore
    : RVSDNode<"ANALOG_MVM_STORE",
               SDTypeProfile<1, 2, [
                 SDTCisVT<0, i32>,
                 SDTCisPtrTy<1>,
                 SDTCisVT<2, i32>
               ]>,
               [SDNPHasChain, SDNPMayStore]>;

def RISCVAnalogMVMMove
    : RVSDNode<"ANALOG_MVM_MOVE",
               SDTypeProfile<1, 2, [
                 SDTCisVT<0, i32>,
                 SDTCisVT<1, i32>,
                 SDTCisVT<2, i32>
               ]>,
               [SDNPHasChain, SDNPMayStore]>;
