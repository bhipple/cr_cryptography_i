module Lib where

data Bit = Zero | One
    deriving (Eq, Ord)

instance Show Bit where
    show Zero = "0"
    show One = "1"

binaryToBit :: String -> [Bit]
binaryToBit [] = []
binaryToBit ('0':xs) = Zero : binaryToBit xs
binaryToBit ('1':xs) = One : binaryToBit xs
binaryToBit (_:xs) = binaryToBit xs

xor :: Bit -> Bit -> Bit
xor One One = Zero
xor Zero Zero = Zero
xor _ _ = One

attackAtDawn :: [Bit]
attackAtDawn = binaryToBit "0110000101110100011101000110000101100011011010110010000001100001011101000010000001100100011000010111011101101110"

cipherOfDawn :: [Bit]
cipherOfDawn = binaryToBit "110110001110011110101010010010000001010100101001000110010000110100110000001101111000010100101001000000101001101"

attackAtDusk :: [Bit]
attackAtDusk = binaryToBit "0110000101110100011101000110000101100011011010110010000001100001011101000010000001100100011101010111001101101011"


-- We've intercepted a one time pad encryption that we happen to know contains
-- the message "attack at dawn." Change it to "attack at dusk".
intercept :: [Bit]
intercept = zipWith xor key attackAtDusk
    where key = zipWith xor attackAtDawn cipherOfDawn
