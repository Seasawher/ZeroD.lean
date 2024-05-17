import Mathlib.Data.Set.Defs
import Mathlib.Data.Set.Image

import Mathlib.Tactic.FunTrans.Attr
import Mathlib.Tactic.FunTrans.Elab

import SciLean.Core.Objects.Scalar
import SciLean.Util.SorryProof

variable {α β γ : Type _}

attribute [fun_trans] Set.preimage
attribute [fun_trans] Set.image


attribute [fun_trans] Set.preimage_id Set.preimage_id'

namespace Set


open Classical in
@[fun_trans]
theorem preimage_const' (b : β) (s : Set β) :
    (fun _ : α => b) ⁻¹' s = if b ∈ s then univ else ∅ := by apply preimage_const

@[fun_trans]
theorem preimage_comp' (f : β → γ) (g : α → β) :
    preimage (fun x => f (g x))
    =
    fun s => g ⁻¹' (f ⁻¹' s) := rfl


----------------------------------------------------------------------------------------------------

@[fun_trans]
theorem Prod.mk.arg_fstsnd.preimage_rule_prod (f : α → β) (g : α → γ) (B : Set β) (C : Set γ) :
    preimage (fun x => (f x, g x)) (B.prod C)
    =
    f ⁻¹' B ∩ g ⁻¹' C := sorry_proof


def _root_.Set.fst (A : Set (α×β)) (b : β) : Set α := {x | (x,b) ∈ A}
def _root_.Set.snd (A : Set (α×β)) (a : α) : Set β := {y | (a,y) ∈ A}

@[fun_trans]
theorem Prod.mk.arg_fst.preimage_rule_prod (f : α → β) (c : γ) :
    preimage (fun x => (f x, c))
    =
    fun s => f ⁻¹' (s.fst c) := sorry_proof

@[fun_trans]
theorem Prod.mk.arg_snd.preimage_rule_prod (b : β) (g : α → γ) :
    preimage (fun x => (b, g x))
    =
    fun s => g ⁻¹' (s.snd b) := sorry_proof


open SciLean
variable {R} [RealScalar R] -- probably generalize following to LinearlyOrderedAddCommGroup

@[fun_trans]
theorem HAdd.hAdd.arg_a0.preimage_rule_Ioo (x' a b : R)  :
    preimage (fun x : R => x + x') (Ioo a b)
    =
    Ioo (a - x') (b - x') := by ext; simp; sorry_proof

@[fun_trans]
theorem HAdd.hAdd.arg_a1.preimage_rule_Ioo (x' a b : R)  :
    preimage (fun x : R => x' + x) (Ioo a b)
    =
    Ioo (a - x') (b - x') := by ext; simp; sorry_proof

@[fun_trans]
theorem HSub.hSub.arg_a0.preimage_rule_Ioo (x' a b : R)  :
    preimage (fun x : R => x - x') (Ioo a b)
    =
    Ioo (a + x') (b + x') := by ext; simp; sorry_proof

@[fun_trans]
theorem HSub.hSub.arg_a1.preimage_rule_Ioo (x' a b : R)  :
    preimage (fun x : R => x' - x) (Ioo a b)
    =
    Ioo (x' - b) (x' - a) := by ext; simp; sorry_proof

@[fun_trans]
theorem Neg.neg.arg_a1.preimage_rule_Ioo (a b : R)  :
    preimage (fun x : R => - x) (Ioo a b)
    =
    Ioo (-b) (-a) := by ext; simp; sorry_proof




----------------------------------------------------------------------------------------------------
-- Preimage1 ---------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------

-- todo: turn into function transformation once we have `fun_trans` supporting two argument functions
def preimage1 {α β γ} (f : α → β → γ) (C : Set γ) : Set α := ⋃ b, (f · b) ⁻¹' C


-- @[simp, ftrans_simp]
-- theorem preimage1_id {α β} (s : Set (α×β)) :
--      s.preimage1 (fun (a : α) (b : β) => (a,b)) = ⋃ b, {a | (a, b) ∈ s} := sorry_proof

-- this probably needs non-empty `β`
@[simp, ftrans_simp]
theorem preimage1_id1 {α β} (A : Set α) :
     A.preimage1 (fun (a : α) (_ : β) => a) = A := sorry_proof

-- this probably needs non-empty `B`
@[simp, ftrans_simp]
theorem preimage1_id2 {α β} (B : Set β) :
     B.preimage1 (fun (_ : α) (b : β) => b) = Set.univ := sorry_proof

open Classical in
@[simp, ftrans_simp]
theorem preimage1_const {α β γ} (c : γ) (C : Set γ) :
     C.preimage1 (fun (_ : α) (_ : β) => c) = if c ∈ C then Set.univ else ∅ := sorry_proof


-- this needs to check that `g ⁻¹' D` is non-empty
open Classical in
@[simp, ftrans_simp]
theorem _root_.Set.preimage1_prod {α β γ δ} (f : α → γ) (g : β → δ) (C : Set γ) (D : Set δ) :
     (C.prod D).preimage1 (fun (x : α) (y : β) => (f x, g y)) = f ⁻¹' C := sorry_proof

-- this needs to check that `g ⁻¹' D` is non-empty
open Classical in
@[simp, ftrans_simp]
theorem _root_.Set.preimage1_prod' {α β γ δ} (f : α → γ) (g : β → δ) (C : Set γ) (D : Set δ) :
     (D.prod C).preimage1 (fun (x : α) (y : β) => (g y, f x)) = f ⁻¹' C := sorry_proof
