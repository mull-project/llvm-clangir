// Smoke test for CIR pass plugins: rewrites every cir.add into cir.sub
#include "clang/CIR/CIRPassPlugin.h"
#include "clang/CIR/Dialect/IR/CIRDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/BuiltinOps.h"
#include "mlir/Pass/Pass.h"
#include "mlir/Pass/PassManager.h"
#include "llvm/Support/raw_ostream.h"

namespace {

struct AddToSubPass
    : mlir::PassWrapper<AddToSubPass, mlir::OperationPass<mlir::ModuleOp>> {
  MLIR_DEFINE_EXPLICIT_INTERNAL_INLINE_TYPE_ID(AddToSubPass)

  llvm::StringRef getArgument() const final { return "add-to-sub"; }

  void runOnOperation() override {
    llvm::SmallVector<cir::AddOp> adds;
    getOperation().walk([&](cir::AddOp op) { adds.push_back(op); });
    for (cir::AddOp add : adds) {
      llvm::errs() << "[add-to-sub] cir.add -> cir.sub at " << add.getLoc() << "\n";
      mlir::OpBuilder b(add);
      auto sub = cir::SubOp::create(b, add.getLoc(), add.getType(), add.getLhs(),
                                    add.getRhs(), add.getNoSignedWrap(),
                                    add.getNoUnsignedWrap(), add.getSaturated());
      add.replaceAllUsesWith(sub.getResult());
      add.erase();
    }
  }
};

struct AddToSubPlugin : cir::CIRPassPlugin {
  void registerPasses(mlir::OpPassManager &pm) override {
    pm.addPass(std::make_unique<AddToSubPass>());
  }
};

} // namespace

static cir::CIRPassPluginRegistry::Add<AddToSubPlugin> X("add-to-sub", "cir.add -> cir.sub");
