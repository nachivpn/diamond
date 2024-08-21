{-# OPTIONS --safe --without-K #-}
open import Relation.Binary.PropositionalEquality using (_≡_; refl; sym; trans; subst; cong ; cong₂)
open import Semantics.Kripke.Frame using (IFrame ; MFrame ; InclusiveMFrame ; ReflexiveMFrame ; InclusiveReflexiveMFrame)

module Semantics.Presheaf.Strong.Pointed
  {C      : Set}
  {_⊆_    : (Γ Δ : C) → Set}
  {IF     : IFrame C _⊆_}
  {_R_    : (Γ Δ : C) → Set}
  (MF     : MFrame IF _R_)
  {IMF    : InclusiveMFrame MF}
  {RMF    : ReflexiveMFrame MF}
  (IRMF   : InclusiveReflexiveMFrame MF IMF RMF)
  (let open MFrame MF)
  (let open InclusiveMFrame IMF)
  (let open ReflexiveMFrame RMF)
  (let open InclusiveReflexiveMFrame IRMF)
  where

open import Data.Product using (∃; _×_; _,_; -,_) renaming (proj₁ to fst; proj₂ to snd)

open import Relation.Binary using (Reflexive; Symmetric; Transitive; IsEquivalence; Setoid)
import Relation.Binary.Reasoning.Setoid as EqReasoning

open import Semantics.Presheaf.Base IF
open import Semantics.Presheaf.CartesianClosure IF
open import Semantics.Presheaf.Possibility MF
open import Semantics.Presheaf.Strong MF IMF
open import Semantics.Presheaf.Pointed MF RMF

private
  variable
    𝒫 𝒫'     : Psh
    𝒬 𝒬'     : Psh

abstract
  ◇'-strength-point : ◇'-strength 𝒫 𝒬  ∘ id'[ 𝒫 ] ×'-map point'[ 𝒬 ] ≈̇ point'[ 𝒫 ×' 𝒬 ]
  ◇'-strength-point {𝒫} {𝒬} = record { proof = λ p×◇q → let p = π₁' .apply p×◇q in proof
    (refl
    , refl
    , proof
      ((let open EqReasoning ≋[ 𝒫 ]-setoid in begin
        wk[ 𝒫 ] (R-to-⊆ R-refl) p   ≡⟨ cong₂ wk[ 𝒫 ] R-to-⊆-pres-refl refl ⟩
        wk[ 𝒫 ] (⊆-refl) p          ≈⟨ wk[ 𝒫 ]-pres-refl p ⟩
        p                           ∎)
      , ≋[ 𝒬 ]-refl)) }
