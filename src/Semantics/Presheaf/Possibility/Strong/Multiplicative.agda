{-# OPTIONS --safe --without-K #-}
open import Relation.Binary.PropositionalEquality using (_≡_; subst; cong; cong₂) renaming (refl to ≡-refl; sym to ≡-sym; trans to ≡-trans)
open import Semantics.Kripke.Frame using (IFrame ; MFrame ; InclusiveMFrame ; TransitiveMFrame ; InclusiveTransitiveMFrame)

module Semantics.Presheaf.Possibility.Strong.Multiplicative
  {C      : Set}
  {_⊆_    : (Γ Δ : C) → Set}
  {IF     : IFrame C _⊆_}
  {_R_    : (Γ Δ : C) → Set}
  (MF     : MFrame IF _R_)
  {IMF    : InclusiveMFrame MF}
  {TMF    : TransitiveMFrame MF}
  (ITMF   : InclusiveTransitiveMFrame MF IMF TMF)
  (let open MFrame MF)
  (let open InclusiveMFrame IMF)
  (let open TransitiveMFrame TMF)
  (let open InclusiveTransitiveMFrame ITMF)
  where

open import Data.Product using (∃; _×_; _,_; -,_) renaming (proj₁ to fst; proj₂ to snd)

open import Relation.Binary using (Reflexive; Symmetric; Transitive; IsEquivalence; Setoid)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; trans; subst; cong ; cong₂)
import Relation.Binary.Reasoning.Setoid as EqReasoning

open import Semantics.Presheaf.Base IF
open import Semantics.Presheaf.CartesianClosure IF
open import Semantics.Presheaf.Possibility.Base MF
open import Semantics.Presheaf.Possibility.Strong.Base MF IMF
open import Semantics.Presheaf.Possibility.Multiplicative MF TMF

open import Semantics.Category.EndoFunctor.Strong.Multiplicative

private
  variable
    Γ Γ' Γ'' : C
    Δ Δ' Δ'' : C
    w w' w'' : Γ ⊆ Δ
    𝒫 𝒫'     : Psh
    𝒬 𝒬'     : Psh

import Semantics.Presheaf.CartesianClosure as CC
import Semantics.Presheaf.Base as B
import Semantics.Presheaf.Possibility.Base as P

-- c.f. https://en.wikipedia.org/wiki/Strong_monad#/media/File:Strong_monad_multiplication.svg
◇'-strong-mult' : (mult'[ 𝒫 ×' 𝒬 ]) ∘ (◇'-map (◇'-strength 𝒫 𝒬)) ∘ ◇'-strength 𝒫 (◇' 𝒬) ≈̇ ◇'-strength 𝒫 𝒬 ∘ (id'[ 𝒫 ] ×'-map mult'[ 𝒬 ])
◇'-strong-mult' {𝒫} {𝒬} = record { proof = λ r → proof (
  (refl
  , refl
  , proof
    ((let open EqReasoning ≋[ 𝒫 ]-setoid in begin
      wk[ 𝒫 ] (R-to-⊆ _) (wk[ 𝒫 ] (R-to-⊆ _) (π₁' .apply r))
        ≈˘⟨ wk[ 𝒫 ]-pres-trans _ _ _ ⟩
      wk[ 𝒫 ] (⊆-trans (R-to-⊆ _) (R-to-⊆ _)) (π₁' .apply r)
        ≡˘⟨ cong (λ z → wk[ 𝒫 ] z (π₁' .apply r)) (R-to-⊆-pres-trans _ _) ⟩
      wk[ 𝒫 ] (R-to-⊆ (R-trans _ _)) (π₁' .apply r) ∎)
    , ≋[ 𝒬 ]-refl))) }

◇'-is-strong-multiplicative : IsStrongMultiplicative ◇'-is-PshFunctor ◇'-is-strong ◇'-is-multiplicative
◇'-is-strong-multiplicative = record { strength-mult = ◇'-strong-mult' }
