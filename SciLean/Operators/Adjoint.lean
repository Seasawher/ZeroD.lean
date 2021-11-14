import SciLean.Categories
import SciLean.Simp

import Init.Classical

namespace SciLean

variable {α β γ : Type}
variable {X Y Z : Type} [Hilbert X] [Hilbert Y] [Hilbert Z]

def adjoint_definition (f : X → Y) (h : IsLin f) (y : Y) 
    : ∃ (x' : X), ∀ x, ⟨x', x⟩ = ⟨y, (f x)⟩ := sorry

noncomputable
def adjoint (f : X → Y) (y : Y) : X :=
    match Classical.propDecidable (IsLin f) with
      | isTrue  h => Classical.choose (adjoint_definition f h y)
      | _ => (0 : X)

postfix:max "†" => adjoint

def kron {n} (i j : Fin n) : ℝ := if (i==j) then 1 else 0

namespace Adjoint

  instance (f : X → Y) [IsLin f] : IsLin f† := sorry

  @[simp]
  def adjoint_of_adjoint (f : X → Y) [IsLin f] : f†† = f := sorry

  @[simp] 
  def adjoint_of_id 
      : (id : X → X)† = id := sorry

  @[simp] 
  def adjoint_of_id'
      : (λ x : X => x)† = id := sorry

  @[simp]
  def adjoint_of_const {n}
      : (λ (x : X) (i : Fin n) => x)† = sum := sorry

  @[simp]
  def adjoint_of_sum {n}
      : (sum)† = (λ (x : X) (i : Fin n) => x) := sorry

  @[simp]
  def adjoint_of_swap {n m}
      : (λ (f : Fin n → Fin m → Y) => (λ j i => f i j))† = λ f i j => f j i := sorry

  @[simp]
  def adjoint_of_parm {n} (f : X → Fin n → Y) (i : Fin n) [IsLin f]
      : (λ x => f x i)† = (λ y => f† (λ j => (kron i j)*y)) := sorry

  @[simp] 
  def adjoint_of_composition (f : Y → Z) [IsLin f] (g : X → Y) [IsLin g] 
      : (f∘g)† = g† ∘ f† := sorry

  @[simp] 
  def adjoint_of_composition_parm {n} (f : β → Y → Z) [∀ b, IsLin (f b)] (g1 : Fin n → β) (g2 : X → Fin n → Y) [IsLin g2] 
      : (λ x i => (f (g1 i) (g2 x i)))† = g2† ∘ (λ z i => (f (g1 i))† (z i)) := sorry

  -- Unfortunatelly this theorem is dangerous and causes simp to loop indefinitely
  -- @[simp] 
  -- def adjoint_of_composition_arg (f : Y → β → Z) (b : β) [IsLin (λ y => f y b)] (g : X → Y) [IsLin g] 
  --     : (λ x => f (g x) b)† = g† ∘ (λ y => f y b)† := sorry

  @[simp]
  def adjoint_of_inner_1 (x : X) (s : ℝ) : (λ y : X => ⟨y, x⟩)† s = s * x := sorry

  @[simp]
  def adjoint_of_inner_2 (x : X) (s : ℝ) : (λ y : X => ⟨x, y⟩)† s = s * x := sorry

  @[simp]
  def adjoint_of_diag {Y1 Y2 : Type} [Hilbert Y1] [Hilbert Y2]
      (f : Y1 → Y2 → Z) (g1 : X → Y1) (g2 : X → Y2) 
      [IsLin (uncurry f)] [IsLin g1] [IsLin g2]
      : (λ x => f (g1 x) (g2 x))† = (uncurry HAdd.hAdd) ∘ (pmap g1† g2†) ∘ (uncurry f)† := sorry

  @[simp]
  def adjoint_of_diag_arg {Y1 Y2 : Type} [Hilbert Y1] [Hilbert Y2]
      (f : Y1 → Y2 → Z) (g1 : X → Fin n → Y1) (g2 : X → Fin n → Y2)
      [IsLin (uncurry f)] [IsLin g1] [IsLin g2]
      : (λ x i => f (g1 x i) (g2 x i))† = (uncurry HAdd.hAdd) ∘ (pmap g1† g2†) ∘ (λ f => (λ i => (f i).1, λ i => (f i).2)) ∘ (comp (uncurry f)†) := sorry

  variable (f g : X → Y) 
  variable (r : ℝ)

  example {X} [Vec X] : IsLin (uncurry HAdd.hAdd : X×X → X) := by infer_instance

  @[simp]
  def adjoint_of_hadd : (λ x : X×X => x.1 + x.2)† = (λ x => (x,x)) := sorry

  @[simp]
  def adjoint_of_add : (λ x : X×X => Add.add x.1 x.2)† = (λ x => (x,x)) := sorry

  @[simp]
  def adjoint_of_hsub : (λ x : X×X => x.1 - x.2)† = (λ x => (x,-x)) := sorry

  @[simp]
  def adjoint_of_sub : (λ x : X×X => Sub.sub x.1 x.2)† = (λ x => (x,-x)) := sorry

  @[simp]
  def adjoint_of_add' [IsLin f] [IsLin g] : (f + g)† = f† + g† := 
  by 
    simp [HAdd.hAdd, Add.add]

  @[simp]
  def adjoint_of_add_args [IsLin f] [IsLin g] : (λ x => f x + g x)† = (λ y => f† y + g† y) := by simp

  @[simp]
  def adjoint_of_add_args2 (f g : X → Fin n → Y) [IsLin f] [IsLin g] 
      : (λ x i => f x i + g x i)† = (λ x i => f x i)† + (λ x i => g x i)† := by funext z; simp

  -- @[simp]
  -- def adjoint_of_sub' [IsLin f] [IsLin g] : (f - g)† = f† - g† := by funext y; simp[HSub.hSub, Sub.sub]

  -- @[simp]
  -- def adjoint_of_sub_args [IsLin f] [IsLin g] : (λ x => f x - g x)† = λ y => f† y - g† y := by funext y; simp

  @[simp]
  def adjoint_of_hmul_2 : (HMul.hMul r : X → X)† = HMul.hMul r := sorry
  @[simp]
  def adjoint_of_hmul_2_parm (f : X → Fin i → Y) [IsLin f] (r : Fin i → ℝ) : (λ x i => (r i)*(f x i))† = f† ∘ (λ y' i => (r i)*(y' i)) := by simp

  @[simp]
  def adjoint_of_hmul_1 (f : X → ℝ) [IsLin f] (y : Y) : (λ x => (f x)*y)† = f† ∘ (λ y' => ⟨y,y'⟩) := by simp
  @[simp]
  def adjoint_of_hmul_1_parm (f : X → Fin i → ℝ) [IsLin f] (y : Fin i → Y) : (λ x i => (f x i)*(y i))† = f† ∘ (λ y' i => ⟨y i,y' i⟩) := sorry


  -- Unfortunatelly this theorem is not sufficient because `adjoint_of_composition_arg` is dangerous
  -- @[simp]
  -- def adjoint_of_hmul_2' (x) : (λ r => r*x)† = (λ y => ⟨x, y⟩) := by simp







  -- @[simp]
  -- def adjoint_of_neg : (Neg.neg : X → X)† = Neg.neg := sorry

  -- @[simp]
  -- def adjoint_of_neg' [IsLin f] : (-f)† = -(f†) := by funext y; simp[Neg.neg]

  -- @[simp]
  -- def adjoint_of_hmul [IsLin f] : (r*f)† = r*f† := sorry

  -- @[simp]
  -- def adjoint_of_hmul_alt (f : X → Y) [IsLin f] (r : ℝ) : (λ x => r*(f x))† = (λ y => r*(f† y)) := sorry

  -- example [IsLin f] [IsLin g] (y : Y) : (λ x => f x + g x)† y = f† y + g† y := by simp done

  -- example (y : Y) (r : ℝ) : (λ x => ⟨x,y⟩)† r = r*y := by simp

  -- example (y : X) (r : ℝ) : (λ x => ⟨x,y⟩ + ⟨y,x⟩)† r = 2*r*y := by simp; done

  -- example (r : ℝ) (x' : X)
  --         : (λ x : X => r*((λ x'' => ⟨x', x''⟩) x))† = λ s => r * s * x' := 
  -- by
  --   simp; funext s; simp[Function.comp]

end Adjoint
