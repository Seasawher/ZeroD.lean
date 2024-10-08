import SciLean
import SciLean

open SciLean

set_default_scalar Float

variable {n : Nat}
set_option synthInstance.maxSize 1000

def _root_.Fin.shift (i : Fin n) (j : Nat) : Fin n := ⟨(i.1+j)%n, sorry_proof⟩

def H (m k : Float) (x p : Float^[n]) : Float :=
  let Δx := 1.0/n.toFloat
  (Δx/(2*m)) * ‖p‖₂² + (Δx * k/2) * (∑ i, ‖x[i.shift 1] - x[i]‖₂²)

approx solver (m k : Float)
  :=  odeSolve (λ t (x,p) => ( ∇ (p':=p), H (n:=n) m k x p',
                              -∇ (x':=x), H (n:=n) m k x' p))
by
  -- Unfold Hamiltonian definition
  unfold H

  -- compute derivatives
  autodiff

  -- apply RK4 method
  conv in odeSolve _ =>
    rw[odeSolve_fixed_dt (R:=Float) rungeKutta4 sorry_proof]

  -- approximate limit by picking concrete `n`
  approx_limit steps sorry_proof



def main : IO Unit := do

  let substeps := 1
  let m := 1.0
  let k := 40000.0

  let N : Nat := 100

  let Δt := 0.1
  let x₀ : Float^[N] := ⊞ (i : Fin N) => (Scalar.sin (i.1.toFloat/10))
  let p₀ : Float^[N] := ⊞ (i : Fin N) => (0 : Float)
  let mut t := 0
  let mut (x,p) := (x₀, p₀)

  for i in [0:1000] do

    (x,p) := solver m k (substeps,()) t (t+Δt) (x, p)
    t += Δt

    let M : Nat := 20
    for m in fullRange (Fin M) do
      for n in fullRange (Fin N) do
        let xi := x[n]
        if (2*m.1.toFloat - M.toFloat)/(M.toFloat) - xi < 0  then
          IO.print "x"
        else
          IO.print "."

      IO.println ""
