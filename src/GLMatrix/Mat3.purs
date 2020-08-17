module GLMatrix.Mat3
  ( Mat3
  , LDU
  , add
  , adjoint
  , determinant
  , epsilonEquals
  , frob
  , fromRotation
  , fromValues
  , identity
  , invert
  , ldu
  , multiply
  , multiplyScalar
  , multiplyScalarAndAdd
  , rotate
  , subtract
  , transpose
  , numbers
  , map
  ) where

import Data.Function.Uncurried (Fn0, Fn1, Fn2, Fn3, Fn4, runFn0, runFn1, runFn2, runFn3, runFn4)
import Partial.Unsafe (unsafeCrashWith, unsafePartial)
import Prelude (($))
import Prelude as Prelude
import Data.Array as Array

foreign import data Mat3 :: Type

foreign import js_add :: Fn2 Mat3 Mat3 Mat3

-- |Adds two Mat3's
add :: Mat3 -> Mat3 -> Mat3
add = runFn2 js_add

foreign import js_adjoint :: Fn1 Mat3 Mat3

-- |Calculates the adjugate of a Mat3
adjoint :: Mat3 -> Mat3
adjoint = runFn1 js_adjoint

foreign import js_determinant :: Fn1 Mat3 Number

-- |Calculates the determinant of a Mat3
determinant :: Mat3 -> Number
determinant = runFn1 js_determinant

foreign import js_epsilonEquals :: Fn2 Mat3 Mat3 Boolean

-- |Returns whether or not the matrices have approximately the same elements in the same position
epsilonEquals :: Mat3 -> Mat3 -> Boolean
epsilonEquals = runFn2 js_epsilonEquals

foreign import js_exactEquals :: Fn2 Mat3 Mat3 Boolean

-- |Returns whether or not the matrices have exactly the same elements in the same position (when compared with ===)
exactEquals :: Mat3 -> Mat3 -> Boolean
exactEquals = runFn2 js_exactEquals

foreign import js_frob :: Fn1 Mat3 Number

-- |Returns Frobenius norm of a Mat3
frob :: Mat3 -> Number
frob = runFn1 js_frob

foreign import js_fromRotation :: Fn1 Number Mat3

-- |Creates a matrix from a given angle This is equivalent to (but much faster than): Mat3.identity(dest); Mat3.rotate(dest, dest, rad);
fromRotation :: Number -> Mat3
fromRotation = runFn1 js_fromRotation

foreign import js_fromValues :: Fn4 Number Number Number Number Mat3

-- |Create a new Mat3 with the given values
fromValues :: Number -> Number -> Number -> Number -> Mat3
fromValues = runFn4 js_fromValues

foreign import js_identity :: Fn0 Mat3

-- |Set a Mat3 to the identity matrix
identity :: Mat3
identity = runFn0 js_identity

foreign import js_invert :: Fn1 Mat3 Mat3

-- |Inverts a Mat3
invert :: Mat3 -> Mat3
invert = runFn1 js_invert

type LDU
  = { l :: Mat3, d :: Mat3, u :: Mat3 }

foreign import js_ldu :: Fn1 Mat3 (Array Mat3)

-- |Returns L, D and U matrices (Lower triangular, Diagonal and Upper triangular) by factorizing the input matrix
ldu :: Mat3 -> LDU
ldu m = unsafePartial $ array3ToRecord $ runFn1 js_ldu m
  where
  array3ToRecord :: Partial => Array Mat3 -> LDU
  array3ToRecord [ a, b, c ] = { l: a, d: b, u: c }

foreign import js_multiply :: Fn2 Mat3 Mat3 Mat3

-- |Multiplies two Mat3's
multiply :: Mat3 -> Mat3 -> Mat3
multiply = runFn2 js_multiply

foreign import js_multiplyScalar :: Fn2 Mat3 Number Mat3

-- |Multiply each element of the matrix by a scalar
multiplyScalar :: Mat3 -> Number -> Mat3
multiplyScalar = runFn2 js_multiplyScalar

foreign import js_multiplyScalarAndAdd :: Fn3 Mat3 Mat3 Number Mat3

-- |Adds two Mat3's after multiplying each element of the second operand by a scalar value
multiplyScalarAndAdd :: Mat3 -> Mat3 -> Number -> Mat3
multiplyScalarAndAdd = runFn3 js_multiplyScalarAndAdd

foreign import js_rotate :: Fn2 Mat3 Number Mat3

-- |Rotates a Mat3 by the given angle
rotate :: Mat3 -> Number -> Mat3
rotate = runFn2 js_rotate

foreign import js_str :: Fn1 Mat3 String

-- |Returns a string representation of a Mat3
str :: Mat3 -> String
str = runFn1 js_str

foreign import js_subtract :: Fn2 Mat3 Mat3 Mat3

-- |Subtracts matrix b from matrix a
subtract :: Mat3 -> Mat3 -> Mat3
subtract = runFn2 js_subtract

foreign import js_transpose :: Fn1 Mat3 Mat3

-- |Transpose the values of a Mat3
transpose :: Mat3 -> Mat3
transpose = runFn1 js_transpose

foreign import js_numbers :: Fn1 Mat3 (Array Number)

-- |Extract a number array
numbers :: Mat3 -> Array Number
numbers = runFn1 js_numbers

-- |Create a matrix from an array produced by `numbers`.
unsafeFromNumbers :: Array Number -> Mat3
unsafeFromNumbers [ m00, m01, m10, m11 ] = fromValues m00 m01 m10 m11

unsafeFromNumbers _ = unsafeCrashWith "Mat3.numbers must produce exactly 4 numbers"

instance showMat3 :: Prelude.Show Mat3 where
  show = str

instance eqMat3 :: Prelude.Eq Mat3 where
  eq = exactEquals

-- |Map a function from `Number` to `Number` over the given matrix, producing
-- |a matrix.
-- |Note: Since a Matrix is not a general container, it cannot be a `Functor`.
map :: (Number -> Number) -> Mat3 -> Mat3
map fn v = unsafeFromNumbers $ Prelude.map fn $ numbers v

zipWith :: (Number -> Number -> Number) -> Mat3 -> Mat3 -> Mat3
zipWith fn v1 v2 = unsafeFromNumbers $ Array.zipWith fn (numbers v1) (numbers v2)