import Control.Monad (liftM)
import Data.Char (toUpper)
import Data.List (intersperse)
import System.Random (randomIO)
import Text.Read (readMaybe)

data Player = Human | Computer deriving (Show)
data Outcome = Win | Lose | Draw deriving (Show, Eq)
data Choice = Rock | Paper | Scissors deriving (Show, Read, Eq, Enum)

main :: IO ()
main = do
    putStrLn $ showChoices ++ "?"
    human <- humanChoice
    computer <- computerChoice
    putListLn ["Computer picks ", show computer]
    putListLn ["You ", show $ human `against` computer]

showChoices :: String
showChoices = concat . intersperse ", " . map show choices
  where choices = autoEnum :: [Choices]

invert :: Outcome -> Outcome
invert Win = Lose
invert Lose = Win
invert Draw = Draw

against :: Choice -> Choice -> Outcome
Rock `against` Paper      = Lose
Paper `against` Scissors  = Lose
Scissors `against` Rock   = Lose
x `against` y | x == y    = Draw
              | otherwise = invert $ y `against` x

getWinner :: Choice -> Choice -> Maybe Choice
getWinner x y | outcome == Win  = Just x
              | outcome == Lose = Just y
              | otherwise       = Nothing
  where outcome = x `against` y

computerChoice :: IO Choice
computerChoice = randomPick autoEnum

humanChoice :: IO Choice
humanChoice = (parseChoice . readMaybe . capitalize) =<< getLine
  where
    parseChoice :: Maybe Choice -> IO Choice
    parseChoice Nothing = putStrLn "Invalid, try again." >> humanChoice
    parseChoice (Just choice) = return choice

-- Helpers.

putListLn :: [String] => IO ()
putListLn = putStrLn . concat

capitalize :: String -> String
capitalize "" = ""
capitalize (x:xs) = (toUpper x):xs

autoEnum :: Enum a => [a]
autoEnum = [(toEnum 0) ..]

randomPick :: [a] -> IO a
randomPick xs = liftM ((xs !!) . (`mod` length xs)) randomIO