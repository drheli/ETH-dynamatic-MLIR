//===- PassDetails.h - Conversion passes class details ----------*- C++ -*-===//
//
// This is the header file for all conversion passes defined in Dynamatic. It
// contains forward declarations needed by conversion passes and includes
// auto-generated base class definitions for all conversion passes.
//
//===----------------------------------------------------------------------===//

#ifndef DYNAMATIC_CONVERSION_PASSDETAILS_H
#define DYNAMATIC_CONVERSION_PASSDETAILS_H

#include "mlir/IR/BuiltinOps.h"
#include "mlir/IR/DialectRegistry.h"
#include "mlir/Pass/Pass.h"

namespace mlir {
namespace arith {
class ArithDialect;
} // namespace arith

namespace cf {
class ControlFlowDialect;
} // namespace cf

namespace scf {
class SCFDialect;
} // namespace scf

namespace func {
class FuncDialect;
class FuncOp;
} // namespace func
} // namespace mlir

namespace circt {
namespace handshake {
class HandshakeDialect;
class FuncOp;
} // namespace handshake

} // namespace circt

namespace dynamatic {

// Generate the classes which represent the passes
#define GEN_PASS_CLASSES
#include "dynamatic/Conversion/Passes.h.inc"

} // namespace dynamatic

#endif // DYNAMATIC_CONVERSION_PASSDETAILS_H