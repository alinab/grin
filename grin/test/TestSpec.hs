module TestSpec where

import Test
import Test.Hspec
import Test.QuickCheck

import Data.List (nub)
import qualified Data.Set as Set


runTests :: IO ()
runTests = hspec spec

uniqueValues :: (Eq a) => [a] -> Property
uniqueValues xs = property $ length (nub xs) == length xs

spec :: Spec
spec = do
  it "newNames generate unique names" $ property $
    forAll
      (do n <- choose (40, 50)
          runGoalUnsafe $ newNames n)
      uniqueValues

  it "withGADTs generate unique tags as constructors" $ property $
    forAll
      (do n <- abs <$> arbitrary
          runGoalUnsafe $ withADTs n getADTs)
      (uniqueValues . concatMap tagNames . Set.toList)
