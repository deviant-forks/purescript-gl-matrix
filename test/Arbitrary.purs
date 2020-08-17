module Test.Arbitrary where

import Prelude
import GLMatrix.Mat2 (Mat2)
import GLMatrix.Mat2 as Mat2
import GLMatrix.Vec2 (Vec2)
import GLMatrix.Vec2 as Vec2
import Test.QuickCheck (class Arbitrary, arbitrary)

newtype ArbMat2
  = ArbMat2 Mat2

instance arbMat2 :: Arbitrary ArbMat2 where
  arbitrary = ArbMat2 <$> (Mat2.fromValues <$> arbitrary <*> arbitrary <*> arbitrary <*> arbitrary)

newtype ArbVec2
  = ArbVec2 Vec2

instance arbVec2 :: Arbitrary ArbVec2 where
  arbitrary = ArbVec2 <$> (Vec2.fromValues <$> arbitrary <*> arbitrary)